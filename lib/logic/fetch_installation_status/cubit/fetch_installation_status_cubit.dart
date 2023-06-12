import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:thingsee_installer/logic/fetch_installation_status_backend.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/logic/test_stack_backend.dart';
import 'package:thingsee_installer/protocol/installation_status.dart';
import 'package:thingsee_installer/protocol/stack_identifier.dart';

import '../../../installer_error_model.dart';
import '../../../protocol/error_message.dart';

part 'fetch_installation_status_state.dart';

class FetchInstallationStatusCubit extends Cubit<FetchInstallationStatusState> {
  final TestStackBackend loginBackend;
  final FetchInstallationStatusBackend installationStatusBackend;
  final ValueNotifier<InstallerErrorModel?> errorNotifier;

  FetchInstallationStatusCubit(
      this.loginBackend, this.installationStatusBackend, this.errorNotifier)
      : super(const FetchInstallationStatusInitial());
  Future<void> fetchInsatllationStatus(
      {required StackIdentifier stack, required String deviceID}) async {
    emit(const FetchInstallationStatusInProgress());
    try {
      List<InstallationStatus> installationStatus;
      String? token;
      token = await InstallerUserRepository().getToken();
      if (token == null) {
        final newToken = await loginBackend.testStack(
          url: stack.apiURL!,
          clientId: stack.clientId,
          secret: stack.secret!,
        );
        token = newToken.token;
        InstallerUserRepository().setToken(token);
      }
      installationStatus =
          await installationStatusBackend.fetchInstallationStatus(
              url: stack.apiURL!, token: token, deviceId: deviceID);
      if (!isClosed) {
        emit(FetchInstallationStatusSuccess(installationStatus));
      }
    } on HTTPError catch (exception) {
      if (exception.errorMessage!.statusCode ==
          InstallerErrorModel.unauthrorized) {
        try {
          final token = await loginBackend.testStack(
            url: stack.apiURL!,
            clientId: stack.clientId,
            secret: stack.secret!,
          );
          InstallerUserRepository().setToken(token.token);
          fetchInsatllationStatus(stack: stack, deviceID: deviceID);
        } catch (e) {
          final errorModel = InstallerErrorModel(exception.errorMessage,
              ErrorOrigin.deviceInfo, ErrorType.httpError);
          errorNotifier.value = errorModel;
          emit(const FetchInstallationStatusFailed());
        }
      } else if (!isClosed) {
        print(exception);
        final errorModel = InstallerErrorModel(exception.errorMessage,
            ErrorOrigin.deviceInfo, ErrorType.httpError);
        errorNotifier.value = errorModel;
        emit(const FetchInstallationStatusFailed());
      }
    } catch (exception) {
      print(exception);
      final errorModel = InstallerErrorModel(
          ErrorMessage(null, exception.toString(), ""),
          ErrorOrigin.deviceInfo,
          ErrorType.contentError);
      errorNotifier.value = errorModel;

      emit(const FetchInstallationStatusFailed());
    }
  }
}
