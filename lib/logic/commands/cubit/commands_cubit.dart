import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:thingsee_installer/logic/commands/cubit/commands_state.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/logic/send_command_backend.dart';
import 'package:thingsee_installer/protocol/device_command.dart';
import '../../../installer_error_model.dart';
import '../../../protocol/error_message.dart';
import '../../../protocol/stack_identifier.dart';
import '../../test_stack_backend.dart';

class CommandsCubit extends Cubit<CommandsState> {
  final TestStackBackend loginBackend;
  final SendCommandBackend commandsBackend;
  final ValueNotifier<InstallerErrorModel?> errorNotifier;

  CommandsCubit(this.loginBackend, this.commandsBackend, this.errorNotifier)
      : super(const CommandInitial());

  Future<void> sendCommands(
      {required StackIdentifier stack,
      required String deviceId,
      required List<DeviceCommand> commands}) async {
    emit(const CommandInProgress(true));
    try {
      var updatedCommands;
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

      updatedCommands = await commandsBackend.sendCommand(
          url: stack.apiURL!,
          token: token,
          deviceId: deviceId,
          commands: commands);
      if (!isClosed) {
        emit(CommandSuccess(updatedCommands, null));
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
          sendCommands(stack: stack, deviceId: deviceId, commands: commands);
        } catch (e) {
          final errorModel = InstallerErrorModel(exception.errorMessage,
              ErrorOrigin.sendCommand, ErrorType.httpError);
          errorNotifier.value = errorModel;
          emit(const CommandFailed());
        }
      } else {
        print(exception);
        final errorModel = InstallerErrorModel(exception.errorMessage,
            ErrorOrigin.sendCommand, ErrorType.httpError);
        errorNotifier.value = errorModel;
        emit(const CommandFailed());
      }
    } catch (exception) {
      final errorModel = InstallerErrorModel(
          ErrorMessage(null, exception.toString(), exception.toString()),
          ErrorOrigin.sendCommand,
          ErrorType.contentError);
      errorNotifier.value = errorModel;
      emit(const CommandFailed());
    }
  }

  Future<void> fetchAllCommands(
      {required StackIdentifier stack,
      required String deviceId,
      required int limit}) async {
    emit(const CommandInProgress(false));
    try {
      var allCommands;
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

      allCommands = await commandsBackend.fetchCommands(
          url: stack.apiURL!, token: token, deviceId: deviceId, limit: limit);
      if (!isClosed) {
        emit(CommandSuccess(null, allCommands));
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
          fetchAllCommands(stack: stack, deviceId: deviceId, limit: limit);
        } catch (e) {
          final errorModel = InstallerErrorModel(exception.errorMessage,
              ErrorOrigin.fetchCommands, ErrorType.httpError);
          errorNotifier.value = errorModel;
          emit(const CommandFailed());
        }
      } else {
        print(exception);
        final errorModel = InstallerErrorModel(exception.errorMessage,
            ErrorOrigin.fetchCommands, ErrorType.httpError);
        errorNotifier.value = errorModel;
        emit(const CommandFailed());
      }
    } catch (exception) {
      print(exception);

      emit(const CommandFailed());
    }
  }
}
