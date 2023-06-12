part of 'fetch_group_cubit.dart';

abstract class FetchGroupState extends Equatable {
  const FetchGroupState();

  @override
  List<Object> get props => [];
}

class FetchGroupInitial extends FetchGroupState {
  const FetchGroupInitial();

  @override
  List<Object> get props => [];
}

class FetchGroupInProgress extends FetchGroupState {
  const FetchGroupInProgress();

  @override
  List<Object> get props => [];
}

class FetchGroupSuccess extends FetchGroupState {
  final DeviceGroup group;
  const FetchGroupSuccess(this.group);

  @override
  List<Object> get props => [group];
}

class FetchGroupFailed extends FetchGroupState {
  const FetchGroupFailed();

  @override
  List<Object> get props => [];
}
