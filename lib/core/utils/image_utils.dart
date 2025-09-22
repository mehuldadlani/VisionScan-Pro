import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'package:visionscan_pro/core/constants/app_constants.dart';
import 'package:visionscan_pro/core/error/exceptions.dart';

/// Utility class for image processing operations
///
/// Provides static methods for image manipulation, validation,
/// compression, cropping, and file management.
class ImageUtils {
  const ImageUtils._();

  /// Validates if the image file meets the application requirements
  static Future<bool> validateImage(File imageFile) async {
    try {
      if (!imageFile.existsSync()) {
        return false;
      }

      final fileSize = await imageFile.length();
      if (fileSize > AppConstants.maxImageSizeBytes) {
        return false;
      }

      final image = await decodeImage(imageFile);
      if (image == null) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Decodes an image file to img.Image object
  static Future<img.Image?> decodeImage(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      return img.decodeImage(bytes);
    } catch (e) {
      throw OCRException('Failed to decode image: $e', 'IMAGE_DECODE_FAILED');
    }
  }

  /// Compresses an image to reduce file size while maintaining quality
  static Future<File> compressImage(
    File originalFile, {
    int quality = 85,
    int? maxWidth,
    int? maxHeight,
  }) async {
    try {
      final image = await decodeImage(originalFile);
      if (image == null) {
        throw const OCRException(
          'Failed to decode original image',
          'IMAGE_COMPRESSION_FAILED',
        );
      }

      var processedImage = image;

      // Resize if dimensions are specified
      if (maxWidth != null || maxHeight != null) {
        final targetWidth = maxWidth ?? AppConstants.maxImageWidth;
        final targetHeight = maxHeight ?? AppConstants.maxImageHeight;

        if (image.width > targetWidth || image.height > targetHeight) {
          processedImage = img.copyResize(
            image,
            width: targetWidth,
            height: targetHeight,
            interpolation: img.Interpolation.cubic,
          );
        }
      }

      // Compress the image
      final compressedBytes = img.encodeJpg(processedImage, quality: quality);

      // Generate output file path
      final directory = await getTemporaryDirectory();
      final fileName = path.basenameWithoutExtension(originalFile.path);
      final outputPath = path.join(
        directory.path,
        '${fileName}_compressed${AppConstants.imageFileExtension}',
      );

      // Write compressed image to file
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(compressedBytes);

      return outputFile;
    } catch (e) {
      if (e is OCRException) {
        rethrow;
      }
      throw OCRException(
        'Image compression failed: $e',
        'IMAGE_COMPRESSION_FAILED',
      );
    }
  }

  /// Crops an image to the specified rectangle
  static Future<File> cropImage(
    File originalFile, {
    required int x,
    required int y,
    required int width,
    required int height,
  }) async {
    try {
      final image = await decodeImage(originalFile);
      if (image == null) {
        throw const OCRException(
          'Failed to decode original image',
          'IMAGE_CROPPING_FAILED',
        );
      }

      // Validate crop parameters
      if (x < 0 ||
          y < 0 ||
          x + width > image.width ||
          y + height > image.height) {
        throw OCRException(
          'Invalid crop parameters: image ${image.width}x${image.height}, crop $x,$y ${width}x$height',
          'IMAGE_CROPPING_FAILED',
        );
      }

      // Crop the image
      final croppedImage = img.copyCrop(
        image,
        x: x,
        y: y,
        width: width,
        height: height,
      );

      // Encode to bytes
      final croppedBytes = img.encodeJpg(croppedImage, quality: 90);

      // Generate output file path
      final directory = await getTemporaryDirectory();
      final fileName = path.basenameWithoutExtension(originalFile.path);
      final outputPath = path.join(
        directory.path,
        '${fileName}_cropped${AppConstants.imageFileExtension}',
      );

      // Write cropped image to file
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(croppedBytes);

      return outputFile;
    } catch (e) {
      if (e is OCRException) {
        rethrow;
      }
      throw OCRException('Image cropping failed: $e', 'IMAGE_CROPPING_FAILED');
    }
  }

  /// Creates a thumbnail from the original image
  static Future<File> createThumbnail(
    File originalFile, {
    int thumbnailSize = 200,
  }) async {
    try {
      final image = await decodeImage(originalFile);
      if (image == null) {
        throw const OCRException(
          'Failed to create thumbnail',
          'IMAGE_THUMBNAIL_FAILED',
        );
      }

      // Calculate thumbnail dimensions maintaining aspect ratio
      int thumbWidth;
      int thumbHeight;
      if (image.width > image.height) {
        thumbWidth = thumbnailSize;
        thumbHeight = (thumbnailSize * image.height / image.width).round();
      } else {
        thumbHeight = thumbnailSize;
        thumbWidth = (thumbnailSize * image.width / image.height).round();
      }

      // Resize image to thumbnail size
      final thumbnail = img.copyResize(
        image,
        width: thumbWidth,
        height: thumbHeight,
        interpolation: img.Interpolation.cubic,
      );

      // Encode thumbnail
      final thumbnailBytes = img.encodeJpg(thumbnail, quality: 80);

      // Generate thumbnail file path
      final directory = await getApplicationDocumentsDirectory();
      final thumbnailDir = Directory(
        path.join(directory.path, AppConstants.thumbnailsDirectory),
      );
      await thumbnailDir.create(recursive: true);

      final fileName = path.basenameWithoutExtension(originalFile.path);
      final thumbnailPath = path.join(
        thumbnailDir.path,
        '$fileName${AppConstants.thumbnailSuffix}${AppConstants.imageFileExtension}',
      );

      // Write thumbnail to file
      final thumbnailFile = File(thumbnailPath);
      await thumbnailFile.writeAsBytes(thumbnailBytes);

      return thumbnailFile;
    } catch (e) {
      if (e is OCRException) {
        rethrow;
      }
      throw OCRException(
        'Failed to create thumbnail: $e',
        'IMAGE_THUMBNAIL_FAILED',
      );
    }
  }

  /// Converts camera image coordinates to actual image coordinates
  static ({int x, int y, int width, int height})
  convertOverlayToImageCoordinates({
    required double overlayX,
    required double overlayY,
    required double overlayWidth,
    required double overlayHeight,
    required int imageWidth,
    required int imageHeight,
    required double previewWidth,
    required double previewHeight,
  }) {
    // Calculate scale factors
    final scaleX = imageWidth / previewWidth;
    final scaleY = imageHeight / previewHeight;

    // Convert overlay coordinates to image coordinates
    final x = (overlayX * scaleX).round();
    final y = (overlayY * scaleY).round();
    final width = (overlayWidth * scaleX).round();
    final height = (overlayHeight * scaleY).round();

    return (x: x, y: y, width: width, height: height);
  }

  /// Gets the image dimensions without fully loading the image into memory
  static Future<({int width, int height})?> getImageDimensions(
    File imageFile,
  ) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      return (width: image.width, height: image.height);
    } catch (e) {
      return null;
    }
  }

  /// Calculates the file size in a human-readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  /// Checks if the given file is a valid image format
  static bool isValidImageFormat(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    const validExtensions = ['.jpg', '.jpeg', '.png', '.webp'];
    return validExtensions.contains(extension);
  }

  /// Cleans up temporary image files
  static Future<void> cleanupTempImages() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final tempFiles = tempDir.listSync().whereType<File>().where(
        (file) => path.extension(file.path) == AppConstants.imageFileExtension,
      );

      for (final file in tempFiles) {
        try {
          await file.delete();
        } catch (e) {
          // Ignore individual file deletion errors
        }
      }
    } catch (e) {
      // Ignore cleanup errors
    }
  }

  /// Saves an image to the application's captured images directory
  static Future<File> saveImageToAppDirectory(
    File sourceFile, {
    String? customFileName,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final capturedDir = Directory(
        path.join(directory.path, AppConstants.capturedImagesDirectory),
      );
      await capturedDir.create(recursive: true);

      final fileName =
          customFileName ??
          '${DateTime.now().millisecondsSinceEpoch}${AppConstants.imageFileExtension}';
      final destinationPath = path.join(capturedDir.path, fileName);

      final destinationFile = await sourceFile.copy(destinationPath);
      return destinationFile;
    } catch (e) {
      throw OCRException(
        'Failed to save image to app directory: $e',
        'SAVE_IMAGE_FAILED',
      );
    }
  }

  /// Converts Uint8List to File for processing
  static Future<File> uint8ListToFile(
    Uint8List data, {
    String? fileName,
  }) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File(
        path.join(
          tempDir.path,
          fileName ??
              '${DateTime.now().millisecondsSinceEpoch}${AppConstants.imageFileExtension}',
        ),
      );

      return await file.writeAsBytes(data);
    } catch (e) {
      throw OCRException(
        'Failed to convert bytes to file: $e',
        'BYTES_TO_FILE_FAILED',
      );
    }
  }

  /// Applies image filters to enhance OCR accuracy
  static Future<File> enhanceImageForOCR(File originalFile) async {
    try {
      final image = await decodeImage(originalFile);
      if (image == null) {
        throw const OCRException(
          'Failed to enhance image for OCR',
          'IMAGE_ENHANCEMENT_FAILED',
        );
      }

      // Apply image enhancements for better OCR
      var enhanced = image;

      // Increase contrast
      enhanced = img.contrast(enhanced, contrast: 1.2);

      // Increase brightness slightly
      enhanced = img.adjustColor(enhanced, brightness: 0.1);

      // Sharpen the image
      enhanced = img.convolution(
        enhanced,
        filter: [0, -1, 0, -1, 5, -1, 0, -1, 0],
        div: 1,
      );

      // Convert to grayscale for better text recognition
      enhanced = img.grayscale(enhanced);

      // Encode enhanced image
      final enhancedBytes = img.encodeJpg(enhanced, quality: 95);

      // Save enhanced image
      final directory = await getTemporaryDirectory();
      final fileName = path.basenameWithoutExtension(originalFile.path);
      final enhancedPath = path.join(
        directory.path,
        '${fileName}_enhanced${AppConstants.imageFileExtension}',
      );

      final enhancedFile = File(enhancedPath);
      await enhancedFile.writeAsBytes(enhancedBytes);

      return enhancedFile;
    } catch (e) {
      if (e is OCRException) {
        rethrow;
      }
      throw OCRException(
        'Failed to enhance image for OCR: $e',
        'IMAGE_ENHANCEMENT_FAILED',
      );
    }
  }
}
