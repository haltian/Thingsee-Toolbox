part of 'fetch_installation_status_cubit.dart';

abstract class FetchInstallationStatusState extends Equatable {
  const FetchInstallationStatusState();

  @override
  List<Object> get props => [];
}

class FetchInstallationStatusInitial extends FetchInstallationStatusState {
  const FetchInstallationStatusInitial();

  @override
  List<Object> get props => [];
}

class FetchInstallationStatusInProgress extends FetchInstallationStatusState {
  const FetchInstallationStatusInProgress();

  @override
  List<Object> get props => [];
}

class FetchInstallationStatusSuccess extends FetchInstallationStatusState {
  final List<InstallationStatus> status;
  const FetchInstallationStatusSuccess(this.status);

  @override
  List<Object> get props => [status];
}

class FetchInstallationStatusFailed extends FetchInstallationStatusState {
  const FetchInstallationStatusFailed();

  @override
  List<Object> get props => [];
}
