// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Verification _$VerificationFromJson(Map<String, dynamic> json) => Verification(
      isConfirmed: json['isConfirmed'] as bool,
      destination: json['destination'] as String?,
      attrName: json['attrName'] as String?,
    )
      ..timestamp = DateTime.parse(json['timestamp'] as String)
      ..type = $enumDecode(_$VerificationTypeEnumMap, json['verificationType']);

Map<String, dynamic> _$VerificationToJson(Verification instance) =>
    <String, dynamic>{
      'isConfirmed': instance.isConfirmed,
      'timestamp': instance.timestamp.toIso8601String(),
      'verificationType': _$VerificationTypeEnumMap[instance.type]!,
      'destination': instance.destination,
      'attrName': instance.attrName,
    };

const _$VerificationTypeEnumMap = {
  VerificationType.none: 'none',
  VerificationType.email: 'email',
  VerificationType.sms: 'sms',
};
