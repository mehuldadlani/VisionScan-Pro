import 'dart:convert';

import 'package:objectbox/objectbox.dart';

import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';

/// ObjectBox entity for scan result persistence
///
/// Maps between domain ScanResult objects and database storage
/// with proper type conversions and JSON serialization.
@Entity()
class ScanResultEntity {

  /// Create entity for ObjectBox
  ScanResultEntity({
    required this.scanId,
    required this.timestamp,
    required this.extractedNumbersJson,
    required this.confidence,
    this.imagePath,
    this.processingDurationMs,
    this.notes,
    this.isFromGallery = false,
    this.metadataJson,
  });
  /// Create entity from domain model
  factory ScanResultEntity.fromDomain(ScanResult scanResult) {
    // Convert extracted numbers to JSON
    final extractedNumbersJson = json.encode(scanResult.extractedNumbers);

    // Convert metadata to JSON if present
    String? metadataJson;
    if (scanResult.metadata != null && scanResult.metadata!.isNotEmpty) {
      try {
        metadataJson = json.encode(scanResult.metadata);
      } catch (e) {
        // Ignore serialization errors
        metadataJson = null;
      }
    }

    return ScanResultEntity(
      scanId: scanResult.id,
      timestamp: scanResult.timestamp.millisecondsSinceEpoch,
      extractedNumbersJson: extractedNumbersJson,
      confidence: scanResult.confidence,
      imagePath: scanResult.imagePath,
      processingDurationMs: scanResult.processingDurationMs,
      notes: scanResult.notes,
      isFromGallery: scanResult.isFromGallery,
      metadataJson: metadataJson,
    );
  }

  /// ObjectBox primary key
  @Id()
  int id = 0;

  /// Unique scan identifier from domain
  @Unique()
  String scanId;

  /// Timestamp as milliseconds since epoch
  int timestamp;

  /// Extracted numbers as JSON array string
  String extractedNumbersJson;

  /// OCR confidence score
  double confidence;

  /// Optional image file path
  String? imagePath;

  /// Processing duration in milliseconds
  int? processingDurationMs;

  /// Optional user notes
  String? notes;

  /// Source flag: gallery vs camera
  bool isFromGallery;

  /// Additional metadata as JSON string
  String? metadataJson;

  /// Convert entity to domain model
  ScanResult toDomain() {
    // Parse extracted numbers from JSON
    var extractedNumbers = <String>[];
    try {
      final jsonList = json.decode(extractedNumbersJson) as List<dynamic>;
      extractedNumbers = jsonList.cast<String>();
    } catch (e) {
      // Fallback for corrupted data
      extractedNumbers = [];
    }

    // Parse metadata from JSON
    Map<String, dynamic>? metadata;
    if (metadataJson != null && metadataJson!.isNotEmpty) {
      try {
        metadata = json.decode(metadataJson!) as Map<String, dynamic>;
      } catch (e) {
        // Ignore corrupted metadata
        metadata = null;
      }
    }

    return ScanResult(
      id: scanId,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
      extractedNumbers: extractedNumbers,
      confidence: confidence,
      imagePath: imagePath,
      processingDurationMs: processingDurationMs,
      notes: notes,
      isFromGallery: isFromGallery,
      metadata: metadata,
    );
  }

  /// Create a copy with updated fields
  ScanResultEntity copyWith({
    int? id,
    String? scanId,
    int? timestamp,
    String? extractedNumbersJson,
    double? confidence,
    String? imagePath,
    int? processingDurationMs,
    String? notes,
    bool? isFromGallery,
    String? metadataJson,
  }) {
    return ScanResultEntity(
      scanId: scanId ?? this.scanId,
      timestamp: timestamp ?? this.timestamp,
      extractedNumbersJson: extractedNumbersJson ?? this.extractedNumbersJson,
      confidence: confidence ?? this.confidence,
      imagePath: imagePath ?? this.imagePath,
      processingDurationMs: processingDurationMs ?? this.processingDurationMs,
      notes: notes ?? this.notes,
      isFromGallery: isFromGallery ?? this.isFromGallery,
      metadataJson: metadataJson ?? this.metadataJson,
    )..id = id ?? this.id;
  }

  /// Debug string representation
  @override
  String toString() {
    return 'ScanResultEntity(id: $id, scanId: $scanId, '
        'timestamp: ${DateTime.fromMillisecondsSinceEpoch(timestamp)}, '
        'extractedNumbers: ${extractedNumbersJson.length} chars, '
        'confidence: ${confidence.toStringAsFixed(2)}, '
        'isFromGallery: $isFromGallery)';
  }

 
}
