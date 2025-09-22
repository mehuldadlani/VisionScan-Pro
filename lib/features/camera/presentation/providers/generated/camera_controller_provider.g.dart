// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../camera_controller_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cameraControllerHash() => r'80e6b57fb7c955314669617ebeedde014f5ec5bc';

/// Camera controller provider following Clean Architecture principles
///
/// Copied from [CameraController].
@ProviderFor(CameraController)
final cameraControllerProvider =
    AutoDisposeAsyncNotifierProvider<CameraController, CameraState>.internal(
  CameraController.new,
  name: r'cameraControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cameraControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CameraController = AutoDisposeAsyncNotifier<CameraState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
