import 'package:identity_service/model/user.dart';
import 'package:identity_service/model/verification.dart';

////
/// Authentication Provider interface
///
/// The implementor of this interface would contain
/// the cloud service provider specific logic.
///
abstract interface class Provider {
  /// Signs up a user
  Future<Verification> signUp(User user, String password);

  /// Resend a code to the given user
  Future<Verification> resendSignUpCode(
    // the name of the user for whom the
    // sign-up code needs to be resent
    String username,
  );

  /// Confirm the registration of a particular user
  Future<bool> confirmSignUpCode(
    // the user's whose registration is to be verified
    String username,
    // the code that was sent for verification
    String code,
  );

  /// Initiates a password reset flow for the given user.
  Future<void> resetPassword(
    // the user whose password needs to be reset
    String username,
  );

  /// Updates the given user's password validating the change with the given code
  Future<void> updatePassword(
    // the user whose password is being reset
    String username,
    // the new password
    String password,
    // the confirmation code for password reset
    String code,
  );

  ///
  /// The following methods apply to the currently logged in user
  ///

  /// Validates session is valid and has a logged on user
  Future<bool> validateSession();

  /// Returns whether the given username is logged in. If a
  /// username is not provided then this method will return
  /// true if session is valid. This service method should
  /// also initialize the internal state with current
  /// logged in session state.
  Future<bool> isLoggedIn(
    // the username to check if logged in
    String username,
  );

  /// Returns the username of the underlying
  /// provider's logged in session. If the
  /// provider session is logged in then
  /// the name will be 'null'.
  Future<String?> getLoggedInUsername();

  /// Signs in the given user
  Future<int> signIn(
    // the username to sign in with
    String username,
    // the password to sign in with
    String password,
  );

  /// Validates the given multi-factor authentication code
  Future<bool> validateMFACode(
    // the MFA code to validate
    String code,
    // the MFA type (i.e. SMS or TOTP)
    int type,
  );

  /// Signs out the logged in user
  Future<void> signOut();

  /// Sends a verifaction code to validate the given attribute.
  Future<void> sendVerificationCodeForAttribute(
    // the user attribute to send the code for verification
    String attribute,
  );

  /// Verifies the given attribute with the code that was sent to the user
  Future<void> confirmVerificationCodeForAttribute(
    // the user attribute to verify
    String attribute,
    // the code to verify the attribute with
    String code,
  );

  /// Config multi-factor authentication for the user
  Future<void> configureMFA(
    // the user to configure MFA for
    User user,
  );

  /// Setup Time-based One Time Password MFA for the user
  ///
  /// returns the secret to be used by a token
  /// generator app like Google Authenticate app
  Future<String> setupTOTP();

  /// Verifies the TOTP setup by validating a code generated
  /// by the token generator app with the current setup
  Future<void> verifyTOTP(
    // the code to validate the setup with
    String code,
  );

  /// Saves the user attributes to the AWS Cognito backend.
  Future<void> saveUser(
    // the user to save to the backend
    User user,
    // the list of attributes to save
    List<String>? attribNames,
  );

  /// Reads attributes of logged in user from the AWS Cognito backend.
  Future<User> readUser(
    // the attributes read from the backend and populate a user object
    List<String>? attribNames,
  );
}
