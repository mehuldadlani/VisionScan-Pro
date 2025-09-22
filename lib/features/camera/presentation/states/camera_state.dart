import 'package:camera/camera.dart' as camera;
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/camera_state.freezed.dart';

/// Camera state for the camera controller
@Freezed(toJson: false, fromJson: false)
class CameraState with _$CameraState {
  /// Camera is ready for use
  const factory CameraState.ready({
    required camera.CameraController controller,
    required Size previewSize,
  }) = _Ready;

  /// Camera is initializing
  const factory CameraState.initializing() = _Initializing;

  /// Camera has an error
  const factory CameraState.error({
    required String message,
    required bool canRetry,
  }) = _Error;
}

/// Extensions for camera state
extension CameraStateExtension on CameraState {
  bool get isReady => when(
    ready: (_, __) => true,
    initializing: () => false,
    error: (_, __) => false,
  );

  bool get isInitializing => when(
    ready: (_, __) => false,
    initializing: () => true,
    error: (_, __) => false,
  );

  bool get hasError => when(
    ready: (_, __) => false,
    initializing: () => false,
    error: (_, __) => true,
  );

  camera.CameraController? get controller =>
      maybeWhen(ready: (controller, _) => controller, orElse: () => null);

  String? get errorMessage =>
      maybeWhen(error: (message, _) => message, orElse: () => null);

  bool get canRetry =>
      maybeWhen(error: (_, canRetry) => canRetry, orElse: () => false);
}
