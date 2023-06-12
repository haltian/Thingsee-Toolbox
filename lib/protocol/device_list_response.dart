import 'package:json_annotation/json_annotation.dart';
part 'device_list_response.g.dart';

@JsonSerializable()
class DeviceListResponse {
  final String? group_id;
  final List<String>? tuids;
  DeviceListResponse(this.group_id, this.tuids);

  factory DeviceListResponse.fromJson(Map<String, dynamic> json) =>
      _$DeviceListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceListResponseToJson(this);
}
