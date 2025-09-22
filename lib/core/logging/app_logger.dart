import 'package:logger/logger.dart';

/// Centralized logging utility for VisionScan Pro
///
/// Provides a consistent logging interface throughout the application
/// with configurable levels, formatting, and output options.
class AppLogger {
  static late Logger _logger;
  static bool _initialized = false;

  /// Initializes the logger with custom configuration
  static void init({
    Level logLevel = Level.debug,
    bool useColors = true,
    bool printEmojis = true,
    DateTimeFormatter dateTimeFormatter = DateTimeFormat.onlyTimeAndSinceStart,
  }) {
    if (_initialized) {
      return;
    }

    _logger = Logger(
      level: logLevel,
      printer: PrettyPrinter(
        methodCount: 0,
        colors: useColors,
        printEmojis: printEmojis,
        dateTimeFormat: dateTimeFormatter,
      ),
      output: ConsoleOutput(),
    );

    _initialized = true;
  }

  /// Gets the logger instance
  Logger get logger => _logger;

  /// Logs a message with the specified level
  static void log(
    Level level,
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) {
    if (!_initialized) {
      init();
    }

    var fullMessage = message.toString();

    if (error != null) {
      fullMessage += '\nError: $error';
      if (stackTrace != null) {
        fullMessage += '\nStack trace:\n${_formatStackTrace(stackTrace)}';
      }
    } else if (stackTrace != null &&
        (level == Level.error || level == Level.fatal)) {
      fullMessage += '\nStack trace:\n${_formatStackTrace(stackTrace)}';
    }

    _logger.log(level, fullMessage);
  }

  /// Formats stack trace for better readability
  static String _formatStackTrace(StackTrace stackTrace) =>
      stackTrace.toString().split('\n').take(8).join('\n');

  /// Logs a trace level message
  static void trace(dynamic message, {dynamic error, StackTrace? stackTrace}) =>
      log(Level.trace, message, error: error, stackTrace: stackTrace);

  /// Logs a debug level message
  static void debug(dynamic message, {dynamic error, StackTrace? stackTrace}) =>
      log(Level.debug, message, error: error, stackTrace: stackTrace);

  /// Logs an info level message
  static void info(dynamic message, {dynamic error, StackTrace? stackTrace}) =>
      log(Level.info, message, error: error, stackTrace: stackTrace);

  /// Logs a warning level message
  static void warning(
    dynamic message, {
    dynamic error,
    StackTrace? stackTrace,
  }) =>
      log(Level.warning, message, error: error, stackTrace: stackTrace);

  /// Logs an error level message
  static void error(dynamic message, {dynamic error, StackTrace? stackTrace}) =>
      log(Level.error, message, error: error, stackTrace: stackTrace);

  /// Logs a fatal level message
  static void fatal(dynamic message, {dynamic error, StackTrace? stackTrace}) =>
      log(Level.fatal, message, error: error, stackTrace: stackTrace);
}
