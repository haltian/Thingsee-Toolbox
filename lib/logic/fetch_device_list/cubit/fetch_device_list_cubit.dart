import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/protocol/device_list_response.dart';
import 'package:thingsee_installer/protocol/stack_identifier.dart';
import '../../../installer_error_model.dart';
import '../../../protocol/error_message.dart';
import '../../fetch_device_list_backend.dart';
import '../../test_stack_backend.dart';

part 'fetch_device_list_state.dart';

class FetchDeviceListCubit extends Cubit<FetchDeviceListState> {
  final TestStackBackend loginBackend;
  final FetchDeviceListBackend deviceListBackend;
  final ValueNotifier<InstallerErrorModel?> errorNotifier;
  FetchDeviceListCubit(
      this.loginBackend, this.deviceListBackend, this.errorNotifier)
      : super(const FetchDeviceListInitial());

  Future<void> fetchDeviceList(
      {required StackIdentifier stack, required String groupId}) async {
    emit(const FetchDeviceListInProgress());
    try {
      var devices;
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
      devices = await deviceListBackend.fetchDeviceList(
          url: stack.apiURL!, token: token, groupId: groupId);

      if (!isClosed) {
        emit(FetchDeviceListSuccess(devices));
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
          fetchDeviceList(stack: stack, groupId: groupId);
        } catch (e) {
          final errorModel = InstallerErrorModel(exception.errorMessage,
              ErrorOrigin.deviceList, ErrorType.httpError);
          errorNotifier.value = errorModel;
          emit(const FetchDeviceListFailed());
        }
      } else {
        print(exception);
        final errorModel = InstallerErrorModel(exception.errorMessage,
            ErrorOrigin.deviceList, ErrorType.httpError);
        errorNotifier.value = errorModel;
        emit(const FetchDeviceListFailed());
      }
    } catch (exception) {
      print("e: " + exception.toString());

      final errorModel = InstallerErrorModel(
          ErrorMessage(null, exception.toString(), ""),
          ErrorOrigin.deviceList,
          ErrorType.contentError);
      errorNotifier.value = errorModel;
      emit(const FetchDeviceListFailed());
    }
  }
}
