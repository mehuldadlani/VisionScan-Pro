import 'dart:io';

import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';

/// Domain service for scan file operations
///
/// Handles file-related business logic for scan results
/// without violating Clean Architecture principles.
class ScanFileService {
  const ScanFileService();

  /// Checks if the image file for a scan result still exists
  Future<bool> checkImageExists(ScanResult scanResult) async {
    if (scanResult.imagePath == null) return false;

    try {
      return File(scanResult.imagePath!).existsSync();
    } catch (e) {
      return false;
    }
  }

  /// Validates if a scan result has a valid image file
  Future<bool> validateScanImage(ScanResult scanResult) async {
    if (scanResult.imagePath == null) return false;

    final file = File(scanResult.imagePath!);

    try {
      if (!file.existsSync()) return false;

      final fileSize = await file.length();
      if (fileSize == 0) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets the file size of a scan result's image
  Future<int?> getImageFileSize(ScanResult scanResult) async {
    if (scanResult.imagePath == null) return null;

    try {
      final file = File(scanResult.imagePath!);
      if (!file.existsSync()) return null;

      return await file.length();
    } catch (e) {
      return null;
    }
  }
}
