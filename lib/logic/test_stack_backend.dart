import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/protocol/installer_token.dart';

import '../installer_error_model.dart';
import '../protocol/base_response.dart';

class TestStackBackend {
  final http.Client client;

  const TestStackBackend(this.client);

  Future<InstallerToken> testStack({
    required String url,
    required String clientId,
    required String secret,
  }) async {
    final apiURL = Uri.parse(url + InstallerConstants.authURL);
    final response = await client.post(
      apiURL,
      headers: {
        InstallerConstants.headerContentType:
            InstallerConstants.headerApplicationJson,
      },
      body: jsonEncode({
        InstallerConstants.clientID: clientId,
        InstallerConstants.clientSecret: secret
      }),
    );
    HTTPError.checkHTTPStatusCode(response, response.body);

    BaseResponse<InstallerToken> testStackResponse = BaseResponse.fromJson(
        json.decode(response.body),
        (data) => InstallerToken.fromJson(data as Map<String, dynamic>));

    InstallerToken token = testStackResponse.data!;
    return token;
  }
}
