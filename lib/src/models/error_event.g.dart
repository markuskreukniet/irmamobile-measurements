// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ErrorEvent _$ErrorEventFromJson(Map<String, dynamic> json) {
  return ErrorEvent(
    exception: json['Exception'] as String,
    stack: json['Stack'] as String,
  );
}

Map<String, dynamic> _$ErrorEventToJson(ErrorEvent instance) => <String, dynamic>{
      'Exception': instance.exception,
      'Stack': instance.stack,
    };
