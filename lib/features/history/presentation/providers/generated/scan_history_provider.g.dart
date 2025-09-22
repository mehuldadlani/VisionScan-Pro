// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../scan_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scanHistoryHash() => r'a1fb0d3b426c65598e96bd4e792c9e0564fb5980';

/// Provider for scan history management
///
/// Copied from [ScanHistory].
@ProviderFor(ScanHistory)
final scanHistoryProvider =
    AsyncNotifierProvider<ScanHistory, List<ScanResult>>.internal(
  ScanHistory.new,
  name: r'scanHistoryProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$scanHistoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ScanHistory = AsyncNotifier<List<ScanResult>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
