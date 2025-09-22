// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../scan_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScanResultImpl _$$ScanResultImplFromJson(Map json) => $checkedCreate(
      r'_$ScanResultImpl',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'id',
            'timestamp',
            'extracted_numbers',
            'confidence',
            'image_path',
            'processing_duration_ms',
            'notes',
            'is_from_gallery',
            'metadata'
          ],
        );
        final val = _$ScanResultImpl(
          id: $checkedConvert('id', (v) => v as String),
          timestamp:
              $checkedConvert('timestamp', (v) => DateTime.parse(v as String)),
          extractedNumbers: $checkedConvert('extracted_numbers',
              (v) => (v as List<dynamic>).map((e) => e as String).toList()),
          confidence:
              $checkedConvert('confidence', (v) => (v as num).toDouble()),
          imagePath: $checkedConvert('image_path', (v) => v as String?),
          processingDurationMs: $checkedConvert(
              'processing_duration_ms', (v) => (v as num?)?.toInt()),
          notes: $checkedConvert('notes', (v) => v as String?),
          isFromGallery:
              $checkedConvert('is_from_gallery', (v) => v as bool? ?? false),
          metadata: $checkedConvert(
              'metadata',
              (v) => (v as Map?)?.map(
                    (k, e) => MapEntry(k as String, e),
                  )),
        );
        return val;
      },
      fieldKeyMap: const {
        'extractedNumbers': 'extracted_numbers',
        'imagePath': 'image_path',
        'processingDurationMs': 'processing_duration_ms',
        'isFromGallery': 'is_from_gallery'
      },
    );

const _$$ScanResultImplFieldMap = <String, String>{
  'id': 'id',
  'timestamp': 'timestamp',
  'extractedNumbers': 'extracted_numbers',
  'confidence': 'confidence',
  'imagePath': 'image_path',
  'processingDurationMs': 'processing_duration_ms',
  'notes': 'notes',
  'isFromGallery': 'is_from_gallery',
  'metadata': 'metadata',
};

abstract final class _$$ScanResultImplJsonKeys {
  static const String id = 'id';
  static const String timestamp = 'timestamp';
  static const String extractedNumbers = 'extracted_numbers';
  static const String confidence = 'confidence';
  static const String imagePath = 'image_path';
  static const String processingDurationMs = 'processing_duration_ms';
  static const String notes = 'notes';
  static const String isFromGallery = 'is_from_gallery';
  static const String metadata = 'metadata';
}

// ignore: unused_element
abstract class _$$ScanResultImplPerFieldToJson {
  // ignore: unused_element
  static Object? id(String instance) => instance;
  // ignore: unused_element
  static Object? timestamp(DateTime instance) => instance.toIso8601String();
  // ignore: unused_element
  static Object? extractedNumbers(List<String> instance) => instance;
  // ignore: unused_element
  static Object? confidence(double instance) => instance;
  // ignore: unused_element
  static Object? imagePath(String? instance) => instance;
  // ignore: unused_element
  static Object? processingDurationMs(int? instance) => instance;
  // ignore: unused_element
  static Object? notes(String? instance) => instance;
  // ignore: unused_element
  static Object? isFromGallery(bool instance) => instance;
  // ignore: unused_element
  static Object? metadata(Map<String, dynamic>? instance) => instance;
}

Map<String, dynamic> _$$ScanResultImplToJson(_$ScanResultImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'extracted_numbers': instance.extractedNumbers,
      'confidence': instance.confidence,
      if (instance.imagePath case final value?) 'image_path': value,
      if (instance.processingDurationMs case final value?)
        'processing_duration_ms': value,
      if (instance.notes case final value?) 'notes': value,
      'is_from_gallery': instance.isFromGallery,
      if (instance.metadata case final value?) 'metadata': value,
    };
