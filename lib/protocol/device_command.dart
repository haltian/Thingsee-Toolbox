import 'package:json_annotation/json_annotation.dart';
part 'device_command.g.dart';

@JsonSerializable(includeIfNull: false)
class DeviceCommand {
  final int tsmId;
  final int tsmEv;
  final String tsmDstTuid;
  final int? peopleCountingOrientation;
  final int? tsmTs;
  final int? mode;
  final int? accelerometerMode;
  final int? hallMode;
  final int? measurementInterval;
  final int? reportInterval;
  final int? passiveReportInterval;
  final int? intervalMultiplier;

  DeviceCommand(
      this.tsmId,
      this.tsmEv,
      this.tsmDstTuid,
      this.peopleCountingOrientation,
      this.tsmTs,
      this.mode,
      this.accelerometerMode,
      this.hallMode,
      this.measurementInterval,
      this.reportInterval,
      this.passiveReportInterval,
      this.intervalMultiplier);

  factory DeviceCommand.fromJson(Map<String, dynamic> json) =>
      _$DeviceCommandFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceCommandToJson(this);
}
