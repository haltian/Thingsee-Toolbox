// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogEvent _$LogEventFromJson(Map<String, dynamic> json) => LogEvent(
      json['id'] as int?,
      json['logId'] as int,
      $enumDecode(_$IncudedEventEnumMap, json['event']),
      DateTime.parse(json['timeStamp'] as String),
      json['deviceId'] as String,
      json['deviceStatus'] as String?,
      json['note'] as String?,
      json['oldDeviceId'] as String?,
      json['groupId'] as String?,
      json['acceleroMeterMode'] as int?,
      json['peopleCountingOrientation'] as int?,
      json['hallMode'] as int?,
      json['mode'] as int?,
      json['newGroupId'] as String?,
      json['version'] as String?,
      json['measurementInterval'] as int?,
    );

Map<String, dynamic> _$LogEventToJson(LogEvent instance) => <String, dynamic>{
      'id': instance.id,
      'logId': instance.logId,
      'event': _$IncudedEventEnumMap[instance.event]!,
      'timeStamp': instance.timeStamp.toIso8601String(),
      'deviceId': instance.deviceId,
      'deviceStatus': instance.deviceStatus,
      'note': instance.note,
      'oldDeviceId': instance.oldDeviceId,
      'groupId': instance.groupId,
      'acceleroMeterMode': instance.acceleroMeterMode,
      'peopleCountingOrientation': instance.peopleCountingOrientation,
      'hallMode': instance.hallMode,
      'mode': instance.mode,
      'newGroupId': instance.newGroupId,
      'version': instance.version,
      'measurementInterval': instance.measurementInterval,
    };

const _$IncudedEventEnumMap = {
  IncudedEvent.addingDevice: 'addingDevice',
  IncudedEvent.replacingDevice: 'replacingDevice',
  IncudedEvent.editingDevice: 'editingDevice',
  IncudedEvent.removingDevice: 'removingDevice',
};
