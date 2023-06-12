part of 'fetch_device_list_cubit.dart';

abstract class FetchDeviceListState extends Equatable {
  const FetchDeviceListState();

  @override
  List<Object> get props => [];
}

class FetchDeviceListInitial extends FetchDeviceListState {
  const FetchDeviceListInitial();

  @override
  List<Object> get props => [];
}

class FetchDeviceListInProgress extends FetchDeviceListState {
  const FetchDeviceListInProgress();

  @override
  List<Object> get props => [];
}

class FetchDeviceListSuccess extends FetchDeviceListState {
  final DeviceListResponse devicesResponse;
  const FetchDeviceListSuccess(this.devicesResponse);

  @override
  List<Object> get props => [devicesResponse];
}

class FetchDeviceListFailed extends FetchDeviceListState {
  const FetchDeviceListFailed();

  @override
  List<Object> get props => [];
}
