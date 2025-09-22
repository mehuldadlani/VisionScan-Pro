import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:visionscan_pro/features/history/data/providers/scan_repository_provider.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';

part 'generated/get_scan_details_usecase.g.dart';

/// Use case for getting scan details
@riverpod
class GetScanDetailsUseCase extends _$GetScanDetailsUseCase {
  @override
  Future<ScanResult?> build() async {
    return null; // Initial state
  }

  /// Get scan details by ID
  Future<ScanResult?> getScanDetails(String scanId) async {
    try {
      final repository = await ref.watch(scanRepositoryProvider.future);
      final scan = await repository.getScanById(scanId);

      state = AsyncValue.data(scan);
      return scan;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return null;
    }
  }

  /// Reset the use case state
  void reset() {
    state = const AsyncValue.data(null);
  }
}
