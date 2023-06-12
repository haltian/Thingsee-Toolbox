import 'package:json_annotation/json_annotation.dart';
part 'installer_token.g.dart';

@JsonSerializable()
class InstallerToken {
  final String token;

  InstallerToken(this.token);

  factory InstallerToken.fromJson(Map<String, dynamic> json) =>
      _$InstallerTokenFromJson(json);

  Map<String, dynamic> toJson() => _$InstallerTokenToJson(this);
}
