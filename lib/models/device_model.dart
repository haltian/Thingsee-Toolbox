import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/constants/installer_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thingsee_installer/protocol/device_info.dart';

enum ThingseeSensorType {
  air,
  beam,
  distance,
  presence,
  environment,
  leakageRugged,
  environmentRugged,
  angleRugged,
  gatewayGlobal,
  count,
  gatewayLan,
  looLight,
  activity,
  unknown
}

enum ConfigurationItem {
  hall,
  accelerometer,
  installationLocation,
  operatingMode
}

class DeviceModel {
  String getIdPrefix({required String tuid}) {
    return tuid.substring(0, 6);
  }

  String getDeviceStatusString(int timeStamp, ThingseeSensorType sensorType) {
    bool online = isOnline(timeStamp, sensorType);
    if (online) {
      return InstallerConstants.offline;
    } else {
      return InstallerConstants.online;
    }
  }

  // These are for checking if the environment devices are pod3 or pod4 because they work differently
  bool isPod3(String firmwareVersion) {
    return firmwareVersion.toLowerCase().contains("pod3");
  }

  bool isPod4(String firmwareVersion) {
    return firmwareVersion.toLowerCase().contains("pod4");
  }

  bool isPir(String firmwareVersion) {
    return firmwareVersion.toLowerCase().contains("pir");
  }

  int? getMeasurementInterval(
      BuildContext context, String firmwareVersion, String selectedValue) {
    if (isPod4(firmwareVersion) || firmwareVersion == "unknown-sw-release") {
      if (selectedValue == AppLocalizations.of(context)!.fixedInterval) {
        return 60;
      } else {
        return 300;
      }
    }
    return null;
  }

  int? getPassiveReportingInterval(
      BuildContext context, String firmwareVersion, String selectedValue) {
    if (isPir(firmwareVersion)) {
      if (selectedValue == AppLocalizations.of(context)!.visitorCounter) {
        return 3600;
      }
    }
    return null;
  }

  int? getReportingInterval(
      BuildContext context, String firmwareVersion, String selectedValue) {
    if (isPod4(firmwareVersion) || firmwareVersion == "unknown-sw-release") {
      if (selectedValue == AppLocalizations.of(context)!.fixedInterval) {
        return 60;
      } else {
        return 3600;
      }
    } else if (isPod3(firmwareVersion)) {
      return 60;
    } else if (isPir(firmwareVersion)) {
      return 60;
    }
    return null;
  }

  int getTsmId(String deviceId, ConfigurationItem configurationItem,
      [String firmwareVersion = ""]) {
    ThingseeSensorType type = getSensorType(deviceId);

    if (type == ThingseeSensorType.count) {
      return 17220;
    } else if (type == ThingseeSensorType.presence) {
      return 13200;
    } else if (type == ThingseeSensorType.environment ||
        type == ThingseeSensorType.environmentRugged) {
      if (configurationItem == ConfigurationItem.hall) {
        return 12211;
      } else if (configurationItem == ConfigurationItem.accelerometer) {
        if (isPod4(firmwareVersion)) {
          return 16200;
        } else if (isPod3(firmwareVersion)) {
          return 12200;
        }
      }
    }

    return 0;
  }

  ThingseeSensorType getSensorType(String deviceId) {
    String idPrefix = getIdPrefix(tuid: deviceId);
    ThingseeSensorType sensorType = ThingseeSensorType.unknown;
    if (InstallerConstants.gatewayGlobalPrefixes.contains(idPrefix)) {
      sensorType = ThingseeSensorType.gatewayGlobal;
    } else if (InstallerConstants.gatewayLanPrefixes.contains(idPrefix)) {
      sensorType = ThingseeSensorType.gatewayLan;
    } else if (InstallerConstants.angleRuggedPrefixes.contains(idPrefix)) {
      sensorType = ThingseeSensorType.angleRugged;
    } else if (InstallerConstants.environmentPrefixes.contains(idPrefix)) {
      sensorType = ThingseeSensorType.environment;
    } else if (InstallerConstants.environmentRuggedPrefixes
        .contains(idPrefix)) {
      sensorType = ThingseeSensorType.environmentRugged;
    } else if (InstallerConstants.presencePrefixes.contains(idPrefix)) {
      sensorType = ThingseeSensorType.presence;
    } else if (InstallerConstants.distancePrefixes.contains(idPrefix)) {
      sensorType = ThingseeSensorType.distance;
    } else if (InstallerConstants.beamPrefixes.contains(idPrefix)) {
      sensorType = ThingseeSensorType.beam;
    } else if (InstallerConstants.leakageRuggedPrefixes.contains(idPrefix)) {
      sensorType = ThingseeSensorType.leakageRugged;
    } else if (InstallerConstants.airPrefixes.contains(idPrefix)) {
      sensorType = ThingseeSensorType.air;
    } else if (InstallerConstants.activityPrefixes.contains(idPrefix)) {
      sensorType = ThingseeSensorType.activity;
    } else if (InstallerConstants.looLightPrefixes.contains(idPrefix)) {
      sensorType = ThingseeSensorType.looLight;
    } else if (InstallerConstants.countPrefixes.contains(idPrefix)) {
      sensorType = ThingseeSensorType.count;
    }
    return sensorType;
  }

  String getSensorName(String deviceId) {
    String sensorName = "Unknown device";
    ThingseeSensorType type = getSensorType(deviceId);

    switch (type) {
      case ThingseeSensorType.gatewayGlobal:
        sensorName = "Thingsee GATEWAY GLOBAL";
        break;
      case ThingseeSensorType.gatewayLan:
        sensorName = "Thingsee GATEWAY LAN";
        break;
      case ThingseeSensorType.angleRugged:
        sensorName = "Thingsee ANGLE RUGGED";
        break;
      case ThingseeSensorType.environment:
        sensorName = "Thingsee ENVIRONMENT";
        break;
      case ThingseeSensorType.environmentRugged:
        sensorName = "Thingsee ENVIRONMENT RUGGED";
        break;
      case ThingseeSensorType.presence:
        sensorName = "Thingsee PRESENCE";
        break;
      case ThingseeSensorType.distance:
        sensorName = "Thingsee DISTANCE";
        break;
      case ThingseeSensorType.beam:
        sensorName = "Thingsee BEAM";
        break;
      case ThingseeSensorType.leakageRugged:
        sensorName = "Thingsee LEAKAGE RUGGED";
        break;
      case ThingseeSensorType.air:
        sensorName = "Thingsee AIR";
        break;
      case ThingseeSensorType.activity:
        sensorName = "Thingsee ACTIVITY";
        break;
      case ThingseeSensorType.looLight:
        sensorName = "WhiffAway LooLight";
        break;
      case ThingseeSensorType.count:
        sensorName = "Thingsee COUNT";
        break;
      default:
    }
    return sensorName;
  }

  String getSensorImage(String deviceId) {
    String imagePath = InstallerIcons.thingseeUnknownDeviceSimple;
    ThingseeSensorType type = getSensorType(deviceId);

    switch (type) {
      case ThingseeSensorType.gatewayGlobal:
        imagePath = InstallerIcons.thingseeGatewayGlobal;
        break;
      case ThingseeSensorType.gatewayLan:
        imagePath = InstallerIcons.thingseeGatewayLan;
        break;
      case ThingseeSensorType.angleRugged:
        imagePath = InstallerIcons.thingseeAngleRugged;
        break;
      case ThingseeSensorType.environment:
        imagePath = InstallerIcons.thingseeEnvironment;
        break;
      case ThingseeSensorType.environmentRugged:
        imagePath = InstallerIcons.thingseeLeakageRuggedAndEnvironmentRugged;
        break;
      case ThingseeSensorType.presence:
        imagePath = InstallerIcons.thingseePresence;
        break;
      case ThingseeSensorType.distance:
        imagePath = InstallerIcons.thingseeDistance;
        break;
      case ThingseeSensorType.beam:
        imagePath = InstallerIcons.thingseeBeam;
        break;
      case ThingseeSensorType.leakageRugged:
        imagePath = InstallerIcons.thingseeLeakageRuggedAndEnvironmentRugged;
        break;
      case ThingseeSensorType.air:
        imagePath = InstallerIcons.thingseeAir;
        break;
      case ThingseeSensorType.activity:
        imagePath = InstallerIcons.thingseeActivity;
        break;
      case ThingseeSensorType.looLight:
        imagePath = InstallerIcons.looLight;
        break;
      case ThingseeSensorType.count:
        imagePath = InstallerIcons.thingseeCount;
        break;
      default:
    }

    return imagePath;
  }

  String getSensorIcon(String deviceId) {
    String imagePath = InstallerIcons.thingseeUnknownDeviceSimple;
    ThingseeSensorType type = getSensorType(deviceId);

    switch (type) {
      case ThingseeSensorType.gatewayGlobal:
        imagePath = InstallerIcons.thingseeGatewayGlobalSimple;
        break;
      case ThingseeSensorType.gatewayLan:
        imagePath = InstallerIcons.thingseeGatewayLanSimple;
        break;
      case ThingseeSensorType.angleRugged:
        imagePath = InstallerIcons.thingseeAngleRuggedSimple;
        break;
      case ThingseeSensorType.environment:
        imagePath = InstallerIcons.thingseeEnvironmentSimple;
        break;
      case ThingseeSensorType.environmentRugged:
        imagePath =
            InstallerIcons.thingseeLeakageRuggedAndEnvironmentRuggedSimple;
        break;
      case ThingseeSensorType.presence:
        imagePath = InstallerIcons.thingseePresenceSimple;
        break;
      case ThingseeSensorType.distance:
        imagePath = InstallerIcons.thingseeDistanceSimple;
        break;
      case ThingseeSensorType.beam:
        imagePath = InstallerIcons.thingseeBeamSimple;
        break;
      case ThingseeSensorType.leakageRugged:
        imagePath =
            InstallerIcons.thingseeLeakageRuggedAndEnvironmentRuggedSimple;
        break;
      case ThingseeSensorType.air:
        imagePath = InstallerIcons.thingseeAirSimple;
        break;
      case ThingseeSensorType.activity:
        imagePath = InstallerIcons.thingseeActivitySimple;
        break;
      case ThingseeSensorType.looLight:
        imagePath = InstallerIcons.looLightSimple;
        break;
      case ThingseeSensorType.count:
        imagePath = InstallerIcons.thingseeCountSimple;
        break;
      default:
    }

    return imagePath;
  }

  bool isOnline(int? timestamp, ThingseeSensorType sensorType) {
    if (timestamp == null) {
      return true;
    }
    // Normal threshol is 2 hours or 7200000 milliseconds
    int _onlineThreshold = 7200000;

    // Gateway threshold is 6 hours or 21600000 milliseconds
    if (sensorType == ThingseeSensorType.gatewayGlobal ||
        sensorType == ThingseeSensorType.gatewayLan) {
      _onlineThreshold = _onlineThreshold * 3;
    }
    // unix to mS
    timestamp = timestamp * 1000;
    int _now = DateTime.now().millisecondsSinceEpoch;
    return ((_now - timestamp) >= _onlineThreshold);
  }

  String formatTime(int? timestamp, BuildContext context) {
    if (timestamp == null) {
      return AppLocalizations.of(context)!.never;
    }
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch((timestamp * 1000), isUtc: true);
    var formattedDate = DateFormat('d MMM yyyy HH:mm').format(date.toLocal());
    return formattedDate.toString();
  }

  String defaultMode(String deviceId, BuildContext context) {
    ThingseeSensorType device = getSensorType(deviceId);

    if (device == ThingseeSensorType.environment ||
        device == ThingseeSensorType.environmentRugged) {
      return AppLocalizations.of(context)!.disabled;
    } else if (device == ThingseeSensorType.count) {
      return AppLocalizations.of(context)!.locationIn;
    } else if (device == ThingseeSensorType.presence) {
      return AppLocalizations.of(context)!.visitorCounter;
    } else if (device == ThingseeSensorType.count) {
      return AppLocalizations.of(context)!.locationIn;
    } else {
      return AppLocalizations.of(context)!.error;
    }
  }

  String batteryLevel(int? batteryLevel, BuildContext context) {
    if (batteryLevel == null) {
      return AppLocalizations.of(context)!.noBattery;
    } else {
      return batteryLevel.toString() + "%";
    }
  }

  String batteryStatus(DeviceModel _deviceModel, BuildContext context,
      ThingseeSensorType sensorType, DeviceInfo info) {
    if (sensorType == ThingseeSensorType.gatewayGlobal ||
        sensorType == ThingseeSensorType.gatewayLan ||
        sensorType == ThingseeSensorType.count) {
      return AppLocalizations.of(context)!.usbPowered;
    } else
      return batteryLevel(info.battery_level, context);
  }
}
