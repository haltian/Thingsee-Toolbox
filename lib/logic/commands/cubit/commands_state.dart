import 'package:equatable/equatable.dart';
import 'package:thingsee_installer/protocol/commands_response.dart';

import '../../../protocol/device_command.dart';

abstract class CommandsState extends Equatable {
  const CommandsState();

  @override
  List<Object> get props => [];
}

class CommandInitial extends CommandsState {
  const CommandInitial();

  @override
  List<Object> get props => [];
}

class CommandInProgress extends CommandsState {
  final bool isSending;
  const CommandInProgress(this.isSending);

  @override
  List<Object> get props => [isSending];
}

class CommandSuccess extends CommandsState {
  final List<DeviceCommand>? commands;
  final List<CommandsResponse>? commandsResponse;
  const CommandSuccess(this.commands, this.commandsResponse);

  @override
  List<Object> get props => [commands!, commandsResponse!];
}

class CommandFailed extends CommandsState {
  const CommandFailed();

  @override
  List<Object> get props => [];
}
