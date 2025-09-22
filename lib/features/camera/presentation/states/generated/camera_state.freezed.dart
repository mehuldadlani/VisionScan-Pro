// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../camera_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$CameraState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            camera.CameraController controller, Size previewSize)
        ready,
    required TResult Function() initializing,
    required TResult Function(String message, bool canRetry) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(camera.CameraController controller, Size previewSize)?
        ready,
    TResult? Function()? initializing,
    TResult? Function(String message, bool canRetry)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(camera.CameraController controller, Size previewSize)?
        ready,
    TResult Function()? initializing,
    TResult Function(String message, bool canRetry)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Ready value) ready,
    required TResult Function(_Initializing value) initializing,
    required TResult Function(_Error value) error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Ready value)? ready,
    TResult? Function(_Initializing value)? initializing,
    TResult? Function(_Error value)? error,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Ready value)? ready,
    TResult Function(_Initializing value)? initializing,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CameraStateCopyWith<$Res> {
  factory $CameraStateCopyWith(
          CameraState value, $Res Function(CameraState) then) =
      _$CameraStateCopyWithImpl<$Res, CameraState>;
}

/// @nodoc
class _$CameraStateCopyWithImpl<$Res, $Val extends CameraState>
    implements $CameraStateCopyWith<$Res> {
  _$CameraStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$ReadyImplCopyWith<$Res> {
  factory _$$ReadyImplCopyWith(
          _$ReadyImpl value, $Res Function(_$ReadyImpl) then) =
      __$$ReadyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({camera.CameraController controller, Size previewSize});
}

/// @nodoc
class __$$ReadyImplCopyWithImpl<$Res>
    extends _$CameraStateCopyWithImpl<$Res, _$ReadyImpl>
    implements _$$ReadyImplCopyWith<$Res> {
  __$$ReadyImplCopyWithImpl(
      _$ReadyImpl _value, $Res Function(_$ReadyImpl) _then)
      : super(_value, _then);

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? controller = null,
    Object? previewSize = null,
  }) {
    return _then(_$ReadyImpl(
      controller: null == controller
          ? _value.controller
          : controller // ignore: cast_nullable_to_non_nullable
              as camera.CameraController,
      previewSize: null == previewSize
          ? _value.previewSize
          : previewSize // ignore: cast_nullable_to_non_nullable
              as Size,
    ));
  }
}

/// @nodoc

class _$ReadyImpl implements _Ready {
  const _$ReadyImpl({required this.controller, required this.previewSize});

  @override
  final camera.CameraController controller;
  @override
  final Size previewSize;

  @override
  String toString() {
    return 'CameraState.ready(controller: $controller, previewSize: $previewSize)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadyImpl &&
            (identical(other.controller, controller) ||
                other.controller == controller) &&
            (identical(other.previewSize, previewSize) ||
                other.previewSize == previewSize));
  }

  @override
  int get hashCode => Object.hash(runtimeType, controller, previewSize);

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadyImplCopyWith<_$ReadyImpl> get copyWith =>
      __$$ReadyImplCopyWithImpl<_$ReadyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            camera.CameraController controller, Size previewSize)
        ready,
    required TResult Function() initializing,
    required TResult Function(String message, bool canRetry) error,
  }) {
    return ready(controller, previewSize);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(camera.CameraController controller, Size previewSize)?
        ready,
    TResult? Function()? initializing,
    TResult? Function(String message, bool canRetry)? error,
  }) {
    return ready?.call(controller, previewSize);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(camera.CameraController controller, Size previewSize)?
        ready,
    TResult Function()? initializing,
    TResult Function(String message, bool canRetry)? error,
    required TResult orElse(),
  }) {
    if (ready != null) {
      return ready(controller, previewSize);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Ready value) ready,
    required TResult Function(_Initializing value) initializing,
    required TResult Function(_Error value) error,
  }) {
    return ready(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Ready value)? ready,
    TResult? Function(_Initializing value)? initializing,
    TResult? Function(_Error value)? error,
  }) {
    return ready?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Ready value)? ready,
    TResult Function(_Initializing value)? initializing,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (ready != null) {
      return ready(this);
    }
    return orElse();
  }
}

abstract class _Ready implements CameraState {
  const factory _Ready(
      {required final camera.CameraController controller,
      required final Size previewSize}) = _$ReadyImpl;

  camera.CameraController get controller;
  Size get previewSize;

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadyImplCopyWith<_$ReadyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$InitializingImplCopyWith<$Res> {
  factory _$$InitializingImplCopyWith(
          _$InitializingImpl value, $Res Function(_$InitializingImpl) then) =
      __$$InitializingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitializingImplCopyWithImpl<$Res>
    extends _$CameraStateCopyWithImpl<$Res, _$InitializingImpl>
    implements _$$InitializingImplCopyWith<$Res> {
  __$$InitializingImplCopyWithImpl(
      _$InitializingImpl _value, $Res Function(_$InitializingImpl) _then)
      : super(_value, _then);

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitializingImpl implements _Initializing {
  const _$InitializingImpl();

  @override
  String toString() {
    return 'CameraState.initializing()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitializingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            camera.CameraController controller, Size previewSize)
        ready,
    required TResult Function() initializing,
    required TResult Function(String message, bool canRetry) error,
  }) {
    return initializing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(camera.CameraController controller, Size previewSize)?
        ready,
    TResult? Function()? initializing,
    TResult? Function(String message, bool canRetry)? error,
  }) {
    return initializing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(camera.CameraController controller, Size previewSize)?
        ready,
    TResult Function()? initializing,
    TResult Function(String message, bool canRetry)? error,
    required TResult orElse(),
  }) {
    if (initializing != null) {
      return initializing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Ready value) ready,
    required TResult Function(_Initializing value) initializing,
    required TResult Function(_Error value) error,
  }) {
    return initializing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Ready value)? ready,
    TResult? Function(_Initializing value)? initializing,
    TResult? Function(_Error value)? error,
  }) {
    return initializing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Ready value)? ready,
    TResult Function(_Initializing value)? initializing,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (initializing != null) {
      return initializing(this);
    }
    return orElse();
  }
}

abstract class _Initializing implements CameraState {
  const factory _Initializing() = _$InitializingImpl;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, bool canRetry});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$CameraStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? canRetry = null,
  }) {
    return _then(_$ErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      canRetry: null == canRetry
          ? _value.canRetry
          : canRetry // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ErrorImpl implements _Error {
  const _$ErrorImpl({required this.message, required this.canRetry});

  @override
  final String message;
  @override
  final bool canRetry;

  @override
  String toString() {
    return 'CameraState.error(message: $message, canRetry: $canRetry)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.canRetry, canRetry) ||
                other.canRetry == canRetry));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, canRetry);

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            camera.CameraController controller, Size previewSize)
        ready,
    required TResult Function() initializing,
    required TResult Function(String message, bool canRetry) error,
  }) {
    return error(message, canRetry);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(camera.CameraController controller, Size previewSize)?
        ready,
    TResult? Function()? initializing,
    TResult? Function(String message, bool canRetry)? error,
  }) {
    return error?.call(message, canRetry);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(camera.CameraController controller, Size previewSize)?
        ready,
    TResult Function()? initializing,
    TResult Function(String message, bool canRetry)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, canRetry);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Ready value) ready,
    required TResult Function(_Initializing value) initializing,
    required TResult Function(_Error value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Ready value)? ready,
    TResult? Function(_Initializing value)? initializing,
    TResult? Function(_Error value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Ready value)? ready,
    TResult Function(_Initializing value)? initializing,
    TResult Function(_Error value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements CameraState {
  const factory _Error(
      {required final String message,
      required final bool canRetry}) = _$ErrorImpl;

  String get message;
  bool get canRetry;

  /// Create a copy of CameraState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
