import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:thingsee_installer/logic/set_device_group_backend.dart';
import 'package:thingsee_installer/logic/set_installation_status_backend.dart';
import 'package:thingsee_installer/logic/test_stack_backend.dart';
import 'package:thingsee_installer/protocol/installation_status.dart';
import '../../../installer_error_model.dart';
import '../../../protocol/error_message.dart';
import '../../../protocol/stack_identifier.dart';
import '../../installer_user_repository.dart';
part 'set_installation_status_state.dart';

class SetInstallationStatusCubit extends Cubit<SetInstallationStatusState> {
  final TestStackBackend loginBackend;
  final SetInstallationStatusBackend setInstallationStatusBackend;
  final SetDeviceGroupBackend setDeviceGroupBackend;
  final ValueNotifier<InstallerErrorModel?> errorNotifier;

  SetInstallationStatusCubit(
      this.loginBackend,
      this.setInstallationStatusBackend,
      this.setDeviceGroupBackend,
      this.errorNotifier)
      : super(const SetInstallationStatusInitial());

  Future<void> setInstallationStatus(
      {required StackIdentifier stack,
      required String? newStatus,
      required String deviceId,
      required String groupId}) async {
    emit(const SetInstallationStatusInProgress());
    try {
      InstallationStatus? newInstallationStatus;
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

      // If new status is given, then update it
      if (newStatus != null) {
        newInstallationStatus =
            await setInstallationStatusBackend.setInstallationStatus(
                url: stack.apiURL!,
                token: token,
                newStatus: newStatus,
                deviceId: deviceId);
      }

      final groupForDevice = await setDeviceGroupBackend.setDeviceGroup(
          url: stack.apiURL!,
          token: token,
          groupId: groupId,
          deviceId: deviceId);

      if (!isClosed) {
        if (newStatus != null) {
          emit(SetInstallationStatusSuccess(InstallationStatus(
              groupForDevice.tuid,
              newInstallationStatus!.installation_status,
              groupForDevice.group_id)));
        } else {
          emit(SetInstallationStatusSuccess(InstallationStatus(
              groupForDevice.tuid, null, groupForDevice.group_id)));
        }
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
          setInstallationStatus(
              stack: stack,
              newStatus: newStatus,
              deviceId: deviceId,
              groupId: groupId);
        } catch (e) {
          final errorModel = InstallerErrorModel(exception.errorMessage,
              ErrorOrigin.installationStatus, ErrorType.httpError);
          errorNotifier.value = errorModel;
          emit(const SetInstallationStatusFailed());
        }
      } else {
        print(exception);
        final errorModel = InstallerErrorModel(exception.errorMessage,
            ErrorOrigin.installationStatus, ErrorType.httpError);
        errorNotifier.value = errorModel;
        emit(const SetInstallationStatusFailed());
      }
    } catch (exception) {
      print(exception);

      final errorModel = InstallerErrorModel(
          ErrorMessage(null, exception.toString(), exception.toString()),
          ErrorOrigin.installationStatus,
          ErrorType.contentError);
      errorNotifier.value = errorModel;
      emit(const SetInstallationStatusFailed());
    }
  }
}
