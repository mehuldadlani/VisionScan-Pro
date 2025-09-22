/// Base exception class for all app-specific exceptions
abstract class AppException implements Exception {
  /// Constructor for AppException
  const AppException(this.message, [this.code]);

  /// Human-readable error message
  final String message;

  /// Optional error code for programmatic handling
  final String? code;

  @override
  String toString() => message;
}

/// Camera-related exceptions
class CameraException extends AppException {
  /// Constructor for CameraException
  const CameraException(
    super.message, [
    super.code,
    this.cameraId,
    this.details,
  ]);

  /// Camera ID where the error occurred
  final String? cameraId;

  /// Additional error details
  final Map<String, dynamic>? details;

  /// Common camera error codes
  ///
  /// @nodoc
  static const String permissionDenied = 'camera_permission_denied';

  /// @nodoc
  static const String notInitialized = 'camera_not_initialized';

  /// @nodoc
  static const String captureFailure = 'camera_capture_failure';

  /// @nodoc
  static const String notAvailable = 'camera_not_available';
}

/// OCR processing exceptions
class OCRException extends AppException {
  /// Constructor for OCRException
  const OCRException(super.message, [super.code]);

  /// Common OCR error codes
  /// @nodoc
  static const String processingFailed = 'ocr_processing_failed';

  /// @nodoc
  static const String imageCorrupted = 'ocr_image_corrupted';

  /// @nodoc
  static const String noTextFound = 'ocr_no_text_found';

  /// @nodoc
  static const String croppingFailed = 'ocr_cropping_failed';
}

/// Database operation exceptions
class DatabaseException extends AppException {
  /// Constructor for DatabaseException
  const DatabaseException(super.message, [super.code]);

  /// Common database error codes
  /// @nodoc
  static const String saveFailed = 'database_save_failed';

  /// @nodoc
  static const String loadFailed = 'database_load_failed';

  /// @nodoc
  static const String deleteFailed = 'database_delete_failed';

  /// @nodoc
  static const String migrationFailed = 'database_migration_failed';
}

/// Permission-related exceptions
class PermissionException extends AppException {
  /// Constructor for PermissionException
  const PermissionException(super.message, [super.code]);

  /// Common permission error codes
  /// @nodoc
  static const String cameraPermissionDenied = 'permission_camera_denied';

  /// @nodoc
  static const String storagePermissionDenied = 'permission_storage_denied';

  /// @nodoc
  static const String permanentlyDenied = 'permission_permanently_denied';
}

/// Error handler utility for user-friendly error messages
class ErrorHandler {
  /// Convert any error to a user-friendly message
  /// @nodoc
  static String getReadableMessage(dynamic error) {
    if (error is AppException) {
      return error.message;
    }

    // Handle platform-specific errors
    if (error.toString().contains('PlatformException')) {
      return _handlePlatformException(error);
    }

    // Handle common Flutter errors
    if (error.toString().contains('camera')) {
      return 'Camera error occurred. Please try again.';
    }

    if (error.toString().contains('permission')) {
      return 'Permission required. Please enable in settings.';
    }

    // Generic fallback
    return 'An unexpected error occurred. Please try again.';
  }

  /// Handle platform-specific exceptions
  static String _handlePlatformException(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('camera_access_denied')) {
      return 'Camera permission denied. Please enable camera access in device settings.';
    }

    if (errorString.contains('no_cameras_available')) {
      return 'No cameras available on this device.';
    }

    return 'System error occurred. Please try again.';
  }
}

/// Camera permission denied exception
class CameraPermissionDeniedException extends PermissionException {
  /// Constructor for CameraPermissionDeniedException
  const CameraPermissionDeniedException()
    : super(
        'Camera permission denied',
        PermissionException.cameraPermissionDenied,
      );
}

/// Storage permission denied exception
class StoragePermissionDeniedException extends PermissionException {
  /// Constructor for StoragePermissionDeniedException
  const StoragePermissionDeniedException()
    : super(
        'Storage permission denied',
        PermissionException.storagePermissionDenied,
      );
}

/// Camera initialization exception
class CameraInitializationException extends CameraException {
  /// Constructor for CameraInitializationException
  const CameraInitializationException({
    String? cameraId,
    Map<String, dynamic>? details,
  }) : super(
         'Camera initialization failed',
         'CAMERA_INIT_FAILED',
         cameraId,
         details,
       );
}

/// Camera capture exception
class CameraCaptureException extends CameraException {
  /// Constructor for CameraCaptureException
  const CameraCaptureException({
    String? cameraId,
    Map<String, dynamic>? details,
  }) : super(
         'Camera capture failed',
         'CAMERA_CAPTURE_FAILED',
         cameraId,
         details,
       );
}
