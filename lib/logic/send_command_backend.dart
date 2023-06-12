import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/protocol/commands_response.dart';
import '../installer_error_model.dart';
import '../protocol/base_response.dart';
import '../protocol/device_command.dart';

class SendCommandBackend {
  final http.Client client;

  const SendCommandBackend(this.client);

  Future<List<DeviceCommand>> sendCommand(
      {required String url,
      required String token,
      required String deviceId,
      required List<DeviceCommand> commands}) async {
    final apiURL =
        Uri.parse(url + InstallerConstants.SendCommandsURL(deviceId: deviceId));
    final response = await client.post(apiURL,
        headers: {
          InstallerConstants.headerContentType:
              InstallerConstants.headerApplicationJson,
          InstallerConstants.authorization:
              InstallerConstants.bearerToken(token: token)
        },
        body: jsonEncode(commands).toString());
    HTTPError.checkHTTPStatusCode(response, response.body);

    BaseResponse<CommandsResponse> commandResponse = BaseResponse.fromJson(
        json.decode(response.body),
        (data) => CommandsResponse.fromJson(data as Map<String, dynamic>));
    List<DeviceCommand> updatedCommands =
        commandResponse.data!.commands!.toList();

    return updatedCommands;
  }

  // To fetch all commands use limit value 0
  Future<List<CommandsResponse>> fetchCommands(
      {required String url,
      required String token,
      required String deviceId,
      required int limit}) async {
    final apiURL = Uri.parse(url +
        InstallerConstants.fetchCommandsURL(deviceId: deviceId, limit: limit));
    final response = await client.get(apiURL, headers: {
      InstallerConstants.headerContentType:
          InstallerConstants.headerApplicationJson,
      InstallerConstants.authorization:
          InstallerConstants.bearerToken(token: token)
    });
    HTTPError.checkHTTPStatusCode(response, response.body);

    BaseResponse<Iterable<CommandsResponse>> commandResponse =
        BaseResponse.fromJson(
            json.decode(response.body),
            (data) => (data as List<dynamic>)
                .map((e) => CommandsResponse.fromJson(e)));

    List<CommandsResponse> listOfCommands = commandResponse.data!.toList();
    return listOfCommands;
  }
}
