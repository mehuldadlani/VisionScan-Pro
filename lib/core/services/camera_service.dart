import 'dart:io';

import 'package:camera/camera.dart' hide CameraException;
import 'package:flutter/services.dart';

import 'package:visionscan_pro/core/constants/app_constants.dart';
import 'package:visionscan_pro/core/error/exceptions.dart';
import 'package:visionscan_pro/core/logging/app_logger.dart';
import 'package:visionscan_pro/core/utils/permission_utils.dart';

/// Core service for camera operations in VisionScan Pro
///
/// Provides high-level camera functionality including initialization,
/// configuration, image capture, and resource management.
class CameraService {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  CameraDescription? _selectedCamera;

  /// Gets the current camera controller
  CameraController? get controller => _controller;

  /// Gets available cameras
  List<CameraDescription>? get cameras => _cameras;

  /// Gets the currently selected camera
  CameraDescription? get selectedCamera => _selectedCamera;

  /// Checks if camera is initialized
  bool get isInitialized => _controller?.value.isInitialized ?? false;

  /// Checks if camera is currently recording
  bool get isRecording => _controller?.value.isRecordingVideo ?? false;

  /// Checks if camera initialization is in progress
  bool get isInitializing => _controller?.value.isInitialized == false;

  /// Gets current camera resolution
  Size? get resolution => _controller?.value.previewSize;

  /// Gets current camera aspect ratio
  double get aspectRatio =>
      _controller?.value.aspectRatio ?? AppConstants.cameraAspectRatio;

  /// Initializes the camera service
  Future<void> initialize() async {
    try {
      // Check camera permission
      final hasPermission = await PermissionUtils.hasCameraPermission();
      if (!hasPermission) {
        final granted = await PermissionUtils.requestCameraPermission();
        if (!granted) {
          throw const CameraPermissionDeniedException();
        }
      }

      // Get available cameras
      _cameras = await availableCameras();

      if (_cameras == null || _cameras!.isEmpty) {
        throw const CameraInitializationException(
          details: {'error': 'No cameras available on device'},
        );
      }

      // Select back camera by default (better for document scanning)
      _selectedCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      await _initializeController();
    } catch (e) {
      if (e is CameraException) {
        rethrow;
      }
      throw CameraInitializationException(details: {'error': e.toString()});
    }
  }

  /// Initializes the camera controller
  Future<void> _initializeController() async {
    try {
      if (_selectedCamera == null) {
        throw const CameraInitializationException(
          details: {'error': 'No camera selected'},
        );
      }

      // Dispose existing controller if any
      await _controller?.dispose();

      // Create new controller with optimized settings for document scanning
      _controller = CameraController(
        _selectedCamera!,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
        fps: 30,
        videoBitrate: 1000000,
      );

      // Initialize controller with timeout
      await _controller!.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw const CameraInitializationException(
            details: {'error': 'Camera initialization timeout'},
          );
        },
      );

      // Configure camera for optimal document scanning
      await _configureCameraForScanning();
    } on CameraException catch (e) {
      throw CameraInitializationException(
        cameraId: _selectedCamera?.name,
        details: {'error': '${e.code}: ${e.message}'},
      );
    } catch (e) {
      throw CameraInitializationException(
        cameraId: _selectedCamera?.name,
        details: {'error': e.toString()},
      );
    }
  }

  /// Configures camera settings for optimal document scanning
  Future<void> _configureCameraForScanning() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      // Set exposure mode to auto for consistent lighting
      await _controller!.setExposureMode(ExposureMode.auto);

      // Set focus mode to auto for sharp text capture
      await _controller!.setFocusMode(FocusMode.auto);

      // Set flash mode to auto
      await _controller!.setFlashMode(FlashMode.auto);

      // Lock white balance for consistent color
      // Note: Some settings might not be supported on all devices
    } catch (e) {
      // Camera configuration is best-effort, don't fail initialization
      if (AppConstants.showDebugInfo) {
        AppLogger.warning('Warning: Some camera configurations failed: $e');
      }
    }
  }

  /// Switches to a different camera
  Future<void> switchCamera(CameraDescription camera) async {
    try {
      if (_cameras == null || !_cameras!.contains(camera)) {
        throw CameraException(
          'Camera not available',
          'CAMERA_NOT_AVAILABLE',
          camera.name,
        );
      }

      _selectedCamera = camera;
      await _initializeController();
    } catch (e) {
      if (e is CameraException) {
        rethrow;
      }
      throw CameraException(
        'Failed to switch camera',
        'CAMERA_SWITCH_FAILED',
        camera.name,
        {'error': e.toString()},
      );
    }
  }

  /// Captures an image from the camera
  Future<XFile> captureImage() async {
    try {
      if (_controller == null || !_controller!.value.isInitialized) {
        throw const CameraCaptureException(
          details: {'error': 'Camera not initialized'},
        );
      }

      // Ensure camera is focused before capture
      await _ensureCameraFocused();

      // Brief pause to allow focus to settle
      await Future<void>.delayed(const Duration(milliseconds: 300));

      // Trigger haptic feedback
      await HapticFeedback.lightImpact();

      // Capture the image with retry mechanism
      XFile? imageFile;
      for (var attempt = 1; attempt <= 3; attempt++) {
        try {
          imageFile = await _controller!.takePicture().timeout(
            const Duration(seconds: 5),
            onTimeout: () => throw Exception('Image capture timeout'),
          );
          break;
        } on Exception {
          if (attempt == 3) {
            throw const CameraCaptureException(
              details: {'error': 'Image capture failed after 3 attempts'},
            );
          }
          await Future<void>.delayed(const Duration(milliseconds: 500));
        } catch (e) {
          if (attempt == 3) rethrow;
          await Future<void>.delayed(const Duration(milliseconds: 500));
        }
      }

      if (imageFile == null) {
        throw const CameraCaptureException(
          details: {'error': 'Failed to capture image'},
        );
      }

      // Validate captured image
      final file = File(imageFile.path);
      if (!file.existsSync()) {
        throw const CameraCaptureException(
          details: {'error': 'Captured image file does not exist'},
        );
      }

      // Check file size
      final fileSize = await file.length();
      if (fileSize == 0) {
        throw const CameraCaptureException(
          details: {'error': 'Captured image file is empty'},
        );
      }

      if (fileSize > AppConstants.maxImageSizeBytes) {
        throw CameraCaptureException(
          details: {
            'error': 'Captured image is too large',
            'file_size': fileSize,
            'max_size': AppConstants.maxImageSizeBytes,
          },
        );
      }

      return imageFile;
    } on CameraException catch (e) {
      throw CameraCaptureException(
        cameraId: _selectedCamera?.name,
        details: {'error': '${e.code}: ${e.message}'},
      );
    } catch (e) {
      throw CameraCaptureException(
        cameraId: _selectedCamera?.name,
        details: {'error': e.toString()},
      );
    }
  }

  /// Ensures camera is properly focused before capture
  Future<void> _ensureCameraFocused() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      // Set focus point to center of preview
      final previewSize = _controller!.value.previewSize;
      if (previewSize != null) {
        final focusPoint = Offset(
          previewSize.width / 2,
          previewSize.height / 2,
        );
        await setFocusPoint(focusPoint);

        // Additional focus mode setting for better results
        await _controller!.setFocusMode(FocusMode.locked);
        await Future<void>.delayed(const Duration(milliseconds: 100));
        await _controller!.setFocusMode(FocusMode.auto);
      }
    } catch (e) {
      AppLogger.warning('Focus optimization failed', error: e);
      // Continue with capture even if focus optimization fails
    }
  }

  /// Sets focus point on the camera preview
  Future<void> setFocusPoint(Offset point) async {
    try {
      if (_controller == null || !_controller!.value.isInitialized) {
        return;
      }

      await _controller!.setFocusPoint(point);
      await _controller!.setExposurePoint(point);

      // Trigger haptic feedback for focus
      await HapticFeedback.selectionClick();
    } catch (e) {
      // Focus setting is best-effort, don't throw exceptions
      if (AppConstants.showDebugInfo) {
        AppLogger.warning('Warning: Failed to set focus point: $e');
      }
    }
  }

  /// Sets the flash mode
  Future<void> setFlashMode(FlashMode flashMode) async {
    try {
      if (_controller == null || !_controller!.value.isInitialized) {
        return;
      }

      await _controller!.setFlashMode(flashMode);
    } catch (e) {
      throw CameraException(
        'Failed to set flash mode',
        'FLASH_MODE_FAILED',
        _selectedCamera?.name,
        {'flash_mode': flashMode.toString(), 'error': e.toString()},
      );
    }
  }

  /// Gets the current flash mode
  FlashMode get currentFlashMode =>
      _controller?.value.flashMode ?? FlashMode.auto;

  /// Checks if flash is available
  bool get isFlashAvailable {
    return _controller?.value.flashMode != null;
  }

  /// Sets the zoom level
  Future<void> setZoomLevel(double zoom) async {
    try {
      if (_controller == null || !_controller!.value.isInitialized) {
        return;
      }

      final minZoom = await _controller!.getMinZoomLevel();
      final maxZoom = await _controller!.getMaxZoomLevel();

      // Clamp zoom level to valid range
      final clampedZoom = zoom.clamp(minZoom, maxZoom);

      await _controller!.setZoomLevel(clampedZoom);
    } catch (e) {
      throw CameraException(
        'Failed to set zoom level',
        'ZOOM_FAILED',
        _selectedCamera?.name,
        {'zoom_level': zoom, 'error': e.toString()},
      );
    }
  }

  /// Gets the current zoom level
  Future<double> getCurrentZoomLevel() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return 1.0;
    }

    try {
      // Note: Some camera implementations might not support getting current zoom
      return 1.0; // Default zoom level
    } catch (e) {
      return 1.0;
    }
  }

  /// Gets the maximum zoom level
  Future<double> getMaxZoomLevel() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return 1.0;
    }

    try {
      return await _controller!.getMaxZoomLevel();
    } catch (e) {
      return 8.0; // Common maximum zoom level
    }
  }

  /// Gets the minimum zoom level
  Future<double> getMinZoomLevel() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return 1.0;
    }

    try {
      return await _controller!.getMinZoomLevel();
    } catch (e) {
      return 1.0; // Standard minimum zoom level
    }
  }

  /// Pauses the camera preview
  Future<void> pausePreview() async {
    try {
      if (_controller != null && _controller!.value.isInitialized) {
        await _controller!.pausePreview();
      }
    } catch (e) {
      // Pause is best-effort
      if (AppConstants.showDebugInfo) {
        AppLogger.warning('Warning: Failed to pause camera preview: $e');
      }
    }
  }

  /// Resumes the camera preview
  Future<void> resumePreview() async {
    try {
      if (_controller != null && _controller!.value.isInitialized) {
        await _controller!.resumePreview();
      }
    } catch (e) {
      // Resume is best-effort
      if (AppConstants.showDebugInfo) {
        AppLogger.warning('Warning: Failed to resume camera preview: $e');
      }
    }
  }

  /// Disposes the camera controller and releases resources
  Future<void> dispose() async {
    try {
      await _controller?.dispose();
      _controller = null;
      _selectedCamera = null;
      _cameras = null;
    } catch (e) {
      // Disposal should not throw exceptions
      if (AppConstants.showDebugInfo) {
        AppLogger.warning('Warning: Error during camera disposal: $e');
      }
    }
  }

  /// Gets camera information for debugging
  Map<String, dynamic> getCameraInfo() {
    return {
      'is_initialized': isInitialized,
      'is_recording': isRecording,
      'selected_camera': _selectedCamera?.name,
      'available_cameras': _cameras?.length ?? 0,
      'aspect_ratio': aspectRatio,
      'resolution': resolution?.toString(),
      'flash_mode': currentFlashMode.toString(),
    };
  }
}
