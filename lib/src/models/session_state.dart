import 'package:irmamobile/src/models/attributes.dart';
import 'package:irmamobile/src/models/credentials.dart';
import 'package:irmamobile/src/models/session.dart';
import 'package:irmamobile/src/models/translated_value.dart';

class SessionState {
  final int sessionID;
  final bool continueOnSecondDevice;
  final SessionStatus status;
  final TranslatedValue serverName;
  final ConDisCon<Attribute> disclosuresCandidates;
  final String clientReturnURL;
  final bool isSignatureSession;
  final String signedMessage;
  final List<Credential> issuedCredentials;
  final List<int> disclosureIndices;
  final ConCon<AttributeIdentifier> disclosureChoices;
  final bool satisfiable;
  final SessionError error;

  SessionState({
    this.sessionID,
    this.continueOnSecondDevice,
    this.status = SessionStatus.uninitialized,
    this.serverName,
    this.disclosuresCandidates,
    this.clientReturnURL,
    this.isSignatureSession,
    this.signedMessage,
    this.issuedCredentials,
    this.disclosureIndices,
    this.disclosureChoices,
    this.satisfiable,
    this.error,
  });

  bool get canDisclose =>
      disclosuresCandidates == null ||
      disclosuresCandidates
          .asMap()
          .map((i, discon) => MapEntry(i, discon[disclosureIndices[i]]))
          .values
          .every((con) => con.every((attr) => attr.choosable));

  bool get isIssuanceSession => issuedCredentials?.isNotEmpty ?? false;
  bool get isReturnPhoneNumber => clientReturnURL?.startsWith("tel:") ?? false;

  SessionState copyWith({
    bool continueOnSecondDevice,
    SessionStatus status,
    TranslatedValue serverName,
    ConDisCon<Attribute> disclosuresCandidates,
    String clientReturnURL,
    bool isSignatureSession,
    String signedMessage,
    List<Credential> issuedCredentials,
    List<int> disclosureIndices,
    ConCon<AttributeIdentifier> disclosureChoices,
    bool satisfiable,
    SessionError error,
  }) {
    return SessionState(
      sessionID: sessionID,
      continueOnSecondDevice: continueOnSecondDevice ?? this.continueOnSecondDevice,
      status: status ?? this.status,
      serverName: serverName ?? this.serverName,
      disclosuresCandidates: disclosuresCandidates ?? this.disclosuresCandidates,
      clientReturnURL: clientReturnURL ?? this.clientReturnURL,
      isSignatureSession: isSignatureSession ?? this.isSignatureSession,
      signedMessage: signedMessage ?? this.signedMessage,
      issuedCredentials: issuedCredentials ?? this.issuedCredentials,
      disclosureIndices: disclosureIndices ?? this.disclosureIndices,
      disclosureChoices: disclosureChoices ?? this.disclosureChoices,
      satisfiable: satisfiable ?? this.satisfiable,
      error: error ?? this.error,
    );
  }
}

enum SessionStatus {
  uninitialized,
  initialized,
  communicating,
  connected,
  requestDisclosurePermission,
  requestIssuancePermission,
  requestPin,
  success,
  canceled,
  error,
}

extension SessionStatusParser on String {
  SessionStatus toSessionStatus() => SessionStatus.values.firstWhere(
        (v) => v.toString() == 'SessionStatus.$this',
        orElse: () => null,
      );
}
