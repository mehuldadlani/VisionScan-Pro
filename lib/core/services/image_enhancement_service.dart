import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:visionscan_pro/core/error/exceptions.dart';
import 'package:visionscan_pro/core/logging/app_logger.dart';

part 'generated/image_enhancement_service.g.dart';

/// Provider for the image enhancement service
@riverpod
ImageEnhancementService imageEnhancementService(Ref ref) {
  return ImageEnhancementService();
}

/// Image enhancement service optimized for OCR processing
class ImageEnhancementService {
  /// Enhance image for OCR processing
  Future<File> enhanceForOCR({
    required File originalFile,
    required Rect cropRect,
    required Size previewSize,
  }) async {
    try {
      AppLogger.info('Starting image enhancement for OCR');

      // Load original image
      final bytes = await originalFile.readAsBytes();
      var image = img.decodeImage(bytes);
      if (image == null) {
        throw const OCRException('Failed to decode image for enhancement');
      }

      AppLogger.debug('Original image: ${image.width}x${image.height}');

      // Step 1: Crop to exact rectangle bounds with padding
      image = _cropImageWithPadding(
        image: image,
        cropRect: cropRect,
        previewSize: previewSize,
      );

      // Step 2: Optimize resolution for OCR (target ~300 DPI equivalent)
      final optimalSize = _calculateOptimalResolution(
        Size(image.width.toDouble(), image.height.toDouble()),
      );

      if (optimalSize.width != image.width ||
          optimalSize.height != image.height) {
        image = img.copyResize(
          image,
          width: optimalSize.width.round(),
          height: optimalSize.height.round(),
          interpolation: img.Interpolation.cubic,
        );
        AppLogger.debug(
          'Optimized resolution: ${optimalSize.width}x${optimalSize.height}',
        );
      }

      // Step 3: Advanced contrast and brightness optimization
      image = img.adjustColor(
        image,
        contrast: 1.4, // Higher contrast for better text separation
        brightness: 1.08, // Slight brightness boost
        gamma: 0.92, // Gamma correction for better midtones
        saturation: 0.8, // Reduce saturation before grayscale
      );

      // Step 4: Apply advanced sharpening filter for crisp text edges
      image = img.convolution(
        image,
        filter: [-0.1, -0.2, -0.1, -0.2, 2.2, -0.2, -0.1, -0.2, -0.1],
      );

      // Step 5: Noise reduction while preserving text edges
      image = _applyNoiseReduction(image);

      // Step 6: Convert to optimized grayscale for OCR
      image = img.grayscale(image);

      // Step 7: Final contrast enhancement for text clarity
      image = img.adjustColor(image, contrast: 1.15, brightness: 1.02);

      // Save enhanced image
      final enhancedFile = await _saveEnhancedImage(image);

      AppLogger.info('Image enhancement completed: ${enhancedFile.path}');
      return enhancedFile;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Image enhancement failed',
        error: e,
        stackTrace: stackTrace,
      );
      throw OCRException('Image enhancement failed: $e');
    }
  }

  /// Crop image with optimal padding for OCR
  img.Image _cropImageWithPadding({
    required img.Image image,
    required Rect cropRect,
    required Size previewSize,
  }) {
    // Convert preview coordinates to image coordinates
    final imageRect = _convertPreviewToImageCoordinates(
      cropRect: cropRect,
      previewSize: previewSize,
      imageSize: Size(image.width.toDouble(), image.height.toDouble()),
    );

    // Add 5% padding around the crop area
    const paddingFactor = 0.05;
    final paddingX = imageRect.width * paddingFactor;
    final paddingY = imageRect.height * paddingFactor;

    final paddedRect = Rect.fromLTWH(
      math.max(0, imageRect.left - paddingX),
      math.max(0, imageRect.top - paddingY),
      math.min(image.width.toDouble(), imageRect.width + (2 * paddingX)),
      math.min(image.height.toDouble(), imageRect.height + (2 * paddingY)),
    );

    // Clamp to image bounds
    final safeRect = Rect.fromLTWH(
      paddedRect.left.clamp(0.0, image.width.toDouble()),
      paddedRect.top.clamp(0.0, image.height.toDouble()),
      paddedRect.width.clamp(1.0, image.width - paddedRect.left),
      paddedRect.height.clamp(1.0, image.height - paddedRect.top),
    );

    return img.copyCrop(
      image,
      x: safeRect.left.round(),
      y: safeRect.top.round(),
      width: safeRect.width.round(),
      height: safeRect.height.round(),
    );
  }

  /// Convert preview coordinates to image coordinates
  Rect _convertPreviewToImageCoordinates({
    required Rect cropRect,
    required Size previewSize,
    required Size imageSize,
  }) {
    final imageAspectRatio = imageSize.width / imageSize.height;
    final previewAspectRatio = previewSize.width / previewSize.height;

    double scaleX;
    double scaleY;
    double offsetX = 0;
    double offsetY = 0;

    if (imageAspectRatio > previewAspectRatio) {
      // Image is wider - fit by height
      scaleY = imageSize.height / previewSize.height;
      scaleX = scaleY;
      offsetX = (imageSize.width - previewSize.width * scaleX) / 2;
    } else {
      // Image is taller - fit by width
      scaleX = imageSize.width / previewSize.width;
      scaleY = scaleX;
      offsetY = (imageSize.height - previewSize.height * scaleY) / 2;
    }

    return Rect.fromLTWH(
      cropRect.left * scaleX + offsetX,
      cropRect.top * scaleY + offsetY,
      cropRect.width * scaleX,
      cropRect.height * scaleY,
    );
  }

  /// Calculate optimal resolution for OCR (target ~300 DPI equivalent)
  /// Apply noise reduction while preserving text edges
  img.Image _applyNoiseReduction(img.Image image) {
    // Gaussian blur with very small radius to reduce noise but preserve text
    return img.gaussianBlur(image, radius: 1);
  }

  Size _calculateOptimalResolution(Size originalSize) {
    const targetDPI = 300.0;
    const baseDPI = 72.0;
    const maxDimension = 3000;
    const minDimension = 200;

    const scaleFactor = targetDPI / baseDPI;
    var targetWidth = (originalSize.width * scaleFactor).round();
    var targetHeight = (originalSize.height * scaleFactor).round();

    // Apply dimension constraints
    if (targetWidth > maxDimension) {
      final ratio = maxDimension / targetWidth;
      targetWidth = maxDimension;
      targetHeight = (targetHeight * ratio).round();
    }

    // Ensure minimum dimensions
    targetWidth = math.max(targetWidth, minDimension);
    targetHeight = math.max(targetHeight, minDimension);

    return Size(targetWidth.toDouble(), targetHeight.toDouble());
  }

  /// Save enhanced image with optimal compression settings
  Future<File> _saveEnhancedImage(img.Image image) async {
    final tempDir = await getTemporaryDirectory();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final enhancedFile = File('${tempDir.path}/enhanced_$timestamp.jpg');

    final encodedBytes = img.encodeJpg(image, quality: 95);
    await enhancedFile.writeAsBytes(encodedBytes);
    return enhancedFile;
  }
}
