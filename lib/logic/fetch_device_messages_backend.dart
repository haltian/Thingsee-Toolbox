import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thingsee_installer/constants/installer_constants.dart';
import '../installer_error_model.dart';
import '../protocol/base_response.dart';
import '../protocol/device_messages.dart';

class FetchDeviceMessagesBackend {
  final http.Client client;

  const FetchDeviceMessagesBackend(this.client);

  Future<List<DeviceMessages>> fetchDeviceMessages(
      {required String url,
      required String token,
      required String deviceId,
      required int limit}) async {
    final apiURL = Uri.parse(url +
        InstallerConstants.deviceMessagesWithLimit(
            deviceId: deviceId, limit: limit));
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

    BaseResponse<Iterable<DeviceMessages>> deviceMessagesResponse =
        BaseResponse.fromJson(
            json.decode(response.body),
            (data) =>
                (data as List<dynamic>).map((e) => DeviceMessages.fromJson(e)));

    List<DeviceMessages> messages = deviceMessagesResponse.data!.toList();
    return messages;
  }
}
