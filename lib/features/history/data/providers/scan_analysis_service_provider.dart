import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:visionscan_pro/features/history/domain/services/scan_analysis_service.dart';

part 'generated/scan_analysis_service_provider.g.dart';

/// Provider for the scan analysis service
@riverpod
ScanAnalysisService scanAnalysisService(Ref ref) {
  return const ScanAnalysisService();
}
