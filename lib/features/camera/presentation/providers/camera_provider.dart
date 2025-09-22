import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart' as camera;
import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:visionscan_pro/core/error/exceptions.dart';
import 'package:visionscan_pro/core/logging/app_logger.dart';
import 'package:visionscan_pro/core/services/ml_kit_ocr_service.dart';
import 'package:visionscan_pro/features/camera/domain/usecases/process_camera_image_usecase.dart';
import 'package:visionscan_pro/features/camera/presentation/states/camera_state.dart';
import 'package:visionscan_pro/features/history/data/repositories/scan_repository_impl.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';

part 'generated/camera_provider.g.dart';

/// Camera controller provider - simplified version
@riverpod
class CameraController extends _$CameraController {
  static camera.CameraController? _globalController;
  static bool _isGloballyInitializing = false;
  static Timer? _globalCleanupTimer;
  static bool _hotRestartOccurred = false;

  @override
  Future<CameraState> build() async {
    // Setup cleanup on dispose
    ref.onDispose(_disposeResources);

    // Simple hot restart handling
    if (_hotRestartOccurred) {
      await _handleHotRestart();
      _hotRestartOccurred = false;
    }

    return _initializeCamera();
  }

  /// Simple hot restart handling
  Future<void> _handleHotRestart() async {
    await _disposeController();
  }

  /// Initialize camera - simplified
  Future<CameraState> _initializeCamera() async {
    if (_isGloballyInitializing) {
      return const CameraState.initializing();
    }

    _isGloballyInitializing = true;

    try {
      // Dispose previous controller
      await _disposeController();

      // Get available cameras
      final cameras = await camera.availableCameras().timeout(
        const Duration(seconds: 5),
        onTimeout: () => throw Exception('Camera discovery timeout'),
      );

      if (cameras.isEmpty) {
        return const CameraState.error(
          message: 'No cameras available on this device',
          canRetry: false,
        );
      }

      // Select back camera
      final selectedCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == camera.CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      // Create and initialize controller
      _globalController = camera.CameraController(
        selectedCamera,
        camera.ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: camera.ImageFormatGroup.jpeg,
      );

      await _globalController!.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Camera initialization timeout'),
      );

      // Apply basic settings
      await _applyOptimalSettings();

      // Setup resource management
      _setupResourceManagement();

      return CameraState.ready(
        controller: _globalController!,
        previewSize: _globalController!.value.previewSize ?? Size.zero,
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Camera initialization failed',
        error: e,
        stackTrace: stackTrace,
      );
      return CameraState.error(
        message: _getReadableErrorMessage(e),
        canRetry: true,
      );
    } finally {
      _isGloballyInitializing = false;
    }
  }

  /// Apply optimal camera settings - simplified
  Future<void> _applyOptimalSettings() async {
    if (_globalController == null || !_globalController!.value.isInitialized) {
      return;
    }

    try {
      await _globalController!.setExposureMode(camera.ExposureMode.auto);
      await _globalController!.setFocusMode(camera.FocusMode.auto);
      await _globalController!.setFlashMode(camera.FlashMode.off);

      final maxExposure = await _globalController!.getMaxExposureOffset();
      final minExposure = await _globalController!.getMinExposureOffset();
      final optimalExposure = (maxExposure + minExposure) / 4;
      await _globalController!.setExposureOffset(optimalExposure);

      await _globalController!.lockCaptureOrientation();
    } catch (e) {
      AppLogger.warning('Failed to apply some camera settings: $e');
    }
  }

  /// Setup resource management
  void _setupResourceManagement() {
    _globalCleanupTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _performResourceCleanup(),
    );
  }

  /// Perform periodic resource cleanup
  Future<void> _performResourceCleanup() async {
    try {
      await _cleanupTemporaryFiles();
    } catch (e) {
      AppLogger.warning('Resource cleanup error: $e');
    }
  }

  /// Clean up temporary files
  Future<void> _cleanupTemporaryFiles() async {
    try {
      final tempDir = Directory.systemTemp;
      final tempFiles = tempDir
          .listSync()
          .whereType<File>()
          .where(
            (file) =>
                file.path.contains('cropped_') ||
                file.path.contains('enhanced_'),
          )
          .where((file) {
            final lastModified = file.lastModifiedSync();
            final ageLimit = DateTime.now().subtract(const Duration(hours: 1));
            return lastModified.isBefore(ageLimit);
          });

      for (final file in tempFiles) {
        try {
          await file.delete();
        } catch (e) {
          // Ignore individual file errors
        }
      }
    } catch (e) {
      AppLogger.warning('Temporary file cleanup failed: $e');
    }
  }

  /// Focus camera at specific point
  Future<void> focusAt(Offset point) async {
    if (_globalController == null || !_globalController!.value.isInitialized) {
      return;
    }

    try {
      await _globalController!.setFocusPoint(point);
      await _globalController!.setExposurePoint(point);
    } catch (e) {
      AppLogger.warning('Failed to focus at point: $e');
    }
  }

  /// Toggle flash
  Future<void> toggleFlash() async {
    if (_globalController == null || !_globalController!.value.isInitialized) {
      return;
    }

    try {
      final currentFlashMode = _globalController!.value.flashMode;
      final newFlashMode = currentFlashMode == camera.FlashMode.off
          ? camera.FlashMode.torch
          : camera.FlashMode.off;

      await _globalController!.setFlashMode(newFlashMode);
    } catch (e) {
      AppLogger.warning('Failed to toggle flash: $e');
    }
  }

  /// Capture image and process
  Future<ScanResult> captureAndProcess({
    required Size previewSize,
    Rect? cropRect,
  }) async {
    try {
      final controller = _globalController;
      if (controller == null || !controller.value.isInitialized) {
        throw const OCRException('Camera is not ready for capture');
      }

      // Determine crop rect
      final finalCropRect =
          cropRect ??
          Rect.fromLTWH(0, 0, previewSize.width, previewSize.height);

      // Focus and capture
      final center = Offset(
        finalCropRect.center.dx / previewSize.width,
        finalCropRect.center.dy / previewSize.height,
      );
      await focusAt(center);
      await Future<void>.delayed(const Duration(milliseconds: 500));

      await HapticFeedback.mediumImpact();
      final xFile = await controller.takePicture();
      final imageFile = File(xFile.path);

      // Process image
      final ocrService = ref.read(mlKitOCRServiceProvider);
      final scanRepository = ref.read(scanRepositoryImplProvider);
      final useCase = ProcessCameraImageUseCase(
        ocrService: ocrService,
        scanRepository: scanRepository,
      );

      final result = await useCase.call(
        ProcessImageParams(
          imageFile: imageFile,
          cropRect: finalCropRect,
          previewSize: previewSize,
        ),
      );

      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Capture and processing failed',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Set flash mode
  Future<void> setFlashMode(camera.FlashMode flashMode) async {
    try {
      if (_globalController != null && _globalController!.value.isInitialized) {
        await _globalController!.setFlashMode(flashMode);

        // Update state to reflect the new flash mode
        state = await AsyncValue.guard(() async {
          return CameraState.ready(
            controller: _globalController!,
            previewSize: _globalController!.value.previewSize ?? Size.zero,
          );
        });
      }
    } catch (e) {
      AppLogger.warning('Failed to set flash mode: $e');
    }
  }

  /// Retry initialization
  Future<void> retryInitialization() async {
    ref.invalidateSelf();
  }

  /// Dispose camera controller
  Future<void> _disposeController() async {
    if (_globalController != null) {
      try {
        if (_globalController!.value.isInitialized) {
          try {
            await _globalController!.stopImageStream();
          } catch (e) {
            // Ignore stream stop errors
          }
        }
        await _globalController!.dispose();
      } catch (e) {
        AppLogger.warning('Error disposing camera controller: $e');
      } finally {
        _globalController = null;
      }
    }
  }

  /// Dispose resources
  void _disposeResources() {
    _globalCleanupTimer?.cancel();
    _globalCleanupTimer = null;
    _disposeController().catchError((Object e) {
      AppLogger.warning('Error during resource disposal: $e');
    });
  }

  /// Global cleanup
  static Future<void> globalCleanup() async {
    try {
      _globalCleanupTimer?.cancel();
      _globalCleanupTimer = null;

      if (_globalController != null) {
        final controller = _globalController;
        _globalController = null;

        await controller?.dispose();
      }
    } catch (e) {
      AppLogger.warning('Error during global cleanup: $e');
    } finally {
      _globalController = null;
      _globalCleanupTimer = null;
    }
  }

  /// Get readable error message
  String _getReadableErrorMessage(dynamic error) {
    return switch (error.toString().toLowerCase()) {
      final str when str.contains('permission') =>
        'Camera permission is required to scan documents',
      final str when str.contains('camera') =>
        'Camera error occurred. Please try again',
      _ => 'Failed to initialize camera. Please try again',
    };
  }
}
