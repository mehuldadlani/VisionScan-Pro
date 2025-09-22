// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../scan_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ScanResult _$ScanResultFromJson(Map<String, dynamic> json) {
  return _ScanResult.fromJson(json);
}

/// @nodoc
mixin _$ScanResult {
  /// Unique identifier for this scan
  String get id => throw _privateConstructorUsedError;

  /// Timestamp when the scan was performed
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// List of numbers extracted from the image
  List<String> get extractedNumbers => throw _privateConstructorUsedError;

  /// OCR confidence score (0.0 to 1.0)
  double get confidence => throw _privateConstructorUsedError;

  /// Path to the source image file (if still available)
  String? get imagePath => throw _privateConstructorUsedError;

  /// Processing duration in milliseconds
  int? get processingDurationMs => throw _privateConstructorUsedError;

  /// Optional user notes or tags
  String? get notes => throw _privateConstructorUsedError;

  /// Whether this scan was processed from gallery vs camera
  bool get isFromGallery => throw _privateConstructorUsedError;

  /// Additional metadata
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            DateTime timestamp,
            List<String> extractedNumbers,
            double confidence,
            String? imagePath,
            int? processingDurationMs,
            String? notes,
            bool isFromGallery,
            Map<String, dynamic>? metadata)
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            DateTime timestamp,
            List<String> extractedNumbers,
            double confidence,
            String? imagePath,
            int? processingDurationMs,
            String? notes,
            bool isFromGallery,
            Map<String, dynamic>? metadata)?
        $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            DateTime timestamp,
            List<String> extractedNumbers,
            double confidence,
            String? imagePath,
            int? processingDurationMs,
            String? notes,
            bool isFromGallery,
            Map<String, dynamic>? metadata)?
        $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ScanResult value) $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ScanResult value)? $default,
  ) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ScanResult value)? $default, {
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this ScanResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ScanResultCopyWith<ScanResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScanResultCopyWith<$Res> {
  factory $ScanResultCopyWith(
          ScanResult value, $Res Function(ScanResult) then) =
      _$ScanResultCopyWithImpl<$Res, ScanResult>;
  @useResult
  $Res call(
      {String id,
      DateTime timestamp,
      List<String> extractedNumbers,
      double confidence,
      String? imagePath,
      int? processingDurationMs,
      String? notes,
      bool isFromGallery,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class _$ScanResultCopyWithImpl<$Res, $Val extends ScanResult>
    implements $ScanResultCopyWith<$Res> {
  _$ScanResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? extractedNumbers = null,
    Object? confidence = null,
    Object? imagePath = freezed,
    Object? processingDurationMs = freezed,
    Object? notes = freezed,
    Object? isFromGallery = null,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      extractedNumbers: null == extractedNumbers
          ? _value.extractedNumbers
          : extractedNumbers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      processingDurationMs: freezed == processingDurationMs
          ? _value.processingDurationMs
          : processingDurationMs // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isFromGallery: null == isFromGallery
          ? _value.isFromGallery
          : isFromGallery // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScanResultImplCopyWith<$Res>
    implements $ScanResultCopyWith<$Res> {
  factory _$$ScanResultImplCopyWith(
          _$ScanResultImpl value, $Res Function(_$ScanResultImpl) then) =
      __$$ScanResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime timestamp,
      List<String> extractedNumbers,
      double confidence,
      String? imagePath,
      int? processingDurationMs,
      String? notes,
      bool isFromGallery,
      Map<String, dynamic>? metadata});
}

/// @nodoc
class __$$ScanResultImplCopyWithImpl<$Res>
    extends _$ScanResultCopyWithImpl<$Res, _$ScanResultImpl>
    implements _$$ScanResultImplCopyWith<$Res> {
  __$$ScanResultImplCopyWithImpl(
      _$ScanResultImpl _value, $Res Function(_$ScanResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? timestamp = null,
    Object? extractedNumbers = null,
    Object? confidence = null,
    Object? imagePath = freezed,
    Object? processingDurationMs = freezed,
    Object? notes = freezed,
    Object? isFromGallery = null,
    Object? metadata = freezed,
  }) {
    return _then(_$ScanResultImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      extractedNumbers: null == extractedNumbers
          ? _value._extractedNumbers
          : extractedNumbers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      imagePath: freezed == imagePath
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      processingDurationMs: freezed == processingDurationMs
          ? _value.processingDurationMs
          : processingDurationMs // ignore: cast_nullable_to_non_nullable
              as int?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      isFromGallery: null == isFromGallery
          ? _value.isFromGallery
          : isFromGallery // ignore: cast_nullable_to_non_nullable
              as bool,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ScanResultImpl implements _ScanResult {
  const _$ScanResultImpl(
      {required this.id,
      required this.timestamp,
      required final List<String> extractedNumbers,
      required this.confidence,
      this.imagePath,
      this.processingDurationMs,
      this.notes,
      this.isFromGallery = false,
      final Map<String, dynamic>? metadata})
      : _extractedNumbers = extractedNumbers,
        _metadata = metadata;

  factory _$ScanResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$ScanResultImplFromJson(json);

  /// Unique identifier for this scan
  @override
  final String id;

  /// Timestamp when the scan was performed
  @override
  final DateTime timestamp;

  /// List of numbers extracted from the image
  final List<String> _extractedNumbers;

  /// List of numbers extracted from the image
  @override
  List<String> get extractedNumbers {
    if (_extractedNumbers is EqualUnmodifiableListView)
      return _extractedNumbers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_extractedNumbers);
  }

  /// OCR confidence score (0.0 to 1.0)
  @override
  final double confidence;

  /// Path to the source image file (if still available)
  @override
  final String? imagePath;

  /// Processing duration in milliseconds
  @override
  final int? processingDurationMs;

  /// Optional user notes or tags
  @override
  final String? notes;

  /// Whether this scan was processed from gallery vs camera
  @override
  @JsonKey()
  final bool isFromGallery;

  /// Additional metadata
  final Map<String, dynamic>? _metadata;

  /// Additional metadata
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'ScanResult(id: $id, timestamp: $timestamp, extractedNumbers: $extractedNumbers, confidence: $confidence, imagePath: $imagePath, processingDurationMs: $processingDurationMs, notes: $notes, isFromGallery: $isFromGallery, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScanResultImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality()
                .equals(other._extractedNumbers, _extractedNumbers) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.processingDurationMs, processingDurationMs) ||
                other.processingDurationMs == processingDurationMs) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isFromGallery, isFromGallery) ||
                other.isFromGallery == isFromGallery) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      timestamp,
      const DeepCollectionEquality().hash(_extractedNumbers),
      confidence,
      imagePath,
      processingDurationMs,
      notes,
      isFromGallery,
      const DeepCollectionEquality().hash(_metadata));

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ScanResultImplCopyWith<_$ScanResultImpl> get copyWith =>
      __$$ScanResultImplCopyWithImpl<_$ScanResultImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            DateTime timestamp,
            List<String> extractedNumbers,
            double confidence,
            String? imagePath,
            int? processingDurationMs,
            String? notes,
            bool isFromGallery,
            Map<String, dynamic>? metadata)
        $default,
  ) {
    return $default(id, timestamp, extractedNumbers, confidence, imagePath,
        processingDurationMs, notes, isFromGallery, metadata);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            DateTime timestamp,
            List<String> extractedNumbers,
            double confidence,
            String? imagePath,
            int? processingDurationMs,
            String? notes,
            bool isFromGallery,
            Map<String, dynamic>? metadata)?
        $default,
  ) {
    return $default?.call(id, timestamp, extractedNumbers, confidence,
        imagePath, processingDurationMs, notes, isFromGallery, metadata);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            DateTime timestamp,
            List<String> extractedNumbers,
            double confidence,
            String? imagePath,
            int? processingDurationMs,
            String? notes,
            bool isFromGallery,
            Map<String, dynamic>? metadata)?
        $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(id, timestamp, extractedNumbers, confidence, imagePath,
          processingDurationMs, notes, isFromGallery, metadata);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ScanResult value) $default,
  ) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ScanResult value)? $default,
  ) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ScanResult value)? $default, {
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ScanResultImplToJson(
      this,
    );
  }
}

abstract class _ScanResult implements ScanResult {
  const factory _ScanResult(
      {required final String id,
      required final DateTime timestamp,
      required final List<String> extractedNumbers,
      required final double confidence,
      final String? imagePath,
      final int? processingDurationMs,
      final String? notes,
      final bool isFromGallery,
      final Map<String, dynamic>? metadata}) = _$ScanResultImpl;

  factory _ScanResult.fromJson(Map<String, dynamic> json) =
      _$ScanResultImpl.fromJson;

  /// Unique identifier for this scan
  @override
  String get id;

  /// Timestamp when the scan was performed
  @override
  DateTime get timestamp;

  /// List of numbers extracted from the image
  @override
  List<String> get extractedNumbers;

  /// OCR confidence score (0.0 to 1.0)
  @override
  double get confidence;

  /// Path to the source image file (if still available)
  @override
  String? get imagePath;

  /// Processing duration in milliseconds
  @override
  int? get processingDurationMs;

  /// Optional user notes or tags
  @override
  String? get notes;

  /// Whether this scan was processed from gallery vs camera
  @override
  bool get isFromGallery;

  /// Additional metadata
  @override
  Map<String, dynamic>? get metadata;

  /// Create a copy of ScanResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ScanResultImplCopyWith<_$ScanResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
