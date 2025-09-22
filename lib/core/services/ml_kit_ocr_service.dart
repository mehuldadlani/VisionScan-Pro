import 'dart:io';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:visionscan_pro/core/error/exceptions.dart';
import 'package:visionscan_pro/core/logging/app_logger.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';

part 'generated/ml_kit_ocr_service.g.dart';

@riverpod
MLKitOCRService mlKitOCRService(Ref ref) {
  return MLKitOCRService();
}

/// Google ML Kit OCR service for reliable text recognition
///
/// Provides accurate text extraction from images with proper
/// coordinate mapping and number filtering capabilities.
class MLKitOCRService {
  TextRecognizer? _textRecognizer;
  bool _isInitialized = false;

  /// Initialize the text recognizer with optimized settings
  Future<void> _initializeRecognizer() async {
    if (_isInitialized) return;

    try {
      _textRecognizer = TextRecognizer();
      _isInitialized = true;
      AppLogger.info('ML Kit TextRecognizer initialized successfully');
    } catch (e) {
      AppLogger.error('Failed to initialize TextRecognizer', error: e);
      rethrow;
    }
  }

  /// Get the text recognizer, initializing if needed
  Future<TextRecognizer> get _recognizer async {
    await _initializeRecognizer();
    return _textRecognizer!;
  }

  /// Process image and extract numeric text from specified rectangle
  ///
  /// [imageFile] - Source image file to process
  /// [cropRect] - UI coordinates of the scanning rectangle
  /// [previewSize] - Size of the camera preview for coordinate mapping
  Future<ScanResult> extractNumbersFromImage(
    File imageFile,
    Rect cropRect,
    Size previewSize,
  ) async {
    final stopwatch = Stopwatch()..start();

    try {
      AppLogger.info(
        'Starting OCR processing: ${imageFile.path}, '
        'cropRect: $cropRect, previewSize: $previewSize',
      );

      // Step 1: Load and crop image to exact rectangle bounds
      final croppedImage = await _cropImageToRectangle(
        imageFile,
        cropRect,
        previewSize,
      );

      if (croppedImage == null) {
        throw const OCRException('Failed to crop image to scanning rectangle');
      }

      AppLogger.info('Image cropped successfully: ${croppedImage.path}');

      // Step 2: Process with Google ML Kit
      final inputImage = InputImage.fromFile(croppedImage);

      // Add debug info about the input image
      final imageStats = await croppedImage.length();
      AppLogger.debug(
        'Input image for ML Kit: ${croppedImage.path}, size: $imageStats bytes',
      );

      final recognizer = await _recognizer;
      final recognizedText = await recognizer.processImage(inputImage);

      AppLogger.info(
        'ML Kit processing completed. Blocks found: ${recognizedText.blocks.length}',
      );

      // Log text block details for debugging
      if (recognizedText.blocks.isEmpty) {
        AppLogger.warning(
          'No text blocks detected by ML Kit - this may indicate:',
        );
        AppLogger.warning('- Poor image quality or lighting');
        AppLogger.warning('- Text not in the cropped region');
        AppLogger.warning('- Text too small or blurry for OCR');
        AppLogger.warning('- Image enhancement too aggressive');
      } else {
        for (var i = 0; i < recognizedText.blocks.length; i++) {
          final block = recognizedText.blocks[i];
          AppLogger.debug(
            'Block $i: "${block.text}" (${block.lines.length} lines)',
          );
        }
      }

      // Step 3: Extract and filter numeric content
      var extractedNumbers = _extractNumbers(recognizedText);
      RecognizedText? originalRecognizedText;

      // Fallback: If no numbers found with cropped image, try with original image
      if (extractedNumbers.isEmpty) {
        AppLogger.warning(
          'No numbers found in cropped image, trying with original image as fallback',
        );

        // Process the original full image with OCR
        final originalInputImage = InputImage.fromFile(imageFile);
        final fallbackRecognizer = await _recognizer;
        originalRecognizedText = await fallbackRecognizer.processImage(
          originalInputImage,
        );

        AppLogger.info(
          'ML Kit processing on full image completed. Blocks found: ${originalRecognizedText.blocks.length}',
        );

        extractedNumbers = _extractNumbers(originalRecognizedText);

        if (extractedNumbers.isNotEmpty) {
          AppLogger.info(
            'Found ${extractedNumbers.length} numbers in full image fallback',
          );
        } else {
          AppLogger.warning('No numbers found in full image either');
        }
      }

      AppLogger.info('Final numbers extracted: $extractedNumbers');

      // Step 4: Clean up temporary cropped image
      try {
        if (croppedImage.existsSync()) {
          await croppedImage.delete();
        }
      } catch (e) {
        AppLogger.warning('Failed to delete temporary image', error: e);
      }

      // Calculate confidence from the recognized text that actually produced the numbers
      final finalRecognizedText =
          extractedNumbers.isNotEmpty && originalRecognizedText != null
          ? originalRecognizedText
          : recognizedText;
      final confidence = _calculateAverageConfidence(finalRecognizedText);
      stopwatch.stop();

      final result = ScanResult(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        extractedNumbers: extractedNumbers,
        confidence: confidence,
        processingDurationMs: stopwatch.elapsedMilliseconds,
      );

      AppLogger.info(
        'OCR processing completed successfully. '
        'Numbers found: ${extractedNumbers.length}, '
        'Confidence: ${confidence.toStringAsFixed(2)}, '
        'Duration: ${stopwatch.elapsedMilliseconds}ms',
      );

      return result;
    } catch (e) {
      stopwatch.stop();
      AppLogger.error(
        'OCR processing failed after ${stopwatch.elapsedMilliseconds}ms',
        error: e,
      );
      throw OCRException('OCR processing failed: $e');
    }
  }

  /// Crop image to exact rectangle coordinates with proper scaling
  Future<File?> _cropImageToRectangle(
    File imageFile,
    Rect cropRect,
    Size previewSize,
  ) async {
    try {
      AppLogger.info('Starting enhanced image cropping process');

      // Load original image with iOS optimization
      final bytes = await imageFile.readAsBytes();

      // For iOS performance, limit image size for processing
      if (bytes.length > 5 * 1024 * 1024) {
        // 5MB limit
        AppLogger.warning('Image too large for processing, reducing quality');
        // Could implement image compression here if needed
      }

      final originalImage = img.decodeImage(bytes);

      if (originalImage == null) {
        AppLogger.error('Failed to decode image');
        return null;
      }

      AppLogger.info(
        'Original image loaded: ${originalImage.width}x${originalImage.height}',
      );

      // Convert UI coordinates to image coordinates
      final imageRect = _convertUIRectToImageRect(
        uiRect: cropRect,
        imageWidth: originalImage.width,
        imageHeight: originalImage.height,
        previewSize: previewSize,
      );

      AppLogger.info(
        'Crop rectangle mapped to image coordinates: '
        'x=${imageRect.left.toInt()}, y=${imageRect.top.toInt()}, '
        'width=${imageRect.width.toInt()}, height=${imageRect.height.toInt()}',
      );

      // Validate crop bounds
      if (imageRect.left < 0 ||
          imageRect.top < 0 ||
          imageRect.right > originalImage.width ||
          imageRect.bottom > originalImage.height) {
        AppLogger.warning(
          'Crop rectangle out of bounds, adjusting: '
          'original=${originalImage.width}x${originalImage.height}, '
          'requested=$imageRect',
        );
      }

      // Clamp to image bounds
      final safeRect = Rect.fromLTWH(
        imageRect.left.clamp(0.0, originalImage.width.toDouble()),
        imageRect.top.clamp(0.0, originalImage.height.toDouble()),
        imageRect.width.clamp(1.0, originalImage.width.toDouble()),
        imageRect.height.clamp(1.0, originalImage.height.toDouble()),
      );

      // Crop image to exact bounds
      var croppedImage = img.copyCrop(
        originalImage,
        x: safeRect.left.round(),
        y: safeRect.top.round(),
        width: safeRect.width.round(),
        height: safeRect.height.round(),
      );

      // Apply image enhancements for better OCR accuracy
      croppedImage = _enhanceImageForOCR(croppedImage);

      AppLogger.info(
        'Image cropped and enhanced to: ${croppedImage.width}x${croppedImage.height}',
      );

      // Save cropped image temporarily with high quality
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final croppedFile = File('${tempDir.path}/cropped_$timestamp.jpg');

      await croppedFile.writeAsBytes(img.encodeJpg(croppedImage, quality: 98));

      AppLogger.info('Enhanced cropped image saved: ${croppedFile.path}');

      return croppedFile;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Image cropping failed',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Apply image enhancements specifically for better OCR accuracy
  img.Image _enhanceImageForOCR(img.Image image) {
    try {
      var enhanced = image;

      // Convert to grayscale for better text recognition
      enhanced = img.grayscale(enhanced);

      // Moderate contrast increase for better text visibility
      enhanced = img.contrast(enhanced, contrast: 1.2);

      // Apply very light sharpening to enhance text edges
      enhanced = img.convolution(
        enhanced,
        filter: [0, -1, 0, -1, 5, -1, 0, -1, 0],
        div: 1,
      );

      // Slight brightness adjustment for better recognition
      enhanced = img.adjustColor(enhanced, brightness: 0.05);

      // Very light denoising to reduce artifacts without losing detail
      enhanced = img.gaussianBlur(enhanced, radius: 1);

      return enhanced;
    } catch (e) {
      AppLogger.warning('Image enhancement failed, using original: $e');
      return image;
    }
  }

  /// Convert UI overlay coordinates to actual image pixel coordinates
  ///
  /// This is critical for accurate cropping - must account for aspect ratio
  /// differences between camera preview and actual captured image
  Rect _convertUIRectToImageRect({
    required Rect uiRect,
    required int imageWidth,
    required int imageHeight,
    required Size previewSize,
  }) {
    // Calculate aspect ratios
    final imageAspectRatio = imageWidth / imageHeight;
    final previewAspectRatio = previewSize.width / previewSize.height;

    AppLogger.debug(
      'Aspect ratios - Image: ${imageAspectRatio.toStringAsFixed(3)}, '
      'Preview: ${previewAspectRatio.toStringAsFixed(3)}',
    );

    double scaleX;
    double scaleY;
    double offsetX = 0;
    double offsetY = 0;

    if (imageAspectRatio > previewAspectRatio) {
      // Image is wider - fit by height, center horizontally
      scaleY = imageHeight / previewSize.height;
      scaleX = scaleY;
      offsetX = (imageWidth - previewSize.width * scaleX) / 2;
    } else {
      // Image is taller - fit by width, center vertically
      scaleX = imageWidth / previewSize.width;
      scaleY = scaleX;
      offsetY = (imageHeight - previewSize.height * scaleY) / 2;
    }

    AppLogger.debug(
      'Scale factors - X: ${scaleX.toStringAsFixed(3)}, '
      'Y: ${scaleY.toStringAsFixed(3)}, '
      'Offset X: ${offsetX.toStringAsFixed(1)}, '
      'Offset Y: ${offsetY.toStringAsFixed(1)}',
    );

    // Apply the transformation - NO EXPANSION for now to test accuracy
    final transformedRect = Rect.fromLTWH(
      uiRect.left * scaleX + offsetX,
      uiRect.top * scaleY + offsetY,
      uiRect.width * scaleX,
      uiRect.height * scaleY,
    );

    // For debugging, let's use the exact transformed rect without expansion
    final finalRect = Rect.fromLTWH(
      transformedRect.left.clamp(0.0, imageWidth.toDouble()),
      transformedRect.top.clamp(0.0, imageHeight.toDouble()),
      transformedRect.width.clamp(1.0, imageWidth.toDouble()),
      transformedRect.height.clamp(1.0, imageHeight.toDouble()),
    );

    AppLogger.debug(
      'UI rect: $uiRect, '
      'Transformed rect: $transformedRect, '
      'Final rect: $finalRect',
    );

    return finalRect;
  }

  /// Extract numeric content from recognized text with intelligent filtering
  List<String> _extractNumbers(RecognizedText recognizedText) {
    final extractedNumbers = <String>[];

    if (recognizedText.blocks.isEmpty) {
      AppLogger.info('No text blocks found in recognized text');
      return extractedNumbers;
    }

    // Sort text blocks by position (top-to-bottom, left-to-right)
    final sortedBlocks = _sortTextBlocks(recognizedText.blocks);

    AppLogger.debug('Processing ${sortedBlocks.length} text blocks');

    for (var blockIndex = 0; blockIndex < sortedBlocks.length; blockIndex++) {
      final block = sortedBlocks[blockIndex];
      AppLogger.debug('Block $blockIndex: "${block.text}"');

      for (var lineIndex = 0; lineIndex < block.lines.length; lineIndex++) {
        final line = block.lines[lineIndex];
        AppLogger.debug('  Line $lineIndex: "${line.text}"');

        for (
          var elementIndex = 0;
          elementIndex < line.elements.length;
          elementIndex++
        ) {
          final element = line.elements[elementIndex];
          final text = element.text.trim();

          AppLogger.debug('    Element $elementIndex: "$text"');

          if (text.isEmpty) continue;

          // Enhanced number patterns for better extraction
          final numberPatterns = [
            // Basic numbers with optional decimal
            RegExp(r'\b\d+\.?\d*\b'),

            // Numbers with thousand separators (commas)
            RegExp(r'\b\d{1,3}(?:,\d{3})+\.?\d*\b'),

            // Numbers with thousand separators (spaces)
            RegExp(r'\b\d{1,3}(?:\s\d{3})+(?:[,\.]\d+)?\b'),

            // Explicit decimal numbers
            RegExp(r'\b\d+\.\d+\b'),

            // Numbers with spaces around decimal
            RegExp(r'\b\d+\s*\.\s*\d+\b'),

            // Currency format (xx.xx or xx,xx)
            RegExp(r'\b\d+[,\.]\d{2}\b'),

            // European decimal format (comma as decimal)
            RegExp(r'\b\d+,\d+\b'),

            // Numbers with currency symbols
            RegExp(r'[$€£¥]\s*\d+(?:,\d{3})*(?:\.\d+)?\b'),
            RegExp(r'\b\d+(?:,\d{3})*(?:\.\d+)?\s*[$€£¥]\b'),

            // Percentage numbers
            RegExp(r'\b\d+(?:\.\d+)?%\b'),

            // Large numbers with mixed separators
            RegExp(r'\b\d+(?:[,\s]\d{3})*(?:\.\d+)?\b'),

            // Negative numbers
            RegExp(r'-\s*\d+(?:[,\s]\d{3})*(?:\.\d+)?\b'),

            // Scientific notation
            RegExp(r'\b\d+\.?\d*[eE][+-]?\d+\b'),
          ];

          for (final pattern in numberPatterns) {
            final matches = pattern.allMatches(text);

            for (final match in matches) {
              final numberStr = match.group(0);
              if (numberStr != null && numberStr.isNotEmpty) {
                // Clean the number string
                final cleanedNumber = _cleanNumberString(numberStr);

                if (_isValidNumber(cleanedNumber)) {
                  AppLogger.debug('      Extracted number: "$cleanedNumber"');

                  // Avoid duplicates
                  if (!extractedNumbers.contains(cleanedNumber)) {
                    extractedNumbers.add(cleanedNumber);
                  }
                }
              }
            }
          }
        }
      }
    }

    AppLogger.info(
      'Total unique numbers extracted: ${extractedNumbers.length}',
    );
    return extractedNumbers;
  }

  /// Clean number string by removing unnecessary characters and fixing OCR errors
  String _cleanNumberString(String numberStr) {
    // Remove common OCR artifacts and formatting
    var cleaned = numberStr
        .replaceAll(
          RegExp(r'[$€£¥%]'),
          '',
        ) // Remove currency symbols and percentage
        .replaceAll(',', '') // Remove thousand separators
        .replaceAll(' ', '') // Remove spaces
        .replaceAll('O', '0') // Replace common OCR mistake O->0
        .replaceAll('o', '0') // Replace lowercase o->0
        .replaceAll('l', '1') // Replace common OCR mistake l->1
        .replaceAll('I', '1') // Replace common OCR mistake I->1
        .replaceAll('|', '1') // Replace pipe->1
        .replaceAll('S', '5') // Replace S->5
        .replaceAll('s', '5') // Replace s->5
        .replaceAll('Z', '2') // Replace Z->2
        .replaceAll('z', '2') // Replace z->2
        .replaceAll('B', '8') // Replace B->8
        .replaceAll('G', '6') // Replace G->6
        .replaceAll('g', '9') // Replace g->9
        .replaceAll('T', '7') // Replace T->7
        .replaceAll('t', '7') // Replace t->7
        .replaceAll('"', '') // Remove quotes
        .replaceAll("'", '') // Remove apostrophes
        .trim();

    // Handle European decimal format (comma as decimal separator)
    if (cleaned.contains(',') && cleaned.contains('.')) {
      // Mixed format - use the last one as decimal
      if (cleaned.indexOf(',') < cleaned.indexOf('.')) {
        cleaned = cleaned.replaceAll(',', '');
      } else {
        cleaned = cleaned.replaceAll('.', '').replaceAll(',', '.');
      }
    } else if (cleaned.contains(',') && !cleaned.contains('.')) {
      // Check if it's likely a European decimal (one comma, followed by digits)
      final commaParts = cleaned.split(',');
      if (commaParts.length == 2 && commaParts[1].length <= 2) {
        cleaned = cleaned.replaceAll(',', '.');
      } else {
        cleaned = cleaned.replaceAll(',', '');
      }
    }

    // Remove negative signs if they're not at the beginning
    if (cleaned.contains('-') && !cleaned.startsWith('-')) {
      cleaned = cleaned.replaceAll('-', '');
    }

    return cleaned;
  }

  /// Sort text blocks for natural reading order
  List<TextBlock> _sortTextBlocks(List<TextBlock> blocks) {
    final sortedBlocks = List<TextBlock>.from(blocks)
      ..sort((a, b) {
        final aTop = a.boundingBox.top;
        final bTop = b.boundingBox.top;

        // If blocks are roughly at the same height (within 20 pixels),
        // sort by left position (left-to-right)
        if ((aTop - bTop).abs() < 20) {
          return a.boundingBox.left.compareTo(b.boundingBox.left);
        }

        // Otherwise sort by top position (top-to-bottom)
        return aTop.compareTo(bTop);
      });

    return sortedBlocks;
  }

  /// Validate extracted number with comprehensive checks
  bool _isValidNumber(String numberStr) {
    if (numberStr.isEmpty) return false;

    // Must be parseable as a number
    final number = double.tryParse(numberStr);
    if (number == null) return false;

    // Length validation - reasonable bounds
    if (numberStr.length > 20) return false; // Too long
    if (numberStr.isEmpty) return false; // Too short

    // Reject common OCR mistakes
    if (numberStr.contains('..')) return false; // Multiple consecutive dots
    if (RegExp(r'\..*\.').hasMatch(numberStr)) return false; // Multiple dots

    // Reject leading zeros (except for decimal numbers like 0.5)
    if (numberStr.startsWith('0') &&
        numberStr.length > 1 &&
        !numberStr.contains('.')) {
      return false;
    }

    // Reject unreasonable numbers
    if (number.isNaN || number.isInfinite) return false;

    // Accept the number
    return true;
  }

  /// Calculate confidence score based on text recognition quality
  ///
  /// Since ML Kit doesn't provide direct confidence scores,
  /// we estimate based on text characteristics and consistency
  double _calculateAverageConfidence(RecognizedText recognizedText) {
    AppLogger.info(
      'Calculating confidence for ${recognizedText.blocks.length} blocks',
    );
    if (recognizedText.blocks.isEmpty) return 0;

    var totalConfidence = 0.0;
    var elementCount = 0;

    for (final block in recognizedText.blocks) {
      for (final line in block.lines) {
        for (final element in line.elements) {
          // Estimate confidence based on text characteristics
          final text = element.text.trim();
          var elementConfidence = 0.0;

          if (text.isNotEmpty) {
            // Higher base confidence for better OCR results
            elementConfidence = 0.7;

            // Larger bonus for numeric content (primary use case)
            if (RegExp(r'\d').hasMatch(text)) {
              elementConfidence += 0.25;
            }

            // Bonus for clean numeric text
            if (RegExp(r'^\d+[.,]?\d*$').hasMatch(text)) {
              elementConfidence += 0.15;
            }

            // Bonus for reasonable length (typical numbers)
            if (text.isNotEmpty && text.length <= 6) {
              elementConfidence += 0.1;
            }

            // Small penalty for non-numeric characters
            if (text.contains(RegExp(r'[^0-9.,\s-]'))) {
              elementConfidence -= 0.05;
            }

            // Clamp to valid range
            elementConfidence = elementConfidence.clamp(0.0, 1.0);
          }

          totalConfidence += elementConfidence;
          elementCount++;
        }
      }
    }

    // If we have numeric elements, ensure minimum confidence
    final averageConfidence = elementCount > 0
        ? totalConfidence / elementCount
        : 0.0;

    // Boost confidence if we found good numeric content
    final finalConfidence = averageConfidence > 0
        ? averageConfidence.clamp(0.6, 1.0) // Minimum 60% if we found anything
        : 0.0;

    AppLogger.info(
      'Calculated confidence: ${finalConfidence.toStringAsFixed(3)} '
      '(raw: ${averageConfidence.toStringAsFixed(3)}) '
      'from $elementCount elements',
    );

    return finalConfidence;
  }

  /// Clean up resources
  void dispose() {
    AppLogger.info('Disposing ML Kit OCR service');
    _textRecognizer?.close();
  }
}
