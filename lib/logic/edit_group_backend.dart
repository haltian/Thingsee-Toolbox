import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/protocol/group.dart';
import '../installer_error_model.dart';
import '../protocol/base_response.dart';

class EditGroupBackend {
  final http.Client client;

  const EditGroupBackend(this.client);

  Future<Group> editGroup(
      {required String url,
      required String token,
      required String oldGroupId,
      required String newGroupId}) async {
    final apiURL =
        Uri.parse(url + InstallerConstants.editGroupURL(groupId: oldGroupId));
    final response = await client.post(apiURL,
        headers: {
          InstallerConstants.headerContentType:
              InstallerConstants.headerApplicationJson,
          InstallerConstants.authorization:
              InstallerConstants.bearerToken(token: token)
        },
        body: jsonEncode({
          InstallerConstants.groupID: newGroupId,
        }));
    HTTPError.checkHTTPStatusCode(response, response.body);

    BaseResponse<Group> editGroupResponse = BaseResponse.fromJson(
        json.decode(response.body),
        (data) => Group.fromJson(data as Map<String, dynamic>));

    Group editedGroup = editGroupResponse.data!;
    return editedGroup;
  }
}
