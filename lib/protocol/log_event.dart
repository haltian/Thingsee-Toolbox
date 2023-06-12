import 'package:json_annotation/json_annotation.dart';
import 'package:thingsee_installer/models/installation_model.dart';
part 'log_event.g.dart';

@JsonSerializable()
class LogEvent {
  final int? id;
  final int logId;
  final IncudedEvent event;
  final DateTime timeStamp;
  final String deviceId;
  final String? deviceStatus;
  final String? note;
  final String? oldDeviceId;
  final String? groupId;
  final int? acceleroMeterMode;
  final int? peopleCountingOrientation;
  final int? hallMode;
  final int? mode;
  final String? newGroupId;
  final String? version;
  final int? measurementInterval;

  LogEvent(
      this.id,
      this.logId,
      this.event,
      this.timeStamp,
      this.deviceId,
      this.deviceStatus,
      this.note,
      this.oldDeviceId,
      this.groupId,
      this.acceleroMeterMode,
      this.peopleCountingOrientation,
      this.hallMode,
      this.mode,
      this.newGroupId,
      this.version,
      this.measurementInterval);

  factory LogEvent.fromJson(Map<String, dynamic> json) =>
      _$LogEventFromJson(json);

  Map<String, dynamic> toJson() => _$LogEventToJson(this);
}
