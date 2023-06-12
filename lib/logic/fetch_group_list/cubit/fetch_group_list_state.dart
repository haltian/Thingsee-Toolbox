part of 'fetch_group_list_cubit.dart';

abstract class FetchGroupListState extends Equatable {
  const FetchGroupListState();

  @override
  List<Object> get props => [];
}

class FetchGroupListInitial extends FetchGroupListState {
  const FetchGroupListInitial();

  @override
  List<Object> get props => [];
}

class FetchGroupListInProgress extends FetchGroupListState {
  const FetchGroupListInProgress();

  @override
  List<Object> get props => [];
}

class FetchGroupListSuccess extends FetchGroupListState {
  final List<Group> groups;
  const FetchGroupListSuccess(this.groups);

  @override
  List<Object> get props => [groups];
}

class FetchGroupListFailed extends FetchGroupListState {
  const FetchGroupListFailed();

  @override
  List<Object> get props => [];
}
