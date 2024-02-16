import 'package:json_annotation/json_annotation.dart';

part 'verification.g.dart';

@JsonSerializable()
class Verification {
  final bool isConfirmed;

  DateTime timestamp = DateTime.now();
  VerificationType type = VerificationType.none;
  String? destination;
  String? attrName;

  Verification({
    required this.isConfirmed,
    this.destination,
    this.attrName,
  });

  factory Verification.fromJson(Map<String, dynamic> json) {
    return _$VerificationFromJson(json);
  }
  Map<String, dynamic> toJson() {
    return _$VerificationToJson(this);
  }
}

enum VerificationType { none, email, sms }
