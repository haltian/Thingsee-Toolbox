import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/protocol/device_group.dart';
import '../installer_error_model.dart';
import '../protocol/base_response.dart';

class FetchGroupBackend {
  final http.Client client;

  const FetchGroupBackend(this.client);

  Future<DeviceGroup> fetchGroup({
    required String url,
    required String token,
    required String deviceId,
  }) async {
    final apiURL =
        Uri.parse(url + InstallerConstants.thingGroupURL(deviceId: deviceId));
    final response = await client.get(
      apiURL,
      headers: {
        InstallerConstants.headerContentType:
            InstallerConstants.headerApplicationJson,
        InstallerConstants.authorization:
            InstallerConstants.bearerToken(token: token)
      },
    );
    HTTPError.checkHTTPStatusCode(response, response.body);

    BaseResponse<DeviceGroup> groupResponse = BaseResponse.fromJson(
        json.decode(response.body),
        (data) => DeviceGroup.fromJson(data as Map<String, dynamic>));

    DeviceGroup deviceGroup = groupResponse.data!;
    return deviceGroup;
  }
}
