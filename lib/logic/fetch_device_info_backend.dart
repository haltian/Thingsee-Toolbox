import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/protocol/device_info.dart';
import '../installer_error_model.dart';
import '../protocol/base_response.dart';

class FetchDeviceInfoBackend {
  final http.Client client;

  const FetchDeviceInfoBackend(this.client);

  Future<DeviceInfo> fetchDeviceInfo({
    required String url,
    required String token,
    required String deviceId,
  }) async {
    final apiURL =
        Uri.parse(url + InstallerConstants.deviceInfoURL(deviceId: deviceId));
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

    BaseResponse<DeviceInfo> deviceInfoResponse = BaseResponse.fromJson(
        json.decode(response.body),
        (data) => DeviceInfo.fromJson(data as Map<String, dynamic>));

    DeviceInfo deviceInfo = deviceInfoResponse.data!;
    return deviceInfo;
  }
}
