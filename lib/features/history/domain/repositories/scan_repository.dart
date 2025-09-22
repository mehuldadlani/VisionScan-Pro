import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:visionscan_pro/core/error/exceptions.dart';

import 'package:visionscan_pro/features/history/data/repositories/scan_repository_impl.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';

part 'generated/scan_repository.g.dart';

/// Ordering options for scan results
enum ScanResultOrderBy {
  /// Order by timestamp, newest first
  timestampDesc,

  /// Order by timestamp, oldest first
  timestampAsc,

  /// Order by ID, descending
  idDesc,

  /// Order by ID, ascending
  idAsc,

  /// Order by confidence, highest first
  confidenceDesc,

  /// Order by confidence, lowest first
  confidenceAsc,
}

/// Provider for scan repository
@riverpod
ScanRepository scanRepository(Ref ref) {
  return ref.watch(scanRepositoryImplProvider);
}

/// Repository interface for managing scan results
///
/// Provides abstraction for scan result persistence operations
/// with support for CRUD operations and querying.
abstract interface class ScanRepository {
  /// Save a scan result to persistent storage
  ///
  /// [scanResult] - The scan result to save
  /// Throws [DatabaseException] if save operation fails
  Future<void> saveScan(ScanResult scanResult);

  /// Retrieve all scan results ordered by timestamp (newest first)
  ///
  /// Returns empty list if no scans exist
  /// Throws [DatabaseException] if load operation fails
  Future<List<ScanResult>> getAllScans();

  /// Get scan results with pagination support
  ///
  /// [limit] - Maximum number of results to return
  /// [offset] - Number of results to skip
  /// Returns paginated list of scan results
  Future<List<ScanResult>> getScans({required int limit, required int offset});

  /// Retrieve a specific scan result by ID
  ///
  /// [scanId] - Unique identifier of the scan
  /// Returns null if scan not found
  /// Throws [DatabaseException] if query fails
  Future<ScanResult?> getScanById(String scanId);

  /// Delete a scan result by ID
  ///
  /// [scanId] - Unique identifier of the scan to delete
  /// Throws [DatabaseException] if delete operation fails
  Future<void> deleteScan(String scanId);

  /// Delete multiple scan results by IDs
  ///
  /// [scanIds] - List of unique identifiers to delete
  /// Throws [DatabaseException] if delete operation fails
  Future<void> deleteScans(List<String> scanIds);

  /// Delete all scan results
  ///
  /// WARNING: This operation cannot be undone
  /// Throws [DatabaseException] if delete operation fails
  Future<void> deleteAllScans();

  /// Update an existing scan result
  ///
  /// [scanResult] - Updated scan result data
  /// Throws [DatabaseException] if update operation fails
  Future<void> updateScan(ScanResult scanResult);

  /// Search scan results by extracted numbers
  ///
  /// [query] - Search query to match against extracted numbers
  /// [caseSensitive] - Whether search should be case sensitive
  /// Returns list of matching scan results
  Future<List<ScanResult>> searchScans(
    String query, {
    bool caseSensitive = false,
  });

  /// Get scan results within a date range
  ///
  /// [startDate] - Start of the date range (inclusive)
  /// [endDate] - End of the date range (inclusive)
  /// Returns list of scan results within the specified range
  Future<List<ScanResult>> getScansByDateRange(
    DateTime startDate,
    DateTime endDate,
  );

  /// Get count of all scan results
  ///
  /// Returns total number of stored scan results
  Future<int> getScansCount();

  /// Get scan results with low confidence scores
  ///
  /// [threshold] - Confidence threshold (0.0 to 1.0)
  /// Returns scans with confidence below the threshold
  Future<List<ScanResult>> getLowConfidenceScans({double threshold = 0.6});

  /// Get scan results from a specific source
  ///
  /// [isFromGallery] - Filter by gallery (true) or camera (false)
  /// Returns filtered list of scan results
  Future<List<ScanResult>> getScansBySource({required bool isFromGallery});

  /// Get aggregate statistics for all scans
  ///
  /// Returns map with statistical data (count, avg confidence, etc.)
  Future<Map<String, dynamic>> getScanStatistics();

  /// Clean up old scan results
  ///
  /// [maxAge] - Maximum age in days to keep
  /// Returns number of deleted scan results
  Future<int> cleanupOldScans({int maxAge = 30});

  /// Export scan results to JSON format
  ///
  /// [scanIds] - Optional list of specific scan IDs to export
  /// Returns JSON string representation of scan data
  Future<String> exportScansToJson({List<String>? scanIds});

  /// Import scan results from JSON format
  ///
  /// [jsonData] - JSON string containing scan data
  /// [overwriteExisting] - Whether to overwrite existing scans with same ID
  /// Returns number of imported scan results
  Future<int> importScansFromJson(
    String jsonData, {
    bool overwriteExisting = false,
  });

  /// Close repository and release resources
  ///
  /// Should be called when repository is no longer needed
  Future<void> close();
}
