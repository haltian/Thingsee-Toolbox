part of 'set_installation_status_cubit.dart';

abstract class SetInstallationStatusState extends Equatable {
  const SetInstallationStatusState();

  @override
  List<Object> get props => [];
}

class SetInstallationStatusInitial extends SetInstallationStatusState {
  const SetInstallationStatusInitial();

  @override
  List<Object> get props => [];
}

class SetInstallationStatusInProgress extends SetInstallationStatusState {
  const SetInstallationStatusInProgress();

  @override
  List<Object> get props => [];
}

class SetInstallationStatusSuccess extends SetInstallationStatusState {
  final InstallationStatus installationStatus;
  const SetInstallationStatusSuccess(this.installationStatus);

  @override
  List<Object> get props => [installationStatus];
}

class SetInstallationStatusFailed extends SetInstallationStatusState {
  const SetInstallationStatusFailed();

  @override
  List<Object> get props => [];
}
