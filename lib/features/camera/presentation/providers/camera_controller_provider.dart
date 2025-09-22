import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart' as camera;
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:visionscan_pro/core/error/exceptions.dart';
import 'package:visionscan_pro/core/logging/app_logger.dart';
import 'package:visionscan_pro/features/camera/presentation/states/camera_state.dart';

part 'generated/camera_controller_provider.g.dart';

/// Camera controller provider following Clean Architecture principles
@riverpod
class CameraController extends _$CameraController {
  camera.CameraController? _controller;
  Timer? _cleanupTimer;

  @override
  Future<CameraState> build() async {
    ref.onDispose(_disposeResources);
    return _initializeCamera();
  }

  /// Initialize camera controller
  Future<CameraState> _initializeCamera() async {
    try {
      final cameras = await camera.availableCameras();
      if (cameras.isEmpty) {
        return const CameraState.error(
          message: 'No cameras available',
          canRetry: false,
        );
      }

      final selectedCamera = cameras.first;
      _controller = camera.CameraController(
        selectedCamera,
        camera.ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();

      return CameraState.ready(
        controller: _controller!,
        previewSize: const Size(1920, 1080),
      );
    } catch (e) {
      AppLogger.error('Camera initialization failed', error: e);
      await _disposeController();
      return CameraState.error(
        message: 'Failed to initialize camera: $e',
        canRetry: true,
      );
    }
  }

  /// Dispose camera resources
  Future<void> _disposeResources() async {
    await _disposeController();
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  /// Dispose camera controller
  Future<void> _disposeController() async {
    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
    }
  }

  /// Capturconst e image from camera
  Future<File?> captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      throw const CameraException('Camera not initialized', 'CAMERA_NOT_READY');
    }

    try {
      final imageFile = await _controller!.takePicture();
      return File(imageFile.path);
    } catch (e) {
      AppLogger.error('Image capture failed', error: e);
      throw const CameraException('Failed to capture image', 'CAPTURE_FAILED');
    }
  }

  /// Toggle flash mode
  Future<void> toggleFlash() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      final currentFlashMode = _controller!.value.flashMode;
      final newFlashMode = currentFlashMode == camera.FlashMode.off
          ? camera.FlashMode.torch
          : camera.FlashMode.off;

      await _controller!.setFlashMode(newFlashMode);
    } catch (e) {
      AppLogger.warning('Failed to toggle flash: $e');
    }
  }

  /// Set flash mode
  Future<void> setFlashMode(camera.FlashMode mode) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      await _controller!.setFlashMode(mode);
    } catch (e) {
      AppLogger.warning('Failed to set flash mode: $e');
    }
  }

  /// Focus camera at specific point
  Future<void> focusAt(Offset point) async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }

    try {
      await _controller!.setFocusPoint(point);
      await _controller!.setExposurePoint(point);
    } catch (e) {
      AppLogger.warning('Failed to focus camera: $e');
    }
  }

  /// Retry camera initialization
  Future<CameraState> retryInitialization() async {
    await _disposeController();
    return _initializeCamera();
  }
}
