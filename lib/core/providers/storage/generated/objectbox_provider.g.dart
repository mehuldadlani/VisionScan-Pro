// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../objectbox_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$objectBoxStoreHash() => r'5e2f4bb5059ecda97f8189465f6283602c1635a2';

/// ObjectBox store provider for VisionScan Pro
///
/// Manages the ObjectBox database connection and provides
/// a singleton Store instance throughout the application.
///
/// Copied from [ObjectBoxStore].
@ProviderFor(ObjectBoxStore)
final objectBoxStoreProvider =
    AsyncNotifierProvider<ObjectBoxStore, Store>.internal(
  ObjectBoxStore.new,
  name: r'objectBoxStoreProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$objectBoxStoreHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ObjectBoxStore = AsyncNotifier<Store>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
