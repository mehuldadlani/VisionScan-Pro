import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/scan_result.freezed.dart';
part 'generated/scan_result.g.dart';

/// Scan result entity representing a completed OCR processing session
///
/// Contains all metadata and extracted data from a scanning operation,
/// including confidence scores, timing information, and file references.
@freezed
class ScanResult with _$ScanResult {
  /// Creates a scan result
  const factory ScanResult({
    /// Unique identifier for this scan
    required String id,

    /// Timestamp when the scan was performed
    required DateTime timestamp,

    /// List of numbers extracted from the image
    required List<String> extractedNumbers,

    /// OCR confidence score (0.0 to 1.0)
    required double confidence,

    /// Path to the source image file (if still available)
    String? imagePath,

    /// Processing duration in milliseconds
    int? processingDurationMs,

    /// Optional user notes or tags
    String? notes,

    /// Whether this scan was processed from gallery vs camera
    @Default(false) bool isFromGallery,

    /// Additional metadata
    Map<String, dynamic>? metadata,
  }) = _ScanResult;

  /// Create ScanResult from JSON
  factory ScanResult.fromJson(Map<String, dynamic> json) =>
      _$ScanResultFromJson(json);
}

/// Extension methods for ScanResult
extension ScanResultExtension on ScanResult {
  /// Get confidence as a percentage string
  String get confidencePercentage =>
      '${(confidence * 100).toStringAsFixed(1)}%';

  /// Check if confidence is considered high (> 80%)
  bool get hasHighConfidence => confidence > 0.8;

  /// Check if confidence is considered low (< 60%)
  bool get hasLowConfidence => confidence < 0.6;

  /// Get processing duration as human-readable string
  String get processingDurationText {
    if (processingDurationMs == null) return 'Unknown';

    final duration = processingDurationMs!;
    if (duration < 1000) {
      return '${duration}ms';
    } else {
      final seconds = (duration / 1000).toStringAsFixed(1);
      return '${seconds}s';
    }
  }

  /// Get formatted timestamp for display
  String get formattedTimestamp {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      // Format as date string
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  /// Get extraction summary
  String get extractionSummary {
    final count = extractedNumbers.length;
    if (count == 0) {
      return 'No numbers found';
    } else if (count == 1) {
      return '1 number found';
    } else {
      return '$count numbers found';
    }
  }

  /// Get the numbers as actual numeric values (filtering out invalid ones)
  List<double> get numericValues {
    return extractedNumbers
        .map(double.tryParse)
        .where((value) => value != null)
        .cast<double>()
        .toList();
  }

  /// Get the total sum of all extracted numbers
  double get totalSum {
    return numericValues.fold(0, (sum, value) => sum + value);
  }

  /// Get the average of all extracted numbers
  double get average {
    final values = numericValues;
    if (values.isEmpty) return 0;
    return totalSum / values.length;
  }

  /// Get the minimum extracted number
  double? get minimum {
    final values = numericValues;
    if (values.isEmpty) return null;
    return values.reduce((a, b) => a < b ? a : b);
  }

  /// Get the maximum extracted number
  double? get maximum {
    final values = numericValues;
    if (values.isEmpty) return null;
    return values.reduce((a, b) => a > b ? a : b);
  }

  /// Get age of the scan in days
  int get ageInDays {
    return DateTime.now().difference(timestamp).inDays;
  }

  /// Check if this is a recent scan (within 24 hours)
  bool get isRecent => ageInDays == 0;

  /// Get source type description
  String get sourceDescription => isFromGallery ? 'Gallery' : 'Camera';

  /// Create a copy with updated notes
  ScanResult withNotes(String newNotes) {
    return copyWith(notes: newNotes);
  }

  /// Create a copy with additional metadata
  ScanResult withMetadata(Map<String, dynamic> additionalMetadata) {
    final currentMetadata = metadata ?? <String, dynamic>{};
    return copyWith(metadata: {...currentMetadata, ...additionalMetadata});
  }
}
