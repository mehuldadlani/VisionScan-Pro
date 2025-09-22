import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';

/// Domain service for scan analysis operations
class ScanAnalysisService {
  const ScanAnalysisService();

  /// Calculate statistics for a list of scans
  ScanStatistics calculateStatistics(List<ScanResult> scans) {
    if (scans.isEmpty) {
      return ScanStatistics.empty();
    }

    final totalScans = scans.length;
    final totalNumbers = scans.fold<int>(
      0,
      (sum, scan) => sum + scan.extractedNumbers.length,
    );
    final averageConfidence =
        scans.fold<double>(0, (sum, scan) => sum + scan.confidence) /
        totalScans;
    final highConfidenceScans = scans
        .where((scan) => scan.hasHighConfidence)
        .length;
    final lowConfidenceScans = scans
        .where((scan) => scan.hasLowConfidence)
        .length;

    return ScanStatistics(
      totalScans: totalScans,
      totalNumbers: totalNumbers,
      averageConfidence: averageConfidence,
      highConfidenceScans: highConfidenceScans,
      lowConfidenceScans: lowConfidenceScans,
      averageNumbersPerScan: totalNumbers / totalScans,
    );
  }

  /// Filter scans by confidence level
  List<ScanResult> filterByConfidence(
    List<ScanResult> scans,
    double minConfidence,
  ) {
    return scans.where((scan) => scan.confidence >= minConfidence).toList();
  }

  /// Sort scans by timestamp
  List<ScanResult> sortByTimestamp(
    List<ScanResult> scans, {
    required bool ascending,
  }) {
    final sorted = List<ScanResult>.from(scans)
      ..sort(
        (a, b) => ascending
            ? a.timestamp.compareTo(b.timestamp)
            : b.timestamp.compareTo(a.timestamp),
      );
    return sorted;
  }

  /// Filter scans by date range
  List<ScanResult> filterByDateRange(
    List<ScanResult> scans,
    DateTime startDate,
    DateTime endDate,
  ) {
    return scans.where((scan) {
      return scan.timestamp.isAfter(startDate) &&
          scan.timestamp.isBefore(endDate);
    }).toList();
  }

  /// Get scans with numbers
  List<ScanResult> getScansWithNumbers(List<ScanResult> scans) {
    return scans.where((scan) => scan.extractedNumbers.isNotEmpty).toList();
  }

  /// Get recent scans (within specified days)
  List<ScanResult> getRecentScans(List<ScanResult> scans, int days) {
    final cutoffDate = DateTime.now().subtract(Duration(days: days));
    return scans.where((scan) => scan.timestamp.isAfter(cutoffDate)).toList();
  }
}

/// Statistics about scans
class ScanStatistics {
  const ScanStatistics({
    required this.totalScans,
    required this.totalNumbers,
    required this.averageConfidence,
    required this.highConfidenceScans,
    required this.lowConfidenceScans,
    required this.averageNumbersPerScan,
  });

  factory ScanStatistics.empty() {
    return const ScanStatistics(
      totalScans: 0,
      totalNumbers: 0,
      averageConfidence: 0,
      highConfidenceScans: 0,
      lowConfidenceScans: 0,
      averageNumbersPerScan: 0,
    );
  }

  final int totalScans;
  final int totalNumbers;
  final double averageConfidence;
  final int highConfidenceScans;
  final int lowConfidenceScans;
  final double averageNumbersPerScan;

  double get highConfidencePercentage =>
      totalScans > 0 ? (highConfidenceScans / totalScans) * 100 : 0;

  double get lowConfidencePercentage =>
      totalScans > 0 ? (lowConfidenceScans / totalScans) * 100 : 0;
}
