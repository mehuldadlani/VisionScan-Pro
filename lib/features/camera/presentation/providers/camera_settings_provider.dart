import 'package:camera/camera.dart' as camera;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/camera_settings_provider.g.dart';

/// Camera settings state
class CameraSettings {
  const CameraSettings({
    this.flashMode = camera.FlashMode.off,
    this.resolutionPreset = camera.ResolutionPreset.high,
    this.enableAudio = false,
  });

  final camera.FlashMode flashMode;
  final camera.ResolutionPreset resolutionPreset;
  final bool enableAudio;

  CameraSettings copyWith({
    camera.FlashMode? flashMode,
    camera.ResolutionPreset? resolutionPreset,
    bool? enableAudio,
  }) {
    return CameraSettings(
      flashMode: flashMode ?? this.flashMode,
      resolutionPreset: resolutionPreset ?? this.resolutionPreset,
      enableAudio: enableAudio ?? this.enableAudio,
    );
  }
}

/// Provider for camera settings
@riverpod
class CameraSettingsNotifier extends _$CameraSettingsNotifier {
  @override
  CameraSettings build() {
    return const CameraSettings();
  }

  /// Update flash mode
  void setFlashMode(camera.FlashMode mode) {
    state = state.copyWith(flashMode: mode);
  }

  /// Update resolution preset
  void setResolutionPreset(camera.ResolutionPreset preset) {
    state = state.copyWith(resolutionPreset: preset);
  }

  /// Toggle audio recording
  void setAudioEnabled({required bool enabled}) {
    state = state.copyWith(enableAudio: enabled);
  }

  /// Cycle through flash modes
  void cycleFlashMode() {
    final currentMode = state.flashMode;
    final newMode = switch (currentMode) {
      camera.FlashMode.off => camera.FlashMode.auto,
      camera.FlashMode.auto => camera.FlashMode.always,
      camera.FlashMode.always => camera.FlashMode.torch,
      camera.FlashMode.torch => camera.FlashMode.off,
    };
    setFlashMode(newMode);
  }
}
