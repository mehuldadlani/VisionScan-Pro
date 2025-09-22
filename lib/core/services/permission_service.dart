import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:visionscan_pro/core/logging/app_logger.dart';

part 'generated/permission_service.freezed.dart';
part 'generated/permission_service.g.dart';

@riverpod
/// Provider for PermissionService
PermissionService permissionService(Ref ref) {
  return PermissionService();
}

/// Service for managing app permissions with comprehensive status handling
///
/// Provides a clean interface for requesting and checking permissions
/// with detailed status reporting and error handling.
class PermissionService {
  /// Request camera permission from user
  Future<PermissionResult> requestCameraPermission() async {
    try {
      AppLogger.info('Requesting camera permission');

      // Check current status first
      final currentStatus = await Permission.camera.status;
      AppLogger.debug('Current camera permission status: $currentStatus');

      // If already granted, return immediately
      if (currentStatus.isGranted) {
        AppLogger.info('Camera permission already granted');
        return const PermissionResult.granted();
      }

      // If permanently denied, can't request again
      if (currentStatus.isPermanentlyDenied) {
        AppLogger.warning('Camera permission permanently denied');
        return const PermissionResult.permanentlyDenied();
      }

      // Request permission
      final status = await Permission.camera.request();
      AppLogger.info('Camera permission request result: $status');

      switch (status) {
        case PermissionStatus.granted:
          return const PermissionResult.granted();
        case PermissionStatus.denied:
          return const PermissionResult.denied();
        case PermissionStatus.permanentlyDenied:
          return const PermissionResult.permanentlyDenied();
        case PermissionStatus.restricted:
          return const PermissionResult.restricted();
        case PermissionStatus.limited:
          return const PermissionResult.limited();
        case PermissionStatus.provisional:
          return const PermissionResult.provisional();
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to request camera permission',
        error: e,
        stackTrace: stackTrace,
      );
      return const PermissionResult.denied();
    }
  }

  /// Check if camera permission is currently granted
  Future<bool> hasCameraPermission() async {
    try {
      final status = await Permission.camera.status;
      final hasPermission = status.isGranted;

      AppLogger.debug('Camera permission check: $hasPermission');
      return hasPermission;
    } catch (e) {
      AppLogger.error('Failed to check camera permission', error: e);
      return false;
    }
  }

  /// Get current camera permission status without requesting
  Future<PermissionStatus> getCameraPermissionStatus() async {
    try {
      final status = await Permission.camera.status;
      AppLogger.debug('Camera permission status: $status');
      return status;
    } catch (e) {
      AppLogger.error('Failed to get camera permission status', error: e);
      return PermissionStatus.denied;
    }
  }

  /// Request storage permission (for saving images)
  Future<PermissionResult> requestStoragePermission() async {
    try {
      AppLogger.info('Requesting storage permission');

      // On Android 13+, we need different permissions
      Permission storagePermission;

      // For now, use photos permission which is more appropriate for our use case
      storagePermission = Permission.photos;

      final status = await storagePermission.request();
      AppLogger.info('Storage permission request result: $status');

      switch (status) {
        case PermissionStatus.granted:
          return const PermissionResult.granted();
        case PermissionStatus.denied:
          return const PermissionResult.denied();
        case PermissionStatus.permanentlyDenied:
          return const PermissionResult.permanentlyDenied();
        case PermissionStatus.restricted:
          return const PermissionResult.restricted();
        case PermissionStatus.limited:
          return const PermissionResult.limited();
        case PermissionStatus.provisional:
          return const PermissionResult.provisional();
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Failed to request storage permission',
        error: e,
        stackTrace: stackTrace,
      );
      return const PermissionResult.denied();
    }
  }

  /// Check if storage permission is granted
  Future<bool> hasStoragePermission() async {
    try {
      final status = await Permission.photos.status;
      final hasPermission = status.isGranted;

      AppLogger.debug('Storage permission check: $hasPermission');
      return hasPermission;
    } catch (e) {
      AppLogger.error('Failed to check storage permission', error: e);
      return false;
    }
  }

  /// Open app settings for manual permission management
  Future<bool> openAppSettings() async {
    try {
      AppLogger.info('Opening app settings');
      final opened = await openAppSettings();

      if (opened) {
        AppLogger.info('App settings opened successfully');
      } else {
        AppLogger.warning('Failed to open app settings');
      }

      return opened;
    } catch (e) {
      AppLogger.error('Error opening app settings', error: e);
      return false;
    }
  }

  /// Request all necessary permissions at once
  Future<Map<String, PermissionResult>> requestAllPermissions() async {
    AppLogger.info('Requesting all necessary permissions');

    final results = <String, PermissionResult>{};

    // Request camera permission
    results['camera'] = await requestCameraPermission();

    // Request storage permission if camera was granted
    if (results['camera'] == const PermissionResult.granted()) {
      results['storage'] = await requestStoragePermission();
    } else {
      results['storage'] = const PermissionResult.denied();
    }

    AppLogger.info('Permission request results: $results');
    return results;
  }

  /// Check if all necessary permissions are granted
  Future<bool> hasAllNecessaryPermissions() async {
    final cameraGranted = await hasCameraPermission();
    final storageGranted = await hasStoragePermission();

    final allGranted = cameraGranted && storageGranted;
    AppLogger.debug('All necessary permissions granted: $allGranted');

    return allGranted;
  }

  /// Get detailed permission status for debugging
  Future<Map<String, PermissionStatus>> getAllPermissionStatuses() async {
    try {
      final results = <String, PermissionStatus>{};

      results['camera'] = await Permission.camera.status;
      results['photos'] = await Permission.photos.status;
      results['storage'] = await Permission.storage.status;

      AppLogger.debug('All permission statuses: $results');
      return results;
    } catch (e) {
      AppLogger.error('Failed to get all permission statuses', error: e);
      return {};
    }
  }
}

/// Permission request result with detailed status information
@freezed
class PermissionResult with _$PermissionResult {
  /// Permission was granted by user
  const factory PermissionResult.granted() = _Granted;

  /// Permission was denied by user (can request again)
  const factory PermissionResult.denied() = _Denied;

  /// Permission was permanently denied (must use app settings)
  const factory PermissionResult.permanentlyDenied() = _PermanentlyDenied;

  /// Permission is restricted by system policy
  const factory PermissionResult.restricted() = _Restricted;

  /// Permission granted with limitations (iOS 14+)
  const factory PermissionResult.limited() = _Limited;

  /// Permission granted temporarily (iOS)
  const factory PermissionResult.provisional() = _Provisional;
}

/// Extension methods for PermissionResult
extension PermissionResultExtension on PermissionResult {
  /// Check if permission is granted (including limited/provisional)
  bool get isGranted => when(
    granted: () => true,
    limited: () => true,
    provisional: () => true,
    denied: () => false,
    permanentlyDenied: () => false,
    restricted: () => false,
  );

  /// Check if user can request permission again
  bool get canRequest => when(
    granted: () => false,
    limited: () => false,
    provisional: () => false,
    denied: () => true,
    permanentlyDenied: () => false,
    restricted: () => false,
  );

  /// Check if user needs to use app settings
  bool get requiresSettings => when(
    granted: () => false,
    limited: () => false,
    provisional: () => false,
    denied: () => false,
    permanentlyDenied: () => true,
    restricted: () => true,
  );

  /// Get user-friendly description of the permission status
  String get description => when(
    granted: () => 'Permission granted',
    limited: () => 'Limited permission granted',
    provisional: () => 'Provisional permission granted',
    denied: () => 'Permission denied',
    permanentlyDenied: () => 'Permission permanently denied',
    restricted: () => 'Permission restricted by system',
  );

  /// Get action message for user
  String get actionMessage => when(
    granted: () => 'You can now use this feature',
    limited: () => 'You can use this feature with limitations',
    provisional: () => 'You can use this feature temporarily',
    denied: () => 'Please allow permission to continue',
    permanentlyDenied: () => 'Please enable permission in device settings',
    restricted: () => 'This feature is not available due to restrictions',
  );
}
