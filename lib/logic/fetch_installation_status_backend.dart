import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/protocol/installation_status.dart';
import '../installer_error_model.dart';
import '../protocol/base_response.dart';

class FetchInstallationStatusBackend {
  final http.Client client;

  const FetchInstallationStatusBackend(this.client);

  Future<List<InstallationStatus>> fetchInstallationStatus({
    required String url,
    required String token,
    required String deviceId,
  }) async {
    final apiURL = Uri.parse(
        url + InstallerConstants.installationStatusURL(deviceId: deviceId));
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

    BaseResponse<Iterable<InstallationStatus>> installationStatusListResponse =
        BaseResponse.fromJson(
            json.decode(response.body),
            (data) => (data as List<dynamic>)
                .map((e) => InstallationStatus.fromJson(e)));

    List<InstallationStatus> installationStatuses =
        installationStatusListResponse.data!.toList();
    return installationStatuses;
  }
}
