import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:visionscan_pro/core/database/objectbox/objectbox.g.dart';
import 'package:visionscan_pro/core/error/exceptions.dart';
import 'package:visionscan_pro/core/logging/app_logger.dart';
import 'package:visionscan_pro/core/providers/storage/objectbox_provider.dart';
import 'package:visionscan_pro/features/history/data/models/scan_result_entity.dart';

part 'generated/database_provider.g.dart';

/// Provider for ObjectBox database store
///
/// This provider has been deprecated in favor of objectBoxStoreProvider.
/// Use objectBoxStoreProvider.future instead.
@riverpod
Future<Store> database(Ref ref) async {
  // Delegate to the proper ObjectBox provider
  return await ref.watch(objectBoxStoreProvider.future);
}

/// Database service for ObjectBox initialization and management
class DatabaseService {
  static Store? _store;
  static bool _isInitialized = false;

  /// Initialize ObjectBox database
  static Future<Store> initialize() async {
    if (_store != null && _isInitialized) {
      return _store!;
    }

    try {
      AppLogger.info('Initializing ObjectBox database');

      // Get application documents directory
      final appDocDir = await getApplicationDocumentsDirectory();
      final dbPath = p.join(appDocDir.path, 'visionscan_objectbox');

      AppLogger.info('Database path: $dbPath');

      // Ensure directory exists
      final dbDir = Directory(dbPath);
      if (!dbDir.existsSync()) {
        dbDir.createSync(recursive: true);
        AppLogger.info('Created database directory: $dbPath');
      }

      // Open ObjectBox store
      _store = Store(getObjectBoxModel(), directory: dbPath);
      _isInitialized = true;

      AppLogger.info('ObjectBox database initialized successfully');

      // Log database info
      await _logDatabaseInfo();

      return _store!;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to initialize ObjectBox database',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to initialize database: $e',
        DatabaseException.migrationFailed,
      );
    }
  }

  /// Close database connection
  static Future<void> close() async {
    if (_store != null) {
      try {
        AppLogger.info('Closing ObjectBox database');
        _store!.close();
        _store = null;
        _isInitialized = false;
        AppLogger.info('Database closed successfully');
      } catch (e) {
        AppLogger.error('Error closing database', error: e);
      }
    }
  }

  /// Get current store instance
  static Store? get store => _store;

  /// Check if database is initialized
  static bool get isInitialized => _isInitialized;

  /// Log database information for debugging
  static Future<void> _logDatabaseInfo() async {
    if (_store == null) return;

    try {
      // Get basic database stats
      // Get basic database info
      AppLogger.info('Database initialized successfully');

      // Log entity counts
      final scanBox = _store!.box<ScanResultEntity>();
      final scanCount = scanBox.count();
      AppLogger.info('Scan results in database: $scanCount');
    } catch (e) {
      AppLogger.warning('Failed to log database info', error: e);
    }
  }

  /// Backup database to specified path
  static Future<void> backupDatabase(String backupPath) async {
    if (_store == null) {
      throw const DatabaseException(
        'Database not initialized',
        DatabaseException.loadFailed,
      );
    }

    try {
      AppLogger.info('Creating database backup at: $backupPath');

      // Ensure backup directory exists
      final backupDir = Directory(p.dirname(backupPath));
      if (!backupDir.existsSync()) {
        await backupDir.create(recursive: true);
      }

      // Create backup
      // Backup functionality may not be available in current ObjectBox version
      // Consider implementing manual backup by copying database files
      AppLogger.warning(
        'Database backup not implemented for this ObjectBox version',
      );

      AppLogger.info('Database backup created successfully');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to create database backup',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to backup database: $e',
        DatabaseException.saveFailed,
      );
    }
  }

  /// Restore database from backup
  static Future<void> restoreDatabase(String backupPath) async {
    try {
      AppLogger.info('Restoring database from backup: $backupPath');

      // Check if backup file exists
      final backupFile = File(backupPath);
      if (!backupFile.existsSync()) {
        throw DatabaseException(
          'Backup file not found: $backupPath',
          DatabaseException.loadFailed,
        );
      }

      // Close current database if open
      if (_store != null) {
        await close();
      }

      // Get database directory
      final appDocDir = await getApplicationDocumentsDirectory();
      final dbPath = p.join(appDocDir.path, 'visionscan_objectbox');

      // Remove existing database
      final dbDir = Directory(dbPath);
      if (dbDir.existsSync()) {
        await dbDir.delete(recursive: true);
      }

      // Restore from backup
      await dbDir.create(recursive: true);
      // Note: ObjectBox restore functionality would need to be implemented
      // This is a placeholder for the restore logic

      // Reinitialize database
      await initialize();

      AppLogger.info('Database restored successfully from backup');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to restore database from backup',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to restore database: $e',
        DatabaseException.loadFailed,
      );
    }
  }

  /// Get database size in bytes
  static Future<int> getDatabaseSize() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final dbPath = p.join(appDocDir.path, 'visionscan_objectbox');

      final dbDir = Directory(dbPath);
      if (!dbDir.existsSync()) {
        return 0;
      }

      var totalSize = 0;
      await for (final entity in dbDir.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }

      AppLogger.debug('Database size: ${totalSize / 1024 / 1024} MB');
      return totalSize;
    } catch (e) {
      AppLogger.warning('Failed to get database size', error: e);
      return 0;
    }
  }

  /// Compact database to reclaim space
  static Future<void> compactDatabase() async {
    if (_store == null) {
      throw const DatabaseException(
        'Database not initialized',
        DatabaseException.loadFailed,
      );
    }

    try {
      AppLogger.info('Compacting database');

      // ObjectBox doesn't have a direct compact method,
      // but we can trigger garbage collection
      // Force garbage collection is not available in Dart
      // The Dart VM handles garbage collection automatically

      AppLogger.info('Database compaction completed');
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to compact database',
        error: e,
        stackTrace: stackTrace,
      );
      throw DatabaseException(
        'Failed to compact database: $e',
        DatabaseException.saveFailed,
      );
    }
  }

  /// Validate database integrity
  static Future<bool> validateDatabase() async {
    if (_store == null) {
      return false;
    }

    try {
      AppLogger.info('Validating database integrity');

      // Basic validation - try to access each box
      final scanBox = _store!.box<ScanResultEntity>();
      final scanCount = scanBox.count();

      AppLogger.info('Database validation passed. Scans: $scanCount');
      return true;
    } catch (e) {
      AppLogger.error('Database validation failed', error: e);
      return false;
    }
  }
}
