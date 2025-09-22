// ignore_for_file: avoid_redundant_argument_values

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';

import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';

part 'generated/export_scan_usecase.g.dart';

/// Export formats for scan data
enum ExportFormat { csv, pdf, json }

/// Use case for exporting scan data
@riverpod
class ExportScanUseCase extends _$ExportScanUseCase {
  @override
  FutureOr<File?> build() async {
    return null; // Initial state
  }

  /// Export scan as CSV file
  Future<File> exportAsCsv(ScanResult scan) async {
    try {
      final directory = await getTemporaryDirectory();
      final fileName =
          'scan_${scan.id.substring(0, 8)}_${DateTime.now().millisecondsSinceEpoch}.csv';
      final file = File('${directory.path}/$fileName');

      final csvContent = StringBuffer()
        ..writeln('Scan ID,Timestamp,Confidence,Source,Extracted Numbers')
        ..writeln(
          '${scan.id},${scan.timestamp.toIso8601String()},${(scan.confidence * 100).toStringAsFixed(1)}%,${scan.isFromGallery ? 'Gallery' : 'Camera'},"${scan.extractedNumbers.join('; ')}"',
        );

      await file.writeAsString(csvContent.toString());

      await SharePlus.instance.share(
        ShareParams(
          text: 'VisionScan Pro - Scan Results',
          files: [XFile(file.path)],
        ),
      );

      state = AsyncValue.data(file);
      return file;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// Export scan as PDF file
  Future<File> exportAsPdf(ScanResult scan) async {
    try {
      final directory = await getTemporaryDirectory();
      final fileName =
          'scan_${scan.id.substring(0, 8)}_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${directory.path}/$fileName');

      // Create PDF document
      final pdf = pw.Document()
        ..addPage(
          pw.Page(
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header - Use built-in fonts to avoid loading issues
                  pw.Text(
                    'VISION SCAN PRO - SCAN REPORT',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Divider(),
                  pw.SizedBox(height: 20),

                  // Scan Information
                  pw.Text(
                    'Scan Information',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text('Scan ID: ${scan.id}'),
                  pw.Text('Date: ${scan.timestamp.toLocal()}'),
                  pw.Text(
                    'Confidence: ${(scan.confidence * 100).toStringAsFixed(1)}%',
                  ),
                  pw.Text(
                    'Source: ${scan.isFromGallery ? 'Gallery' : 'Camera'}',
                  ),
                  pw.SizedBox(height: 20),

                  // Extracted Numbers
                  pw.Text(
                    'Extracted Numbers (${scan.extractedNumbers.length})',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),

                  if (scan.extractedNumbers.isNotEmpty)
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: scan.extractedNumbers.asMap().entries.map((
                        entry,
                      ) {
                        final index = entry.key;
                        final number = entry.value;
                        return pw.Padding(
                          padding: const pw.EdgeInsets.only(bottom: 8),
                          child: pw.Text('${index + 1}. $number'),
                        );
                      }).toList(),
                    )
                  else
                    pw.Text('No numbers extracted'),

                  // Notes
                  if (scan.notes?.isNotEmpty ?? false) ...[
                    pw.SizedBox(height: 20),
                    pw.Text(
                      'Notes',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(scan.notes!),
                  ],

                  pw.SizedBox(height: 30),
                  pw.Divider(),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Generated by VisionScan Pro',
                    style: const pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.grey600,
                    ),
                  ),
                ],
              );
            },
          ),
        );

      // Save PDF to file
      final bytes = await pdf.save();
      await file.writeAsBytes(bytes);

      await SharePlus.instance.share(
        ShareParams(
          text: 'VisionScan Pro - Scan Results',
          files: [XFile(file.path)],
        ),
      );

      state = AsyncValue.data(file);
      return file;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// Export scan as JSON file
  Future<File> exportAsJson(ScanResult scan) async {
    try {
      final directory = await getTemporaryDirectory();
      final fileName =
          'scan_${scan.id.substring(0, 8)}_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${directory.path}/$fileName');

      final jsonContent = {
        'scanId': scan.id,
        'timestamp': scan.timestamp.toIso8601String(),
        'confidence': scan.confidence,
        'source': scan.isFromGallery ? 'gallery' : 'camera',
        'extractedNumbers': scan.extractedNumbers,
        'notes': scan.notes,
        'metadata': scan.metadata,
      };

      await file.writeAsString(jsonEncode(jsonContent));

      state = AsyncValue.data(file);
      return file;
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// Share scan result
  Future<void> shareScanResult(ScanResult scan) async {
    try {
      final shareText = StringBuffer()
        ..writeln('VisionScan Pro - Scan Results')
        ..writeln('Scan ID: ${scan.id.substring(0, 8)}')
        ..writeln('Date: ${scan.timestamp}')
        ..writeln('Numbers Found: ${scan.extractedNumbers.length}')
        ..writeln('');

      for (var i = 0; i < scan.extractedNumbers.length; i++) {
        shareText.writeln('${i + 1}. ${scan.extractedNumbers[i]}');
      }

      await SharePlus.instance.share(
        ShareParams(
          text: 'VisionScan Pro - Scan Results',
          files: [XFile(shareText.toString())],
        ),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      rethrow;
    }
  }

  /// Reset the use case state
  void reset() {
    state = const AsyncValue.data(null);
  }
}
