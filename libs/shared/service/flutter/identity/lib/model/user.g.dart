// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      username: json['username'] as String? ?? '',
      status: $enumDecodeNullable(_$UserStatusEnumMap, json['status']) ??
          UserStatus.unknown,
      userID: json['userID'] as String? ?? '',
      emailAddress: json['emailAddress'] as String? ?? '',
      emailAddressVerified: json['emailAddressVerified'] as bool? ?? false,
      mobilePhone: json['mobilePhone'] as String? ?? '',
      mobilePhoneVerified: json['mobilePhoneVerified'] as bool? ?? false,
      rememberFor24h: json['rememberFor24h'] as bool? ?? false,
      enableBiometric: json['enableBiometric'] as bool? ?? false,
      enableMFA: json['enableMFA'] as bool? ?? false,
      enableTOTP: json['enableTOTP'] as bool? ?? false,
    )
      ..firstName = json['firstName'] as String?
      ..middleName = json['middleName'] as String?
      ..familyName = json['familyName'] as String?
      ..preferredName = json['preferredName'] as String?
      ..profilePictureUrl = json['profilePictureUrl'] as String?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'status': _$UserStatusEnumMap[instance.status]!,
      'userID': instance.userID,
      'username': instance.username,
      'firstName': instance.firstName,
      'middleName': instance.middleName,
      'familyName': instance.familyName,
      'preferredName': instance.preferredName,
      'emailAddress': instance.emailAddress,
      'emailAddressVerified': instance.emailAddressVerified,
      'mobilePhone': instance.mobilePhone,
      'mobilePhoneVerified': instance.mobilePhoneVerified,
      'profilePictureUrl': instance.profilePictureUrl,
      'rememberFor24h': instance.rememberFor24h,
      'enableBiometric': instance.enableBiometric,
      'enableMFA': instance.enableMFA,
      'enableTOTP': instance.enableTOTP,
    };

const _$UserStatusEnumMap = {
  UserStatus.unknown: 'unknown',
  UserStatus.unregistered: 'unregistered',
  UserStatus.unconfirmed: 'unconfirmed',
  UserStatus.confirmed: 'confirmed',
};
