import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:visionscan_pro/core/constants/app_constants.dart';
import 'package:visionscan_pro/core/logging/app_logger.dart';
import 'package:visionscan_pro/core/providers/storage/objectbox_provider.dart';
import 'package:visionscan_pro/core/utils/permission_utils.dart';

part 'generated/app_startup_provider.g.dart';

/// Manages the application startup sequence
///
/// Coordinates initialization of critical services and dependencies
/// required for the application to function properly.
@Riverpod(keepAlive: true)
class AppStartup extends _$AppStartup {
  @override
  Future<AppStartupResult> build() async {
    try {
      // Add overall timeout to prevent infinite startup
      return await _performStartup().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          AppLogger.error('App startup timed out after 30 seconds');
          return AppStartupResult.failure(
            error: 'Startup timeout',
            stackTrace: StackTrace.current,
          );
        },
      );
    } catch (e, stackTrace) {
      return AppStartupResult.failure(error: e, stackTrace: stackTrace);
    }
  }

  /// Performs the actual startup sequence
  Future<AppStartupResult> _performStartup() async {
    final startTime = DateTime.now();

    // Initialize database
    await _initializeDatabase();

    // Check permissions (but don't require them for startup)
    final permissionStatus = await _checkPermissions();

    // Perform any additional startup tasks
    await _performStartupTasks();

    final endTime = DateTime.now();
    final duration = endTime.difference(startTime);

    return AppStartupResult.success(
      initializationTime: duration,
      permissionStatus: permissionStatus,
    );
  }

  /// Initializes the ObjectBox database with timeout
  Future<void> _initializeDatabase() async {
    try {
      // Initialize the database with timeout to prevent hanging
      await ref
          .read(objectBoxStoreProvider.future)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              AppLogger.warning(
                'Database initialization timed out, continuing without database',
              );
              throw TimeoutException(
                'Database initialization timed out',
                const Duration(seconds: 10),
              );
            },
          );

      // Validate database integrity with timeout
      final isValid = await ref
          .read(objectBoxStoreProvider.notifier)
          .validateDatabaseIntegrity()
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () {
              AppLogger.warning('Database validation timed out');
              return false;
            },
          );

      if (!isValid) {
        AppLogger.warning(
          'Database validation failed, but continuing with startup',
        );
        // Don't throw exception on validation failure for now
        // This allows the app to start even if database validation fails
      }

      if (AppConstants.showDebugInfo) {
        AppLogger.info('ObjectBox database initialized successfully');
        try {
          final stats = await ref
              .read(objectBoxStoreProvider.notifier)
              .getDatabaseStats()
              .timeout(const Duration(seconds: 3));
          AppLogger.info('Database stats: $stats');
        } catch (e) {
          AppLogger.warning('Could not get database stats: $e');
        }
      }
    } catch (e) {
      AppLogger.error('Database initialization failed', error: e);
      // Don't throw exception, just log the error
      // This allows the app to start even if database fails
    }
  }

  /// Checks application permissions
  Future<StartupPermissionStatus> _checkPermissions() async {
    try {
      final cameraPermission = await PermissionUtils.hasCameraPermission();
      final storagePermission = await PermissionUtils.hasStoragePermission();
      final photosPermission = await PermissionUtils.hasPhotosPermission();

      return StartupPermissionStatus(
        cameraGranted: cameraPermission,
        storageGranted: storagePermission,
        photosGranted: photosPermission,
      );
    } catch (e) {
      return StartupPermissionStatus(
        cameraGranted: false,
        storageGranted: false,
        photosGranted: false,
        error: e.toString(),
      );
    }
  }

  /// Performs additional startup tasks
  Future<void> _performStartupTasks() async {
    try {
      // Clean up temporary files from previous sessions
      await _cleanupTempFiles();

      // Initialize app directories
      await _initializeDirectories();

      if (AppConstants.showDebugInfo) {
        AppLogger.info('Startup tasks completed successfully');
      }
    } catch (e) {
      // Non-critical startup tasks - log but don't fail startup
      if (AppConstants.showDebugInfo) {
        AppLogger.warning('Warning: Some startup tasks failed: $e');
      }
    }
  }

  /// Cleans up temporary files
  Future<void> _cleanupTempFiles() async {
    // Implementation will be added when ImageUtils is available
    // await ImageUtils.cleanupTempImages();
  }

  /// Initializes application directories
  Future<void> _initializeDirectories() async {
    // Implementation to ensure required directories exist
    // This will be implemented when directory structure is needed
  }

  /// Restarts the application startup process
  Future<void> restart() async {
    ref.invalidateSelf();
    await future;
  }

  /// Gets the current startup status
  AppStartupResult? get currentStatus {
    final asyncValue = ref.read(appStartupProvider);
    return asyncValue.when(
      data: (result) => result,
      loading: () => null,
      error: (error, stackTrace) =>
          AppStartupResult.failure(error: error, stackTrace: stackTrace),
    );
  }

  /// Checks if startup is complete and successful
  bool get isStartupComplete {
    final status = currentStatus;
    return status != null && status.isSuccess;
  }

  /// Checks if startup failed
  bool get isStartupFailed {
    final status = currentStatus;
    return status != null && status.isFailure;
  }
}

/// Result of the application startup process
class AppStartupResult {
  /// Creates a successful startup result
  factory AppStartupResult.success({
    required Duration initializationTime,
    required StartupPermissionStatus permissionStatus,
  }) {
    return AppStartupResult._(
      isSuccess: true,
      initializationTime: initializationTime,
      permissionStatus: permissionStatus,
    );
  }

  /// Creates a failure startup result
  factory AppStartupResult.failure({
    required Object error,
    required StackTrace stackTrace,
  }) {
    return AppStartupResult._(
      isSuccess: false,
      error: error,
      stackTrace: stackTrace,
    );
  }
  const AppStartupResult._({
    required this.isSuccess,
    this.initializationTime,
    this.permissionStatus,
    this.error,
    this.stackTrace,
  });

  /// Whether the startup was successful
  final bool isSuccess;

  /// The time it took to initialize the application
  final Duration? initializationTime;

  /// The permission status during startup
  final StartupPermissionStatus? permissionStatus;

  /// The error that occurred during startup
  final Object? error;

  /// The stack trace of the error
  final StackTrace? stackTrace;

  /// Whether the startup failed
  bool get isFailure => !isSuccess;

  @override
  String toString() {
    if (isSuccess) {
      return 'AppStartupResult.success(time: ${initializationTime?.inMilliseconds}ms)';
    } else {
      return 'AppStartupResult.failure(error: $error)';
    }
  }
}

/// Permission status during startup
class StartupPermissionStatus {
  /// Creates a startup permission status
  const StartupPermissionStatus({
    required this.cameraGranted,
    required this.storageGranted,
    required this.photosGranted,
    this.error,
  });

  /// Whether the camera permission was granted
  final bool cameraGranted;

  /// Whether the storage permission was granted
  final bool storageGranted;

  /// Whether the photos permission was granted
  final bool photosGranted;

  /// The error that occurred during startup
  final String? error;

  /// Whether all permissions were granted
  bool get allGranted => cameraGranted && storageGranted && photosGranted;

  /// Whether an error occurred during startup
  bool get hasError => error != null;

  /// Gets the missing permissions
  List<String> get missingPermissions {
    final missing = <String>[];
    if (!cameraGranted) missing.add('Camera');
    if (!storageGranted) missing.add('Storage');
    if (!photosGranted) missing.add('Photos');
    return missing;
  }

  @override
  String toString() {
    return 'StartupPermissionStatus('
        'camera: $cameraGranted, '
        'storage: $storageGranted, '
        'photos: $photosGranted'
        ')';
  }
}
