import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:thingsee_installer/logic/create_group_backend.dart';
import 'package:thingsee_installer/protocol/error_message.dart';
import 'package:thingsee_installer/protocol/group.dart';

import '../../../installer_error_model.dart';
import '../../../protocol/stack_identifier.dart';
import '../../installer_user_repository.dart';
import '../../test_stack_backend.dart';

part 'create_group_state.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  final TestStackBackend loginBackend;
  final CreateGroupBackend createGroupBackend;
  final ValueNotifier<InstallerErrorModel?> errorNotifier;
  CreateGroupCubit(
      this.loginBackend, this.createGroupBackend, this.errorNotifier)
      : super(const CreateGroupInitial());

  Future<void> createNewGroup(
      {required StackIdentifier stack,
      required String groupId,
      required String? description}) async {
    emit(const CreateGroupInProgress());
    try {
      var newGroup;
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

      newGroup = await createGroupBackend.createGroup(
          url: stack.apiURL!,
          token: token,
          groupId: groupId,
          description: description);
      if (!isClosed) {
        emit(CreateGroupSuccess(newGroup));
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
          createNewGroup(
              stack: stack, groupId: groupId, description: description);
        } catch (e) {
          final errorModel = InstallerErrorModel(exception.errorMessage,
              ErrorOrigin.createGroup, ErrorType.httpError);
          errorNotifier.value = errorModel;
          emit(const CreateGroupFailed());
        }
      } else {
        print(exception);
        final errorModel = InstallerErrorModel(exception.errorMessage,
            ErrorOrigin.createGroup, ErrorType.httpError);
        errorNotifier.value = errorModel;
        emit(const CreateGroupFailed());
      }
    } catch (exception) {
      print(exception);

      final errorModel = InstallerErrorModel(
          ErrorMessage(null, exception.toString(), ""),
          ErrorOrigin.createGroup,
          ErrorType.contentError);
      errorNotifier.value = errorModel;
      emit(const CreateGroupFailed());
    }
  }
}
