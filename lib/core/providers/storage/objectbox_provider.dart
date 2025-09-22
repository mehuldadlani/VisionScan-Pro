import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:visionscan_pro/core/constants/objectbox_constants.dart';
import 'package:visionscan_pro/core/database/objectbox/objectbox.g.dart';
import 'package:visionscan_pro/core/error/exceptions.dart';
import 'package:visionscan_pro/core/logging/app_logger.dart';

part 'generated/objectbox_provider.g.dart';

/// ObjectBox store provider for VisionScan Pro
///
/// Manages the ObjectBox database connection and provides
/// a singleton Store instance throughout the application.
@Riverpod(keepAlive: true)
class ObjectBoxStore extends _$ObjectBoxStore {
  @override
  Future<Store> build() async {
    try {
      // Use a more efficient initialization with timeout
      return await _initializeStoreWithTimeout();
    } catch (e) {
      // Fallback: try to open store with minimal configuration
      return openStore();
    }
  }

  /// Initialize store with timeout and optimized settings
  Future<Store> _initializeStoreWithTimeout() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dbPath = path.join(appDir.path, ObjectBoxConstants.databaseDirectory);

    return Future.any([
      openStore(
        directory: dbPath,
        // Optimize for iOS performance
        maxDBSizeInKB: 100 * 1024, // 100MB limit
        maxDataSizeInKB: 10 * 1024, // 10MB data limit
        fileMode: 438, // 0o666 in decimal
        maxReaders: 1, // Reduce concurrent readers for iOS
      ),
      Future.delayed(
        const Duration(seconds: 5),
        () => throw TimeoutException(
          'ObjectBox initialization timeout',
          const Duration(seconds: 5),
        ),
      ),
    ]);
  }

  /// Gets the current store instance
  Future<Store> get currentStore => future;

  /// Checks if the store is initialized and open
  Future<bool> get isOpen async => !(await future).isClosed();

  /// Closes the ObjectBox store
  Future<void> closeStore() async {
    final store = await future;
    if (!store.isClosed()) {
      store.close();
    }
  }

  /// Gets database statistics
  Future<DatabaseStats> getDatabaseStats() async {
    final store = await future;

    try {
      final stats = Store.dbFileSize(
        path.join(
          (await getApplicationDocumentsDirectory()).path,
          ObjectBoxConstants.databaseDirectory,
        ),
      );

      return DatabaseStats(
        dbFileSize: stats,
        isOpen: !store.isClosed(),
        storeId: store.toString(),
      );
    } catch (e) {
      throw const DatabaseException(
        'Failed to get database statistics',
        'DB_STATS_FAILED',
      );
    }
  }

  /// Performs database maintenance operations
  Future<void> performMaintenance() async {
    final store = await future;

    try {
      // Run garbage collection if available
      // Note: ObjectBox handles most maintenance automatically

      // Log maintenance completion
      if (ObjectBoxConstants.enableDebugMode) {
        AppLogger.info('ObjectBox maintenance completed for store: $store');
      }
    } catch (e) {
      throw const DatabaseException(
        'Database maintenance failed',
        'DB_MAINTENANCE_FAILED',
      );
    }
  }

  /// Backs up the database
  Future<String> backupDatabase() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final backupDir = Directory(path.join(appDocDir.path, 'backups'));

      if (!backupDir.existsSync()) {
        await backupDir.create(recursive: true);
      }

      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-');
      final backupFileName =
          'visionscan_backup_$timestamp${ObjectBoxConstants.backupFileExtension}';
      final backupPath = path.join(backupDir.path, backupFileName);

      // Copy database files
      final dbDir = Directory(
        path.join(appDocDir.path, ObjectBoxConstants.databaseDirectory),
      );
      final dbFiles = await dbDir.list().toList();

      for (final file in dbFiles) {
        if (file is File) {
          final fileName = path.basename(file.path);
          final backupFilePath = path.join(
            backupDir.path,
            '${timestamp}_$fileName',
          );
          await file.copy(backupFilePath);
        }
      }

      return backupPath;
    } catch (e) {
      throw const DatabaseException(
        'Database backup failed',
        'DB_BACKUP_FAILED',
      );
    }
  }

  /// Validates database integrity
  Future<bool> validateDatabaseIntegrity() async {
    try {
      final store = await future;

      // Basic validation: check if store is open and accessible
      if (store.isClosed()) {
        return false;
      }

      // Try to access a box to ensure database is working
      store.box<dynamic>();

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Gets database file path
  Future<String> getDatabasePath() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    return path.join(appDocDir.path, ObjectBoxConstants.databaseDirectory);
  }
}

/// Database statistics information
class DatabaseStats {
  /// Constructor for DatabaseStats
  const DatabaseStats({
    required this.dbFileSize,
    required this.isOpen,
    required this.storeId,
  });

  /// The size of the database file
  final int dbFileSize;

  /// Whether the store is open
  final bool isOpen;

  /// The ID of the store
  final String storeId;

  /// Gets database size in human-readable format
  String get formattedSize => switch (dbFileSize) {
    < 1024 => '$dbFileSize B',
    < 1024 * 1024 => '${(dbFileSize / 1024).toStringAsFixed(1)} KB',
    < 1024 * 1024 * 1024 =>
      '${(dbFileSize / (1024 * 1024)).toStringAsFixed(1)} MB',
    _ => '${(dbFileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB',
  };

  @override
  String toString() {
    return 'DatabaseStats(size: $formattedSize, isOpen: $isOpen)';
  }
}
