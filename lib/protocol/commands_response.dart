import 'package:json_annotation/json_annotation.dart';
import 'package:thingsee_installer/protocol/device_command.dart';
part 'commands_response.g.dart';

@JsonSerializable()
class CommandsResponse {
  final String? tuid;
  final int? timestamp;
  final String? responsible;
  final DeviceCommand? command;
  final List<DeviceCommand>? commands;
  CommandsResponse(
      this.tuid, this.timestamp, this.responsible, this.command, this.commands);

  factory CommandsResponse.fromJson(Map<String, dynamic> json) =>
      _$CommandsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CommandsResponseToJson(this);
}
