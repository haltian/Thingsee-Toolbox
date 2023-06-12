import 'package:json_annotation/json_annotation.dart';
import 'package:thingsee_installer/models/installation_model.dart';
import 'package:thingsee_installer/protocol/stack_identifier.dart';
part 'log_file.g.dart';

@JsonSerializable()
class LogFile {
  final int? id;
  final StackIdentifier stack;
  final String title;
  final String description;
  final DateTime timeStamp;
  bool recording;
  final String groupId;
  final List<IncudedEvent> includedEvents;

  LogFile(this.id, this.stack, this.title, this.description, this.timeStamp,
      this.recording, this.groupId, this.includedEvents);

  factory LogFile.fromJson(Map<String, dynamic> json) =>
      _$LogFileFromJson(json);

  Map<String, dynamic> toJson() => _$LogFileToJson(this);
}
