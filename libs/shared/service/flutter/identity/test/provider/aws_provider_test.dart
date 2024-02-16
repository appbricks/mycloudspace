import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';

import 'package:utilities/logging/init_logging.dart';

import 'package:identity_service/model/user.dart';
import 'package:identity_service/model/verification.dart';
import 'package:identity_service/provider/aws_provider.dart';

void main() {
  initLogging(
    Level.ALL,
    logToConsole: true,
  );

  // AWS Cognito needs to be mocked for testing
  //
  // group('AwsProviderTest', () {
  //   final Logger logger = Logger('AwsProviderTest');

  //   const testEmail = 'test.appbricks@gmail.com';
  //   const testPhone = '+19782951552';

  //   const password = 'TestPassword123!';

  //   final signUpTime = DateTime.now().millisecondsSinceEpoch;
  //   final signUpUserName = 'testUser$signUpTime';

  //   final provider = AWSProvider();

  //   test('registers a new user, confirms registration and signs-in', () async {
  //     logger.info('Signing up user: $signUpUserName');

  //     final user = User(
  //       username: signUpUserName,
  //       emailAddress: testEmail,
  //       mobilePhone: testPhone,
  //     );
  //     final verification = await provider.signUp(user, password);

  //     expect(verification.isConfirmed, false);
  //     expect(verification.type, VerificationType.email);
  //     expect(verification.destination, 't***@g***');
  //     expect(verification.attrName, 'email');
  //   });
  // });
}
