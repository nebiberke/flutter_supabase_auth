import 'package:logger/logger.dart';

final class LoggerUtils {
  // Factory constructor to return the singleton instance
  factory LoggerUtils() => _instance;

  // Private named constructor
  LoggerUtils._internal()
      : _logger = Logger(printer: PrettyPrinter(stackTraceBeginIndex: 2));
  // Lazy singleton instance
  static final LoggerUtils _instance = LoggerUtils._internal();

  final Logger _logger;

  void logInfo(String message) => _logger.i(message);
  void logWarning(String message) => _logger.w(message);
  void logError(String message) => _logger.e(message);
  void logFatalError(String message, StackTrace? stackTrace) =>
      _logger.f(message, stackTrace: stackTrace);
}
