part of 'test_stack_cubit.dart';

abstract class TestStackState extends Equatable {
  const TestStackState();

  @override
  List<Object> get props => [];
}

class TestStackInitial extends TestStackState {
  const TestStackInitial();

  @override
  List<Object> get props => [];
}

class TestStackInProgress extends TestStackState {
  const TestStackInProgress();

  @override
  List<Object> get props => [];
}

class TestStackSuccess extends TestStackState {
  final InstallerToken token;
  const TestStackSuccess(this.token);

  @override
  List<Object> get props => [token];
}

class TestStackFailed extends TestStackState {
  const TestStackFailed();

  @override
  List<Object> get props => [];
}
