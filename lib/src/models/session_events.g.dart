// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewSessionEvent _$NewSessionEventFromJson(Map<String, dynamic> json) {
  return NewSessionEvent(
    request: json['Request'] == null ? null : SessionPointer.fromJson(json['Request'] as Map<String, dynamic>),
    continueOnSecondDevice: json['continueOnSecondDevice'] as bool,
  )..sessionID = json['SessionID'] as int;
}

Map<String, dynamic> _$NewSessionEventToJson(NewSessionEvent instance) => <String, dynamic>{
      'SessionID': instance.sessionID,
      'Request': instance.request,
      'continueOnSecondDevice': instance.continueOnSecondDevice,
    };

RespondPermissionEvent _$RespondPermissionEventFromJson(Map<String, dynamic> json) {
  return RespondPermissionEvent(
    sessionID: json['SessionID'] as int,
    proceed: json['Proceed'] as bool,
    disclosureChoices: (json['DisclosureChoices'] as List)
        ?.map((e) => (e as List)
            ?.map((e) => e == null ? null : AttributeIdentifier.fromJson(e as Map<String, dynamic>))
            ?.toList())
        ?.toList(),
  );
}

Map<String, dynamic> _$RespondPermissionEventToJson(RespondPermissionEvent instance) => <String, dynamic>{
      'SessionID': instance.sessionID,
      'Proceed': instance.proceed,
      'DisclosureChoices': instance.disclosureChoices,
    };

RespondPinEvent _$RespondPinEventFromJson(Map<String, dynamic> json) {
  return RespondPinEvent(
    sessionID: json['SessionID'] as int,
    proceed: json['Proceed'] as bool,
    pin: json['Pin'] as String,
  );
}

Map<String, dynamic> _$RespondPinEventToJson(RespondPinEvent instance) => <String, dynamic>{
      'SessionID': instance.sessionID,
      'Proceed': instance.proceed,
      'Pin': instance.pin,
    };

DismissSessionEvent _$DismissSessionEventFromJson(Map<String, dynamic> json) {
  return DismissSessionEvent(
    sessionID: json['SessionID'] as int,
  );
}

Map<String, dynamic> _$DismissSessionEventToJson(DismissSessionEvent instance) => <String, dynamic>{
      'SessionID': instance.sessionID,
    };

StatusUpdateSessionEvent _$StatusUpdateSessionEventFromJson(Map<String, dynamic> json) {
  return StatusUpdateSessionEvent(
    sessionID: json['SessionID'] as int,
    action: json['Action'] as String,
    status: json['Status'] as String,
  );
}

Map<String, dynamic> _$StatusUpdateSessionEventToJson(StatusUpdateSessionEvent instance) => <String, dynamic>{
      'SessionID': instance.sessionID,
      'Action': instance.action,
      'Status': instance.status,
    };

ClientReturnURLSetSessionEvent _$ClientReturnURLSetSessionEventFromJson(Map<String, dynamic> json) {
  return ClientReturnURLSetSessionEvent(
    sessionID: json['SessionID'] as int,
    clientReturnURL: json['ClientReturnURL'] as String,
  );
}

Map<String, dynamic> _$ClientReturnURLSetSessionEventToJson(ClientReturnURLSetSessionEvent instance) =>
    <String, dynamic>{
      'SessionID': instance.sessionID,
      'ClientReturnURL': instance.clientReturnURL,
    };

SuccessSessionEvent _$SuccessSessionEventFromJson(Map<String, dynamic> json) {
  return SuccessSessionEvent(
    sessionID: json['SessionID'] as int,
    result: json['Result'] as String,
    measurementAgain: json['MeasurementAgain'] as bool,
    measurementType: json['MeasurementType'] as String,
  );
}

Map<String, dynamic> _$SuccessSessionEventToJson(SuccessSessionEvent instance) => <String, dynamic>{
      'SessionID': instance.sessionID,
      'Result': instance.result,
      'MeasurementAgain': instance.measurementAgain,
      'MeasurementType': instance.measurementType,
    };

FailureSessionEvent _$FailureSessionEventFromJson(Map<String, dynamic> json) {
  return FailureSessionEvent(
    sessionID: json['SessionID'] as int,
    error: json['Error'] == null ? null : SessionError.fromJson(json['Error'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$FailureSessionEventToJson(FailureSessionEvent instance) => <String, dynamic>{
      'SessionID': instance.sessionID,
      'Error': instance.error,
    };

CanceledSessionEvent _$CanceledSessionEventFromJson(Map<String, dynamic> json) {
  return CanceledSessionEvent(
    sessionID: json['SessionID'] as int,
  );
}

Map<String, dynamic> _$CanceledSessionEventToJson(CanceledSessionEvent instance) => <String, dynamic>{
      'SessionID': instance.sessionID,
    };

RequestIssuancePermissionSessionEvent _$RequestIssuancePermissionSessionEventFromJson(Map<String, dynamic> json) {
  return RequestIssuancePermissionSessionEvent(
    sessionID: json['SessionID'] as int,
    serverName:
        json['ServerName'] == null ? null : TranslatedValue.fromJson(json['ServerName'] as Map<String, dynamic>),
    satisfiable: json['Satisfiable'] as bool,
    issuedCredentials: (json['IssuedCredentials'] as List)
        ?.map((e) => e == null ? null : RawCredential.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    disclosuresLabels: (json['DisclosuresLabels'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k), e == null ? null : TranslatedValue.fromJson(e as Map<String, dynamic>)),
    ),
    disclosuresCandidates: (json['DisclosuresCandidates'] as List)
        ?.map((e) => (e as List)
            ?.map((e) => (e as List)
                ?.map((e) => e == null ? null : DisclosureCandidate.fromJson(e as Map<String, dynamic>))
                ?.toList())
            ?.toList())
        ?.toList(),
  );
}

Map<String, dynamic> _$RequestIssuancePermissionSessionEventToJson(RequestIssuancePermissionSessionEvent instance) =>
    <String, dynamic>{
      'SessionID': instance.sessionID,
      'ServerName': instance.serverName,
      'Satisfiable': instance.satisfiable,
      'IssuedCredentials': instance.issuedCredentials,
      'DisclosuresLabels': instance.disclosuresLabels?.map((k, e) => MapEntry(k.toString(), e)),
      'DisclosuresCandidates': instance.disclosuresCandidates,
    };

RequestVerificationPermissionSessionEvent _$RequestVerificationPermissionSessionEventFromJson(
    Map<String, dynamic> json) {
  return RequestVerificationPermissionSessionEvent(
    sessionID: json['SessionID'] as int,
    serverName:
        json['ServerName'] == null ? null : TranslatedValue.fromJson(json['ServerName'] as Map<String, dynamic>),
    satisfiable: json['Satisfiable'] as bool,
    disclosuresLabels: (json['DisclosuresLabels'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(int.parse(k), e == null ? null : TranslatedValue.fromJson(e as Map<String, dynamic>)),
    ),
    disclosuresCandidates: (json['DisclosuresCandidates'] as List)
        ?.map((e) => (e as List)
            ?.map((e) => (e as List)
                ?.map((e) => e == null ? null : DisclosureCandidate.fromJson(e as Map<String, dynamic>))
                ?.toList())
            ?.toList())
        ?.toList(),
  )
    ..isSignatureSession = json['IsSignatureSession'] as bool
    ..signedMessage = json['SignedMessage'] as String;
}

Map<String, dynamic> _$RequestVerificationPermissionSessionEventToJson(
        RequestVerificationPermissionSessionEvent instance) =>
    <String, dynamic>{
      'SessionID': instance.sessionID,
      'ServerName': instance.serverName,
      'Satisfiable': instance.satisfiable,
      'DisclosuresLabels': instance.disclosuresLabels?.map((k, e) => MapEntry(k.toString(), e)),
      'DisclosuresCandidates': instance.disclosuresCandidates,
      'IsSignatureSession': instance.isSignatureSession,
      'SignedMessage': instance.signedMessage,
    };

RequestPinSessionEvent _$RequestPinSessionEventFromJson(Map<String, dynamic> json) {
  return RequestPinSessionEvent(
    sessionID: json['SessionID'] as int,
    remainingAttempts: json['RemainingAttempts'] as int,
  );
}

Map<String, dynamic> _$RequestPinSessionEventToJson(RequestPinSessionEvent instance) => <String, dynamic>{
      'SessionID': instance.sessionID,
      'RemainingAttempts': instance.remainingAttempts,
    };

KeyshareEnrollmentMissingSessionEvent _$KeyshareEnrollmentMissingSessionEventFromJson(Map<String, dynamic> json) {
  return KeyshareEnrollmentMissingSessionEvent(
    sessionID: json['SessionID'] as int,
    schemeManagerID: json['SchemeManagerID'] as String,
  );
}

Map<String, dynamic> _$KeyshareEnrollmentMissingSessionEventToJson(KeyshareEnrollmentMissingSessionEvent instance) =>
    <String, dynamic>{
      'SessionID': instance.sessionID,
      'SchemeManagerID': instance.schemeManagerID,
    };

KeyshareEnrollmentDeletedSessionEvent _$KeyshareEnrollmentDeletedSessionEventFromJson(Map<String, dynamic> json) {
  return KeyshareEnrollmentDeletedSessionEvent(
    sessionID: json['SessionID'] as int,
    schemeManagerID: json['SchemeManagerID'] as String,
  );
}

Map<String, dynamic> _$KeyshareEnrollmentDeletedSessionEventToJson(KeyshareEnrollmentDeletedSessionEvent instance) =>
    <String, dynamic>{
      'SessionID': instance.sessionID,
      'SchemeManagerID': instance.schemeManagerID,
    };

KeyshareBlockedSessionEvent _$KeyshareBlockedSessionEventFromJson(Map<String, dynamic> json) {
  return KeyshareBlockedSessionEvent(
    sessionID: json['SessionID'] as int,
    schemeManagerID: json['SchemeManagerID'] as String,
    duration: json['Duration'] as int,
  );
}

Map<String, dynamic> _$KeyshareBlockedSessionEventToJson(KeyshareBlockedSessionEvent instance) => <String, dynamic>{
      'SessionID': instance.sessionID,
      'SchemeManagerID': instance.schemeManagerID,
      'Duration': instance.duration,
    };

KeyshareEnrollmentIncompleteSessionEvent _$KeyshareEnrollmentIncompleteSessionEventFromJson(Map<String, dynamic> json) {
  return KeyshareEnrollmentIncompleteSessionEvent(
    sessionID: json['SessionID'] as int,
    schemeManagerID: json['SchemeManagerID'] as String,
  );
}

Map<String, dynamic> _$KeyshareEnrollmentIncompleteSessionEventToJson(
        KeyshareEnrollmentIncompleteSessionEvent instance) =>
    <String, dynamic>{
      'SessionID': instance.sessionID,
      'SchemeManagerID': instance.schemeManagerID,
    };
