import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:visionscan_pro/core/logging/app_logger.dart';
import 'package:visionscan_pro/core/services/ml_kit_ocr_service.dart';
import 'package:visionscan_pro/features/camera/domain/usecases/process_camera_image_usecase.dart';
import 'package:visionscan_pro/features/history/data/repositories/scan_repository_impl.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';
import 'package:visionscan_pro/features/history/presentation/providers/scan_history_provider.dart';

/// OCR processing page that handles text extraction from cropped images
class OCRProcessPage extends ConsumerStatefulWidget {
  const OCRProcessPage({required this.imagePath, super.key});

  final String imagePath;

  @override
  ConsumerState<OCRProcessPage> createState() => _OCRProcessPageState();
}

class _OCRProcessPageState extends ConsumerState<OCRProcessPage> {
  bool _isProcessing = true;
  ScanResult? _result;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _processImage();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background image
          SizedBox.expand(
            child: Image.file(
              File(widget.imagePath),
              fit: BoxFit.cover,
              color: Colors.black.withValues(alpha: 0.3),
              colorBlendMode: BlendMode.darken,
            ),
          ),

          // Processing overlay
          if (_isProcessing) _buildProcessingOverlay(theme),

          // Results overlay
          if (!_isProcessing && _result != null) _buildResultsOverlay(theme),

          // Error overlay
          if (!_isProcessing && _errorMessage != null)
            _buildErrorOverlay(theme),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: _buildBackButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessingOverlay(ThemeData theme) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.8),
              Colors.black.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.cyan.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyan.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                    strokeWidth: 4,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'EXTRACTING TEXT',
                  style: TextStyle(
                    color: Colors.cyan.withValues(alpha: 0.9),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Analyzing image for numbers...',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),
                const LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                  backgroundColor: Colors.white24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsOverlay(ThemeData theme) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.7),
              Colors.black.withValues(alpha: 0.85),
            ],
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.green.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withValues(alpha: 0.2),
                  blurRadius: 20,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.green.withValues(alpha: 0.2),
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  child: const Icon(
                    PhosphorIconsRegular.check,
                    color: Colors.green,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'EXTRACTION COMPLETE',
                  style: TextStyle(
                    color: Colors.green.withValues(alpha: 0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Found ${_result!.extractedNumbers.length} number${_result!.extractedNumbers.length == 1 ? '' : 's'}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                // Preview of extracted numbers
                if (_result!.extractedNumbers.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Extracted Numbers:',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: _result!.extractedNumbers.take(8).map((
                            number,
                          ) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.cyan.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.cyan.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Text(
                                number,
                                style: const TextStyle(
                                  color: Colors.cyan,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        if (_result!.extractedNumbers.length > 5)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              '+${_result!.extractedNumbers.length - 5} more',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(PhosphorIconsRegular.caretLeft),
                      label: const Text('Back'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.push('/scan-details/${_result!.id}'),
                      icon: const Icon(PhosphorIconsRegular.eye),
                      label: const Text('View Details'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorOverlay(ThemeData theme) {
    return SizedBox.expand(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.8),
              Colors.black.withValues(alpha: 0.9),
            ],
          ),
        ),
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.red.withValues(alpha: 0.5),
                width: 2,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red.withValues(alpha: 0.2),
                    border: Border.all(color: Colors.red, width: 2),
                  ),
                  child: const Icon(
                    PhosphorIconsRegular.warning,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'EXTRACTION FAILED',
                  style: TextStyle(
                    color: Colors.red.withValues(alpha: 0.9),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => context.pop(),
                      icon: const Icon(PhosphorIconsRegular.caretLeft),
                      label: const Text('Back'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _retryProcessing,
                      icon: const Icon(PhosphorIconsRegular.arrowClockwise),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(PhosphorIconsRegular.caretLeft, color: Colors.white),
        onPressed: () => context.pop(),
      ),
    );
  }

  Future<void> _processImage() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final imageFile = File(widget.imagePath);
      if (!imageFile.existsSync()) {
        throw Exception('Image file not found');
      }

      final ocrService = ref.read(mlKitOCRServiceProvider);
      final scanRepository = ref.read(scanRepositoryImplProvider);

      final useCase = ProcessCameraImageUseCase(
        ocrService: ocrService,
        scanRepository: scanRepository,
      );

      // Process the image
      const previewSize = Size(1920, 1080); // Default size
      final cropRect = Rect.fromLTWH(
        0,
        0,
        previewSize.width,
        previewSize.height,
      );

      final result = await useCase.call(
        ProcessImageParams(
          imageFile: imageFile,
          cropRect: cropRect,
          previewSize: previewSize,
        ),
      );

      // Add the scan to history provider
      await ref.read(scanHistoryProvider.notifier).addScan(result);

      if (mounted) {
        setState(() {
          _result = result;
          _isProcessing = false;
        });
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'OCR processing failed',
        error: e,
        stackTrace: stackTrace,
      );

      if (mounted) {
        setState(() {
          _errorMessage = _getReadableError(e);
          _isProcessing = false;
        });
      }
    }
  }

  void _retryProcessing() {
    _processImage();
  }

  String _getReadableError(dynamic error) {
    final errorStr = error.toString().toLowerCase();

    if (errorStr.contains('no numbers detected')) {
      return 'No numbers found in the image. Please ensure the image contains clear, visible numbers.';
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
}
