import 'package:json_annotation/json_annotation.dart';
part 'installation_status.g.dart';

@JsonSerializable()
class InstallationStatus {
  final String? tuid;
  final String? installation_status;
  final String? group_id;

  InstallationStatus(this.tuid, this.installation_status, this.group_id);

  factory InstallationStatus.fromJson(Map<String, dynamic> json) =>
      _$InstallationStatusFromJson(json);

  Map<String, dynamic> toJson() => _$InstallationStatusToJson(this);
}
