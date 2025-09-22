// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../database_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$databaseHash() => r'dcfe992d4fb345d564b72f164f25236e2c38abac';

/// Provider for ObjectBox database store
///
/// This provider has been deprecated in favor of objectBoxStoreProvider.
/// Use objectBoxStoreProvider.future instead.
///
/// Copied from [database].
@ProviderFor(database)
final databaseProvider = AutoDisposeFutureProvider<Store>.internal(
  database,
  name: r'databaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$databaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DatabaseRef = AutoDisposeFutureProviderRef<Store>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
