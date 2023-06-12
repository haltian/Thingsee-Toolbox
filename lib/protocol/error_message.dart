import 'package:json_annotation/json_annotation.dart';
part 'error_message.g.dart';

@JsonSerializable()
class ErrorMessage {
  final int? statusCode;
  final String? error;
  final String? message;
  ErrorMessage(this.statusCode, this.error, this.message);

  factory ErrorMessage.fromJson(Map<String, dynamic> json) =>
      _$ErrorMessageFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorMessageToJson(this);
}
