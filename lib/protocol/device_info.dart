import 'package:json_annotation/json_annotation.dart';
part 'device_info.g.dart';

@JsonSerializable()
class DeviceInfo {
  final int? battery_level;
  final int? timestamp;
  final String? gateway_tuid;
  final String? version;

  DeviceInfo(
      this.battery_level, this.timestamp, this.gateway_tuid, this.version);

  factory DeviceInfo.fromJson(Map<String, dynamic> json) =>
      _$DeviceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceInfoToJson(this);
}
