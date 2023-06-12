// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceInfo _$DeviceInfoFromJson(Map<String, dynamic> json) => DeviceInfo(
      json['battery_level'] as int?,
      json['timestamp'] as int?,
      json['gateway_tuid'] as String?,
      json['version'] as String?,
    );

Map<String, dynamic> _$DeviceInfoToJson(DeviceInfo instance) =>
    <String, dynamic>{
      'battery_level': instance.battery_level,
      'timestamp': instance.timestamp,
      'gateway_tuid': instance.gateway_tuid,
      'version': instance.version,
    };
