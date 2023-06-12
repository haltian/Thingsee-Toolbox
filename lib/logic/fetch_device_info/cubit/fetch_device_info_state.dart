part of 'fetch_device_info_cubit.dart';

abstract class FetchDeviceInfoState extends Equatable {
  const FetchDeviceInfoState();

  @override
  List<Object> get props => [];
}

class FetchDeviceInfoInitial extends FetchDeviceInfoState {
  const FetchDeviceInfoInitial();

  @override
  List<Object> get props => [];
}

class FetchDeviceInfoInProgress extends FetchDeviceInfoState {
  const FetchDeviceInfoInProgress();

  @override
  List<Object> get props => [];
}

class FetchDeviceInfoSuccess extends FetchDeviceInfoState {
  final DeviceInfo info;
  const FetchDeviceInfoSuccess(this.info);

  @override
  List<Object> get props => [info];
}

class FetchDeviceInfoFailed extends FetchDeviceInfoState {
  const FetchDeviceInfoFailed();

  @override
  List<Object> get props => [];
}
