// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogFile _$LogFileFromJson(Map<String, dynamic> json) => LogFile(
      json['id'] as int?,
      StackIdentifier.fromJson(json['stack'] as Map<String, dynamic>),
      json['title'] as String,
      json['description'] as String,
      DateTime.parse(json['timeStamp'] as String),
      json['recording'] as bool,
      json['groupId'] as String,
      (json['includedEvents'] as List<dynamic>)
          .map((e) => $enumDecode(_$IncudedEventEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$LogFileToJson(LogFile instance) => <String, dynamic>{
      'id': instance.id,
      'stack': instance.stack,
      'title': instance.title,
      'description': instance.description,
      'timeStamp': instance.timeStamp.toIso8601String(),
      'recording': instance.recording,
      'groupId': instance.groupId,
      'includedEvents': instance.includedEvents
          .map((e) => _$IncudedEventEnumMap[e]!)
          .toList(),
    };

const _$IncudedEventEnumMap = {
  IncudedEvent.addingDevice: 'addingDevice',
  IncudedEvent.replacingDevice: 'replacingDevice',
  IncudedEvent.editingDevice: 'editingDevice',
  IncudedEvent.removingDevice: 'removingDevice',
};
