import 'package:flutter/foundation.dart';

import 'package:utilities_ab/error/app_exception.dart';

class SignUpException extends AppException {
  SignUpException({
    required String super.message,
    super.innerException,
    super.innerStackTrace,
    bool log = kDebugMode,
  }) : super(
          stackTrace: StackTrace.current,
        );
}

class ResendSignUpCodeException extends AppException {
  ResendSignUpCodeException({
    required String super.message,
    super.innerException,
    super.innerStackTrace,
    bool log = kDebugMode,
  }) : super(
          stackTrace: StackTrace.current,
        );
}

class ConfirmSignUpCodeException extends AppException {
  ConfirmSignUpCodeException({
    required String super.message,
    super.innerException,
    super.innerStackTrace,
    bool log = kDebugMode,
  }) : super(
          stackTrace: StackTrace.current,
        );
}

class InvalidCodeException extends AppException {
  InvalidCodeException({
    required String super.message,
    super.innerException,
    super.innerStackTrace,
    bool log = kDebugMode,
  }) : super(
          stackTrace: StackTrace.current,
        );
}

class ResetPasswordException extends AppException {
  ResetPasswordException({
    required String super.message,
    super.innerException,
    super.innerStackTrace,
    bool log = kDebugMode,
  }) : super(
          stackTrace: StackTrace.current,
        );
}
