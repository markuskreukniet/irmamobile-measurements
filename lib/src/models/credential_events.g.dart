// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialsEvent _$CredentialsEventFromJson(Map<String, dynamic> json) {
  return CredentialsEvent(
    credentials: (json['Credentials'] as List).map((e) => RawCredential.fromJson(e as Map<String, dynamic>)).toList(),
  );
}

Map<String, dynamic> _$CredentialsEventToJson(CredentialsEvent instance) => <String, dynamic>{
      'Credentials': instance.credentials,
    };

DeleteCredentialEvent _$DeleteCredentialEventFromJson(Map<String, dynamic> json) {
  return DeleteCredentialEvent(
    hash: json['Hash'] as String,
  );
}

Map<String, dynamic> _$DeleteCredentialEventToJson(DeleteCredentialEvent instance) => <String, dynamic>{
      'Hash': instance.hash,
    };
