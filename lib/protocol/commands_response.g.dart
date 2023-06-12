// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commands_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommandsResponse _$CommandsResponseFromJson(Map<String, dynamic> json) =>
    CommandsResponse(
      json['tuid'] as String?,
      json['timestamp'] as int?,
      json['responsible'] as String?,
      json['command'] == null
          ? null
          : DeviceCommand.fromJson(json['command'] as Map<String, dynamic>),
      (json['commands'] as List<dynamic>?)
          ?.map((e) => DeviceCommand.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommandsResponseToJson(CommandsResponse instance) =>
    <String, dynamic>{
      'tuid': instance.tuid,
      'timestamp': instance.timestamp,
      'responsible': instance.responsible,
      'command': instance.command,
      'commands': instance.commands,
    };
