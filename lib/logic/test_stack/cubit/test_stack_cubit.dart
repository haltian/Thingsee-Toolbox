import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:thingsee_installer/installer_error_model.dart';
import 'package:thingsee_installer/protocol/error_message.dart';
import 'package:thingsee_installer/protocol/installer_token.dart';
import '../../test_stack_backend.dart';
part 'test_stack_state.dart';

class TestStackCubit extends Cubit<TestStackState> {
  final TestStackBackend backend;
  final ValueNotifier<InstallerErrorModel?> errorNotifier;
  TestStackCubit(this.backend, this.errorNotifier)
      : super(const TestStackInitial());

  Future<void> testStack(
      {required String url,
      required String clientId,
      required String secret}) async {
    emit(const TestStackInProgress());
    try {
      final token = await backend.testStack(
        url: url,
        clientId: clientId,
        secret: secret,
      );

      if (!isClosed) {
        emit(TestStackSuccess(token));
      }
    } on HTTPError catch (exception) {
      final errorModel = InstallerErrorModel(
          exception.errorMessage, ErrorOrigin.testStack, ErrorType.httpError);
      errorNotifier.value = errorModel;
      emit(const TestStackFailed());
    } catch (exception) {
      final errorModel = InstallerErrorModel(
          ErrorMessage(null, exception.toString(), exception.toString()),
          ErrorOrigin.testStack,
          ErrorType.contentError);
      errorNotifier.value = errorModel;

      emit(const TestStackFailed());
    }
  }
}
