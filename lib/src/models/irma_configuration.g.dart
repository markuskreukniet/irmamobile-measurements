// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'irma_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IrmaConfigurationEvent _$IrmaConfigurationEventFromJson(Map<String, dynamic> json) {
  return IrmaConfigurationEvent(
    irmaConfiguration: IrmaConfiguration.fromJson(json['IrmaConfiguration'] as Map<String, dynamic>),
  );
}

IrmaConfiguration _$IrmaConfigurationFromJson(Map<String, dynamic> json) {
  return IrmaConfiguration(
    schemeManagers: (json['SchemeManagers'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, SchemeManager.fromJson(e as Map<String, dynamic>)),
    ),
    issuers: (json['Issuers'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, Issuer.fromJson(e as Map<String, dynamic>)),
    ),
    credentialTypes: (json['CredentialTypes'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, CredentialType.fromJson(e as Map<String, dynamic>)),
    ),
    attributeTypes: (json['AttributeTypes'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, AttributeType.fromJson(e as Map<String, dynamic>)),
    ),
    path: json['Path'] as String,
  );
}

SchemeManager _$SchemeManagerFromJson(Map<String, dynamic> json) {
  return SchemeManager(
    id: json['ID'] as String,
    name: TranslatedValue.fromJson(json['Name'] as Map<String, dynamic>),
    url: json['URL'] as String,
    description: TranslatedValue.fromJson(json['Description'] as Map<String, dynamic>),
    minimumAppVersion: AppVersion.fromJson(json['MinimumAppVersion'] as Map<String, dynamic>),
    keyshareServer: json['KeyshareServer'] as String,
    keyshareWebsite: json['KeyshareWebsite'] as String,
    keyshareAttribute: json['KeyshareAttribute'] as String,
    timestamp: json['Timestamp'] as int,
  );
}

AppVersion _$AppVersionFromJson(Map<String, dynamic> json) {
  return AppVersion(
    android: json['Android'] as int,
    iOS: json['IOS'] as int,
  );
}

Issuer _$IssuerFromJson(Map<String, dynamic> json) {
  return Issuer(
    id: json['ID'] as String,
    name: TranslatedValue.fromJson(json['Name'] as Map<String, dynamic>),
    shortName: TranslatedValue.fromJson(json['ShortName'] as Map<String, dynamic>),
    schemeManagerId: json['SchemeManagerID'] as String,
    contactAddress: json['ContactAddress'] as String,
    contactEmail: json['ContactEmail'] as String,
  );
}

CredentialType _$CredentialTypeFromJson(Map<String, dynamic> json) {
  return CredentialType(
    id: json['ID'] as String,
    name: TranslatedValue.fromJson(json['Name'] as Map<String, dynamic>),
    shortName: TranslatedValue.fromJson(json['ShortName'] as Map<String, dynamic>),
    issuerId: json['IssuerID'] as String,
    schemeManagerId: json['SchemeManagerID'] as String,
    isSingleton: json['IsSingleton'] as bool,
    description: TranslatedValue.fromJson(json['Description'] as Map<String, dynamic>),
    issueUrl: json['IssueURL'] == null ? null : TranslatedValue.fromJson(json['IssueURL'] as Map<String, dynamic>),
    isULIssueUrl: json['IsULIssueURL'] as bool,
    disallowDelete: json['DisallowDelete'] as bool,
    foregroundColor: _fromColorCode(json['ForegroundColor'] as String),
    backgroundGradientStart: _fromColorCode(json['BackgroundGradientStart'] as String),
    backgroundGradientEnd: _fromColorCode(json['BackgroundGradientEnd'] as String),
    isInCredentialStore: json['IsInCredentialStore'] as bool,
    category: json['Category'] == null ? null : TranslatedValue.fromJson(json['Category'] as Map<String, dynamic>),
    faqIntro: json['FAQIntro'] == null ? null : TranslatedValue.fromJson(json['FAQIntro'] as Map<String, dynamic>),
    faqPurpose:
        json['FAQPurpose'] == null ? null : TranslatedValue.fromJson(json['FAQPurpose'] as Map<String, dynamic>),
    faqContent:
        json['FAQContent'] == null ? null : TranslatedValue.fromJson(json['FAQContent'] as Map<String, dynamic>),
    faqHowto: json['FAQHowto'] == null ? null : TranslatedValue.fromJson(json['FAQHowto'] as Map<String, dynamic>),
  );
}

AttributeType _$AttributeTypeFromJson(Map<String, dynamic> json) {
  return AttributeType(
    id: json['ID'] as String,
    optional: json['Optional'] as String,
    name: TranslatedValue.fromJson(json['Name'] as Map<String, dynamic>),
    description: TranslatedValue.fromJson(json['Description'] as Map<String, dynamic>),
    index: json['Index'] as int,
    displayIndex: json['DisplayIndex'] as int,
    displayHint: json['DisplayHint'] as String,
    credentialTypeId: json['CredentialTypeID'] as String,
    issuerId: json['IssuerID'] as String,
    schemeManagerId: json['SchemeManagerID'] as String,
  );
}
