part of 'fetch_device_messages_cubit.dart';

abstract class FetchDeviceMessagesState extends Equatable {
  const FetchDeviceMessagesState();

  @override
  List<Object> get props => [];
}

class FetchDeviceMessagesInitial extends FetchDeviceMessagesState {
  const FetchDeviceMessagesInitial();

  @override
  List<Object> get props => [];
}

class FetchDeviceMessagesInProgress extends FetchDeviceMessagesState {
  const FetchDeviceMessagesInProgress();

  @override
  List<Object> get props => [];
}

class FetchDeviceMessagesSuccess extends FetchDeviceMessagesState {
  final List<DeviceMessages> messages;
  const FetchDeviceMessagesSuccess(this.messages);

  @override
  List<Object> get props => [messages];
}

class FetchDeviceMessagesFailed extends FetchDeviceMessagesState {
  const FetchDeviceMessagesFailed();

  @override
  List<Object> get props => [];
}
