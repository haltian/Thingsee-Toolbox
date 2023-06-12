import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/protocol/installation_status.dart';
import '../installer_error_model.dart';
import '../protocol/base_response.dart';

class SetInstallationStatusBackend {
  final http.Client client;

  const SetInstallationStatusBackend(this.client);

  Future<InstallationStatus> setInstallationStatus(
      {required String url,
      required String token,
      required String newStatus,
      required String deviceId}) async {
    final apiURL = Uri.parse(
        url + InstallerConstants.installationStatusSetURL(deviceId: deviceId));
    final response = await client.post(
      apiURL,
      headers: {
        InstallerConstants.headerContentType:
            InstallerConstants.headerApplicationJson,
        InstallerConstants.authorization:
            InstallerConstants.bearerToken(token: token)
      },
      body: jsonEncode({
        InstallerConstants.installationStatus: newStatus,
      }),
    );
    HTTPError.checkHTTPStatusCode(response, response.body);

    BaseResponse<InstallationStatus> setStatusResponse = BaseResponse.fromJson(
        json.decode(response.body),
        (data) => InstallationStatus.fromJson(data as Map<String, dynamic>));

    InstallationStatus installationStatus = setStatusResponse.data!;
    return installationStatus;
  }
}
