import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:visionscan_pro/core/services/ml_kit_ocr_service.dart';
import 'package:visionscan_pro/features/camera/domain/usecases/process_camera_image_usecase.dart';
import 'package:visionscan_pro/features/history/data/providers/scan_repository_provider.dart';

part 'generated/process_camera_image_usecase_provider.g.dart';

/// Provider for the process camera image use case
@riverpod
ProcessCameraImageUseCase processCameraImageUseCase(Ref ref) {
  return ProcessCameraImageUseCase(
    ocrService: ref.watch(mlKitOCRServiceProvider),
    scanRepository: ref.watch(scanRepositoryProvider).valueOrNull!,
  );
}
