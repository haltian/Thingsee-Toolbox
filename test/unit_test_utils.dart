import 'package:flutter/foundation.dart';
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/installer_error_model.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/protocol/stack_identifier.dart';

class UnitTestUtils {
  static const applicationId = 'applicationId';
  static const userId = 'userId';
  static const httpOK = 200;
  static const httpFailed = 404;
  static const testStackSuccessMessage = '{"data":{"token":"testToken"}}';
  static const testDefaultDuration = Duration(seconds: 1);

  InstallerUserRepository userRepository = InstallerUserRepository();

  static loginHeaders() {
    return {
      InstallerConstants.headerContentType:
          InstallerConstants.headerApplicationJson,
    };
  }

  static Future<StackIdentifier?> getActiveStack() async {
    return await InstallerUserRepository().getActiveStack();
  }

  static basicHeaders(String token) {
    return {
      InstallerConstants.headerContentType:
          InstallerConstants.headerApplicationJson,
      InstallerConstants.authorization:
          InstallerConstants.bearerToken(token: token),
    };
  }

  static ValueNotifier<InstallerErrorModel?> errorNotifier() {
    return ValueNotifier<InstallerErrorModel?>(null);
  }
}
