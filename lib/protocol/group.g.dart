// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      json['group_id'] as String,
      json['group_description'] as String?,
      json['deleted'] as bool?,
    );

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'group_id': instance.group_id,
      'group_description': instance.group_description,
      'deleted': instance.deleted,
    };
