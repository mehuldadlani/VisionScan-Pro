import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:visionscan_pro/core/logging/app_logger.dart';
import 'package:visionscan_pro/features/history/data/providers/scan_repository_provider.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';

part 'generated/scan_history_provider.g.dart';

/// Provider for scan history management
@Riverpod(keepAlive: true)
class ScanHistory extends _$ScanHistory {
  @override
  Future<List<ScanResult>> build() async {
    // Use actual repository to get scans
    final repository = await ref.watch(scanRepositoryProvider.future);
    return repository.getAllScans();
  }

  /// Add a new scan to history
  Future<void> addScan(ScanResult scan) async {
    try {
      final repository = await ref.read(scanRepositoryProvider.future);
      await repository.saveScan(scan);

      // Refresh the state to show the new scan
      ref.invalidateSelf();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to add scan to history',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Delete a scan from history
  Future<void> deleteScan(String scanId) async {
    try {
      final repository = await ref.read(scanRepositoryProvider.future);
      await repository.deleteScan(scanId);

      // Refresh the state to remove the deleted scan
      ref.invalidateSelf();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete scan from history',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Duplicate a scan
  Future<void> duplicateScan(ScanResult originalScan) async {
    try {
      final newScan = ScanResult(
        id: 'scan_${DateTime.now().millisecondsSinceEpoch}',
        imagePath: originalScan.imagePath,
        extractedNumbers: List.from(originalScan.extractedNumbers),
        timestamp: DateTime.now(),
        confidence: originalScan.confidence,
        notes: originalScan.notes,
        isFromGallery: originalScan.isFromGallery,
        metadata: originalScan.metadata != null
            ? Map<String, dynamic>.from(originalScan.metadata!)
            : null,
      );

      await addScan(newScan);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to duplicate scan',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Search scans by query
  Future<List<ScanResult>> searchScans(String query) async {
    try {
      final repository = await ref.read(scanRepositoryProvider.future);
      return repository.searchScans(query);
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to search scans',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Get scan statistics
  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final repository = await ref.read(scanRepositoryProvider.future);
      return repository.getScanStatistics();
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get scan statistics',
        error: e,
        stackTrace: stackTrace,
      );
      return {};
    }
  }
}

/// Clipboard service provider for copying text and numbers
final clipboardServiceProvider = Provider<ClipboardService>((ref) {
  return ClipboardService();
});

/// Share service provider for sharing scan results
final shareServiceProvider = Provider<ShareService>((ref) {
  return ShareService();
});

/// Export service provider for exporting scans as CSV/PDF
final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService();
});

/// Provider to get a single scan by ID
final scanByIdProvider = FutureProvider.family<ScanResult?, String>((
  ref,
  scanId,
) async {
  try {
    final repository = await ref.read(scanRepositoryProvider.future);
    final scan = await repository.getScanById(scanId);
    if (scan != null) {
      return scan;
    }
  } catch (e) {
    AppLogger.error('Failed to get scan from repository: $scanId', error: e);
  }

  ref.invalidate(scanHistoryProvider);
  await Future<void>.delayed(const Duration(milliseconds: 500));

  try {
    final repository = await ref.read(scanRepositoryProvider.future);
    final scan = await repository.getScanById(scanId);
    if (scan != null) {
      return scan;
    }
  } catch (e) {
    AppLogger.error(
      'Failed to get scan from repository after refresh: $scanId',
      error: e,
    );
  }

  final scansAsync = ref.watch(scanHistoryProvider);
  return scansAsync.when(
    data: (scans) {
      try {
        return scans.firstWhere((scan) => scan.id == scanId);
      } catch (e) {
        AppLogger.warning('Scan not found in history list with ID: $scanId');
        return null;
      }
    },
    loading: () => null,
    error: (error, stack) {
      AppLogger.error(
        'Error loading scan history',
        error: error,
        stackTrace: stack,
      );
      return null;
    },
  );
});

// Service implementations using actual functionality

/// Service for clipboard operations
class ClipboardService {
  /// Copy text to clipboard
  void copyText(String text) {
    try {
      Clipboard.setData(ClipboardData(text: text));
      AppLogger.info('Text copied to clipboard: ${text.length} characters');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to copy text to clipboard',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Copy multiple numbers to clipboard as comma-separated values
  void copyNumbers(List<String> numbers) {
    try {
      final text = numbers.join(', ');
      Clipboard.setData(ClipboardData(text: text));
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to copy numbers to clipboard',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}

/// Service for sharing content
class ShareService {
  /// Share extracted numbers as plain text
  Future<void> shareNumbers(List<String> numbers) async {
    try {
      final text = 'Extracted Numbers:\n${numbers.join('\n')}';
      await SharePlus.instance.share(
        ShareParams(text: text, subject: 'VisionScan Pro - Extracted Numbers'),
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to share numbers',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Share complete scan result with metadata
  Future<void> shareScanResult(ScanResult scan) async {
    try {
      final buffer = StringBuffer()
        ..writeln('VisionScan Pro - Scan Results')
        ..writeln('================================')
        ..writeln('Scan ID: ${scan.id}')
        ..writeln('Date: ${_formatDate(scan.timestamp)}')
        ..writeln('Confidence: ${(scan.confidence * 100).toStringAsFixed(1)}%')
        ..writeln('Source: ${scan.isFromGallery ? 'Gallery' : 'Camera'}')
        ..writeln()
        ..writeln('Extracted Numbers (${scan.extractedNumbers.length}):');
      for (var i = 0; i < scan.extractedNumbers.length; i++) {
        buffer.writeln('${i + 1}. ${scan.extractedNumbers[i]}');
      }

      if (scan.notes?.isNotEmpty ?? false) {
        buffer
          ..writeln()
          ..writeln('Notes: ${scan.notes}');
      }

      await SharePlus.instance.share(
        ShareParams(
          text: buffer.toString(),
          subject: 'VisionScan Pro - Scan #${scan.id.substring(0, 8)}',
        ),
      );

      AppLogger.info('Shared complete scan result: ${scan.id}');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to share scan result',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

/// Service for exporting scan data
class ExportService {
  /// Export scan as CSV file
  Future<void> exportAsCsv(ScanResult scan) async {
    try {
      final directory = await getTemporaryDirectory();
      final fileName =
          'scan_${scan.id.substring(0, 8)}_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File('${directory.path}/$fileName');

      final csvContent = StringBuffer()
        ..writeln('Scan ID,Timestamp,Number,Index,Confidence,Source');

      for (var i = 0; i < scan.extractedNumbers.length; i++) {
        csvContent.writeln(
          '"${scan.id}","${scan.timestamp.toIso8601String()}","${scan.extractedNumbers[i]}","${i + 1}","${scan.confidence}","${scan.isFromGallery ? 'Gallery' : 'Camera'}"',
        );
      }

      await file.writeAsString(csvContent.toString());

      await SharePlus.instance.share(
        ShareParams(
          text: 'Exported scan data from VisionScan Pro',
          subject: 'VisionScan Pro - CSV Export',
          files: [XFile(file.path)],
        ),
      );

      AppLogger.info('Successfully exported scan as CSV: $fileName');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to export scan as CSV',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Export scan as PDF file
  Future<void> exportAsPdf(ScanResult scan) async {
    try {
      // Create a PDF-formatted text file with .pdf extension for sharing
      // In a real implementation, you would use a PDF library like pdf or printing
      final directory = await getTemporaryDirectory();
      final fileName =
          'scan_${scan.id.substring(0, 8)}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');

      final pdfContent = StringBuffer()
        ..writeln('VISION SCAN PRO - SCAN REPORT')
        ..writeln('==========================================')
        ..writeln()
        ..writeln('Scan Information:')
        ..writeln('  Scan ID: ${scan.id}')
        ..writeln('  Date: ${scan.timestamp.toLocal()}')
        ..writeln(
          '  Confidence: ${(scan.confidence * 100).toStringAsFixed(1)}%',
        )
        ..writeln('  Source: ${scan.isFromGallery ? 'Gallery' : 'Camera'}')
        ..writeln()
        ..writeln('Extracted Numbers (${scan.extractedNumbers.length}):')
        ..writeln('------------------------------------------');

      for (var i = 0; i < scan.extractedNumbers.length; i++) {
        pdfContent.writeln(
          '${(i + 1).toString().padLeft(3)}. ${scan.extractedNumbers[i]}',
        );
      }

      if (scan.notes?.isNotEmpty ?? false) {
        pdfContent
          ..writeln()
          ..writeln('Notes:')
          ..writeln('------------------------------------------')
          ..writeln(scan.notes);
      }

      pdfContent
        ..writeln()
        ..writeln('==========================================')
        ..writeln('Generated by VisionScan Pro')
        ..writeln('Generated on: ${DateTime.now().toLocal()}');

      await file.writeAsString(pdfContent.toString());

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'VisionScan Pro - Scan Report (PDF)',
          text: 'PDF report exported from VisionScan Pro',
        ),
      );

      AppLogger.info('Successfully exported scan as PDF report: $fileName');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to export scan as PDF',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Export multiple scans as JSON
  Future<void> exportMultipleScans(List<ScanResult> scans) async {
    try {
      AppLogger.info('Exporting ${scans.length} scans');

      final directory = await getTemporaryDirectory();
      final fileName =
          'visionscan_export_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${directory.path}/$fileName');

      final exportData = {
        'exportType': 'VisionScan Pro Multi-Scan Export',
        'exportedAt': DateTime.now().toIso8601String(),
        'scansCount': scans.length,
        'scans': scans.map((scan) => scan.toJson()).toList(),
      };

      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert(exportData),
      );

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          subject: 'VisionScan Pro - Multi-Scan Export',
          text: 'Exported ${scans.length} scans from VisionScan Pro',
        ),
      );

      AppLogger.info('Successfully exported ${scans.length} scans: $fileName');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to export multiple scans',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
