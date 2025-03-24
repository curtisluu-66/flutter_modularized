import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'dart:developer' as dev;

class AlwaysShowLogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}

abstract class AppLogger {
  static final Logger _logger = Logger(
    printer: _CustomPrinter(
      colors: true,
    ),
    filter: AlwaysShowLogFilter(),
    output: _CustomOutput(),
  );

  static final Logger _customSimpleLogger = Logger(
    printer: _CustomPrinter(
      colors: true,
      printEmojis: false,
      methodCount: 0,
      errorMethodCount: 0,
    ),
    filter: AlwaysShowLogFilter(),
    output: _CustomOutput(),
  );

  /// Log a message at level [Level.trace].
  static void t(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.trace] with simple pretty.
  static void simpleT(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _customSimpleLogger.t(message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.debug].
  static void d(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.debug] with simple pretty.
  static void simpleD(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _customSimpleLogger.d(message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.info].
  static void i(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.info] with simple pretty.
  static void simpleI(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _customSimpleLogger.i(message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.warning].
  static void w(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.warning] with simple pretty.
  static void simpleW(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _customSimpleLogger.w(message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.error].
  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log a message at level [Level.error] with simple pretty.
  static void simpleE(
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _customSimpleLogger.e(message, error: error, stackTrace: stackTrace);
  }

  /// Log a message with print core.
  static void prt(Object? object) {
    if (kDebugMode) {
      print(object);
    }
  }

  /// Log a message with print core with full message.
  static void prtFull(Object? object) {
    if (kDebugMode) {
      _printWrapped(object);
    }
  }

  /// Log a message with log core.
  static void log(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      dev.log(message, error: error, stackTrace: stackTrace);
    }
  }
}

class _CustomPrinter extends PrettyPrinter {
  _CustomPrinter({
    int super.methodCount = 4,
    int super.errorMethodCount = 20,
    super.colors,
    super.printEmojis,
  });

  @override
  List<String> log(LogEvent event) {
    final tag = DateFormat("HH:mm:ss.S").format(DateTime.now());

    return super.log(
      LogEvent(
        event.level,
        "[$tag] ${event.message}",
        error: event.error,
        stackTrace: event.stackTrace,
      ),
    );
  }
}

class _CustomOutput extends ConsoleOutput {
  @override
  void output(OutputEvent event) {
    if (!kDebugMode) return;

    for (final message in event.lines) {
      _printWrapped(message);
    }
  }
}

void _printWrapped(
  Object? object, {
  String? startColor,
  String? endColor,
}) {
  if (object != null && object is String) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(object).forEach(
          // ignore: avoid_print
          (match) => print(
            "${startColor ?? ""}${match.group(0)}${endColor ?? ""}",
          ),
        );
  } else {
    // ignore: avoid_print
    print(object);
  }
}
