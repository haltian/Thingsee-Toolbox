import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/protocol/group.dart';
import '../installer_error_model.dart';
import '../protocol/base_response.dart';

class DeleteGroupBackend {
  final http.Client client;

  const DeleteGroupBackend(this.client);

  Future<Group> deleteGroup(
      {required String url,
      required String token,
      required String groupId}) async {
    final apiURL = Uri.parse(
        url + InstallerConstants.groupsURLwithGroupID(groupId: groupId));
    final response = await client.delete(
      apiURL,
      headers: {
        InstallerConstants.headerContentType:
            InstallerConstants.headerApplicationJson,
        InstallerConstants.authorization:
            InstallerConstants.bearerToken(token: token)
      },
    );
    HTTPError.checkHTTPStatusCode(response, response.body);

    BaseResponse<Group> deleteGroupResponse = BaseResponse.fromJson(
        json.decode(response.body),
        (data) => Group.fromJson(data as Map<String, dynamic>));

    Group createdGroup = deleteGroupResponse.data!;
    return createdGroup;
  }
}
