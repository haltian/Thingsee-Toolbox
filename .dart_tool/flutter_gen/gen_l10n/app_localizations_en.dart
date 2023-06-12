import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get installerTitle => 'Thingsee Toolbox';

  @override
  String get removeStack => 'Remove stack?';

  @override
  String get remove => 'Remove';

  @override
  String get cancel => 'Cancel';

  @override
  String get areYouSureYouWantToDeleteStack => 'Are you sure you want to remove the stack from your account? The stack will remain available in the system.';

  @override
  String clientID(String id) {
    return 'Client ID: $id';
  }

  @override
  String path(String path) {
    return 'Path: $path';
  }

  @override
  String get ok => 'OK';

  @override
  String get info => 'Info';

  @override
  String get addNewStack => 'Add a new stack';

  @override
  String get stackAddedSuccessfully => 'Stack added successfully';

  @override
  String get stackDeletedSuccessfully => 'Stack deleted successfully';

  @override
  String get youHaveNotTakenStacksToUse => 'You have not taken any\nThingsee stacks into use.';

  @override
  String get noResults => 'No results';

  @override
  String get filter => 'Filter';

  @override
  String get errorOccured => 'An Error occurred';

  @override
  String get error => 'Error: ';

  @override
  String get problemConnectingToServers => 'Problem connecting to the server';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get edit => 'Edit';

  @override
  String get envProduction => 'pr - Production';

  @override
  String get envDevelopment => 'rd - Development';

  @override
  String get envDemo => 'dm - Demo';

  @override
  String get envUnassigned => 'un - Unassigned';

  @override
  String get environment => 'Environment';

  @override
  String get selectEnvironment => 'Select environment';

  @override
  String get country => 'Country';

  @override
  String get selectCountry => 'Select country';

  @override
  String get search => 'Search';

  @override
  String get name => 'Name';

  @override
  String get enterGroupName => 'Enter group name';

  @override
  String get description => 'Description';

  @override
  String get enterGroupDescription => 'Enter group description';

  @override
  String get environmentNameWillBe => 'The name of the deployment group will be';

  @override
  String get addGroup => 'Add group';

  @override
  String get addNewDeploymentGroup => 'Add new deployment group';

  @override
  String get groupCreatedSuccessfully => 'Group created successfully';

  @override
  String get groupDeletedSuccessfully => 'Group deleted successfully';

  @override
  String get areYouSureYouWantToDeleteGroup => 'Are you sure you want to remove the deployment group? All devices assigned to this group will be moved to “Unassigned”.';

  @override
  String get removeDeploymentGroup => 'Remove deployment group?';

  @override
  String get thereAreNoDeploymentGroups => 'There are no deployment\ngroups in this stack.';

  @override
  String get addNewGroup => 'Add new stack';

  @override
  String get thereAreNoDevices => 'There are no devices in this deployment group.';

  @override
  String get addNewDevice => 'Add new device';

  @override
  String get deviceInfo => 'Device info';

  @override
  String get welcomeToThingseeInstaller => 'Welcome to Thingsee Toolbox!\n\nStart by entering the details of the Thingsee stack you are going to use.';

  @override
  String get editDeploymentGroup => 'Edit deployment group';

  @override
  String get saveChanges => 'Save changes';

  @override
  String get editDevice => 'Edit device';

  @override
  String get tuid => 'TUID';

  @override
  String get installed => 'Installed';

  @override
  String get newInstallation => 'New';

  @override
  String get quarantine => 'Quarantine';

  @override
  String get retired => 'Retired';

  @override
  String get uninstalled => 'Uninstalled';

  @override
  String get installationStatus => 'Installation status';

  @override
  String get visitorCounter => 'Visitor counter';

  @override
  String get occupancy => 'Occupancy';

  @override
  String get eventBased => 'Event-based';

  @override
  String get locationIn => 'In';

  @override
  String get locationOut => 'Out';

  @override
  String get defaultMode => 'Default';

  @override
  String get fixedInterval => 'Fixed interval';

  @override
  String get operatingMode => 'Operating mode';

  @override
  String get disabled => 'Disabled';

  @override
  String get save => 'Save';

  @override
  String get orientation => 'Orientation';

  @override
  String mumModeAccelerometer(String newline) {
    return 'MUM mode$newline(accelerometer)';
  }

  @override
  String get installationLocation => 'Installation location';

  @override
  String get deploymentGroup => 'Deployment group';

  @override
  String get replaceDevice => 'Replace device';

  @override
  String get readQrCode => 'Read QR-code';

  @override
  String hallModeMagneticSensor(String newline) {
    return 'Hall mode$newline(magnetic${newline}sensor)';
  }

  @override
  String get replace => 'Replace';

  @override
  String get deviceAddedSuccessfully => 'Device added successfully';

  @override
  String get deviceDeletedSuccessfully => 'Device deleted successfully';

  @override
  String get sameDevice => ' Same device. Please read the QR code from the device that replaces the current one.';

  @override
  String get unknownQRcode => 'Unknown QR code! \nPlease make sure that only one code is being read at a time';

  @override
  String get cameraPermissionNotGranted => 'You didn\'t provide permission to access the camera.';

  @override
  String get areYouSureYouWantToDeleteDevice => 'Are you sure you want to remove the device? It will be moved to “Unassigned”';

  @override
  String get removeDevice => 'Remove device';

  @override
  String get deviceReplacedSuccessfully => 'Device replaced successfully';

  @override
  String get originalDevice => 'Original device';

  @override
  String get replaceWith => 'Replace with';

  @override
  String get deviceStatus => 'Device status';

  @override
  String get online => 'Online';

  @override
  String offlineLastSeen(String offline) {
    return 'Offline, last seen: $offline';
  }

  @override
  String get batteryLevel => 'Battery level';

  @override
  String get deviceEvents => 'Events';

  @override
  String get deviceUpdated => 'Device information updated successfully';

  @override
  String vibration(num? activityLevel, num? energyLevel) {
    return 'Vibration: $activityLevel Energy: $energyLevel';
  }

  @override
  String get accConfig => 'Accelerometer sensor configuration';

  @override
  String get systemInfo => 'Thing system information data';

  @override
  String get infoRequest => 'Thing information request';

  @override
  String get infoRequestUnv => 'Thing information unavailable';

  @override
  String weatherInfoAirp(String airp) {
    return 'Air pressure: $airp hPa ';
  }

  @override
  String weatherInfoHumd(num? humd) {
    return 'Humidity: $humd% ';
  }

  @override
  String weatherInfoTemp(num? temp) {
    return 'Temperature: $temp°C ';
  }

  @override
  String weatherInfoLght(num? lght) {
    return 'Light: $lght lux ';
  }

  @override
  String magnetoInfo(num? hall, num? hallCount) {
    return 'Hall: $hall Hall count: $hallCount';
  }

  @override
  String leakageResistance(num? res) {
    return 'Leakage resistance: $res';
  }

  @override
  String sensorConfig(int tsmId) {
    return 'Sensor configuration message: $tsmId';
  }

  @override
  String get batteryInfo => 'Battery message';

  @override
  String get ping => 'Ping';

  @override
  String moveCount(num? moveCount) {
    return 'Move count: $moveCount';
  }

  @override
  String count(num? count) {
    return 'Count: $count';
  }

  @override
  String get heartbeat => 'Heartbeat';

  @override
  String gatewayMessage(String gatewayMessage) {
    return 'Gateway message: $gatewayMessage';
  }

  @override
  String get edgeCoreChange => 'Edge core state change';

  @override
  String get edgeCoreStats => 'Edge core stats diagnostics data event request';

  @override
  String get edgeCoreBinary => 'Edge core binary event';

  @override
  String get jamDetection => 'Jam detection message';

  @override
  String angle(num? angle) {
    return 'Angle: $angle°';
  }

  @override
  String temperature(num? temperature) {
    return 'Temperature: $temperature°C';
  }

  @override
  String distance(num? dist) {
    return 'Distance: $dist mm';
  }

  @override
  String beamInfo(num? dist) {
    return 'Distance: $dist mm';
  }

  @override
  String get beam2d => 'Beam 2D area information';

  @override
  String get ledControl => 'LED control request';

  @override
  String get devices => 'Devices';

  @override
  String get logs => 'Logs';

  @override
  String get more => 'More';

  @override
  String get noBattery => 'No battery data available';

  @override
  String neighbouringData(num? rssi) {
    return 'Sensor network neighbouring data\nRSSI:$rssi';
  }

  @override
  String get help => 'Help';

  @override
  String get goToHelp => 'Go to Haltian support center';

  @override
  String get licenses => 'Licenses';

  @override
  String get export => 'Export csv';

  @override
  String get stopRecording => 'Stop recording';

  @override
  String get startRecording => 'Start recording';

  @override
  String get deleteLogFile => 'Delete log file?';

  @override
  String get areYouSureDeleteLogFile => 'Are you sure you want to remove the log file?';

  @override
  String get recordingOn => 'Recording on';

  @override
  String get recordingOff => 'Recording off';

  @override
  String get logFileDeleted => 'Log file deleted';

  @override
  String get noEventsInThisLogFile => 'No events in this log file';

  @override
  String get addingADevice => 'Adding a device';

  @override
  String get replacingADevice => 'Replacing a device';

  @override
  String get editingADevice => 'Editing a device';

  @override
  String get removingADevice => 'Removing a device';

  @override
  String get deviceAdded => 'Device added';

  @override
  String get deviceReplaced => 'Device replaced';

  @override
  String get deviceEdited => 'Device edited';

  @override
  String get deviceRemoved => 'Device removed';

  @override
  String get title => 'Title';

  @override
  String get enterTitle => 'Enter title';

  @override
  String get enterDescription => 'Enter description';

  @override
  String get eventsIncludedInTheLog => 'Events included in the log:';

  @override
  String get addNewLogFile => 'Add new log file';

  @override
  String get editLogFile => 'Edit log file';

  @override
  String get addLog => 'Add log';

  @override
  String get deleteLogEntry => 'Delete log entry';

  @override
  String get goToLicenses => 'Used by this application';

  @override
  String version(String version) {
    return 'Version: $version';
  }

  @override
  String copyright(String year) {
    return 'Copyright $year Haltian';
  }

  @override
  String get removeLogEntry => 'Remove log entry?';

  @override
  String get areYouSureDeleteLogEntry => 'Are you sure you want to remove this log entry?';

  @override
  String get device => 'Device';

  @override
  String get note => 'Note';

  @override
  String get oldDevice => 'Old device';

  @override
  String get installationNotes => 'Installation notes';

  @override
  String get logEntryDeleted => 'Log entry deleted';

  @override
  String get thisNoteIsStoredInYourDevice => 'This note is stored in your device and will only be shown in the log.';

  @override
  String get newDevice => 'New device';

  @override
  String get offline => 'Offline';

  @override
  String carbonInfo(num? carbonDioxide) {
    return 'CO2: $carbonDioxide ppm';
  }

  @override
  String tvocInfo(num? tvoc) {
    return 'TVOC: $tvoc ppm';
  }

  @override
  String get carbonConfig => 'Carbon Dioxide configure';

  @override
  String get carbonManual => 'Carbon Dioxide manual calibrate';

  @override
  String get tvocConfig => 'TVOC configure';

  @override
  String get carbonHardware => 'Carbon Dioxide read hardware component versions';

  @override
  String get tvocReset => 'TVOC Reset';

  @override
  String countInOut(int? countIn, int? out) {
    return 'In: $countIn Out: $out';
  }

  @override
  String get group => 'Group';

  @override
  String get noLogsAdded => 'No logs added';

  @override
  String get enterTuid => 'Enter TUID';

  @override
  String batl(int? batl) {
    return 'Battery Level: $batl %';
  }

  @override
  String orientationMsg(num? accx, num? accy, num? accz) {
    return 'Orientation - x: $accx - y: $accy - z: $accz';
  }

  @override
  String celluralRfDataRat(String? cellRat) {
    return 'Rat: $cellRat ';
  }

  @override
  String celluralRfDataRssi(num? cellRssi) {
    return 'RSSI: $cellRssi ';
  }

  @override
  String cellularInfoMccMnc(String? cellMccMnc) {
    return 'MccMnc: $cellMccMnc ';
  }

  @override
  String cellularInfoOperator(String? operatorName) {
    return 'Operator: $operatorName ';
  }

  @override
  String systemMessage(int msgId) {
    return 'System message: $msgId';
  }

  @override
  String occupancyMode(num? state) {
    return 'State: $state';
  }

  @override
  String get exportingCsvFailed => 'Exporting CSV failed';

  @override
  String get csvSavedToDownloadsFolder => 'CSV saved in the \'Downloads\'-folder';

  @override
  String get csvSaved => 'CSV saved';

  @override
  String get enterTuidOrReadQR => 'Enter TUID or read QR code';

  @override
  String get firmwareVersion => 'Firmware version';

  @override
  String get logFileUpdated => 'Log file updated';

  @override
  String get deviceNotFound => 'Device not found in the active stack';

  @override
  String get networkDisconnected => 'Network disconnected';

  @override
  String get networkConnected => 'Network connected';

  @override
  String powerCoverMessage(String usbpwr) {
    return 'Power cover information\nUSB-Power: $usbpwr';
  }

  @override
  String get wirepassNode => 'Wirepas node message';

  @override
  String get usbPowered => 'USB-powered';

  @override
  String get never => 'Never';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String celluralRfDataRsrp(num? cellRsrp) {
    return 'RSRP: $cellRsrp ';
  }

  @override
  String get addingStackFailed => 'Adding stack failed';

  @override
  String get stackAlreadyExists => 'Stack already exists';

  @override
  String get clientDetails => 'Client details';

  @override
  String get secret => 'Secret';

  @override
  String get pathTitle => 'Path';

  @override
  String get acceloremeter => 'MUM mode';

  @override
  String get hallMode => 'Hall mode';

  @override
  String get selectGroup => 'Select group';

  @override
  String get thingseeStack => 'Thingsee stack';

  @override
  String get replacementDeviceCantBeDifferentType => 'The replacement device cannot be a different device type';

  @override
  String get enabled => 'Enabled';

  @override
  String amountIn(num? amountIn) {
    return 'Inside: $amountIn';
  }

  @override
  String get testMode => 'Test mode, please update device\'s configuration';
}
