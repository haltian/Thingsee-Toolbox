import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:thingsee_installer/installer_error_model.dart';
import 'package:thingsee_installer/logic/fetch_group_backend.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/logic/test_stack_backend.dart';
import 'package:thingsee_installer/protocol/device_group.dart';
import 'package:thingsee_installer/protocol/stack_identifier.dart';
import '../../../protocol/error_message.dart';
part 'fetch_group_state.dart';

class FetchGroupCubit extends Cubit<FetchGroupState> {
  final TestStackBackend loginBackend;
  final ValueNotifier<InstallerErrorModel?> errorNotifier;
  final FetchGroupBackend backend;

  FetchGroupCubit(this.loginBackend, this.errorNotifier, this.backend)
      : super(const FetchGroupInitial());

  Future<void> fetchGroup(
      {required StackIdentifier stack, required String deviceID}) async {
    emit(const FetchGroupInProgress());
    try {
      DeviceGroup groupID;
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
      groupID = await backend.fetchGroup(
          url: stack.apiURL!, token: token, deviceId: deviceID);
      if (!isClosed) {
        emit(FetchGroupSuccess(groupID));
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
          fetchGroup(stack: stack, deviceID: deviceID);
        } catch (e) {
          final errorModel = InstallerErrorModel(exception.errorMessage,
              ErrorOrigin.deviceGroup, ErrorType.httpError);
          errorNotifier.value = errorModel;
          emit(const FetchGroupFailed());
        }
      } else if (!isClosed) {
        final errorModel = InstallerErrorModel(exception.errorMessage,
            ErrorOrigin.deviceGroup, ErrorType.httpError);
        errorNotifier.value = errorModel;
        emit(const FetchGroupFailed());
      }
    } catch (exception) {
      if (exception is FormatException) {
        final errorModel = InstallerErrorModel(
            ErrorMessage(
                null, exception.toString(), exception.message.toString()),
            ErrorOrigin.deviceGroup,
            ErrorType.platFormError);
        errorNotifier.value = errorModel;
      } else {
        final errorModel = InstallerErrorModel(
            ErrorMessage(null, exception.toString(), exception.toString()),
            ErrorOrigin.deviceGroup,
            ErrorType.contentError);
        errorNotifier.value = errorModel;
      }
      emit(const FetchGroupFailed());
    }
  }
}
