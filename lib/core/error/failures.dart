import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/failures.freezed.dart';

/// Failure hierarchy for VisionScan Pro using Freezed unions
///
/// Represents different types of failures that can occur in the application
/// following Clean Architecture principles for error handling in the domain layer.
@Freezed(toJson: false, fromJson: false)
class Failure with _$Failure {
  /// Constructor for CameraFailure
  const factory Failure.camera({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = CameraFailure;

  /// Constructor for CameraPermissionFailure
  const factory Failure.cameraPermission({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = CameraPermissionFailure;

  /// Constructor for CameraInitializationFailure
  const factory Failure.cameraInitialization({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = CameraInitializationFailure;

  /// Constructor for CameraCaptureFailure
  const factory Failure.cameraCapture({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = CameraCaptureFailure;

  /// Constructor for OCRFailure
  const factory Failure.ocr({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = OCRFailure;

  /// Constructor for OCRTimeoutFailure
  const factory Failure.ocrTimeout({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = OCRTimeoutFailure;

  /// Constructor for OCRInitializationFailure
  const factory Failure.ocrInitialization({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = OCRInitializationFailure;

  /// Constructor for NoNumbersFoundFailure
  const factory Failure.noNumbersFound({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = NoNumbersFoundFailure;

  /// Constructor for DatabaseFailure
  const factory Failure.database({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = DatabaseFailure;

  /// Constructor for DatabaseConnectionFailure
  const factory Failure.databaseConnection({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = DatabaseConnectionFailure;

  /// Constructor for DatabaseCorruptionFailure
  const factory Failure.databaseCorruption({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = DatabaseCorruptionFailure;

  /// Constructor for DatabaseQueryFailure
  const factory Failure.databaseQuery({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = DatabaseQueryFailure;

  /// Constructor for DatabaseTransactionFailure
  const factory Failure.databaseTransaction({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = DatabaseTransactionFailure;

  /// Constructor for FileSystemFailure
  const factory Failure.fileSystem({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = FileSystemFailure;

  /// Constructor for FileNotFoundFailure
  const factory Failure.fileNotFound({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = FileNotFoundFailure;

  /// Constructor for InsufficientStorageFailure
  const factory Failure.insufficientStorage({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = InsufficientStorageFailure;

  /// Constructor for FileAccessDeniedFailure
  const factory Failure.fileAccessDenied({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = FileAccessDeniedFailure;

  /// Constructor for PermissionFailure
  const factory Failure.permission({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = PermissionFailure;

  /// Constructor for StoragePermissionFailure
  const factory Failure.storagePermission({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = StoragePermissionFailure;

  /// Constructor for ImageProcessingFailure
  const factory Failure.imageProcessing({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = ImageProcessingFailure;

  /// Constructor for ImageTooLargeFailure
  const factory Failure.imageTooLarge({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = ImageTooLargeFailure;

  /// Constructor for ImageCompressionFailure
  const factory Failure.imageCompression({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = ImageCompressionFailure;

  /// Constructor for ImageCroppingFailure
  const factory Failure.imageCropping({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = ImageCroppingFailure;

  /// Constructor for ValidationFailure
  const factory Failure.validation({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = ValidationFailure;

  /// Constructor for NetworkFailure
  const factory Failure.network({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = NetworkFailure;

  /// Constructor for NoInternetConnectionFailure
  const factory Failure.noInternetConnection({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = NoInternetConnectionFailure;

  /// Constructor for InvalidImageFormatFailure
  const factory Failure.invalidImageFormat({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = InvalidImageFormatFailure;

  /// Constructor for UnknownFailure
  const factory Failure.unknown({
    required String message,
    String? code,
    Map<String, dynamic>? details,
  }) = UnknownFailure;
}

/// Extension methods for Failure to provide additional functionality
extension FailureExtension on Failure {
  /// Returns true if this is a critical failure that requires immediate attention
  bool get isCritical => when(
    camera: (_, __, ___) => false,
    cameraPermission: (_, __, ___) => false,
    cameraInitialization: (_, __, ___) => true,
    cameraCapture: (_, __, ___) => false,
    ocr: (_, __, ___) => false,
    ocrTimeout: (_, __, ___) => false,
    ocrInitialization: (_, __, ___) => true,
    noNumbersFound: (_, __, ___) => false,
    database: (_, __, ___) => true,
    databaseConnection: (_, __, ___) => true,
    databaseCorruption: (_, __, ___) => true,
    databaseQuery: (_, __, ___) => false,
    databaseTransaction: (_, __, ___) => false,
    fileSystem: (_, __, ___) => false,
    fileNotFound: (_, __, ___) => false,
    insufficientStorage: (_, __, ___) => true,
    fileAccessDenied: (_, __, ___) => false,
    permission: (_, __, ___) => false,
    storagePermission: (_, __, ___) => false,
    imageProcessing: (_, __, ___) => false,
    imageTooLarge: (_, __, ___) => false,
    imageCompression: (_, __, ___) => false,
    imageCropping: (_, __, ___) => false,
    validation: (_, __, ___) => false,
    network: (_, __, ___) => false,
    noInternetConnection: (_, __, ___) => false,
    invalidImageFormat: (_, __, ___) => false,
    unknown: (_, __, ___) => true,
  );

  /// Returns true if this failure is recoverable through user action
  bool get isRecoverable => when(
    camera: (_, __, ___) => true,
    cameraPermission: (_, __, ___) => true,
    cameraInitialization: (_, __, ___) => false,
    cameraCapture: (_, __, ___) => true,
    ocr: (_, __, ___) => true,
    ocrTimeout: (_, __, ___) => true,
    ocrInitialization: (_, __, ___) => false,
    noNumbersFound: (_, __, ___) => true,
    database: (_, __, ___) => false,
    databaseConnection: (_, __, ___) => false,
    databaseCorruption: (_, __, ___) => false,
    databaseQuery: (_, __, ___) => true,
    databaseTransaction: (_, __, ___) => true,
    fileSystem: (_, __, ___) => true,
    fileNotFound: (_, __, ___) => true,
    insufficientStorage: (_, __, ___) => true,
    fileAccessDenied: (_, __, ___) => true,
    permission: (_, __, ___) => true,
    storagePermission: (_, __, ___) => true,
    imageProcessing: (_, __, ___) => true,
    imageTooLarge: (_, __, ___) => true,
    imageCompression: (_, __, ___) => true,
    imageCropping: (_, __, ___) => true,
    validation: (_, __, ___) => true,
    network: (_, __, ___) => true,
    noInternetConnection: (_, __, ___) => true,
    invalidImageFormat: (_, __, ___) => true,
    unknown: (_, __, ___) => false,
  );

  /// Returns the failure category for grouping similar failures
  String get category => when(
    camera: (_, __, ___) => 'camera',
    cameraPermission: (_, __, ___) => 'camera',
    cameraInitialization: (_, __, ___) => 'camera',
    cameraCapture: (_, __, ___) => 'camera',
    ocr: (_, __, ___) => 'ocr',
    ocrTimeout: (_, __, ___) => 'ocr',
    ocrInitialization: (_, __, ___) => 'ocr',
    noNumbersFound: (_, __, ___) => 'ocr',
    database: (_, __, ___) => 'database',
    databaseConnection: (_, __, ___) => 'database',
    databaseCorruption: (_, __, ___) => 'database',
    databaseQuery: (_, __, ___) => 'database',
    databaseTransaction: (_, __, ___) => 'database',
    fileSystem: (_, __, ___) => 'filesystem',
    fileNotFound: (_, __, ___) => 'filesystem',
    insufficientStorage: (_, __, ___) => 'filesystem',
    fileAccessDenied: (_, __, ___) => 'filesystem',
    permission: (_, __, ___) => 'permission',
    storagePermission: (_, __, ___) => 'permission',
    imageProcessing: (_, __, ___) => 'image',
    imageTooLarge: (_, __, ___) => 'image',
    imageCompression: (_, __, ___) => 'image',
    imageCropping: (_, __, ___) => 'image',
    validation: (_, __, ___) => 'validation',
    network: (_, __, ___) => 'network',
    noInternetConnection: (_, __, ___) => 'network',
    invalidImageFormat: (_, __, ___) => 'image',
    unknown: (_, __, ___) => 'unknown',
  );

  /// Gets the error code if available
  String? get code => when(
    camera: (_, code, __) => code,
    cameraPermission: (_, code, __) => code,
    cameraInitialization: (_, code, __) => code,
    cameraCapture: (_, code, __) => code,
    ocr: (_, code, __) => code,
    ocrTimeout: (_, code, __) => code,
    ocrInitialization: (_, code, __) => code,
    noNumbersFound: (_, code, __) => code,
    database: (_, code, __) => code,
    databaseConnection: (_, code, __) => code,
    databaseCorruption: (_, code, __) => code,
    databaseQuery: (_, code, __) => code,
    databaseTransaction: (_, code, __) => code,
    fileSystem: (_, code, __) => code,
    fileNotFound: (_, code, __) => code,
    insufficientStorage: (_, code, __) => code,
    fileAccessDenied: (_, code, __) => code,
    permission: (_, code, __) => code,
    storagePermission: (_, code, __) => code,
    imageProcessing: (_, code, __) => code,
    imageTooLarge: (_, code, __) => code,
    imageCompression: (_, code, __) => code,
    imageCropping: (_, code, __) => code,
    validation: (_, code, __) => code,
    network: (_, code, __) => code,
    noInternetConnection: (_, code, __) => code,
    invalidImageFormat: (_, code, __) => code,
    unknown: (_, code, __) => code,
  );

  /// Returns a user-friendly error message
  String get userMessage => when(
    camera: (message, _, __) => 'Camera error: $message',
    cameraPermission: (message, _, __) => 'Camera permission required',
    cameraInitialization: (message, _, __) => 'Failed to initialize camera',
    cameraCapture: (message, _, __) => 'Failed to capture image',
    ocr: (message, _, __) => 'Failed to process image',
    ocrTimeout: (message, _, __) => 'Image processing timed out',
    ocrInitialization: (message, _, __) => 'Failed to initialize scanner',
    noNumbersFound: (message, _, __) => 'No numbers detected in image',
    database: (message, _, __) => 'Database error occurred',
    databaseConnection: (message, _, __) => 'Database connection failed',
    databaseCorruption: (message, _, __) => 'Database corruption detected',
    databaseQuery: (message, _, __) => 'Failed to retrieve data',
    databaseTransaction: (message, _, __) => 'Failed to save data',
    fileSystem: (message, _, __) => 'File system error',
    fileNotFound: (message, _, __) => 'File not found',
    insufficientStorage: (message, _, __) => 'Insufficient storage space',
    fileAccessDenied: (message, _, __) => 'File access denied',
    permission: (message, _, __) => 'Permission denied',
    storagePermission: (message, _, __) => 'Storage permission required',
    imageProcessing: (message, _, __) => 'Image processing failed',
    imageTooLarge: (message, _, __) => 'Image is too large',
    imageCompression: (message, _, __) => 'Image compression failed',
    imageCropping: (message, _, __) => 'Image cropping failed',
    validation: (message, _, __) => 'Invalid input: $message',
    network: (message, _, __) => 'Network error: $message',
    noInternetConnection: (message, _, __) => 'No internet connection',
    invalidImageFormat: (message, _, __) => 'Invalid image format',
    unknown: (message, _, __) => 'An unexpected error occurred',
  );
}
