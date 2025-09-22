// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../permission_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PermissionResult _$PermissionResultFromJson(Map<String, dynamic> json) {
  switch (json['type']) {
    case 'granted':
      return _Granted.fromJson(json);
    case 'denied':
      return _Denied.fromJson(json);
    case 'permanently_denied':
      return _PermanentlyDenied.fromJson(json);
    case 'restricted':
      return _Restricted.fromJson(json);
    case 'limited':
      return _Limited.fromJson(json);
    case 'provisional':
      return _Provisional.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'type', 'PermissionResult',
          'Invalid union type "${json['type']}"!');
  }
}

/// @nodoc
mixin _$PermissionResult {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() granted,
    required TResult Function() denied,
    required TResult Function() permanentlyDenied,
    required TResult Function() restricted,
    required TResult Function() limited,
    required TResult Function() provisional,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? granted,
    TResult? Function()? denied,
    TResult? Function()? permanentlyDenied,
    TResult? Function()? restricted,
    TResult? Function()? limited,
    TResult? Function()? provisional,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? granted,
    TResult Function()? denied,
    TResult Function()? permanentlyDenied,
    TResult Function()? restricted,
    TResult Function()? limited,
    TResult Function()? provisional,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Granted value) granted,
    required TResult Function(_Denied value) denied,
    required TResult Function(_PermanentlyDenied value) permanentlyDenied,
    required TResult Function(_Restricted value) restricted,
    required TResult Function(_Limited value) limited,
    required TResult Function(_Provisional value) provisional,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Granted value)? granted,
    TResult? Function(_Denied value)? denied,
    TResult? Function(_PermanentlyDenied value)? permanentlyDenied,
    TResult? Function(_Restricted value)? restricted,
    TResult? Function(_Limited value)? limited,
    TResult? Function(_Provisional value)? provisional,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Granted value)? granted,
    TResult Function(_Denied value)? denied,
    TResult Function(_PermanentlyDenied value)? permanentlyDenied,
    TResult Function(_Restricted value)? restricted,
    TResult Function(_Limited value)? limited,
    TResult Function(_Provisional value)? provisional,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Serializes this PermissionResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PermissionResultCopyWith<$Res> {
  factory $PermissionResultCopyWith(
          PermissionResult value, $Res Function(PermissionResult) then) =
      _$PermissionResultCopyWithImpl<$Res, PermissionResult>;
}

/// @nodoc
class _$PermissionResultCopyWithImpl<$Res, $Val extends PermissionResult>
    implements $PermissionResultCopyWith<$Res> {
  _$PermissionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PermissionResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$GrantedImplCopyWith<$Res> {
  factory _$$GrantedImplCopyWith(
          _$GrantedImpl value, $Res Function(_$GrantedImpl) then) =
      __$$GrantedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GrantedImplCopyWithImpl<$Res>
    extends _$PermissionResultCopyWithImpl<$Res, _$GrantedImpl>
    implements _$$GrantedImplCopyWith<$Res> {
  __$$GrantedImplCopyWithImpl(
      _$GrantedImpl _value, $Res Function(_$GrantedImpl) _then)
      : super(_value, _then);

  /// Create a copy of PermissionResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$GrantedImpl implements _Granted {
  const _$GrantedImpl({final String? $type}) : $type = $type ?? 'granted';

  factory _$GrantedImpl.fromJson(Map<String, dynamic> json) =>
      _$$GrantedImplFromJson(json);

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'PermissionResult.granted()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$GrantedImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() granted,
    required TResult Function() denied,
    required TResult Function() permanentlyDenied,
    required TResult Function() restricted,
    required TResult Function() limited,
    required TResult Function() provisional,
  }) {
    return granted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? granted,
    TResult? Function()? denied,
    TResult? Function()? permanentlyDenied,
    TResult? Function()? restricted,
    TResult? Function()? limited,
    TResult? Function()? provisional,
  }) {
    return granted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? granted,
    TResult Function()? denied,
    TResult Function()? permanentlyDenied,
    TResult Function()? restricted,
    TResult Function()? limited,
    TResult Function()? provisional,
    required TResult orElse(),
  }) {
    if (granted != null) {
      return granted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Granted value) granted,
    required TResult Function(_Denied value) denied,
    required TResult Function(_PermanentlyDenied value) permanentlyDenied,
    required TResult Function(_Restricted value) restricted,
    required TResult Function(_Limited value) limited,
    required TResult Function(_Provisional value) provisional,
  }) {
    return granted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Granted value)? granted,
    TResult? Function(_Denied value)? denied,
    TResult? Function(_PermanentlyDenied value)? permanentlyDenied,
    TResult? Function(_Restricted value)? restricted,
    TResult? Function(_Limited value)? limited,
    TResult? Function(_Provisional value)? provisional,
  }) {
    return granted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Granted value)? granted,
    TResult Function(_Denied value)? denied,
    TResult Function(_PermanentlyDenied value)? permanentlyDenied,
    TResult Function(_Restricted value)? restricted,
    TResult Function(_Limited value)? limited,
    TResult Function(_Provisional value)? provisional,
    required TResult orElse(),
  }) {
    if (granted != null) {
      return granted(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$GrantedImplToJson(
      this,
    );
  }
}

abstract class _Granted implements PermissionResult {
  const factory _Granted() = _$GrantedImpl;

  factory _Granted.fromJson(Map<String, dynamic> json) = _$GrantedImpl.fromJson;
}

/// @nodoc
abstract class _$$DeniedImplCopyWith<$Res> {
  factory _$$DeniedImplCopyWith(
          _$DeniedImpl value, $Res Function(_$DeniedImpl) then) =
      __$$DeniedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$DeniedImplCopyWithImpl<$Res>
    extends _$PermissionResultCopyWithImpl<$Res, _$DeniedImpl>
    implements _$$DeniedImplCopyWith<$Res> {
  __$$DeniedImplCopyWithImpl(
      _$DeniedImpl _value, $Res Function(_$DeniedImpl) _then)
      : super(_value, _then);

  /// Create a copy of PermissionResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$DeniedImpl implements _Denied {
  const _$DeniedImpl({final String? $type}) : $type = $type ?? 'denied';

  factory _$DeniedImpl.fromJson(Map<String, dynamic> json) =>
      _$$DeniedImplFromJson(json);

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'PermissionResult.denied()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$DeniedImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() granted,
    required TResult Function() denied,
    required TResult Function() permanentlyDenied,
    required TResult Function() restricted,
    required TResult Function() limited,
    required TResult Function() provisional,
  }) {
    return denied();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? granted,
    TResult? Function()? denied,
    TResult? Function()? permanentlyDenied,
    TResult? Function()? restricted,
    TResult? Function()? limited,
    TResult? Function()? provisional,
  }) {
    return denied?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? granted,
    TResult Function()? denied,
    TResult Function()? permanentlyDenied,
    TResult Function()? restricted,
    TResult Function()? limited,
    TResult Function()? provisional,
    required TResult orElse(),
  }) {
    if (denied != null) {
      return denied();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Granted value) granted,
    required TResult Function(_Denied value) denied,
    required TResult Function(_PermanentlyDenied value) permanentlyDenied,
    required TResult Function(_Restricted value) restricted,
    required TResult Function(_Limited value) limited,
    required TResult Function(_Provisional value) provisional,
  }) {
    return denied(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Granted value)? granted,
    TResult? Function(_Denied value)? denied,
    TResult? Function(_PermanentlyDenied value)? permanentlyDenied,
    TResult? Function(_Restricted value)? restricted,
    TResult? Function(_Limited value)? limited,
    TResult? Function(_Provisional value)? provisional,
  }) {
    return denied?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Granted value)? granted,
    TResult Function(_Denied value)? denied,
    TResult Function(_PermanentlyDenied value)? permanentlyDenied,
    TResult Function(_Restricted value)? restricted,
    TResult Function(_Limited value)? limited,
    TResult Function(_Provisional value)? provisional,
    required TResult orElse(),
  }) {
    if (denied != null) {
      return denied(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DeniedImplToJson(
      this,
    );
  }
}

abstract class _Denied implements PermissionResult {
  const factory _Denied() = _$DeniedImpl;

  factory _Denied.fromJson(Map<String, dynamic> json) = _$DeniedImpl.fromJson;
}

/// @nodoc
abstract class _$$PermanentlyDeniedImplCopyWith<$Res> {
  factory _$$PermanentlyDeniedImplCopyWith(_$PermanentlyDeniedImpl value,
          $Res Function(_$PermanentlyDeniedImpl) then) =
      __$$PermanentlyDeniedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PermanentlyDeniedImplCopyWithImpl<$Res>
    extends _$PermissionResultCopyWithImpl<$Res, _$PermanentlyDeniedImpl>
    implements _$$PermanentlyDeniedImplCopyWith<$Res> {
  __$$PermanentlyDeniedImplCopyWithImpl(_$PermanentlyDeniedImpl _value,
      $Res Function(_$PermanentlyDeniedImpl) _then)
      : super(_value, _then);

  /// Create a copy of PermissionResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$PermanentlyDeniedImpl implements _PermanentlyDenied {
  const _$PermanentlyDeniedImpl({final String? $type})
      : $type = $type ?? 'permanently_denied';

  factory _$PermanentlyDeniedImpl.fromJson(Map<String, dynamic> json) =>
      _$$PermanentlyDeniedImplFromJson(json);

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'PermissionResult.permanentlyDenied()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$PermanentlyDeniedImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() granted,
    required TResult Function() denied,
    required TResult Function() permanentlyDenied,
    required TResult Function() restricted,
    required TResult Function() limited,
    required TResult Function() provisional,
  }) {
    return permanentlyDenied();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? granted,
    TResult? Function()? denied,
    TResult? Function()? permanentlyDenied,
    TResult? Function()? restricted,
    TResult? Function()? limited,
    TResult? Function()? provisional,
  }) {
    return permanentlyDenied?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? granted,
    TResult Function()? denied,
    TResult Function()? permanentlyDenied,
    TResult Function()? restricted,
    TResult Function()? limited,
    TResult Function()? provisional,
    required TResult orElse(),
  }) {
    if (permanentlyDenied != null) {
      return permanentlyDenied();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Granted value) granted,
    required TResult Function(_Denied value) denied,
    required TResult Function(_PermanentlyDenied value) permanentlyDenied,
    required TResult Function(_Restricted value) restricted,
    required TResult Function(_Limited value) limited,
    required TResult Function(_Provisional value) provisional,
  }) {
    return permanentlyDenied(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Granted value)? granted,
    TResult? Function(_Denied value)? denied,
    TResult? Function(_PermanentlyDenied value)? permanentlyDenied,
    TResult? Function(_Restricted value)? restricted,
    TResult? Function(_Limited value)? limited,
    TResult? Function(_Provisional value)? provisional,
  }) {
    return permanentlyDenied?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Granted value)? granted,
    TResult Function(_Denied value)? denied,
    TResult Function(_PermanentlyDenied value)? permanentlyDenied,
    TResult Function(_Restricted value)? restricted,
    TResult Function(_Limited value)? limited,
    TResult Function(_Provisional value)? provisional,
    required TResult orElse(),
  }) {
    if (permanentlyDenied != null) {
      return permanentlyDenied(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$PermanentlyDeniedImplToJson(
      this,
    );
  }
}

abstract class _PermanentlyDenied implements PermissionResult {
  const factory _PermanentlyDenied() = _$PermanentlyDeniedImpl;

  factory _PermanentlyDenied.fromJson(Map<String, dynamic> json) =
      _$PermanentlyDeniedImpl.fromJson;
}

/// @nodoc
abstract class _$$RestrictedImplCopyWith<$Res> {
  factory _$$RestrictedImplCopyWith(
          _$RestrictedImpl value, $Res Function(_$RestrictedImpl) then) =
      __$$RestrictedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$RestrictedImplCopyWithImpl<$Res>
    extends _$PermissionResultCopyWithImpl<$Res, _$RestrictedImpl>
    implements _$$RestrictedImplCopyWith<$Res> {
  __$$RestrictedImplCopyWithImpl(
      _$RestrictedImpl _value, $Res Function(_$RestrictedImpl) _then)
      : super(_value, _then);

  /// Create a copy of PermissionResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$RestrictedImpl implements _Restricted {
  const _$RestrictedImpl({final String? $type}) : $type = $type ?? 'restricted';

  factory _$RestrictedImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestrictedImplFromJson(json);

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'PermissionResult.restricted()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$RestrictedImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() granted,
    required TResult Function() denied,
    required TResult Function() permanentlyDenied,
    required TResult Function() restricted,
    required TResult Function() limited,
    required TResult Function() provisional,
  }) {
    return restricted();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? granted,
    TResult? Function()? denied,
    TResult? Function()? permanentlyDenied,
    TResult? Function()? restricted,
    TResult? Function()? limited,
    TResult? Function()? provisional,
  }) {
    return restricted?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? granted,
    TResult Function()? denied,
    TResult Function()? permanentlyDenied,
    TResult Function()? restricted,
    TResult Function()? limited,
    TResult Function()? provisional,
    required TResult orElse(),
  }) {
    if (restricted != null) {
      return restricted();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Granted value) granted,
    required TResult Function(_Denied value) denied,
    required TResult Function(_PermanentlyDenied value) permanentlyDenied,
    required TResult Function(_Restricted value) restricted,
    required TResult Function(_Limited value) limited,
    required TResult Function(_Provisional value) provisional,
  }) {
    return restricted(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Granted value)? granted,
    TResult? Function(_Denied value)? denied,
    TResult? Function(_PermanentlyDenied value)? permanentlyDenied,
    TResult? Function(_Restricted value)? restricted,
    TResult? Function(_Limited value)? limited,
    TResult? Function(_Provisional value)? provisional,
  }) {
    return restricted?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Granted value)? granted,
    TResult Function(_Denied value)? denied,
    TResult Function(_PermanentlyDenied value)? permanentlyDenied,
    TResult Function(_Restricted value)? restricted,
    TResult Function(_Limited value)? limited,
    TResult Function(_Provisional value)? provisional,
    required TResult orElse(),
  }) {
    if (restricted != null) {
      return restricted(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$RestrictedImplToJson(
      this,
    );
  }
}

abstract class _Restricted implements PermissionResult {
  const factory _Restricted() = _$RestrictedImpl;

  factory _Restricted.fromJson(Map<String, dynamic> json) =
      _$RestrictedImpl.fromJson;
}

/// @nodoc
abstract class _$$LimitedImplCopyWith<$Res> {
  factory _$$LimitedImplCopyWith(
          _$LimitedImpl value, $Res Function(_$LimitedImpl) then) =
      __$$LimitedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LimitedImplCopyWithImpl<$Res>
    extends _$PermissionResultCopyWithImpl<$Res, _$LimitedImpl>
    implements _$$LimitedImplCopyWith<$Res> {
  __$$LimitedImplCopyWithImpl(
      _$LimitedImpl _value, $Res Function(_$LimitedImpl) _then)
      : super(_value, _then);

  /// Create a copy of PermissionResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$LimitedImpl implements _Limited {
  const _$LimitedImpl({final String? $type}) : $type = $type ?? 'limited';

  factory _$LimitedImpl.fromJson(Map<String, dynamic> json) =>
      _$$LimitedImplFromJson(json);

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'PermissionResult.limited()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LimitedImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() granted,
    required TResult Function() denied,
    required TResult Function() permanentlyDenied,
    required TResult Function() restricted,
    required TResult Function() limited,
    required TResult Function() provisional,
  }) {
    return limited();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? granted,
    TResult? Function()? denied,
    TResult? Function()? permanentlyDenied,
    TResult? Function()? restricted,
    TResult? Function()? limited,
    TResult? Function()? provisional,
  }) {
    return limited?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? granted,
    TResult Function()? denied,
    TResult Function()? permanentlyDenied,
    TResult Function()? restricted,
    TResult Function()? limited,
    TResult Function()? provisional,
    required TResult orElse(),
  }) {
    if (limited != null) {
      return limited();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Granted value) granted,
    required TResult Function(_Denied value) denied,
    required TResult Function(_PermanentlyDenied value) permanentlyDenied,
    required TResult Function(_Restricted value) restricted,
    required TResult Function(_Limited value) limited,
    required TResult Function(_Provisional value) provisional,
  }) {
    return limited(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Granted value)? granted,
    TResult? Function(_Denied value)? denied,
    TResult? Function(_PermanentlyDenied value)? permanentlyDenied,
    TResult? Function(_Restricted value)? restricted,
    TResult? Function(_Limited value)? limited,
    TResult? Function(_Provisional value)? provisional,
  }) {
    return limited?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Granted value)? granted,
    TResult Function(_Denied value)? denied,
    TResult Function(_PermanentlyDenied value)? permanentlyDenied,
    TResult Function(_Restricted value)? restricted,
    TResult Function(_Limited value)? limited,
    TResult Function(_Provisional value)? provisional,
    required TResult orElse(),
  }) {
    if (limited != null) {
      return limited(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$LimitedImplToJson(
      this,
    );
  }
}

abstract class _Limited implements PermissionResult {
  const factory _Limited() = _$LimitedImpl;

  factory _Limited.fromJson(Map<String, dynamic> json) = _$LimitedImpl.fromJson;
}

/// @nodoc
abstract class _$$ProvisionalImplCopyWith<$Res> {
  factory _$$ProvisionalImplCopyWith(
          _$ProvisionalImpl value, $Res Function(_$ProvisionalImpl) then) =
      __$$ProvisionalImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$ProvisionalImplCopyWithImpl<$Res>
    extends _$PermissionResultCopyWithImpl<$Res, _$ProvisionalImpl>
    implements _$$ProvisionalImplCopyWith<$Res> {
  __$$ProvisionalImplCopyWithImpl(
      _$ProvisionalImpl _value, $Res Function(_$ProvisionalImpl) _then)
      : super(_value, _then);

  /// Create a copy of PermissionResult
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
@JsonSerializable()
class _$ProvisionalImpl implements _Provisional {
  const _$ProvisionalImpl({final String? $type})
      : $type = $type ?? 'provisional';

  factory _$ProvisionalImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProvisionalImplFromJson(json);

  @JsonKey(name: 'type')
  final String $type;

  @override
  String toString() {
    return 'PermissionResult.provisional()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$ProvisionalImpl);
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() granted,
    required TResult Function() denied,
    required TResult Function() permanentlyDenied,
    required TResult Function() restricted,
    required TResult Function() limited,
    required TResult Function() provisional,
  }) {
    return provisional();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? granted,
    TResult? Function()? denied,
    TResult? Function()? permanentlyDenied,
    TResult? Function()? restricted,
    TResult? Function()? limited,
    TResult? Function()? provisional,
  }) {
    return provisional?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? granted,
    TResult Function()? denied,
    TResult Function()? permanentlyDenied,
    TResult Function()? restricted,
    TResult Function()? limited,
    TResult Function()? provisional,
    required TResult orElse(),
  }) {
    if (provisional != null) {
      return provisional();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Granted value) granted,
    required TResult Function(_Denied value) denied,
    required TResult Function(_PermanentlyDenied value) permanentlyDenied,
    required TResult Function(_Restricted value) restricted,
    required TResult Function(_Limited value) limited,
    required TResult Function(_Provisional value) provisional,
  }) {
    return provisional(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Granted value)? granted,
    TResult? Function(_Denied value)? denied,
    TResult? Function(_PermanentlyDenied value)? permanentlyDenied,
    TResult? Function(_Restricted value)? restricted,
    TResult? Function(_Limited value)? limited,
    TResult? Function(_Provisional value)? provisional,
  }) {
    return provisional?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Granted value)? granted,
    TResult Function(_Denied value)? denied,
    TResult Function(_PermanentlyDenied value)? permanentlyDenied,
    TResult Function(_Restricted value)? restricted,
    TResult Function(_Limited value)? limited,
    TResult Function(_Provisional value)? provisional,
    required TResult orElse(),
  }) {
    if (provisional != null) {
      return provisional(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ProvisionalImplToJson(
      this,
    );
  }
}

abstract class _Provisional implements PermissionResult {
  const factory _Provisional() = _$ProvisionalImpl;

  factory _Provisional.fromJson(Map<String, dynamic> json) =
      _$ProvisionalImpl.fromJson;
}
