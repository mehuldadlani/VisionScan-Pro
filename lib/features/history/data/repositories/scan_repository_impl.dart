import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:visionscan_pro/core/database/objectbox/objectbox.g.dart';
import 'package:visionscan_pro/core/error/exceptions.dart';
import 'package:visionscan_pro/core/logging/app_logger.dart';
import 'package:visionscan_pro/core/providers/storage/objectbox_provider.dart';
import 'package:visionscan_pro/features/history/data/models/scan_result_entity.dart';
import 'package:visionscan_pro/features/history/domain/entities/scan_result.dart';
import 'package:visionscan_pro/features/history/domain/repositories/scan_repository.dart';

part 'generated/scan_repository_impl.g.dart';

/// Provider for scan repository implementation
@riverpod
ScanRepositoryImpl scanRepositoryImpl(Ref ref) {
  final store = ref.watch(objectBoxStoreProvider);
  return store.when(
    data: ScanRepositoryImpl.new,
    loading: () => throw const DatabaseException(
      'Database is still initializing',
      'DB_INITIALIZING',
    ),
    error: (error, stack) => throw DatabaseException(
      'Database initialization failed: $error',
      'DB_INIT_FAILED',
    ),
  );
}

/// ObjectBox implementation of scan repository
///
/// Provides reliable persistence for scan results using ObjectBox database
/// with comprehensive error handling and logging.
class ScanRepositoryImpl implements ScanRepository {
  ScanRepositoryImpl(this._store) {
    _scanBox = _store.box<ScanResultEntity>();
    AppLogger.info('ScanRepositoryImpl initialized');
  }
  final Store _store;
  late final Box<ScanResultEntity> _scanBox;

  @override
  Future<void> saveScan(ScanResult scanResult) async {
    try {
      AppLogger.info('Saving scan result: ${scanResult.id}');

      final entity = ScanResultEntity.fromDomain(scanResult);
      final savedId = _scanBox.put(entity);

      AppLogger.info(
        'Scan result saved successfully. ObjectBox ID: $savedId, '
        'Scan ID: ${scanResult.id}',
      );
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to save scan result: ${scanResult.id}',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to save scan result: $e',
        DatabaseException.saveFailed,
      );
    }
  }

  @override
  Future<List<ScanResult>> getAllScans() async {
    try {
      AppLogger.debug('Retrieving all scan results');

      final entities = _scanBox.getAll()
        // Sort by timestamp descending (newest first)
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

      final scanResults = entities.map((e) => e.toDomain()).toList();

      AppLogger.info('Retrieved ${scanResults.length} scan results');
      return scanResults;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to retrieve all scan results',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to load scan results: $e',
        DatabaseException.loadFailed,
      );
    }
  }

  @override
  Future<List<ScanResult>> getScans({
    required int limit,
    required int offset,
  }) async {
    try {
      AppLogger.debug('Retrieving scans with limit: $limit, offset: $offset');

      final query = _scanBox.query()
        ..order(ScanResultEntity_.timestamp, flags: Order.descending);

      final builtQuery = query.build();
      final entities = builtQuery.find();
      // Apply offset and limit manually since ObjectBox doesn't support it directly
      final limitedEntities = entities.skip(offset).take(limit).toList();
      builtQuery.close();

      final scanResults = limitedEntities.map((e) => e.toDomain()).toList();

      AppLogger.debug('Retrieved ${scanResults.length} paginated scan results');
      return scanResults;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to retrieve paginated scan results',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to load paginated scans: $e',
        DatabaseException.loadFailed,
      );
    }
  }

  @override
  Future<ScanResult?> getScanById(String scanId) async {
    try {
      AppLogger.debug('Retrieving scan by ID: $scanId');

      final query = _scanBox.query(ScanResultEntity_.scanId.equals(scanId));
      final builtQuery = query.build();
      final entities = builtQuery.find();
      builtQuery.close(  );

      if (entities.isNotEmpty) {
        final scanResult = entities.first.toDomain();
        AppLogger.debug('Found scan result: $scanId');
        return scanResult;
      }

      AppLogger.debug('Scan result not found: $scanId');
      return null;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to retrieve scan by ID: $scanId',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to load scan: $e',
        DatabaseException.loadFailed,
      );
    }
  }

  @override
  Future<void> deleteScan(String scanId) async {
    try {
      AppLogger.info('Deleting scan: $scanId');

      final query = _scanBox.query(ScanResultEntity_.scanId.equals(scanId));
      final builtQuery = query.build();
      final entities = builtQuery.find();
      builtQuery.close();

      if (entities.isNotEmpty) {
        final removed = _scanBox.remove(entities.first.id);
        if (removed) {
          AppLogger.info('Scan deleted successfully: $scanId');
        } else {
          AppLogger.warning('Failed to delete scan: $scanId');
        }
      } else {
        AppLogger.warning('Scan not found for deletion: $scanId');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete scan: $scanId',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to delete scan: $e',
        DatabaseException.deleteFailed,
      );
    }
  }

  @override
  Future<void> deleteScans(List<String> scanIds) async {
    try {
      AppLogger.info('Deleting ${scanIds.length} scans');

      for (final scanId in scanIds) {
        await deleteScan(scanId);
      }

      AppLogger.info('Successfully deleted ${scanIds.length} scans');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete multiple scans',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to delete scans: $e',
        DatabaseException.deleteFailed,
      );
    }
  }

  @override
  Future<void> deleteAllScans() async {
    try {
      AppLogger.warning('Deleting ALL scan results');

      final removedCount = _scanBox.removeAll();

      AppLogger.warning('Deleted $removedCount scan results');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete all scans',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to delete all scans: $e',
        DatabaseException.deleteFailed,
      );
    }
  }

  @override
  Future<void> updateScan(ScanResult scanResult) async {
    try {
      AppLogger.info('Updating scan: ${scanResult.id}');

      // Find existing entity
      final query = _scanBox.query(
        ScanResultEntity_.scanId.equals(scanResult.id),
      );
      final builtQuery = query.build();
      final entities = builtQuery.find();
      builtQuery.close();

      if (entities.isNotEmpty) {
        final entity = entities.first;
        // Update the entity with new data
        final updatedEntity = ScanResultEntity.fromDomain(scanResult)
        ..id = entity.id; // Preserve ObjectBox ID

        _scanBox.put(updatedEntity);
        AppLogger.info('Scan updated successfully: ${scanResult.id}');
      } else {
        // If not found, create new
        AppLogger.warning(
          'Scan not found for update, creating new: ${scanResult.id}',
        );
        await saveScan(scanResult);
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update scan: ${scanResult.id}',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to update scan: $e',
        DatabaseException.saveFailed,
      );
    }
  }

  @override
  Future<List<ScanResult>> searchScans(
    String query, {
    bool caseSensitive = false,
  }) async {
    try {
      AppLogger.debug('Searching scans for: "$query"');

      // For simple implementation, we'll search in extracted numbers
      final allScans = await getAllScans();

      final searchQuery = caseSensitive ? query : query.toLowerCase();

      final matchingScans = allScans.where((scan) {
        return scan.extractedNumbers.any((number) {
          final numberToSearch = caseSensitive ? number : number.toLowerCase();
          return numberToSearch.contains(searchQuery);
        });
      }).toList();

      AppLogger.debug('Found ${matchingScans.length} matching scans');
      return matchingScans;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to search scans',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to search scans: $e',
        DatabaseException.loadFailed,
      );
    }
  }

  @override
  Future<List<ScanResult>> getScansByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      AppLogger.debug('Retrieving scans from $startDate to $endDate');

      final startMillis = startDate.millisecondsSinceEpoch;
      final endMillis = endDate.millisecondsSinceEpoch;

      final query = _scanBox.query(
        ScanResultEntity_.timestamp.between(startMillis, endMillis),
      )..order(ScanResultEntity_.timestamp, flags: Order.descending);

      final builtQuery = query.build();
      final entities = builtQuery.find();
      builtQuery.close();

      final scanResults = entities.map((e) => e.toDomain()).toList();

      AppLogger.debug('Found ${scanResults.length} scans in date range');
      return scanResults;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to retrieve scans by date range',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to load scans by date: $e',
        DatabaseException.loadFailed,
      );
    }
  }

  @override
  Future<int> getScansCount() async {
    try {
      final count = _scanBox.count();
      AppLogger.debug('Total scans count: $count');
      return count;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to get scans count',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to count scans: $e',
        DatabaseException.loadFailed,
      );
    }
  }

  @override
  Future<List<ScanResult>> getLowConfidenceScans({
    double threshold = 0.6,
  }) async {
    try {
      AppLogger.debug('Retrieving low confidence scans below $threshold');

      final query = _scanBox.query(
        ScanResultEntity_.confidence.lessThan(threshold),
      )..order(ScanResultEntity_.timestamp, flags: Order.descending);

      final builtQuery = query.build();
      final entities = builtQuery.find();
      builtQuery.close();

      final scanResults = entities.map((e) => e.toDomain()).toList();

      AppLogger.debug('Found ${scanResults.length} low confidence scans');
      return scanResults;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to retrieve low confidence scans',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to load low confidence scans: $e',
        DatabaseException.loadFailed,
      );
    }
  }

  @override
  Future<List<ScanResult>> getScansBySource({
    required bool isFromGallery,
  }) async {
    try {
      AppLogger.debug(
        'Retrieving scans by source: ${isFromGallery ? "Gallery" : "Camera"}',
      );

      final query = _scanBox.query(
        ScanResultEntity_.isFromGallery.equals(isFromGallery),
      )..order(ScanResultEntity_.timestamp, flags: Order.descending);

      final builtQuery = query.build();
      final entities = builtQuery.find();
      builtQuery.close();

      final scanResults = entities.map((e) => e.toDomain()).toList();

      AppLogger.debug('Found ${scanResults.length} scans from source');
      return scanResults;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to retrieve scans by source',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to load scans by source: $e',
        DatabaseException.loadFailed,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> getScanStatistics() async {
    try {
      AppLogger.debug('Computing scan statistics');

      final allScans = await getAllScans();

      if (allScans.isEmpty) {
        return {
          'totalScans': 0,
          'averageConfidence': 0.0,
          'totalNumbers': 0,
          'cameraScanCount': 0,
          'galleryScanCount': 0,
          'averageProcessingTime': 0,
        };
      }

      final statistics = {
        'totalScans': allScans.length,
        'averageConfidence':
            allScans.map((s) => s.confidence).reduce((a, b) => a + b) /
            allScans.length,
        'totalNumbers': allScans
            .map((s) => s.extractedNumbers.length)
            .reduce((a, b) => a + b),
        'cameraScanCount': allScans.where((s) => !s.isFromGallery).length,
        'galleryScanCount': allScans.where((s) => s.isFromGallery).length,
        'averageProcessingTime':
            allScans
                .where((s) => s.processingDurationMs != null)
                .map((s) => s.processingDurationMs!)
                .fold<double>(0, (a, b) => a + b) /
            allScans.length,
      };

      AppLogger.debug('Computed statistics: $statistics');
      return statistics;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to compute scan statistics',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to compute statistics: $e',
        DatabaseException.loadFailed,
      );
    }
  }

  @override
  Future<int> cleanupOldScans({int maxAge = 30}) async {
    try {
      AppLogger.info('Cleaning up scans older than $maxAge days');

      final cutoffDate = DateTime.now().subtract(Duration(days: maxAge));
      final cutoffMillis = cutoffDate.millisecondsSinceEpoch;

      final query = _scanBox.query(
        ScanResultEntity_.timestamp.lessThan(cutoffMillis),
      );

      final builtQuery = query.build();
      final removedCount = builtQuery.remove();
      builtQuery.close();

      AppLogger.info('Cleaned up $removedCount old scans');
      return removedCount;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to cleanup old scans',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to cleanup old scans: $e',
        DatabaseException.deleteFailed,
      );
    }
  }

  @override
  Future<String> exportScansToJson({List<String>? scanIds}) async {
    try {
      AppLogger.info('Exporting scans to JSON');

      List<ScanResult> scansToExport;

      if (scanIds != null && scanIds.isNotEmpty) {
        scansToExport = [];
        for (final scanId in scanIds) {
          final scan = await getScanById(scanId);
          if (scan != null) {
            scansToExport.add(scan);
          }
        }
      } else {
        scansToExport = await getAllScans();
      }

      final jsonData = {
        'exportedAt': DateTime.now().toIso8601String(),
        'version': '1.0',
        'scansCount': scansToExport.length,
        'scans': scansToExport.map((s) => s.toJson()).toList(),
      };

      final jsonString = json.encode(jsonData);

      AppLogger.info('Exported ${scansToExport.length} scans to JSON');
      return jsonString;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to export scans to JSON',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to export scans: $e',
        DatabaseException.loadFailed,
      );
    }
  }

  @override
  Future<int> importScansFromJson(
    String jsonData, {
    bool overwriteExisting = false,
  }) async {
    try {
      AppLogger.info('Importing scans from JSON');

      final data = json.decode(jsonData) as Map<String, dynamic>;
      final scansData = data['scans'] as List<dynamic>? ?? [];

      var importedCount = 0;

      for (final scanData in scansData) {
        try {
          final scanResult = ScanResult.fromJson(
            scanData as Map<String, dynamic>,
          );

          final existingScan = await getScanById(scanResult.id);

          if (existingScan == null || overwriteExisting) {
            await saveScan(scanResult);
            importedCount++;
          }
        } catch (e) {
          AppLogger.warning('Failed to import individual scan', error: e);
        }
      }

      AppLogger.info('Imported $importedCount scans from JSON');
      return importedCount;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to import scans from JSON',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to import scans: $e',
        DatabaseException.saveFailed,
      );
    }
  }

  @override
  Future<void> close() async {
    try {
      AppLogger.info('Closing scan repository');
      // ObjectBox Store is managed by the provider, so we don't close it here
    } catch (e) {
      AppLogger.warning('Error during scan repository close', error: e);
    }
  }
}
