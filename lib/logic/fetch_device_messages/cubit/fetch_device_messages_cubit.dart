import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../../../installer_error_model.dart';
import '../../../protocol/device_messages.dart';
import '../../../protocol/error_message.dart';
import '../../../protocol/stack_identifier.dart';
import '../../fetch_device_messages_backend.dart';
import '../../installer_user_repository.dart';
import '../../test_stack_backend.dart';

part 'fetch_device_messages_state.dart';

class FetchDeviceMessagesCubit extends Cubit<FetchDeviceMessagesState> {
  final TestStackBackend loginBackend;
  final FetchDeviceMessagesBackend deviceMessagesBackend;
  final ValueNotifier<InstallerErrorModel?> errorNotifier;

  FetchDeviceMessagesCubit(
      this.loginBackend, this.deviceMessagesBackend, this.errorNotifier)
      : super(const FetchDeviceMessagesInitial());

  Future<void> FetchDeviceMessages(
      {required StackIdentifier stack,
      required String deviceId,
      required int limit}) async {
    emit(const FetchDeviceMessagesInProgress());
    try {
      var messageList;
      String? token;
      token = await InstallerUserRepository().getToken();
      if (token == null) {
        print(token);
        final newToken = await loginBackend.testStack(
          url: stack.apiURL!,
          clientId: stack.clientId,
          secret: stack.secret!,
        );
        token = newToken.token;
        InstallerUserRepository().setToken(token);
      }
      messageList = await deviceMessagesBackend.fetchDeviceMessages(
        url: stack.apiURL!,
        token: token,
        deviceId: deviceId,
        limit: limit,
      );
      if (!isClosed) {
        emit(FetchDeviceMessagesSuccess(messageList));
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
          FetchDeviceMessages(stack: stack, deviceId: deviceId, limit: limit);
        } catch (e) {
          final errorModel = InstallerErrorModel(exception.errorMessage,
              ErrorOrigin.deviceMessages, ErrorType.httpError);
          errorNotifier.value = errorModel;
          emit(const FetchDeviceMessagesFailed());
        }
      } else if (!isClosed) {
        final errorModel = InstallerErrorModel(exception.errorMessage,
            ErrorOrigin.deviceMessages, ErrorType.httpError);
        errorNotifier.value = errorModel;
        emit(const FetchDeviceMessagesFailed());
      }
    } catch (exception) {
      print("e: " + exception.toString());

      final errorModel = InstallerErrorModel(
          ErrorMessage(null, exception.toString(), ""),
          ErrorOrigin.deviceMessages,
          ErrorType.contentError);
      errorNotifier.value = errorModel;
      emit(const FetchDeviceMessagesFailed());
    }
  }
}
