import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:thingsee_installer/logic/fetch_device_info_backend.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/logic/test_stack_backend.dart';
import 'package:thingsee_installer/protocol/device_info.dart';
import 'package:thingsee_installer/protocol/stack_identifier.dart';
import '../../../installer_error_model.dart';
import '../../../protocol/error_message.dart';

part 'fetch_device_info_state.dart';

class FetchDeviceInfoCubit extends Cubit<FetchDeviceInfoState> {
  final TestStackBackend loginBackend;
  final FetchDeviceInfoBackend deviceInfoBackend;
  final ValueNotifier<InstallerErrorModel?> errorNotifier;

  FetchDeviceInfoCubit(
      this.loginBackend, this.deviceInfoBackend, this.errorNotifier)
      : super(const FetchDeviceInfoInitial());
  Future<void> fetchDeviceInfo(
      {required StackIdentifier stack, required String deviceID}) async {
    emit(const FetchDeviceInfoInProgress());
    try {
      var deviceInfo;
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
      deviceInfo = await deviceInfoBackend.fetchDeviceInfo(
          url: stack.apiURL!, token: token, deviceId: deviceID);
      if (!isClosed) {
        emit(FetchDeviceInfoSuccess(deviceInfo));
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
          fetchDeviceInfo(stack: stack, deviceID: deviceID);
        } catch (e) {
          final errorModel = InstallerErrorModel(exception.errorMessage,
              ErrorOrigin.deviceInfo, ErrorType.httpError);
          errorNotifier.value = errorModel;
          emit(const FetchDeviceInfoFailed());
        }
      } else if (!isClosed) {
        final errorModel = InstallerErrorModel(exception.errorMessage,
            ErrorOrigin.deviceInfo, ErrorType.httpError);
        errorNotifier.value = errorModel;
        emit(const FetchDeviceInfoFailed());
      }
    } catch (exception) {
      final errorModel = InstallerErrorModel(
          ErrorMessage(null, exception.toString(), ""),
          ErrorOrigin.deviceInfo,
          ErrorType.contentError);
      errorNotifier.value = errorModel;

      emit(const FetchDeviceInfoFailed());
    }
  }
}
