/// Application-wide constants for VisionScan Pro
///
/// Contains configuration values, constraints, and static strings
/// used throughout the application.
class AppConstants {
  const AppConstants._();

  // Application Info

  /// Application name
  static const String appName = 'VisionScan Pro';

  /// Application version
  static const String appVersion = '1.0.0';

  /// Application description
  static const String appDescription =
      'Professional camera-based OCR application for numeric data extraction';

  // Database Configuration

  /// Database name
  static const String dbName = 'visionscan_pro.db';

  /// Database version
  static const int dbVersion = 1;

  /// Database directory name
  static const String dbDirectoryName = 'objectbox';

  // Image Processing Constants

  /// Maximum image width
  static const int maxImageWidth = 2048;

  /// Minimum valid number
  static const double minValidNumber = 0;

  /// Maximum valid number
  static const double maxValidNumber = 999999999.99;

  /// Maximum image height
  static const int maxImageHeight = 2048;

  /// Image compression quality
  static const double imageCompressionQuality = 0.8;

  /// Maximum image size in bytes
  static const int maxImageSizeBytes = 5 * 1024 * 1024; // 5MB

  // Camera Configuration

  /// Camera aspect ratio
  static const double cameraAspectRatio = 16 / 9;

  /// Overlay aspect ratio
  static const double overlayAspectRatio = 4 / 3;

  /// Overlay width ratio
  static const double overlayWidthRatio = 0.8;

  /// Overlay height ratio
  static const double overlayHeightRatio = 0.6;

  /// Camera resolution width
  static const int cameraResolutionWidth = 1920;

  /// Camera resolution height
  static const int cameraResolutionHeight = 1080;

  // OCR Configuration (Google ML Kit)

  /// OCR processing timeout in seconds
  static const int ocrTimeoutSeconds = 30;

  /// OCR confidence threshold (0.0 to 1.0)
  static const double ocrConfidenceThreshold = 0.6;

  /// Maximum number length for validation
  static const int maxNumberLength = 20;

  // UI Constants

  /// Default padding
  static const double defaultPadding = 16;

  /// Small padding
  static const double smallPadding = 8;

  /// Large padding
  static const double largePadding = 24;

  /// Card border radius
  static const double cardBorderRadius = 16;

  /// Button border radius
  static const double buttonBorderRadius = 12;

  /// Bottom sheet border radius
  static const double bottomSheetBorderRadius = 20;

  // Animation Durations

  /// Short animation duration
  static const Duration shortAnimation = Duration(milliseconds: 200);

  /// Medium animation duration
  static const Duration mediumAnimation = Duration(milliseconds: 300);

  /// Long animation duration
  static const Duration longAnimation = Duration(milliseconds: 500);

  /// Splash duration
  static const Duration splashDuration = Duration(seconds: 2);

  // Glass Effect Configuration

  /// Glass blur radius
  static const double glassBlurRadius = 10;

  /// Glass opacity
  static const double glassOpacity = 0.1;

  /// Glass border opacity
  static const double glassBorderOpacity = 0.2;

  // Shimmer Configuration

  /// Shimmer period
  static const Duration shimmerPeriod = Duration(seconds: 2);

  /// Shimmer base color
  static const double shimmerBaseColor = 0.85;

  /// Shimmer highlight color
  static const double shimmerHighlightColor = 0.95;

  // Pagination and List Configuration

  /// Default page size
  static const int defaultPageSize = 20;

  /// Maximum history items
  static const int maxHistoryItems = 1000;

  /// History cleanup threshold
  static const int historyCleanupThreshold = 1200;

  // File Paths and Naming

  /// Captured images directory
  static const String capturedImagesDirectory = 'captured_images';

  /// Thumbnails directory
  static const String thumbnailsDirectory = 'thumbnails';

  /// Temp directory
  static const String tempDirectory = 'temp';

  /// Image file extension
  static const String imageFileExtension = '.jpg';

  /// Thumbnail suffix
  static const String thumbnailSuffix = '_thumb';

  // Validation Constants

  /// Minimum scan ID
  static const int minScanId = 6;


  /// Maximum image path length
  static const int maxImagePathLength = 500;

  /// Maximum history display length
  static const int maxHistoryDisplayLength = 50;

  // Haptic Feedback

  /// Haptic delay
  static const Duration hapticDelay = Duration(milliseconds: 50);

  // Error Messages

  /// Default error message
  static const String defaultErrorMessage = 'An unexpected error occurred';

  /// Network error message
  static const String networkErrorMessage = 'Network connection error';

  /// Camera error message
  static const String cameraErrorMessage = 'Camera access error';

  /// OCR error message
  static const String ocrErrorMessage = 'Text recognition failed';

  /// Permission error message
  static const String permissionErrorMessage =
      'Required permissions not granted';

  /// Storage error message
  static const String storageErrorMessage = 'Storage access error';

  // Success Messages

  /// Scan success message
  static const String scanSuccessMessage = 'Scan completed successfully';

  /// Save success message
  static const String saveSuccessMessage = 'Data saved successfully';

  /// Delete success message
  static const String deleteSuccessMessage = 'Item deleted successfully';

  // Loading Messages

  /// Loading message
  static const String loadingMessage = 'Loading...';

  /// Processing message
  static const String processingMessage = 'Processing image...';

  /// Saving message
  static const String savingMessage = 'Saving data...';

  /// Deleting message
  static const String deletingMessage = 'Deleting...';

  // Empty State Messages

  /// No history message
  static const String noHistoryMessage = 'No scan history available';

  /// No results message
  static const String noResultsMessage = 'No results found';

  /// No numbers found message
  static const String noNumbersFoundMessage = 'No numbers detected in image';

  // Permission Messages

  /// Camera permission title
  static const String cameraPermissionTitle = 'Camera Permission Required';

  /// Camera permission message
  static const String cameraPermissionMessage =
      'VisionScan Pro needs camera access to scan documents and images.';

  /// Storage permission title
  static const String storagePermissionTitle = 'Storage Permission Required';

  /// Storage permission message
  static const String storagePermissionMessage =
      'VisionScan Pro needs storage access to save captured images.';

  // App Store / Play Store Links (for settings)

  /// App store URL
  static const String appStoreUrl = 'https://apps.apple.com/app/visionscan-pro';

  /// Play store URL
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.visionscan.pro';

  // Support and Legal

  /// Support email
  static const String supportEmail = 'support@visionscanpro.com';

  /// Privacy policy URL
  static const String privacyPolicyUrl = 'https://visionscan.pro/privacy';

  /// Terms of service URL
  static const String termsOfServiceUrl = 'https://visionscan.pro/terms';

  // Feature Flags

  /// Enable analytics
  static const bool enableAnalytics = false;

  /// Enable crash reporting
  static const bool enableCrashReporting = false;

  /// Enable image enhancement for better OCR
  static const bool enableImageEnhancement = true;

  /// Enable image filters
  static const bool enableImageFilters = true;

  /// Enable batch scanning
  static const bool enableBatchScanning = false; // Future feature

  // Development Constants

  /// Show debug info
  static const bool showDebugInfo = false;

  /// Enable performance profiling
  static const bool enablePerformanceProfiling = false;

  /// Show frame metrics
  static const bool showFrameMetrics = false;
}
