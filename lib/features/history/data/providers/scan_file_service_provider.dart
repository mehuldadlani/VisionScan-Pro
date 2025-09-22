import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:visionscan_pro/features/history/domain/services/scan_file_service.dart';

part 'generated/scan_file_service_provider.g.dart';

/// Provider for the scan file service
@riverpod
ScanFileService scanFileService(Ref ref) {
  return const ScanFileService();
}
