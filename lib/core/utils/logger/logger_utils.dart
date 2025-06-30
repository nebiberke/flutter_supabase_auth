import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// A utility class for logging messages with different severity levels.
///
/// In release & profile builds (`!kDebugMode`) the methods become no-ops,
/// so you won’t pay the performance cost or leak sensitive details.
final class LoggerUtils {
  // Factory constructor returns the singleton instance.
  factory LoggerUtils() => _instance;

  /// Private named constructor.
  /// stackTraceBeginIndex is 2 because the first two frames are from the logger itself.
  LoggerUtils._internal()
    : _logger = Logger(
        printer: PrettyPrinter(stackTraceBeginIndex: 2),
      );

  static final LoggerUtils _instance = LoggerUtils._internal();

  final Logger _logger;

  /// Log an informational message (debug builds only).
  void logInfo(String message) {
    if (!kDebugMode) return;
    _logger.i(message);
  }

  /// Log a warning message.
  void logWarning(String message) {
    if (!kDebugMode) return;
    _logger.w(message);
  }

  /// Log an error message.
  void logError(String message) {
    if (!kDebugMode) return;
    _logger.e(message);
  }

  /// Log a fatal error with an optional stack trace.
  void logFatalError(String message, [StackTrace? stackTrace]) {
    if (!kDebugMode) return;
    _logger.f(message, stackTrace: stackTrace);
  }
}
