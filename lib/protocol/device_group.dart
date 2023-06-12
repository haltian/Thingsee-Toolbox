import 'package:json_annotation/json_annotation.dart';
part 'device_group.g.dart';

@JsonSerializable()
class DeviceGroup {
  final String group_id;
  final String tuid;

  DeviceGroup(this.group_id, this.tuid);

  factory DeviceGroup.fromJson(Map<String, dynamic> json) =>
      _$DeviceGroupFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceGroupToJson(this);
}
