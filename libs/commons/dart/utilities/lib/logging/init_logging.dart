import 'dart:developer' as developer;
import 'dart:async';
import 'package:logging/logging.dart' as logging;

void initLogging(
  logging.Level logLevel, {
  logToConsole = false,
  LogFnType logFn = developer.log,
  ConsoleLogFnType consoleLogFn = print,
}) {
  logging.Logger.root.level = logLevel;

  if (logToConsole) {
    logging.Logger.root.onRecord.listen(
      (record) {
        if (record.error != null || record.stackTrace != null) {
          consoleLogFn(
            '${record.time} '
            '[${record.loggerName}] '
            '${record.level.name}: '
            '${record.message} =>'
            '\n===================='
            '\n${record.error}:'
            '\n${record.stackTrace}\n',
          );
        } else {
          consoleLogFn(
            '${record.time} '
            '[${record.loggerName}] '
            '${record.level.name}: '
            '${record.message}',
          );
        }
      },
    );
  } else {
    logging.Logger.root.onRecord.listen(
      (record) {
        logFn(
          record.message,
          time: record.time,
          sequenceNumber: record.sequenceNumber,
          level: record.level.value,
          name: record.loggerName,
          zone: record.zone,
          error: record.error,
          stackTrace: record.stackTrace,
        );
      },
    );
  }
}

typedef LogFnType = void Function(
  String message, {
  DateTime? time,
  int? sequenceNumber,
  int level,
  String name,
  Zone? zone,
  Object? error,
  StackTrace? stackTrace,
});

typedef ConsoleLogFnType = void Function(
  Object? object,
);
