part of 'edit_group_cubit.dart';

abstract class EditGroupState extends Equatable {
  const EditGroupState();

  @override
  List<Object> get props => [];
}

class EditGroupInitial extends EditGroupState {
  const EditGroupInitial();

  @override
  List<Object> get props => [];
}

class EditGroupInProgress extends EditGroupState {
  const EditGroupInProgress();

  @override
  List<Object> get props => [];
}

class EditGroupSuccess extends EditGroupState {
  final Group editedGroup;
  const EditGroupSuccess(this.editedGroup);

  @override
  List<Object> get props => [editedGroup];
}

class EditGroupFailed extends EditGroupState {
  const EditGroupFailed();

  @override
  List<Object> get props => [];
}
