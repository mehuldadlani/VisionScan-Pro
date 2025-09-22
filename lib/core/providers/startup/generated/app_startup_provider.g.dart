// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../app_startup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appStartupHash() => r'bec1aebae9155f25e37b4d535bf3d3cb48e39116';

/// Manages the application startup sequence
///
/// Coordinates initialization of critical services and dependencies
/// required for the application to function properly.
///
/// Copied from [AppStartup].
@ProviderFor(AppStartup)
final appStartupProvider =
    AsyncNotifierProvider<AppStartup, AppStartupResult>.internal(
  AppStartup.new,
  name: r'appStartupProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appStartupHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppStartup = AsyncNotifier<AppStartupResult>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
