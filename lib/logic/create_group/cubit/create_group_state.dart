part of 'create_group_cubit.dart';

abstract class CreateGroupState extends Equatable {
  const CreateGroupState();

  @override
  List<Object> get props => [];
}

class CreateGroupInitial extends CreateGroupState {
  const CreateGroupInitial();

  @override
  List<Object> get props => [];
}

class CreateGroupInProgress extends CreateGroupState {
  const CreateGroupInProgress();

  @override
  List<Object> get props => [];
}

class CreateGroupSuccess extends CreateGroupState {
  final Group group;
  const CreateGroupSuccess(this.group);

  @override
  List<Object> get props => [group];
}

class CreateGroupFailed extends CreateGroupState {
  const CreateGroupFailed();

  @override
  List<Object> get props => [];
}
