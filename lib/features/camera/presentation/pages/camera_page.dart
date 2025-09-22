import 'dart:io';

import 'package:camera/camera.dart' as camera;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:visionscan_pro/core/logging/app_logger.dart';
import 'package:visionscan_pro/core/services/ml_kit_ocr_service.dart';
import 'package:visionscan_pro/core/theme/app_theme.dart';
import 'package:visionscan_pro/features/camera/domain/usecases/process_camera_image_usecase.dart';
import 'package:visionscan_pro/features/camera/presentation/providers/camera_provider.dart';
import 'package:visionscan_pro/features/camera/presentation/states/camera_state.dart';
import 'package:visionscan_pro/features/camera/presentation/widgets/camera_controls.dart';
import 'package:visionscan_pro/features/camera/presentation/widgets/camera_overlay.dart';
import 'package:visionscan_pro/features/camera/presentation/widgets/ocr_processing_overlay.dart';
import 'package:visionscan_pro/features/history/data/repositories/scan_repository_impl.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';
import 'package:visionscan_pro/features/history/presentation/providers/scan_history_provider.dart';

/// Camera page for number scanning with live preview and direct OCR processing
class CameraPage extends ConsumerStatefulWidget {
  const CameraPage({super.key});

  @override
  ConsumerState<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late AnimationController _overlayAnimationController;
  late Animation<double> _overlayAnimation;
  bool _isCapturing = false;
  bool _isProcessingOCR = false;
  ScanResult? _scanResult;
  String? _ocrError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeAnimations();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _overlayAnimationController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.resumed:
        _ensureCameraReady();
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
    }
  }

  void _initializeAnimations() {
    _overlayAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _overlayAnimation = CurvedAnimation(
      parent: _overlayAnimationController,
      curve: Curves.easeInOut,
    );
    _overlayAnimationController.forward();
  }

  void _ensureCameraReady() {
    if (!mounted) return;
    ref
        .read(cameraControllerProvider)
        .whenOrNull(
          data: (state) {
            if (state.hasError) {
              ref.read(cameraControllerProvider.notifier).retryInitialization();
            }
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cameraAsyncState = ref.watch(cameraControllerProvider);

    return Scaffold(
      backgroundColor: AppTheme.primaryBlack,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context, theme),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // Main camera view
                  cameraAsyncState.when(
                    data: (cameraState) =>
                        _buildCameraView(context, cameraState),
                    loading: () => _buildLoadingView(context, theme),
                    error: (error, stackTrace) =>
                        _buildErrorView(context, theme, error.toString()),
                  ),
                  // OCR Processing overlay
                  if (_isProcessingOCR)
                    OCRProcessingOverlay(
                      isProcessing:
                          _isProcessingOCR &&
                          _scanResult == null &&
                          _ocrError == null,
                      result: _scanResult,
                      error: _ocrError,
                      onRetry: _retryOCR,
                      onViewDetails: () {
                        if (_scanResult != null) {
                          context.push('/scan-details/${_scanResult!.id}');
                        }
                      },
                      onBackToCamera: _resetOCRState,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      automaticallyImplyLeading: false, // Remove back button
      title: Text(
        'VisionScan Pro',
        style: AppTheme.headlineMedium.copyWith(
          color: AppTheme.primaryWhite,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
          shadows: [
            Shadow(
              offset: const Offset(0, 2),
              blurRadius: 4,
              color: AppTheme.primaryBlack.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
      centerTitle: true,
      // Remove actions (history button)
    );
  }

  Widget _buildCameraView(BuildContext context, CameraState cameraState) {
    return cameraState.when(
      ready: (controller, previewSize) =>
          _buildReadyCameraView(context, controller, previewSize),
      initializing: () => _buildLoadingView(context, Theme.of(context)),
      error: (message, canRetry) =>
          _buildErrorView(context, Theme.of(context), message, canRetry),
    );
  }

  Widget _buildReadyCameraView(
    BuildContext context,
    camera.CameraController controller,
    Size previewSize,
  ) {
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        // Camera preview
        _buildCameraPreview(controller, screenSize),
        // Camera overlay with scanning rectangle
        AnimatedBuilder(
          animation: _overlayAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _overlayAnimation.value,
              child: CameraOverlay(
                isCapturing: _isCapturing || _isProcessingOCR,
              ),
            );
          },
        ),
        // Camera controls
        Consumer(
          builder: (context, ref, child) {
            final cameraState = ref.watch(cameraControllerProvider);
            return cameraState.when(
              data: (cameraState) => cameraState.maybeWhen(
                ready: (controller, previewSize) => CameraControls(
                  onCapturePressed: () =>
                      _handleDirectOCRCapture(context, controller, previewSize),
                  onGalleryPressed: () => _handleGalleryPick(context),
                  onFlashToggle: _handleFlashToggle,
                  isCapturing: _isCapturing || _isProcessingOCR,
                  currentFlashMode: controller.value.flashMode,
                ),
                orElse: () => const SizedBox.shrink(),
              ),
              loading: () => const SizedBox.shrink(),
              error: (error, stackTrace) => const SizedBox.shrink(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCameraPreview(
    camera.CameraController controller,
    Size screenSize,
  ) {
    return SizedBox.expand(
      child: ClipRect(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: controller.value.previewSize?.height ?? screenSize.width,
            height: controller.value.previewSize?.width ?? screenSize.height,
            child: camera.CameraPreview(controller),
          ),
        ),
      ),
    );
  }

  /// Handle direct OCR capture without cropping
  Future<void> _handleDirectOCRCapture(
    BuildContext context,
    camera.CameraController controller,
    Size previewSize,
  ) async {
    if (_isCapturing || _isProcessingOCR || !mounted) return;

    setState(() {
      _isCapturing = true;
      _isProcessingOCR = true;
      _scanResult = null;
      _ocrError = null;
    });

    try {
      AppLogger.info('Capturing image for direct OCR processing');

      // Take the picture
      final image = await controller.takePicture();

      if (!mounted) return;

      setState(() => _isCapturing = false);

      // Process OCR directly without cropping
      await _processOCRDirectly(File(image.path), previewSize);
    } catch (e) {
      if (!mounted) return;
      AppLogger.error('Direct OCR capture failed', error: e);
      setState(() {
        _isCapturing = false;
        _isProcessingOCR = false;
        _ocrError = 'Failed to capture image. Please try again.';
      });
    }
  }

  /// Process OCR directly on the captured image
  Future<void> _processOCRDirectly(
    File imageFile,
    Size previewSize, {
    bool isFromGallery = false,
  }) async {
    try {
      final screenSize = MediaQuery.of(context).size;
      final rect = _getScanningRect(screenSize);

      final ocrService = ref.read(mlKitOCRServiceProvider);
      final scanRepository = ref.read(scanRepositoryImplProvider);
      final useCase = ProcessCameraImageUseCase(
        ocrService: ocrService,
        scanRepository: scanRepository,
      );

      final result = await useCase.call(
        ProcessImageParams(
          imageFile: imageFile,
          cropRect: rect,
          previewSize: previewSize,
          isFromGallery: isFromGallery,
        ),
      );

      if (mounted) {
        setState(() {
          _scanResult = result;
          _isProcessingOCR = true;
        });
        ref.invalidate(scanHistoryProvider);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Direct OCR processing failed',
        error: e,
        stackTrace: stackTrace,
      );
      if (mounted) {
        setState(() {
          _ocrError = _getReadableError(e);
          _isProcessingOCR = true; // Keep overlay visible to show error
        });
      }
    }
  }

  /// Get scanning rectangle for overlay bounds
  Rect _getScanningRect(Size screenSize) {
    const aspectRatio = 4 / 3;
    final rectWidth = screenSize.width * 0.85;
    final rectHeight = rectWidth / aspectRatio;
    final left = (screenSize.width - rectWidth) / 2;
    final top = (screenSize.height - rectHeight) / 2;
    return Rect.fromLTWH(left, top, rectWidth, rectHeight);
  }

  Future<void> _handleGalleryPick(BuildContext context) async {
    if (_isCapturing || _isProcessingOCR || !mounted) return;

    setState(() {
      _isCapturing = true;
      _isProcessingOCR = true;
      _scanResult = null;
      _ocrError = null;
    });

    try {
      final picker = ImagePicker();
      final xFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 95,
      );

      if (xFile == null || !mounted) {
        setState(() {
          _isCapturing = false;
          _isProcessingOCR = false;
        });
        return;
      }

      setState(() => _isCapturing = false);

      await _processOCRDirectly(
        File(xFile.path),
        const Size(1920, 1080),
        isFromGallery: true,
      );
    } catch (e) {
      if (!mounted) return;
      AppLogger.error('Gallery pick failed', error: e);
      setState(() {
        _isCapturing = false;
        _isProcessingOCR = false;
        _ocrError = 'Failed to select image. Please try again.';
      });
    }
  }

  Future<void> _handleFlashToggle(camera.FlashMode flashMode) async {
    await ref.read(cameraControllerProvider.notifier).setFlashMode(flashMode);
  }

  void _retryOCR() {
    setState(() {
      _isProcessingOCR = false;
      _ocrError = null;
      _scanResult = null;
    });
  }

  void _resetOCRState() {
    setState(() {
      _isProcessingOCR = false;
      _ocrError = null;
      _scanResult = null;
    });
  }

  String _getReadableError(dynamic error) {
    final errorStr = error.toString().toLowerCase();
    if (errorStr.contains('no numbers detected')) {
      return 'No numbers found in the image. Please ensure the document contains clear, visible numbers.';
    }
    if (errorStr.contains('confidence')) {
      return 'Image quality too low for reliable extraction. Please try with better lighting and focus.';
    }
    if (errorStr.contains('mlkit') || errorStr.contains('ocr')) {
      return 'Text recognition service error. Please check your internet connection and try again.';
    }
    if (errorStr.contains('file') || errorStr.contains('io')) {
      return 'Unable to read the image file. Please try capturing a new photo.';
    }
    return 'An unexpected error occurred during text extraction. Please try again.';
  }

  Widget _buildLoadingView(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.primaryBlack,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primaryWhite.withValues(alpha: 0.1),
                border: Border.all(
                  color: AppTheme.primaryWhite.withValues(alpha: 0.2),
                ),
              ),
              child: const Center(
                child: SizedBox(
                  width: 32,
                  height: 32,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor: AlwaysStoppedAnimation(AppTheme.primaryWhite),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.space32),
            Text(
              'INITIALIZING CAMERA',
              style: AppTheme.titleLarge.copyWith(
                color: AppTheme.primaryWhite,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: AppTheme.space12),
            Text(
              'Please wait while we prepare your camera...',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.primaryWhite.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(
    BuildContext context,
    ThemeData theme,
    String errorMessage, [
    bool canRetry = true,
  ]) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.primaryBlack,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.space32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryWhite.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppTheme.primaryWhite.withValues(alpha: 0.2),
                  ),
                ),
                child: const Icon(
                  PhosphorIconsRegular.camera,
                  size: 36,
                  color: AppTheme.primaryWhite,
                ),
              ),
              const SizedBox(height: AppTheme.space24),
              Text(
                'CAMERA ERROR',
                style: AppTheme.titleLarge.copyWith(
                  color: AppTheme.primaryWhite,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: AppTheme.space16),
              Container(
                padding: const EdgeInsets.all(AppTheme.space20),
                decoration: BoxDecoration(
                  color: AppTheme.primaryWhite.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  border: Border.all(
                    color: AppTheme.primaryWhite.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  errorMessage,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.primaryWhite.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppTheme.space32),
              if (canRetry) ...[
                ElevatedButton.icon(
                  onPressed: () => ref
                      .read(cameraControllerProvider.notifier)
                      .retryInitialization(),
                  icon: const Icon(
                    PhosphorIconsRegular.arrowClockwise,
                    size: 18,
                  ),
                  label: Text(
                    'Try Again',
                    style: AppTheme.labelLarge.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryWhite,
                    foregroundColor: AppTheme.primaryBlack,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.space24,
                      vertical: AppTheme.space16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppTheme.radiusMedium,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppTheme.space16),
              ],
              TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Go Back',
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.primaryWhite.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
