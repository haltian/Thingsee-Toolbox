import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/protocol/group.dart';
import '../installer_error_model.dart';
import '../protocol/base_response.dart';

class CreateGroupBackend {
  final http.Client client;

  const CreateGroupBackend(this.client);

  Future<Group> createGroup(
      {required String url,
      required String token,
      required String groupId,
      required String? description}) async {
    final apiURL = Uri.parse(url + InstallerConstants.groupsURL);
    var response = await client.post(
      apiURL,
      headers: {
        InstallerConstants.headerContentType:
            InstallerConstants.headerApplicationJson,
        InstallerConstants.authorization:
            InstallerConstants.bearerToken(token: token)
      },
      body: jsonEncode({
        InstallerConstants.groupID: groupId,
        if (description != null)
          InstallerConstants.groupDescription: description
      }),
    );

    String source = const Utf8Decoder().convert(response.bodyBytes);

    HTTPError.checkHTTPStatusCode(response, response.body);

    BaseResponse<Group> createGroupResponse = BaseResponse.fromJson(
        json.decode(source),
        (data) => Group.fromJson(data as Map<String, dynamic>));

    Group createdGroup = createGroupResponse.data!;
    return createdGroup;
  }
}
