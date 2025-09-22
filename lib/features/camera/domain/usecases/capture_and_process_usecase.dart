import 'dart:io';

import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:visionscan_pro/core/error/exceptions.dart';
import 'package:visionscan_pro/core/logging/app_logger.dart';
import 'package:visionscan_pro/features/camera/data/providers/process_camera_image_usecase_provider.dart';
import 'package:visionscan_pro/features/camera/domain/usecases/process_camera_image_usecase.dart';
import 'package:visionscan_pro/features/camera/presentation/providers/camera_controller_provider.dart';
import 'package:visionscan_pro/features/camera/presentation/states/camera_state.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';

part 'generated/capture_and_process_usecase.g.dart';

/// Parameters for capture and process operation
class CaptureAndProcessParams {
  const CaptureAndProcessParams({
    required this.previewSize,
    required this.cropRect,
    this.isFromGallery = false,
  });

  final Size previewSize;
  final Rect cropRect;
  final bool isFromGallery;
}

/// Use case for capturing and processing camera images
@riverpod
class CaptureAndProcessUseCase extends _$CaptureAndProcessUseCase {
  @override
  FutureOr<ScanResult?> build() async {
    return null; // Initial state
  }

  /// Capture image and process with OCR
  Future<ScanResult?> execute(CaptureAndProcessParams params) async {
    try {
      // Get camera controller
      final cameraAsync = ref.read(cameraControllerProvider);

      final cameraState = cameraAsync.when(
        data: (state) => state,
        loading: () => throw const CameraException(
          'Camera not ready for capture',
          'CAMERA_NOT_READY',
        ),
        error: (error, _) =>
            throw CameraException('Camera error: $error', 'CAMERA_ERROR'),
      );

      if (!cameraState.isReady || cameraState.controller == null) {
        throw const CameraException(
          'Camera not ready for capture',
          'CAMERA_NOT_READY',
        );
      }

      // Capture image
      final imageFile = await cameraState.controller!.takePicture();
      final file = File(imageFile.path);

      // Process with OCR
      final processUseCase = ref.read(processCameraImageUseCaseProvider);
      final result = await processUseCase.call(
        ProcessImageParams(
          imageFile: file,
          cropRect: params.cropRect,
          previewSize: params.previewSize,
          isFromGallery: params.isFromGallery,
        ),
      );

      // Update state with result
      state = AsyncValue.data(result);
      return result;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Capture and process failed',
        error: e,
        stackTrace: stackTrace,
      );
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// Reset the use case state
  void reset() {
    state = const AsyncValue.data(null);
  }
}
