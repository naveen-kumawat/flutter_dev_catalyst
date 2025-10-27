import 'package:logger/logger.dart';

/// Log levels
enum LogLevel { verbose, debug, info, warning, error, wtf, nothing }

/// Catalyst Logger for consistent logging across the plugin
class CatalystLogger {
  static final CatalystLogger _instance = CatalystLogger._internal();
  factory CatalystLogger() => _instance;

  CatalystLogger._internal() {
    _initializeLogger();
  }

  Logger? _loggerInstance;
  bool _isEnabled = true;
  LogLevel _logLevel = LogLevel.debug;

  Logger get _logger {
    _loggerInstance ??= _createLogger();
    return _loggerInstance!;
  }

  Logger _createLogger() {
    return Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        // dateTimeFormat is only available in logger ^2.0.0
        // Remove or use printTime for older versions
      ),
      level: _convertLogLevel(_logLevel),
    );
  }

  void _initializeLogger() {
    _loggerInstance = _createLogger();
  }

  void init({bool isEnabled = true, LogLevel logLevel = LogLevel.debug}) {
    _isEnabled = isEnabled;
    _logLevel = logLevel;
    _loggerInstance = _createLogger();
  }

  /// Convert LogLevel to Logger Level
  Level _convertLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.verbose:
        return Level.trace;
      case LogLevel.debug:
        return Level.debug;
      case LogLevel.info:
        return Level.info;
      case LogLevel.warning:
        return Level.warning;
      case LogLevel.error:
        return Level.error;
      case LogLevel.wtf:
        return Level.fatal;
      case LogLevel.nothing:
        return Level.off;
    }
  }

  /// Check if logger should log
  bool _shouldLog(LogLevel level) {
    if (!_isEnabled) return false;
    return level.index >= _logLevel.index;
  }

  /// Log verbose message
  void verbose(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_shouldLog(LogLevel.verbose)) {
      _logger.t(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log debug message
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_shouldLog(LogLevel.debug)) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log info message
  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_shouldLog(LogLevel.info)) {
      _logger.i(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log warning message
  void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_shouldLog(LogLevel.warning)) {
      _logger.w(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log error message
  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_shouldLog(LogLevel.error)) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log fatal message
  void wtf(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (_shouldLog(LogLevel.wtf)) {
      _logger.f(message, error: error, stackTrace: stackTrace);
    }
  }

  /// Log success message (custom)
  void success(dynamic message) {
    if (_shouldLog(LogLevel.info)) {
      _logger.i('✅ $message');
    }
  }

  /// Enable logging
  void enable() {
    _isEnabled = true;
  }

  /// Disable logging
  void disable() {
    _isEnabled = false;
  }

  /// Set log level
  void setLogLevel(LogLevel level) {
    _logLevel = level;
    _loggerInstance = _createLogger();
  }

  /// Close logger
  void close() {
    _loggerInstance?.close();
    _loggerInstance = null;
  }
}
