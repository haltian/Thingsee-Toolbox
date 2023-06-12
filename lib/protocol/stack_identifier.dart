import 'package:json_annotation/json_annotation.dart';
part 'stack_identifier.g.dart';

@JsonSerializable()
class StackIdentifier {
  final int? id;
  final String name;
  final String clientId;
  final String? apiURL;
  final String? secret;
  StackIdentifier(this.id, this.name, this.clientId, this.apiURL, this.secret);

  factory StackIdentifier.fromJson(Map<String, dynamic> json) =>
      _$StackIdentifierFromJson(json);

  Map<String, dynamic> toJson() => _$StackIdentifierToJson(this);
}
