part of 'delete_group_cubit.dart';

abstract class DeleteGroupState extends Equatable {
  const DeleteGroupState();

  @override
  List<Object> get props => [];
}

class DeleteGroupInitial extends DeleteGroupState {
  const DeleteGroupInitial();

  @override
  List<Object> get props => [];
}

class DeleteGroupInProgress extends DeleteGroupState {
  const DeleteGroupInProgress();

  @override
  List<Object> get props => [];
}

class DeleteGroupSuccess extends DeleteGroupState {
  final Group group;
  const DeleteGroupSuccess(this.group);

  @override
  List<Object> get props => [group];
}

class DeleteGroupFailed extends DeleteGroupState {
  const DeleteGroupFailed();

  @override
  List<Object> get props => [];
}
