import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final UserStatus status;

  final String userID;
  final String username;

  late final String? firstName;
  late final String? middleName;
  late final String? familyName;
  late final String? preferredName;

  final String emailAddress;
  final bool emailAddressVerified;

  final String mobilePhone;
  final bool mobilePhoneVerified;

  late final String? profilePictureUrl;

  final bool rememberFor24h;

  final bool enableBiometric;

  final bool enableMFA;
  final bool enableTOTP;

  User({
    this.username = '',
    this.status = UserStatus.unknown,
    this.userID = '',
    this.emailAddress = '',
    this.emailAddressVerified = false,
    this.mobilePhone = '',
    this.mobilePhoneVerified = false,
    this.rememberFor24h = false,
    this.enableBiometric = false,
    // If MFA is enabled and TOTP is disabled
    // then SMS will be the preferred MFA type
    this.enableMFA = false,
    this.enableTOTP = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }
  Map<String, dynamic> toJson() {
    return _$UserToJson(this);
  }
}

enum UserStatus {
  unknown,
  unregistered,
  unconfirmed,
  confirmed,
}
