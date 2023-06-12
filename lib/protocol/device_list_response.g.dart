// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceListResponse _$DeviceListResponseFromJson(Map<String, dynamic> json) =>
    DeviceListResponse(
      json['group_id'] as String?,
      (json['tuids'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DeviceListResponseToJson(DeviceListResponse instance) =>
    <String, dynamic>{
      'group_id': instance.group_id,
      'tuids': instance.tuids,
    };
