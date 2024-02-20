import 'package:identity_service/model/user.dart';
import 'package:identity_service/model/verification.dart';
import 'package:identity_service/provider/aws_provider.dart';

const testEmail = 'test.appbricks@gmail.com';
const testPhone = '+19782951552';

const password = 'TestPassword123!';

final signUpTime = DateTime.now().millisecondsSinceEpoch;
final signUpUserName = 'testUser$signUpTime';


  // void _identityTest() async {
  //   logger.info('Signing up user: $signUpUserName');

  //   final user = User(
  //     username: signUpUserName,
  //     emailAddress: testEmail,
  //     mobilePhone: testPhone,
  //   );
  //   try {
  //     final verification = await provider.signUp(user, password);
  //     safePrint(inspect(verification));
  //   } catch (e) {
  //     logger.severe('Error signing up user: $signUpUserName', e);
  //   }
  // }
