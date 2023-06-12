import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/protocol/group.dart';
import '../installer_error_model.dart';
import '../protocol/base_response.dart';

class FetchGroupListBackend {
  final http.Client client;

  const FetchGroupListBackend(this.client);

  Future<List<Group>> fetchGroupList({
    required String url,
    required String token,
  }) async {
    final apiURL = Uri.parse(url + InstallerConstants.groupsURL);
    var response = await client.get(
      apiURL,
      headers: {
        InstallerConstants.headerContentType:
            InstallerConstants.headerApplicationJson,
        InstallerConstants.authorization:
            InstallerConstants.bearerToken(token: token)
      },
    );

    String source = Utf8Decoder().convert(response.bodyBytes);

    HTTPError.checkHTTPStatusCode(response, response.body);

    BaseResponse<Iterable<Group>> groupListResponse = BaseResponse.fromJson(
        json.decode(source),
        (data) => (data as List<dynamic>).map((e) => Group.fromJson(e)));

    List<Group> groups = groupListResponse.data!.toList();

    return groups;
  }
}
