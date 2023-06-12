import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:thingsee_installer/installer_error_model.dart';
import 'package:thingsee_installer/logic/edit_group_backend.dart';
import 'package:thingsee_installer/protocol/group.dart';

import '../../../protocol/error_message.dart';
import '../../../protocol/stack_identifier.dart';
import '../../installer_user_repository.dart';
import '../../test_stack_backend.dart';

part 'edit_group_state.dart';

class EditGroupCubit extends Cubit<EditGroupState> {
  final TestStackBackend loginBackend;
  final EditGroupBackend editGroupBackend;
  final ValueNotifier<InstallerErrorModel?> errorNotifier;
  EditGroupCubit(this.loginBackend, this.editGroupBackend, this.errorNotifier)
      : super(const EditGroupInitial());

  Future<void> editGroup(
      {required StackIdentifier stack,
      required String oldGroupId,
      required String newGroupId}) async {
    emit(const EditGroupInProgress());
    try {
      Group editedGroup;
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
      editedGroup = await editGroupBackend.editGroup(
          url: stack.apiURL!,
          token: token,
          oldGroupId: oldGroupId,
          newGroupId: newGroupId);
      if (!isClosed) {
        emit(EditGroupSuccess(editedGroup));
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
          editGroup(
              stack: stack, oldGroupId: oldGroupId, newGroupId: newGroupId);
        } catch (e) {
          final errorModel = InstallerErrorModel(exception.errorMessage,
              ErrorOrigin.editGroup, ErrorType.httpError);
          errorNotifier.value = errorModel;
          emit(const EditGroupFailed());
        }
      } else {
        print(exception);
        final errorModel = InstallerErrorModel(
            exception.errorMessage, ErrorOrigin.editGroup, ErrorType.httpError);
        errorNotifier.value = errorModel;
        emit(const EditGroupFailed());
      }
    } catch (exception) {
      print(exception);

      final errorModel = InstallerErrorModel(
          ErrorMessage(null, exception.toString(), ""),
          ErrorOrigin.editGroup,
          ErrorType.contentError);
      errorNotifier.value = errorModel;
      emit(const EditGroupFailed());
    }
  }
}
