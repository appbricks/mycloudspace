import 'package:test/test.dart';
import 'package:logging/logging.dart';

import 'package:utilities/logging/init_logging.dart';
import 'package:utilities/error/app_exception.dart';

void main() {
  test('creates a logged nested exception', () {
    String logMessage = '';
    initLogging(
      Level.ALL,
      logToConsole: true,
      consoleLogFn: (m) => logMessage = m.toString(),
    );

    final e1 = AppException(
      message: 'Test exception 1',
      stackTrace: StackTrace.current,
      innerException: Exception('Generic Exception'),
      innerStackTrace: StackTrace.current,
      log: true,
    );
    final e2 = AppException1(
      message: 'Test exception 2',
      innerException: e1,
      log: false,
    );
    final e3 = AppException2(
      message: 'Test exception 3',
      innerException: e2,
      log: false,
    );

    expect(
      logMessage,
      matches(
        RegExp(
          r'^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\.\d{6} \[AppException\] FINE: AppException created =>',
        ),
      ),
    );

    final e3Dump = e3.toString();
    expect(e3Dump, contains('AppException2: Test exception 3'));
    expect(
      e3Dump,
      contains(
        'at main.<anonymous closure> (file:///Users/mevan/Work/appbricks/cloud/mycloudspace/libs/commons/dart/utilities/test/error/app_exception_test.dart:30:16)',
      ),
    );
    expect(e3Dump, contains('Caused by: AppException1: Test exception 2'));
    expect(
      e3Dump,
      contains(
        'at main.<anonymous closure> (file:///Users/mevan/Work/appbricks/cloud/mycloudspace/libs/commons/dart/utilities/test/error/app_exception_test.dart:25:16)',
      ),
    );
    expect(e3Dump, contains('Caused by: AppException: Test exception 1'));
    expect(
      e3Dump,
      contains(
        'at main.<anonymous closure> (file:///Users/mevan/Work/appbricks/cloud/mycloudspace/libs/commons/dart/utilities/test/error/app_exception_test.dart:20:30)',
      ),
    );
    expect(e3Dump, contains('Caused by: Exception: Generic Exception'));
    expect(
      e3Dump,
      contains(
        'at main.<anonymous closure> (file:///Users/mevan/Work/appbricks/cloud/mycloudspace/libs/commons/dart/utilities/test/error/app_exception_test.dart:22:35)',
      ),
    );
  });
}

class AppException1 extends AppException {
  AppException1({
    required String message,
    Exception? innerException,
    StackTrace? innerStackTrace,
    bool log = false,
  }) : super(
          message: message,
          stackTrace: StackTrace.current,
          innerException: innerException,
          innerStackTrace: innerStackTrace,
          log: log,
        );
}

class AppException2 extends AppException {
  AppException2({
    required String message,
    Exception? innerException,
    StackTrace? innerStackTrace,
    bool log = false,
  }) : super(
          message: message,
          stackTrace: StackTrace.current,
          innerException: innerException,
          innerStackTrace: innerStackTrace,
          log: log,
        );
}
