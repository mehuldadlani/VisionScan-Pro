// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../scan_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$scanRepositoryHash() => r'6e8197828a85994a46f4f5ebdcac4462ac26f538';

/// Provider for the scan repository
///
/// Copied from [scanRepository].
@ProviderFor(scanRepository)
final scanRepositoryProvider = FutureProvider<ScanRepository>.internal(
  scanRepository,
  name: r'scanRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scanRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScanRepositoryRef = FutureProviderRef<ScanRepository>;
String _$scanStatisticsHash() => r'a121f9a7a7bafb0940dc2d470c33267f85cd001c';

/// Provider for getting scan statistics
///
/// Copied from [scanStatistics].
@ProviderFor(scanStatistics)
final scanStatisticsProvider =
    AutoDisposeFutureProvider<Map<String, dynamic>>.internal(
  scanStatistics,
  name: r'scanStatisticsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$scanStatisticsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScanStatisticsRef = AutoDisposeFutureProviderRef<Map<String, dynamic>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
