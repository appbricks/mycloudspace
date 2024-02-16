import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' as awsCognito;

import 'package:logging/logging.dart' as logging;

import 'package:identity_service/model/user.dart';
import 'package:identity_service/model/verification.dart';

import 'provider.dart';
import 'exceptions.dart';

class AWSProvider implements Provider {
  final logging.Logger _logger = logging.Logger('AWSProvider');

  @override
  Future<Verification> signUp(
    User user,
    String password,
  ) async {
    try {
      final userAttributes = {
        awsCognito.AuthUserAttributeKey.email: user.emailAddress,
        awsCognito.AuthUserAttributeKey.phoneNumber: user.mobilePhone,
      };
      final result = await Amplify.Auth.signUp(
        username: user.username,
        password: password,
        options: awsCognito.SignUpOptions(
          userAttributes: userAttributes,
        ),
      );
      _logger.fine('Successful sign up: $result');

      final nextStep = result.nextStep;
      switch (nextStep.signUpStep) {
        case awsCognito.AuthSignUpStep.confirmSignUp:
          final verification = Verification(
            isConfirmed: false,
            destination: nextStep.codeDeliveryDetails?.destination,
            attrName: nextStep.codeDeliveryDetails?.attributeKey?.key,
          );
          switch (nextStep.codeDeliveryDetails?.deliveryMedium) {
            case awsCognito.DeliveryMedium.email:
              verification.type = VerificationType.email;
              break;
            case awsCognito.DeliveryMedium.sms:
              verification.type = VerificationType.sms;
              break;
            default:
              throw SignUpException(
                message:
                    'Unknown verification type ${nextStep.codeDeliveryDetails?.deliveryMedium.name}',
              );
          }
          return verification;

        case awsCognito.AuthSignUpStep.done:
          return Verification(
            isConfirmed: true,
          );

        default:
          throw SignUpException(
            message: 'Unknown sign up step: ${nextStep.signUpStep.name}',
          );
      }
    } on awsCognito.AuthException catch (e) {
      throw SignUpException(
        message: 'Failed to sign up user',
        innerException: e,
        innerStackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<Verification> resendSignUpCode(
    String username,
  ) async {
    try {
      final result = await Amplify.Auth.resendSignUpCode(
        username: username,
      );
      _logger.fine('Successfully resent sign up code: $result');

      final codeDeliveryDetails = result.codeDeliveryDetails;

      final verification = Verification(
        isConfirmed: false,
        destination: codeDeliveryDetails.destination,
        attrName: codeDeliveryDetails.attributeKey?.key,
      );
      switch (codeDeliveryDetails.deliveryMedium) {
        case awsCognito.DeliveryMedium.email:
          verification.type = VerificationType.email;
          break;
        case awsCognito.DeliveryMedium.sms:
          verification.type = VerificationType.sms;
          break;
        default:
          throw ResendSignUpCodeException(
            message:
                'Unknown verification type ${codeDeliveryDetails.deliveryMedium.name}',
          );
      }
      return verification;
    } on awsCognito.AuthException catch (e) {
      throw ResendSignUpCodeException(
        message: 'Failed to sign up user',
        innerException: e,
        innerStackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<bool> confirmSignUpCode(
    String username,
    String code,
  ) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: code,
      );
      _logger.fine('Successfully confirmed sign up code: $result');

      return true;
    } on awsCognito.AuthException catch (e) {
      if (e.message ==
          'Invalid verification code provided, please try again.') {
        throw InvalidCodeException(
          message: e.message,
          innerException: e,
          innerStackTrace: StackTrace.current,
        );
      } else {
        throw ResendSignUpCodeException(
          message: 'Failed to sign up user',
          innerException: e,
          innerStackTrace: StackTrace.current,
        );
      }
    }
  }

  @override
  Future<void> resetPassword(
    String username,
  ) async {
    try {
      // TODO: implement confirmSignUpCode
      throw UnimplementedError();
    } on awsCognito.AuthException catch (e) {
      throw ResendSignUpCodeException(
        message: 'Failed to sign up user',
        innerException: e,
        innerStackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<void> updatePassword(
    String username,
    String password,
    String code,
  ) async {
    try {
      // TODO: implement confirmSignUpCode
      throw UnimplementedError();
    } on awsCognito.AuthException catch (e) {
      throw ResendSignUpCodeException(
        message: 'Failed to sign up user',
        innerException: e,
        innerStackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<bool> validateSession() async {
    final result = await Amplify.Auth.fetchAuthSession();
    return result.isSignedIn;
  }

  @override
  Future<bool> isLoggedIn(String username) async {
    return username == await getLoggedInUsername();
  }

  @override
  Future<String?> getLoggedInUsername() async {
    if (await validateSession()) {
      final user = await Amplify.Auth.getCurrentUser();
      return user.username;
    } else {
      return null;
    }
  }

  @override
  Future<int> signIn(
    String username,
    String password,
  ) async {
    try {
      // TODO: implement confirmSignUpCode
      throw UnimplementedError();
    } on awsCognito.AuthException catch (e) {
      throw ResendSignUpCodeException(
        message: 'Failed to sign up user',
        innerException: e,
        innerStackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<bool> validateMFACode(
    String code,
    int type,
  ) async {
    try {
      // TODO: implement confirmSignUpCode
      throw UnimplementedError();
    } on awsCognito.AuthException catch (e) {
      throw ResendSignUpCodeException(
        message: 'Failed to sign up user',
        innerException: e,
        innerStackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      // TODO: implement confirmSignUpCode
      throw UnimplementedError();
    } on awsCognito.AuthException catch (e) {
      throw ResendSignUpCodeException(
        message: 'Failed to sign up user',
        innerException: e,
        innerStackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<void> sendVerificationCodeForAttribute(
    String attribute,
  ) async {
    // TODO: implement sendVerificationCodeForAttribute
    throw UnimplementedError();
  }

  @override
  Future<void> confirmVerificationCodeForAttribute(
    String attribute,
    String code,
  ) async {
    try {
      // TODO: implement confirmSignUpCode
      throw UnimplementedError();
    } on awsCognito.AuthException catch (e) {
      throw ResendSignUpCodeException(
        message: 'Failed to sign up user',
        innerException: e,
        innerStackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<void> configureMFA(
    User user,
  ) async {
    try {
      // TODO: implement confirmSignUpCode
      throw UnimplementedError();
    } on awsCognito.AuthException catch (e) {
      throw ResendSignUpCodeException(
        message: 'Failed to sign up user',
        innerException: e,
        innerStackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<String> setupTOTP() async {
    try {
      // TODO: implement confirmSignUpCode
      throw UnimplementedError();
    } on awsCognito.AuthException catch (e) {
      throw ResendSignUpCodeException(
        message: 'Failed to sign up user',
        innerException: e,
        innerStackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<void> verifyTOTP(
    String code,
  ) async {
    try {
      // TODO: implement confirmSignUpCode
      throw UnimplementedError();
    } on awsCognito.AuthException catch (e) {
      throw ResendSignUpCodeException(
        message: 'Failed to sign up user',
        innerException: e,
        innerStackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<User> readUser(
    List<String>? attribNames,
  ) async {
    try {
      // TODO: implement confirmSignUpCode
      throw UnimplementedError();
    } on awsCognito.AuthException catch (e) {
      throw ResendSignUpCodeException(
        message: 'Failed to sign up user',
        innerException: e,
        innerStackTrace: StackTrace.current,
      );
    }
  }

  @override
  Future<void> saveUser(
    User user,
    List<String>? attribNames,
  ) async {
    try {
      // TODO: implement confirmSignUpCode
      throw UnimplementedError();
    } on awsCognito.AuthException catch (e) {
      throw ResendSignUpCodeException(
        message: 'Failed to sign up user',
        innerException: e,
        innerStackTrace: StackTrace.current,
      );
    }
  }
}
