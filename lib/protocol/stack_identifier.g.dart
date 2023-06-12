// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stack_identifier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StackIdentifier _$StackIdentifierFromJson(Map<String, dynamic> json) =>
    StackIdentifier(
      json['id'] as int?,
      json['name'] as String,
      json['clientId'] as String,
      json['apiURL'] as String?,
      json['secret'] as String?,
    );

Map<String, dynamic> _$StackIdentifierToJson(StackIdentifier instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'clientId': instance.clientId,
      'apiURL': instance.apiURL,
      'secret': instance.secret,
    };
