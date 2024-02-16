// ignore_for_file: prefer_initializing_formals

import 'dart:convert';

import 'package:logging/logging.dart' as logging;

class AppException implements Exception {
  final dynamic message;
  StackTrace? stackTrace;

  Exception? innerException;
  StackTrace? innerStackTrace;

  AppException({
    required this.message,
    required StackTrace stackTrace,
    Exception? innerException,
    StackTrace? innerStackTrace,
    log = true,
  }) {
    if (log) {
      _logger.fine(
        '${runtimeType.toString()} created',
        this,
        stackTrace,
      );
    }
    this.stackTrace = stackTrace;
    this.innerException = innerException;
    this.innerStackTrace = innerStackTrace;
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    final exceptionType = runtimeType.toString();

    buffer.write(exceptionType);
    if (message != null) {
      buffer.write(": $message");
    }
    if (stackTrace != null) {
      buffer.writeln();
      _printStackTrace(buffer, exceptionType, stackTrace!);
    }

    if (innerException != null) {
      if (innerException is AppException) {
        buffer.writeln("Caused by: $innerException");
      } else {
        buffer.write("Caused by: $innerException\n");
        if (innerStackTrace != null) {
          _printStackTrace(buffer, exceptionType, innerStackTrace!);
        }
      }
    }

    return buffer.toString();
  }
}

final _logger = logging.Logger('AppException');

void _printStackTrace(
  StringBuffer buffer,
  String exceptionType,
  StackTrace stackTrace,
) {
  LineSplitter.split(
    stackTrace.toString(),
  ).forEach((line) {
    if (line.contains('<asynchronous suspension>')) {
      buffer.writeln('\t<asynchronous suspension>');
    } else if (!line.contains(' new $exceptionType ')) {
      buffer.writeln(line.replaceAll(RegExp(r'^#\d+\s+'), '\tat '));
    }
  });
}
