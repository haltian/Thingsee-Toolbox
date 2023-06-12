class InstallerConstants {
  static const String authURL = 'auth/client-token';
  static const String groupsURL = 'groups/';
  static const String thingsURL = 'things/';
  static const String headerContentType = 'Content-Type';
  static const String headerApplicationJson = 'application/json; charset=UTF-8';
  static const String clientID = 'client_id';
  static const String clientSecret = 'client_secret';
  static const String authorization = 'Authorization';
  static const String groupID = 'group_id';
  static const String groupDescription = 'group_description';
  static const String installationStatus = 'installation_status';
  static const String uninstalled = 'uninstalled';
  static const String installed = 'installed';
  static const String retired = 'retired';
  static const String unassigned = 'unassigned';
  static const String online = 'online';
  static const String offline = 'offline';
  static const String success = 'success';

  static String bearerToken({required String token}) {
    return "Bearer $token";
  }

  static String deviceListwithGroupIdURL({required String groupId}) {
    return "groups/$groupId/things";
  }

  static String groupsURLwithGroupID({required String groupId}) {
    return "groups/$groupId";
  }

  static String editGroupURL({required String groupId}) {
    return "groups/$groupId/rename";
  }

  static String deviceMessagesWithLimit(
      {required String deviceId, required int limit}) {
    return "things/$deviceId/messages?limit=$limit";
  }

  static String deviceInfoURL({required String deviceId}) {
    return "things/$deviceId";
  }

  static String thingGroupURL({required String deviceId}) {
    return "things/$deviceId/group";
  }

  static String installationStatusURL({required String deviceId}) {
    return "things/$deviceId/installations?limit=1";
  }

  static String installationStatusSetURL({required String deviceId}) {
    return "things/$deviceId/installations";
  }

  static String SendCommandsURL({required String deviceId}) {
    return "things/$deviceId/commands";
  }

  static String fetchCommandsURL(
      {required String deviceId, required int limit}) {
    return "things/$deviceId/commands?limit=$limit";
  }

  static String installationDeviceGroupURL({required String deviceId}) {
    return "things/$deviceId/group";
  }

  static const List<String> gatewayGlobalPrefixes = [
    "XXXX00",
    "TSGW01",
    "TSGW02",
    "XXXX08",
    "TSGW03",
    "XXXX11",
    "TSGW04",
    "XXXX21",
    "TSGW06",
  ];

  static const List<String> gatewayLanPrefixes = ["XXXX16", "TSGW05"];

  static const List<String> angleRuggedPrefixes = ["XXXX10", "TSAN01"];

  static const List<String> environmentPrefixes = [
    "XXXX01",
    "TSPD01",
    "XXXX03",
    "TSPD02",
    "TSPD03",
    "TSPD04",
    "XXEN01",
    "TSEN01"
  ];

  static const List<String> environmentRuggedPrefixes = [
    "XXXX18",
    "TSPD05",
    "XXRU01",
    "TSRU01",
    "TSRU02",
  ];

  static const List<String> presencePrefixes = [
    "XXXX05",
    "TSPR01",
    "XXXX06",
    "TSPR02",
    "XXXX12",
    "TSPR03",
    "XXXX13",
    "TSPR04"
  ];

  static const List<String> distancePrefixes = [
    "XXXX02",
    "TSTF01",
    "XXXX04",
    "TSTF02"
  ];

  static const List<String> beamPrefixes = ["XXXX20", "TSTF04"];

  static const List<String> leakageRuggedPrefixes = [
    "XXLK01",
    "TSLK01",
    "TSLK02",
  ];

  static const List<String> airPrefixes = ["XXAR01", "TSAR01", "TSAR02"];

  static const List<String> activityPrefixes = ["XXXXSP", "GOTG01"];

  static const List<String> looLightPrefixes = ["WHLL01"];

  static const List<String> countPrefixes = ["XXXX24", "TSAP01"];
}
