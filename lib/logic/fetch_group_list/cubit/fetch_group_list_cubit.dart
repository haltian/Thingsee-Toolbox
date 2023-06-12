import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:thingsee_installer/installer_error_model.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/logic/test_stack_backend.dart';
import 'package:thingsee_installer/protocol/error_message.dart';
import 'package:thingsee_installer/protocol/group.dart';
import 'package:thingsee_installer/protocol/stack_identifier.dart';

import '../../fetch_group_list_backend.dart';

part 'fetch_group_list_state.dart';

class FetchGroupListCubit extends Cubit<FetchGroupListState> {
  final TestStackBackend loginBackend;
  final FetchGroupListBackend groupListBackend;
  final ValueNotifier<InstallerErrorModel?> errorNotifier;
  FetchGroupListCubit(
      this.loginBackend, this.groupListBackend, this.errorNotifier)
      : super(const FetchGroupListInitial());
  Future<void> fetchGroupList({required StackIdentifier stack}) async {
    emit(const FetchGroupListInProgress());
    try {
      var groupList;
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

      groupList = await groupListBackend.fetchGroupList(
          url: stack.apiURL!, token: token);

      if (!isClosed) {
        emit(FetchGroupListSuccess(groupList));
      }
    } on HTTPError catch (exception) {
      print(exception.errorMessage!.statusCode);

      if (exception.errorMessage!.statusCode ==
          InstallerErrorModel.unauthrorized) {
        try {
          final token = await loginBackend.testStack(
            url: stack.apiURL!,
            clientId: stack.clientId,
            secret: stack.secret!,
          );
          InstallerUserRepository().setToken(token.token);
          fetchGroupList(stack: stack);
        } catch (e) {
          final errorModel = InstallerErrorModel(exception.errorMessage,
              ErrorOrigin.groupList, ErrorType.httpError);
          errorNotifier.value = errorModel;
          emit(const FetchGroupListFailed());
        }
      } else {
        print(exception);
        final errorModel = InstallerErrorModel(
            exception.errorMessage, ErrorOrigin.groupList, ErrorType.httpError);
        errorNotifier.value = errorModel;
        emit(const FetchGroupListFailed());
      }
    } catch (exception) {
      print(exception);

      final errorModel = InstallerErrorModel(
          ErrorMessage(null, exception.toString(), exception.toString()),
          ErrorOrigin.groupList,
          ErrorType.contentError);
      errorNotifier.value = errorModel;
      emit(const FetchGroupListFailed());
    }
  }
}
