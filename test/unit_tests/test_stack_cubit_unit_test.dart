import 'dart:convert';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/logic/test_stack/cubit/test_stack_cubit.dart';
import 'package:thingsee_installer/logic/test_stack_backend.dart';
import '../unit_test_utils.dart';
import 'test_stack_cubit_unit_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const clientId = "testerClientId";
  const clientSecret = "testerClientSecret";
  const URL =
      "https://4zbezvcgi1.execute-api.eu-west-1.amazonaws.com/prod/v1/";

  Uri url() {
    return Uri.parse(URL + InstallerConstants.authURL);
  }

  String body() {
    return jsonEncode(<String, dynamic>{
      InstallerConstants.clientID: clientId,
      InstallerConstants.clientSecret: clientSecret
    });
  }

  group('TestStackCubit', () {
    final validClient = MockClient();

    when(validClient.post(url(),
            headers: UnitTestUtils.loginHeaders(), body: body()))
        .thenAnswer((_) async => http.Response(
            UnitTestUtils.testStackSuccessMessage, UnitTestUtils.httpOK));

    blocTest<TestStackCubit, TestStackState>(
      'Test Stack Success',
      build: () => TestStackCubit(
          TestStackBackend(validClient), UnitTestUtils.errorNotifier()),
      act: (cubit) => cubit.testStack(
          url: URL, clientId: clientId, secret: clientSecret),
      wait: UnitTestUtils.testDefaultDuration,
      expect: () => [const TestStackInProgress(), isA<TestStackSuccess>()],
    );

    final errorClient = MockClient();

    when(errorClient.post(url(),
            headers: UnitTestUtils.loginHeaders(), body: body()))
        .thenAnswer(
            (_) async => http.Response('http error', UnitTestUtils.httpFailed));
    blocTest<TestStackCubit, TestStackState>(
      'Token Refresh Failure',
      build: () => TestStackCubit(
          TestStackBackend(errorClient), UnitTestUtils.errorNotifier()),
      act: (cubit) => cubit.testStack(
          url: URL, clientId: clientId, secret: clientSecret),
      wait: UnitTestUtils.testDefaultDuration,
      expect: () => [const TestStackInProgress(), isA<TestStackFailed>()],
    );
  });
}
