import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/logic/delete_group_backend.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/logic/set_device_group_backend.dart';
import 'package:thingsee_installer/logic/set_installation_status_backend.dart';
import '../../../installer_error_model.dart';
import '../../../protocol/error_message.dart';
import '../../../protocol/group.dart';
import '../../../protocol/stack_identifier.dart';
import '../../test_stack_backend.dart';

part 'delete_group_state.dart';

class DeleteGroupCubit extends Cubit<DeleteGroupState> {
  final TestStackBackend loginBackend;
  final DeleteGroupBackend deleteGroupBackend;
  final SetInstallationStatusBackend setInstallationStatusBackend;
  final SetDeviceGroupBackend setDeviceGroupBackend;

  final ValueNotifier<InstallerErrorModel?> errorNotifier;
  DeleteGroupCubit(
      this.loginBackend,
      this.deleteGroupBackend,
      this.setInstallationStatusBackend,
      this.setDeviceGroupBackend,
      this.errorNotifier)
      : super(const DeleteGroupInitial());

  Future<void> deleteGroup(
      {required StackIdentifier stack,
      required String groupId,
      required List<String> devicesinGroup}) async {
    emit(const DeleteGroupInProgress());
    try {
      Group deletedGroup;
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

      // First we need to remove all the devices in group
      // Set installation status to 'unistalled' and group to 'unassigned'
      if (devicesinGroup.isNotEmpty) {
        for (final thingID in devicesinGroup) {
          await setInstallationStatusBackend.setInstallationStatus(
              url: stack.apiURL!,
              token: token,
              newStatus: InstallerConstants.uninstalled,
              deviceId: thingID);
          await setDeviceGroupBackend.setDeviceGroup(
              url: stack.apiURL!,
              token: token,
              groupId: InstallerConstants.unassigned,
              deviceId: thingID);
        }
      }
      // Then we can delete group

      deletedGroup = await deleteGroupBackend.deleteGroup(
          url: stack.apiURL!, token: token, groupId: groupId);
      if (!isClosed) {
        emit(DeleteGroupSuccess(deletedGroup));
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
          deleteGroup(
              stack: stack, groupId: groupId, devicesinGroup: devicesinGroup);
        } catch (e) {
          final errorModel = InstallerErrorModel(exception.errorMessage,
              ErrorOrigin.deleteGroup, ErrorType.httpError);
          errorNotifier.value = errorModel;
          emit(const DeleteGroupFailed());
        }
      } else {
        print(exception);
        final errorModel = InstallerErrorModel(exception.errorMessage,
            ErrorOrigin.deleteGroup, ErrorType.httpError);
        errorNotifier.value = errorModel;
        emit(const DeleteGroupFailed());
      }
    } catch (exception) {
      print(exception);

      final errorModel = InstallerErrorModel(
          ErrorMessage(null, exception.toString(), ""),
          ErrorOrigin.deleteGroup,
          ErrorType.contentError);
      errorNotifier.value = errorModel;
      emit(const DeleteGroupFailed());
    }
  }
}
