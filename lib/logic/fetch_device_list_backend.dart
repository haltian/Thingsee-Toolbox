import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/protocol/device_list_response.dart';
import '../installer_error_model.dart';
import '../protocol/base_response.dart';

class FetchDeviceListBackend {
  final http.Client client;

  const FetchDeviceListBackend(this.client);

  Future<DeviceListResponse> fetchDeviceList(
      {required String url,
      required String token,
      required String groupId}) async {
    final apiURL = Uri.parse(
        url + InstallerConstants.deviceListwithGroupIdURL(groupId: groupId));
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

    BaseResponse<DeviceListResponse> deviceListResponse = BaseResponse.fromJson(
        json.decode(response.body),
        (data) => DeviceListResponse.fromJson(data as Map<String, dynamic>));

    DeviceListResponse deviceResponse = deviceListResponse.data!;
    return deviceResponse;
  }
}
