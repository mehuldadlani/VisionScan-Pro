import 'dart:io';
import 'dart:ui';

import 'package:uuid/uuid.dart';

import 'package:visionscan_pro/core/error/exceptions.dart';
import 'package:visionscan_pro/core/logging/app_logger.dart';
import 'package:visionscan_pro/core/services/ml_kit_ocr_service.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';
import 'package:visionscan_pro/features/history/domain/repositories/scan_repository.dart';

/// Use case for processing camera-captured images with OCR
class ProcessCameraImageUseCase {
  const ProcessCameraImageUseCase({
    required this.ocrService,
    required this.scanRepository,
  });

  final MLKitOCRService ocrService;
  final ScanRepository scanRepository;

  /// Process captured image and return scan result
  Future<ScanResult> call(ProcessImageParams params) async {
    final stopwatch = Stopwatch()..start();

    try {
      await _validateInputs(params);

      final ocrResult = await ocrService.extractNumbersFromImage(
        params.imageFile,
        params.cropRect,
        params.previewSize,
      );

      final scanResult = ocrResult.copyWith(
        id: const Uuid().v4(),
        imagePath: params.imageFile.path,
        isFromGallery: params.isFromGallery,
      );

      try {
        _validateOCRResults(scanResult);
      } catch (e) {
        AppLogger.error('OCR validation failed: $e');
        rethrow;
      }
      await scanRepository.saveScan(scanResult);

      stopwatch.stop();

      return scanResult;
    } on OCRException catch (e) {
      AppLogger.error('OCR processing failed: $e');
      rethrow;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Image processing failed',
        error: e,
        stackTrace: stackTrace,
      );
      throw OCRException('Processing failed: $e');
    } finally {
      stopwatch.stop();
    }
  }

  /// Validates input parameters
  Future<void> _validateInputs(ProcessImageParams params) async {
    if (!params.imageFile.existsSync()) {
      throw const OCRException('Image file does not exist');
    }

    final fileSize = await params.imageFile.length();
    const maxFileSize = 50 * 1024 * 1024; // 50MB
    if (fileSize > maxFileSize) {
      throw OCRException('Image file too large: ${_formatFileSize(fileSize)}');
    }

    if (params.cropRect.width <= 0 || params.cropRect.height <= 0) {
      throw OCRException('Invalid crop rectangle: ${params.cropRect}');
    }

    if (params.previewSize.width <= 0 || params.previewSize.height <= 0) {
      throw OCRException('Invalid preview size: ${params.previewSize}');
    }
  }

  /// Validates OCR processing results
  void _validateOCRResults(ScanResult scanResult) {
    final extractedNumbers = scanResult.extractedNumbers;
    if (extractedNumbers.isEmpty) {
      throw const OCRException(
        'No numbers detected in the scanned area. '
        'Please ensure numbers are clearly visible and well-lit.',
      );
    }

    const minConfidenceThreshold = 0.1;
    final confidence = scanResult.confidence;
    if (confidence < minConfidenceThreshold) {
      throw OCRException(
        'OCR confidence too low (${(confidence * 100).toStringAsFixed(1)}%). '
        'Please ensure better lighting and focus.',
      );
    }
  }

  /// Formats file size in human-readable format
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Parameters for image processing use case
class ProcessImageParams {
  const ProcessImageParams({
    required this.imageFile,
    required this.cropRect,
    required this.previewSize,
    this.isFromGallery = false,
  });

  final File imageFile;
  final Rect cropRect;
  final Size previewSize;
  final bool isFromGallery;
}
