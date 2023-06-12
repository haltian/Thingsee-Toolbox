// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_command.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceCommand _$DeviceCommandFromJson(Map<String, dynamic> json) =>
    DeviceCommand(
      json['tsmId'] as int,
      json['tsmEv'] as int,
      json['tsmDstTuid'] as String,
      json['peopleCountingOrientation'] as int?,
      json['tsmTs'] as int?,
      json['mode'] as int?,
      json['accelerometerMode'] as int?,
      json['hallMode'] as int?,
      json['measurementInterval'] as int?,
      json['reportInterval'] as int?,
      json['passiveReportInterval'] as int?,
      json['intervalMultiplier'] as int?,
    );

Map<String, dynamic> _$DeviceCommandToJson(DeviceCommand instance) {
  final val = <String, dynamic>{
    'tsmId': instance.tsmId,
    'tsmEv': instance.tsmEv,
    'tsmDstTuid': instance.tsmDstTuid,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('peopleCountingOrientation', instance.peopleCountingOrientation);
  writeNotNull('tsmTs', instance.tsmTs);
  writeNotNull('mode', instance.mode);
  writeNotNull('accelerometerMode', instance.accelerometerMode);
  writeNotNull('hallMode', instance.hallMode);
  writeNotNull('measurementInterval', instance.measurementInterval);
  writeNotNull('reportInterval', instance.reportInterval);
  writeNotNull('passiveReportInterval', instance.passiveReportInterval);
  writeNotNull('intervalMultiplier', instance.intervalMultiplier);
  return val;
}
