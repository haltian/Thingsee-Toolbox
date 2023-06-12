import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thingsee_installer/protocol/error_message.dart';
import 'package:thingsee_installer/protocol/stack_identifier.dart';

import 'logic/installer_user_repository.dart';
import 'logic/test_stack_backend.dart';

enum ErrorOrigin {
  testStack,
  groupList,
  deviceList,
  createGroup,
  deleteGroup,
  editGroup,
  deviceInfo,
  installationStatus,
  sendCommand,
  deviceMessages,
  deviceGroup,
  fetchCommands
}

enum ErrorType { connectionError, httpError, contentError, platFormError }

class TokenRefreshHandler {
  Future<void> handleTokenRefreshingError(
      Function() method,
      Function() emitError,
      StackIdentifier stack,
      TestStackBackend loginBackend) async {
    try {
      final token = await loginBackend.testStack(
        url: stack.apiURL!,
        clientId: stack.clientId,
        secret: stack.secret!,
      );
      InstallerUserRepository().setToken(token.token);
      method;
    } catch (e) {
      emitError;
    }
  }
}

class InstallerErrorModel extends Equatable {
  final ErrorMessage? errorMessage;
  final ErrorOrigin? origin;
  final ErrorType type;

  const InstallerErrorModel(this.errorMessage, this.origin, this.type);

  static const int unauthrorized = 401;
  static const int forbidden = 403;
  static const int badRequest = 400;
  static const int notFound = 404;
  static const int cannotReadProperty = 500;
  static const int conflict = 409;
  static const int timing = 504;

  String _formatErrorType(BuildContext context) {
    switch (type) {
      case ErrorType.connectionError:
        return errorMessage!.error ??
            AppLocalizations.of(context)!.problemConnectingToServers;
      case ErrorType.httpError:
        return errorMessage!.error ??
            AppLocalizations.of(context)!.somethingWentWrong;
      case ErrorType.contentError:
        return errorMessage!.error ??
            AppLocalizations.of(context)!.somethingWentWrong;
      case ErrorType.platFormError:
        return "";
    }
  }

  String formatError(BuildContext context) {
    switch (errorMessage!.statusCode) {
      case InstallerErrorModel.cannotReadProperty:
      case InstallerErrorModel.forbidden:
      case InstallerErrorModel.badRequest:
      case InstallerErrorModel.notFound:
      case InstallerErrorModel.conflict:
      case InstallerErrorModel.unauthrorized:
      case InstallerErrorModel.timing:
    }
    return _formatErrorType(context);
  }

  @override
  List<Object?> get props => [errorMessage, origin];
}

class HTTPError implements Exception {
  final ErrorMessage? errorMessage;
  const HTTPError(this.errorMessage);
  @override
  String toString() => errorMessage.toString();
  static void checkHTTPStatusCode(http.Response response, String responseBody) {
    final error = ErrorMessage.fromJson(jsonDecode(responseBody));
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        break;
      default:
        throw HTTPError(
            ErrorMessage(error.statusCode, error.error, error.message));
    }
  }
}

class ContentError implements Exception {
  final ErrorMessage? errorMessage;

  const ContentError(this.errorMessage);
  @override
  String toString() =>
      'Message: ' +
      (errorMessage!.message == null ? 'no message' : errorMessage!.message!) +
      ' code: ' +
      (errorMessage!.statusCode == null
          ? 'no code'
          : errorMessage!.statusCode.toString()) +
      ' body: ' +
      (errorMessage!.error == null
          ? 'no error'
          : errorMessage!.error.toString());
}
