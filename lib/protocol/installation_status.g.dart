// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installation_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InstallationStatus _$InstallationStatusFromJson(Map<String, dynamic> json) =>
    InstallationStatus(
      json['tuid'] as String?,
      json['installation_status'] as String?,
      json['group_id'] as String?,
    );

Map<String, dynamic> _$InstallationStatusToJson(InstallationStatus instance) =>
    <String, dynamic>{
      'tuid': instance.tuid,
      'installation_status': instance.installation_status,
      'group_id': instance.group_id,
    };
