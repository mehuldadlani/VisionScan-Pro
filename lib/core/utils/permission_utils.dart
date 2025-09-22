import 'package:permission_handler/permission_handler.dart';

import 'package:visionscan_pro/core/constants/app_constants.dart';
import 'package:visionscan_pro/core/error/exceptions.dart';

/// Utility class for handling application permissions
///
/// Provides static methods for requesting, checking, and managing
/// permissions required by VisionScan Pro.
class PermissionUtils {
  const PermissionUtils._();

  /// Requests camera permission from the user
  static Future<bool> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      return status.isGranted;
    } catch (e) {
      throw const CameraPermissionDeniedException();
    }
  }

  /// Checks if camera permission is granted
  static Future<bool> hasCameraPermission() async {
    try {
      final status = await Permission.camera.status;
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  /// Requests storage permission from the user
  static Future<bool> requestStoragePermission() async {
    try {
      final status = await Permission.storage.request();
      return status.isGranted;
    } catch (e) {
      throw const StoragePermissionDeniedException();
    }
  }

  /// Checks if storage permission is granted
  static Future<bool> hasStoragePermission() async {
    try {
      final status = await Permission.storage.status;
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  /// Requests photos permission (iOS specific)
  static Future<bool> requestPhotosPermission() async {
    try {
      final status = await Permission.photos.request();
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  /// Checks if photos permission is granted (iOS specific)
  static Future<bool> hasPhotosPermission() async {
    try {
      final status = await Permission.photos.status;
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  /// Requests all required permissions for the app
  static Future<PermissionStatus> requestAllRequiredPermissions() async {
    try {
      // Request camera permission
      final cameraGranted = await requestCameraPermission();
      if (!cameraGranted) {
        return PermissionStatus.denied;
      }

      // Request storage permission
      final storageGranted = await requestStoragePermission();
      if (!storageGranted) {
        return PermissionStatus.denied;
      }

      // Request photos permission (iOS)
      final photosGranted = await requestPhotosPermission();
      if (!photosGranted) {
        return PermissionStatus.denied;
      }

      return PermissionStatus.granted;
    } catch (e) {
      return PermissionStatus.denied;
    }
  }

  /// Checks if all required permissions are granted
  static Future<bool> hasAllRequiredPermissions() async {
    try {
      final cameraGranted = await hasCameraPermission();
      final storageGranted = await hasStoragePermission();
      final photosGranted = await hasPhotosPermission();

      return cameraGranted && storageGranted && photosGranted;
    } catch (e) {
      return false;
    }
  }

  /// Gets the status of a specific permission
  static Future<PermissionStatus> getPermissionStatus(
    Permission permission,
  ) async {
    try {
      return await permission.status;
    } catch (e) {
      return PermissionStatus.denied;
    }
  }

  /// Opens the app settings for the user to manually grant permissions
  static Future<bool> openAppSettings() async {
    try {
      return await openAppSettings();
    } catch (e) {
      return false;
    }
  }

  /// Checks if a permission is permanently denied
  static Future<bool> isPermissionPermanentlyDenied(
    Permission permission,
  ) async {
    try {
      final status = await permission.status;
      return status.isPermanentlyDenied;
    } catch (e) {
      return false;
    }
  }

  /// Gets the camera permission status with detailed information
  static Future<PermissionResult> getCameraPermissionResult() async {
    try {
      final status = await Permission.camera.status;

      return PermissionResult(
        permission: Permission.camera,
        status: status,
        isGranted: status.isGranted,
        isDenied: status.isDenied,
        isPermanentlyDenied: status.isPermanentlyDenied,
        isRestricted: status.isRestricted,
        canRequest: !status.isPermanentlyDenied && status.isDenied,
      );
    } catch (e) {
      return const PermissionResult(
        permission: Permission.camera,
        status: PermissionStatus.denied,
        isGranted: false,
        isDenied: true,
        isPermanentlyDenied: false,
        isRestricted: false,
        canRequest: true,
      );
    }
  }

  /// Gets the storage permission status with detailed information
  static Future<PermissionResult> getStoragePermissionResult() async {
    try {
      final status = await Permission.storage.status;

      return PermissionResult(
        permission: Permission.storage,
        status: status,
        isGranted: status.isGranted,
        isDenied: status.isDenied,
        isPermanentlyDenied: status.isPermanentlyDenied,
        isRestricted: status.isRestricted,
        canRequest: !status.isPermanentlyDenied && status.isDenied,
      );
    } catch (e) {
      return const PermissionResult(
        permission: Permission.storage,
        status: PermissionStatus.denied,
        isGranted: false,
        isDenied: true,
        isPermanentlyDenied: false,
        isRestricted: false,
        canRequest: true,
      );
    }
  }

  /// Gets user-friendly permission description
  static String getPermissionDescription(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return AppConstants.cameraPermissionMessage;
      case Permission.storage:
        return AppConstants.storagePermissionMessage;
      case Permission.photos:
        return 'VisionScan Pro needs photos access to save scanned images to your gallery.';
      default:
        return 'This permission is required for the app to function properly.';
    }
  }

  /// Gets user-friendly permission title
  static String getPermissionTitle(Permission permission) {
    switch (permission) {
      case Permission.camera:
        return AppConstants.cameraPermissionTitle;
      case Permission.storage:
        return AppConstants.storagePermissionTitle;
      case Permission.photos:
        return 'Photos Access Required';
      default:
        return 'Permission Required';
    }
  }

  /// Handles permission request flow with proper error handling
  static Future<PermissionFlowResult> handlePermissionFlow(
    Permission permission,
  ) async {
    try {
      // Check current status
      final currentStatus = await permission.status;

      // If already granted, return success
      if (currentStatus.isGranted) {
        return PermissionFlowResult.granted();
      }

      // If permanently denied, suggest opening settings
      if (currentStatus.isPermanentlyDenied) {
        return PermissionFlowResult.permanentlyDenied(
          title: getPermissionTitle(permission),
          message: getPermissionDescription(permission),
        );
      }

      // Request permission
      final requestedStatus = await permission.request();

      if (requestedStatus.isGranted) {
        return PermissionFlowResult.granted();
      } else if (requestedStatus.isPermanentlyDenied) {
        return PermissionFlowResult.permanentlyDenied(
          title: getPermissionTitle(permission),
          message: getPermissionDescription(permission),
        );
      } else {
        return PermissionFlowResult.denied(
          title: getPermissionTitle(permission),
          message: getPermissionDescription(permission),
        );
      }
    } catch (e) {
      return PermissionFlowResult.error(
        title: 'Permission Error',
        message: 'Failed to handle permission request: $e',
      );
    }
  }
}

/// Detailed permission result with additional information
class PermissionResult {
  /// Constructor for PermissionResult
  const PermissionResult({
    required this.permission,
    required this.status,
    required this.isGranted,
    required this.isDenied,
    required this.isPermanentlyDenied,
    required this.isRestricted,
    required this.canRequest,
  });

  /// The permission
  final Permission permission;
  /// The status
  final PermissionStatus status;
  /// Whether the permission is granted
  final bool isGranted;
  /// Whether the permission is denied
  final bool isDenied;
  /// Whether the permission is permanently denied
  final bool isPermanentlyDenied;
  /// Whether the permission is restricted
  final bool isRestricted;
  /// Whether the permission can be requested
  final bool canRequest;

  @override
  String toString() =>
      'PermissionResult(permission: $permission, status: $status)';
}

/// Result of permission flow handling
class PermissionFlowResult {
  /// Constructor for PermissionFlowResult
  factory PermissionFlowResult.granted() =>
      const PermissionFlowResult._(type: PermissionFlowType.granted);

  /// Constructor for PermissionFlowResult
  factory PermissionFlowResult.denied({
    required String title,
    required String message,
  }) => PermissionFlowResult._(
    type: PermissionFlowType.denied,
    title: title,
    message: message,
  );

  /// Constructor for PermissionFlowResult
  factory PermissionFlowResult.permanentlyDenied({
    required String title,
    required String message,
  }) => PermissionFlowResult._(
    type: PermissionFlowType.permanentlyDenied,
    title: title,
    message: message,
  );

  /// Constructor for PermissionFlowResult
  factory PermissionFlowResult.error({
    required String title,
    required String message,
  }) => PermissionFlowResult._(
    type: PermissionFlowType.error,
    title: title,
    message: message,
  );
  const PermissionFlowResult._({required this.type, this.title, this.message});

  /// The type of permission flow result
  final PermissionFlowType type;
  /// The title of the permission flow result
  final String? title;
  /// The message of the permission flow result
  final String? message;

  /// Whether the permission flow result is granted
  bool get isGranted => type == PermissionFlowType.granted;
  /// Whether the permission flow result is denied
  bool get isDenied => type == PermissionFlowType.denied;
  /// Whether the permission flow result is permanently denied
  bool get isPermanentlyDenied => type == PermissionFlowType.permanentlyDenied;
  /// Whether the permission flow result is an error
  bool get isError => type == PermissionFlowType.error;
  /// Whether the permission flow result requires user action
  bool get requiresUserAction => isDenied || isPermanentlyDenied || isError;
}

/// Types of permission flow results
enum PermissionFlowType {
  /// The permission flow result is granted
  granted,
  /// The permission flow result is denied
  denied,
  /// The permission flow result is permanently denied
  permanentlyDenied,
  /// The permission flow result is an error
  error }
