import 'package:flutter/material.dart';

class InstallerIcons {  
  static const String thingseePresence = 'assets/thingsee_presence_white.png';
  static const String thingseePresenceSimple = 'assets/thingsee_presence_simple.png';
  static const String thingseeAir = 'assets/thingsee_air.png';
  static const String thingseeAirSimple = 'assets/thingsee_air_simple.png';
  static const String thingseeAngleRugged = 'assets/thingsee_angle.png';
  static const String thingseeAngleRuggedSimple = 'assets/thingsee_angle_simple.png';
  static const String thingseeBeam = 'assets/thingsee_beam.png';
  static const String thingseeBeamSimple = 'assets/thingsee_beam_simple.png';
  static const String thingseeCount = 'assets/thingsee_count.png';
  static const String thingseeCountSimple = 'assets/thingsee_count_simple.png';
  static const String thingseeDistance = 'assets/thingsee_distance.png';
  static const String thingseeDistanceSimple = 'assets/thingsee_distance_simple.png';
  static const String thingseeEnvironment = 'assets/thingsee_environment.png';
  static const String thingseeEnvironmentSimple = 'assets/thingsee_environment_simple.png';
  static const String thingseeGatewayGlobal = 'assets/thingsee_gateway_global.png';
  static const String thingseeGatewayGlobalSimple = 'assets/thingsee_gateway_global_simple.png';
  static const String thingseeGatewayLan = 'assets/thingsee_gateway_lan.png';
  static const String thingseeGatewayLanSimple = 'assets/thingsee_gateway_lan_simple.png';
  static const String thingseeLeakageRuggedAndEnvironmentRugged = 'assets/thingsee_leakage_rugged_and_environment_rugged.png';
  static const String thingseeLeakageRuggedAndEnvironmentRuggedSimple = 'assets/thingsee_leakage_rugged_and_environment_rugged_simple.png';
  static const String thingseeUnknownDevice = 'assets/thingsee_unknown_device.png';
  static const String thingseeUnknownDeviceSimple = 'assets/thingsee_unknown_device_simple.png';
  static const String looLight = 'assets/whiffAway_looLight.png';
  static const String looLightSimple = 'assets/whiffAway_looLight_simple.png';
  static const String thingseeActivity = 'assets/thingsee_activity.png';
  static const String thingseeActivitySimple = 'assets/thingsee_activity_simple.png';
  static const String deviceOffline = 'assets/device_offline.png';
  static const String deviceOnline = 'assets/device_online.png';
  static const String batteryIcon = 'assets/battery_icon.png';
  static const String operatingMode = 'assets/operating_mode_icon.png';
  static const String installationStatus = 'assets/installation_status_icon.png';
  static const String stack = 'assets/stack.png';
  static const String folder = 'assets/folder.png';
  static const String folderGrey = 'assets/folder_grey.png';
  static const String qr = 'assets/qr_code.png';
  static const String navDeviceUnselected = 'assets/icon_devices_unselected.png';
  static const String navSearchUnselected = 'assets/icon_search_unselected.png';
  static const String navLogsUnselected = 'assets/icon_logs_unselected.png';
  static const String navMoreUnselected = 'assets/icon_more_unselected.png';
  static const String navDeviceSelected = 'assets/icon_devices_selected.png';
  static const String navSearchSelected = 'assets/icon_search_selected.png';
  static const String navLogsSelected = 'assets/icon_logs_selected.png';
  static const String navMoreSelected = 'assets/icon_more_selected.png';
  static const String savedLog = 'assets/icon_saved_log.png';
  static const String recording = 'assets/icon_recording.png';
  static const String arrowUp = 'assets/icon_arrow_up.png';
  static const String arrowDown = 'assets/icon_arrow_down.png';
  static const String trash = 'assets/icon_trash.png';
  static const String firmware = 'assets/firmware_icon.png';
  static const String thingseeLogoWhite = 'assets/Thingsee_logo_white.png';

  static Widget createInstallerAssetImage(
      {required String assetPath,
      required double width,
      required double height}) {
    return Image.asset((assetPath), width: width, height: height);
  }
}
