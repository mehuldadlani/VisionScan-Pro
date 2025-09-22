/// ObjectBox database constants for VisionScan Pro
///
/// Contains database-specific configuration values, entity constraints,
/// and query optimization parameters.
class ObjectBoxConstants {
  const ObjectBoxConstants._();

  // Database Configuration

  /// Database name
  static const String databaseName = 'visionscan_pro_db';

  /// Database directory
  static const String databaseDirectory = 'objectbox';

  /// Database version
  static const int databaseVersion = 1;

  /// Enable query logging
  static const bool enableQueryLogging = false;

  /// Enable debug mode
  static const bool enableDebugMode = false;

  // Entity IDs and Constraints

  /// Scan result entity ID
  static const int scanResultEntityId = 1;

  /// Maximum scan results
  static const int maxScanResults = 10000;

  /// Default query limit
  static const int defaultQueryLimit = 100;

  /// Batch size
  static const int batchSize = 50;

  // ScanResult Entity Constants

  /// Scan ID maximum length
  static const int scanIdMaxLength = 36; // UUID length

  /// Extracted numbers JSON maximum length
  static const int extractedNumbersJsonMaxLength = 5000;

  /// Image path maximum length
  static const int imagePathMaxLength = 500;

  /// Notes maximum length
  static const int notesMaxLength = 1000;

  // Query Configuration

  /// Timestamp index name
  static const String timestampIndexName = 'timestamp_index';

  /// Scan ID index name
  static const String scanIdIndexName = 'scan_id_index';

  /// Use timestamp index
  static const bool useTimestampIndex = true;

  /// Use scan ID index
  static const bool useScanIdIndex = true;

  // Backup and Maintenance

  /// Backup interval
  static const Duration backupInterval = Duration(days: 7);

  /// Cleanup interval
  static const Duration cleanupInterval = Duration(days: 30);

  /// Maximum backup files
  static const int maxBackupFiles = 5;

  /// Database maintenance threshold
  static const double dbMaintenanceThreshold = 0.8; // 80% full

  // Performance Settings

  /// Maximum concurrent transactions
  static const int maxConcurrentTransactions = 5;

  /// Transaction timeout
  static const Duration transactionTimeout = Duration(seconds: 10);

  /// Cache size
  static const int cacheSize = 100; // Number of entities to cache

  /// Enable lazy loading
  static const bool enableLazyLoading = true;

  // Error Handling

  /// Maximum retry attempts
  static const int maxRetryAttempts = 3;

  /// Retry delay
  static const Duration retryDelay = Duration(milliseconds: 500);

  /// Corruption error message
  static const String corruptionErrorMessage = 'Database corruption detected';

  /// Lock timeout error message
  static const String lockTimeoutErrorMessage = 'Database lock timeout';

  /// Disk full error message
  static const String diskFullErrorMessage = 'Insufficient storage space';

  // Validation Constants

  /// Minimum valid timestamp
  static const int minValidTimestamp = 1577836800; // 2020-01-01 00:00:00 UTC

  /// Maximum valid timestamp
  static const int maxValidTimestamp = 4102444800; // 2100-01-01 00:00:00 UTC

  /// Minimum valid number
  static const double minValidNumber = -999999999.99;

  /// Maximum valid number
  static const double maxValidNumber = 999999999.99;

  // JSON Field Keys for extractedNumbersJson

  /// JSON key for numbers
  static const String jsonKeyNumbers = 'numbers';

  /// JSON key for confidences
  static const String jsonKeyConfidences = 'confidences';

  /// JSON key for bounding boxes
  static const String jsonKeyBoundingBoxes = 'bounding_boxes';

  /// JSON key for processing time
  static const String jsonKeyProcessingTime = 'processing_time';

  /// JSON key for OCR engine
  static const String jsonKeyOcrEngine = 'ocr_engine';

  /// JSON key for image dimensions
  static const String jsonKeyImageDimensions = 'image_dimensions';

  // Statistics and Metrics

  /// Metrics table name
  static const String metricsTableName = 'scan_metrics';

  /// Metrics retention
  static const Duration metricsRetention = Duration(days: 90);

  /// Maximum metric entries
  static const int maxMetricEntries = 1000;

  // Migration Constants

  /// Migration log prefix
  static const String migrationLogPrefix = 'ObjectBoxMigration';

  /// Maximum migration time
  static const int maxMigrationTime = 30; // seconds

  /// Enable migration logging
  static const bool enableMigrationLogging = true;

  // Development and Testing

  /// Test database suffix
  static const String testDatabaseSuffix = '_test';

  /// Drop database on test start
  static const bool dropDatabaseOnTestStart = true;

  /// Test data set size
  static const int testDataSetSize = 100;

  /// Default values for ScanResult entity fields
  static const bool defaultIsProcessing = false;

  /// Default extracted numbers
  static const String defaultExtractedNumbers = '[]';

  /// Default notes
  static const String defaultNotes = '';

  /// Query sort orders
  static const String sortByTimestampDesc = 'timestamp_desc';

  /// Query sort orders
  static const String sortByTimestampAsc = 'timestamp_asc';

  /// Query sort orders
  static const String sortByScanIdAsc = 'scan_id_asc';

  /// Database file extensions
  static const String dataFileExtension = '.mdb';

  /// Lock file extension
  static const String lockFileExtension = '.lck';

  /// Backup file extension
  static const String backupFileExtension = '.bak';
}
