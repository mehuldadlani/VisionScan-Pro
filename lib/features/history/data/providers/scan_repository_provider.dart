import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:visionscan_pro/core/providers/storage/objectbox_provider.dart';
import 'package:visionscan_pro/features/history/data/repositories/scan_repository_impl.dart';
import 'package:visionscan_pro/features/history/domain/repositories/scan_repository.dart';

part 'generated/scan_repository_provider.g.dart';

/// Provider for the scan repository
@Riverpod(keepAlive: true)
Future<ScanRepository> scanRepository(Ref ref) async {
  final objectBoxStore = await ref.watch(objectBoxStoreProvider.future);
  return ScanRepositoryImpl(objectBoxStore);
}

/// Provider for getting scan statistics
@riverpod
Future<Map<String, dynamic>> scanStatistics(Ref ref) async {
  final repository =
      await ref.watch(scanRepositoryProvider.future) as ScanRepository?;
  return repository!.getScanStatistics();
}

/// Statistics about scans in the database
class ScanStatistics {
  /// Creates a [ScanStatistics] instance
  const ScanStatistics({
    required this.totalScans,
    required this.totalNumbers,
    required this.avgProcessingTime,
    required this.avgConfidence,
    required this.successRate,
    required this.lastScanDate,
  });

  /// Total number of scans
  final int totalScans;

  /// Total numbers extracted across all scans
  final int totalNumbers;

  /// Average processing time in milliseconds
  final double avgProcessingTime;

  /// Average confidence score
  final double avgConfidence;

  /// Success rate (percentage of successful scans)
  final double successRate;

  /// Date of the last scan
  final DateTime? lastScanDate;

  @override
  String toString() {
    return 'ScanStatistics('
        'totalScans: $totalScans, '
        'totalNumbers: $totalNumbers, '
        'avgProcessingTime: ${avgProcessingTime.toStringAsFixed(1)}ms, '
        'avgConfidence: ${(avgConfidence * 100).toStringAsFixed(1)}%, '
        'successRate: ${(successRate * 100).toStringAsFixed(1)}%, '
        'lastScanDate: $lastScanDate'
        ')';
  }
}
