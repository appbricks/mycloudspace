import 'package:test/test.dart';
import 'package:logging/logging.dart';

import 'package:utilities/logging/init_logging.dart';

void main() {
  test('logs to the console', () {
    String logMessage = '';
    initLogging(
      Level.ALL,
      logToConsole: true,
      consoleLogFn: (m) => logMessage = m.toString(),
    );

    final log = Logger('LoggerTest');

    log.log(Level.FINE, 'This is a fine message');
    expect(
      logMessage,
      matches(
        RegExp(
          r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{6} \[LoggerTest\] FINE: This is a fine message$',
        ),
      ),
    );

    log.log(
      Level.SEVERE,
      'This is an error message with a stack trace',
      Exception('test exception'),
      StackTrace.current,
    );
    expect(
      logMessage,
      matches(
        RegExp(
          r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{6} \[LoggerTest\] SEVERE: This is an error message with a stack trace =>\n====================\nException: test exception:\n#0\s+main',
        ),
      ),
    );
  });

  test('logs to log handler', () {
    DateTime? logTime;
    String logMessage = '';
    int levelNum = 0;
    String loggerName = '';
    Object? logError;
    Object? logStackTrace;
    initLogging(
      Level.ALL,
      logToConsole: false,
      logFn: (
        message, {
        time,
        sequenceNumber,
        level = 0,
        name = '',
        zone,
        error,
        stackTrace,
      }) {
        logTime = time;
        logMessage = message;
        levelNum = level;
        loggerName = name;
        logError = error;
        logStackTrace = stackTrace;
      },
    );

    final log = Logger('LoggerTest');

    log.log(
      Level.SEVERE,
      'This is an error message with a stack trace',
      Exception('test exception'),
      StackTrace.current,
    );
    expect(logTime, isNotNull);
    expect(logMessage, 'This is an error message with a stack trace');
    expect(levelNum, Level.SEVERE.value);
    expect(loggerName, 'LoggerTest');
    expect(logError, isA<Exception>());
    expect(logStackTrace, isA<StackTrace>());
  });
}
