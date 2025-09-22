// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../permission_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GrantedImpl _$$GrantedImplFromJson(Map json) => $checkedCreate(
      r'_$GrantedImpl',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['type'],
        );
        final val = _$GrantedImpl(
          $type: $checkedConvert('type', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {r'$type': 'type'},
    );

const _$$GrantedImplFieldMap = <String, String>{
  r'$type': 'type',
};

abstract final class _$$GrantedImplJsonKeys {
  static const String $type = 'type';
}

// ignore: unused_element
abstract class _$$GrantedImplPerFieldToJson {
  // ignore: unused_element
  static Object? $type(String instance) => instance;
}

Map<String, dynamic> _$$GrantedImplToJson(_$GrantedImpl instance) =>
    <String, dynamic>{
      'type': instance.$type,
    };

_$DeniedImpl _$$DeniedImplFromJson(Map json) => $checkedCreate(
      r'_$DeniedImpl',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['type'],
        );
        final val = _$DeniedImpl(
          $type: $checkedConvert('type', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {r'$type': 'type'},
    );

const _$$DeniedImplFieldMap = <String, String>{
  r'$type': 'type',
};

abstract final class _$$DeniedImplJsonKeys {
  static const String $type = 'type';
}

// ignore: unused_element
abstract class _$$DeniedImplPerFieldToJson {
  // ignore: unused_element
  static Object? $type(String instance) => instance;
}

Map<String, dynamic> _$$DeniedImplToJson(_$DeniedImpl instance) =>
    <String, dynamic>{
      'type': instance.$type,
    };

_$PermanentlyDeniedImpl _$$PermanentlyDeniedImplFromJson(Map json) =>
    $checkedCreate(
      r'_$PermanentlyDeniedImpl',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['type'],
        );
        final val = _$PermanentlyDeniedImpl(
          $type: $checkedConvert('type', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {r'$type': 'type'},
    );

const _$$PermanentlyDeniedImplFieldMap = <String, String>{
  r'$type': 'type',
};

abstract final class _$$PermanentlyDeniedImplJsonKeys {
  static const String $type = 'type';
}

// ignore: unused_element
abstract class _$$PermanentlyDeniedImplPerFieldToJson {
  // ignore: unused_element
  static Object? $type(String instance) => instance;
}

Map<String, dynamic> _$$PermanentlyDeniedImplToJson(
        _$PermanentlyDeniedImpl instance) =>
    <String, dynamic>{
      'type': instance.$type,
    };

_$RestrictedImpl _$$RestrictedImplFromJson(Map json) => $checkedCreate(
      r'_$RestrictedImpl',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['type'],
        );
        final val = _$RestrictedImpl(
          $type: $checkedConvert('type', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {r'$type': 'type'},
    );

const _$$RestrictedImplFieldMap = <String, String>{
  r'$type': 'type',
};

abstract final class _$$RestrictedImplJsonKeys {
  static const String $type = 'type';
}

// ignore: unused_element
abstract class _$$RestrictedImplPerFieldToJson {
  // ignore: unused_element
  static Object? $type(String instance) => instance;
}

Map<String, dynamic> _$$RestrictedImplToJson(_$RestrictedImpl instance) =>
    <String, dynamic>{
      'type': instance.$type,
    };

_$LimitedImpl _$$LimitedImplFromJson(Map json) => $checkedCreate(
      r'_$LimitedImpl',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['type'],
        );
        final val = _$LimitedImpl(
          $type: $checkedConvert('type', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {r'$type': 'type'},
    );

const _$$LimitedImplFieldMap = <String, String>{
  r'$type': 'type',
};

abstract final class _$$LimitedImplJsonKeys {
  static const String $type = 'type';
}

// ignore: unused_element
abstract class _$$LimitedImplPerFieldToJson {
  // ignore: unused_element
  static Object? $type(String instance) => instance;
}

Map<String, dynamic> _$$LimitedImplToJson(_$LimitedImpl instance) =>
    <String, dynamic>{
      'type': instance.$type,
    };

_$ProvisionalImpl _$$ProvisionalImplFromJson(Map json) => $checkedCreate(
      r'_$ProvisionalImpl',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['type'],
        );
        final val = _$ProvisionalImpl(
          $type: $checkedConvert('type', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {r'$type': 'type'},
    );

const _$$ProvisionalImplFieldMap = <String, String>{
  r'$type': 'type',
};

abstract final class _$$ProvisionalImplJsonKeys {
  static const String $type = 'type';
}

// ignore: unused_element
abstract class _$$ProvisionalImplPerFieldToJson {
  // ignore: unused_element
  static Object? $type(String instance) => instance;
}

Map<String, dynamic> _$$ProvisionalImplToJson(_$ProvisionalImpl instance) =>
    <String, dynamic>{
      'type': instance.$type,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$permissionServiceHash() => r'8944118369fdc2dd355a221dd4f8a487b7f3372c';

/// Provider for PermissionService
///
/// Copied from [permissionService].
@ProviderFor(permissionService)
final permissionServiceProvider =
    AutoDisposeProvider<PermissionService>.internal(
  permissionService,
  name: r'permissionServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$permissionServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PermissionServiceRef = AutoDisposeProviderRef<PermissionService>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
