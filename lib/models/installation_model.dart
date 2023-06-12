import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thingsee_installer/models/device_model.dart';

enum IncudedEvent {
  addingDevice,
  replacingDevice,
  editingDevice,
  removingDevice
}

//Class for AccelerometerModes for Enviroment sensors.
class AccelerometerMode {
  String? name;
  int? mode;
  int? measurementInterval;
  int? passiveReportingInterval;

  AccelerometerMode(
      {this.name,
      this.mode,
      this.measurementInterval,
      this.passiveReportingInterval});
}

class HallMode {
  String? name;
  int? mode, measurementInterval, passiveReportingInterval;

  HallMode(
      {this.name,
      this.mode,
      this.measurementInterval,
      this.passiveReportingInterval});
}

class InstallationModel extends ChangeNotifier {
  InstallationModel();
  List<IncudedEvent> _includedEventsToLogs = [];

  void addOrRemoveEventsToLog(IncudedEvent event, bool isChecked) {
    isChecked
        ? _includedEventsToLogs.add(event)
        : _includedEventsToLogs.remove(event);
    notifyListeners();
  }

  void updateEventsList(List<IncudedEvent> events) {
    _includedEventsToLogs = events;
    notifyListeners();
  }

  List<IncudedEvent> getIncudedEvents() {
    return _includedEventsToLogs;
  }

  void clearIncludedEvents() {
    _includedEventsToLogs.clear();
    notifyListeners();
  }

  List<String> installationStatuses(BuildContext context) {
    return [
      AppLocalizations.of(context)!.installed,
      AppLocalizations.of(context)!.newInstallation,
      AppLocalizations.of(context)!.quarantine,
      AppLocalizations.of(context)!.retired,
      AppLocalizations.of(context)!.uninstalled,
    ];
  }

  List<String> presenceModes(BuildContext context) {
    return [
      AppLocalizations.of(context)!.testMode,
      AppLocalizations.of(context)!.occupancy,
      AppLocalizations.of(context)!.visitorCounter,
    ];
  }

  List<String> installationLocations(BuildContext context) {
    return [
      AppLocalizations.of(context)!.locationOut,
      AppLocalizations.of(context)!.locationIn,
    ];
  }

// This is to ge mum mode to UI
  String selectedMode(BuildContext context, int? mode, int? measurementInterval,
      String firmwareVersion) {
    if (DeviceModel().isPod3(firmwareVersion) == true) {
      if (mode == 2) {
        return AppLocalizations.of(context)!.eventBased;
      } else if (mode == 1) {
        return AppLocalizations.of(context)!.fixedInterval;
      } else {
        return AppLocalizations.of(context)!.disabled;
      }
    } else {
      if (mode == 2 && measurementInterval == 60) {
        return AppLocalizations.of(context)!.fixedInterval;
      } else if (mode == 2 && measurementInterval == 300) {
        return AppLocalizations.of(context)!.eventBased;
      } else {
        return AppLocalizations.of(context)!.disabled;
      }
    }
  }

  // List of modes for dropdown items
  List<String> accelerometerModeNames(
      BuildContext context, String? firmwareVersion) {
    List<String> modes = [];
    accelerometerModes(context, firmwareVersion).forEach((AccelerometerModes) {
      modes.add(AccelerometerModes.name.toString());
    });
    return modes;
  }

  List<String> hallModeNames(BuildContext context, String? firmwareVersion) {
    List<String> modes = [];
    hallModes(context, firmwareVersion).forEach((hallmode) {
      modes.add(hallmode.name.toString());
    });
    return modes;
  }

  String selectedHallMode(BuildContext context, int? mode) {
    if (mode == 1) {
      return AppLocalizations.of(context)!.enabled;
    } else {
      return AppLocalizations.of(context)!.disabled;
    }
  }

  //List of the modes for environment mum mode
  List<AccelerometerMode> accelerometerModes(
      BuildContext context, String? firmwareVersion) {
    return DeviceModel().isPod3(firmwareVersion!)
        ? [
            AccelerometerMode(
                name: AppLocalizations.of(context)!.disabled,
                mode: 0,
                measurementInterval: 300,
                passiveReportingInterval: 3600),
            AccelerometerMode(
                name: AppLocalizations.of(context)!.fixedInterval,
                mode: 1,
                measurementInterval: 60,
                passiveReportingInterval: 60),
            AccelerometerMode(
                name: AppLocalizations.of(context)!.eventBased,
                mode: 2,
                measurementInterval: 300,
                passiveReportingInterval: 3600),
          ]
        : [
            AccelerometerMode(
                name: AppLocalizations.of(context)!.disabled,
                mode: 1,
                measurementInterval: 300,
                passiveReportingInterval: 3600),
            AccelerometerMode(
                name: AppLocalizations.of(context)!.fixedInterval,
                mode: 2,
                measurementInterval: 60,
                passiveReportingInterval: 60),
            AccelerometerMode(
                name: AppLocalizations.of(context)!.eventBased,
                mode: 2,
                measurementInterval: 300,
                passiveReportingInterval: 3600),
          ];
  }

  List<HallMode> hallModes(BuildContext context, String? firmwareVersion) {
    return DeviceModel().isPod3(firmwareVersion!)
        ? [
            HallMode(
                name: AppLocalizations.of(context)!.disabled,
                mode: -1,
                measurementInterval: 300,
                passiveReportingInterval: 3600),
            HallMode(
                name: AppLocalizations.of(context)!.enabled,
                mode: 1,
                measurementInterval: 60,
                passiveReportingInterval: 60),
          ]
        : [
            HallMode(
                name: AppLocalizations.of(context)!.disabled,
                mode: 0,
                measurementInterval: 300,
                passiveReportingInterval: 3600),
            HallMode(
                name: AppLocalizations.of(context)!.enabled,
                mode: 1,
                measurementInterval: 60,
                passiveReportingInterval: 60),
          ];
  }

  String getInstallationStatusForBackend(String name, BuildContext context) {
    String status = "";
    if (name == AppLocalizations.of(context)!.newInstallation) {
      status = "new";
    } else if (name == AppLocalizations.of(context)!.installed) {
      status = "installed";
    } else if (name == AppLocalizations.of(context)!.uninstalled) {
      status = "uninstalled";
    } else if (name == AppLocalizations.of(context)!.retired) {
      status = "retired";
    }

    return status;
  }

  String getIncudedEventsTitles(IncudedEvent event, BuildContext context) {
    switch (event) {
      case IncudedEvent.addingDevice:
        return AppLocalizations.of(context)!.addingADevice;
      case IncudedEvent.replacingDevice:
        return AppLocalizations.of(context)!.replacingADevice;
      case IncudedEvent.editingDevice:
        return AppLocalizations.of(context)!.editingADevice;
      case IncudedEvent.removingDevice:
        return AppLocalizations.of(context)!.removingADevice;
      default:
        return "";
    }
  }

  String getSavedEventsTitles(IncudedEvent event, BuildContext context) {
    switch (event) {
      case IncudedEvent.addingDevice:
        return AppLocalizations.of(context)!.deviceAdded;
      case IncudedEvent.replacingDevice:
        return AppLocalizations.of(context)!.deviceReplaced;
      case IncudedEvent.editingDevice:
        return AppLocalizations.of(context)!.deviceEdited;
      case IncudedEvent.removingDevice:
        return AppLocalizations.of(context)!.deviceRemoved;
      default:
        return "";
    }
  }
}
