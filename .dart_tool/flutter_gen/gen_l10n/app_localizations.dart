import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fi.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fi')
  ];

  /// Application title
  ///
  /// In en, this message translates to:
  /// **'Thingsee Toolbox'**
  String get installerTitle;

  /// Dialog text
  ///
  /// In en, this message translates to:
  /// **'Remove stack?'**
  String get removeStack;

  /// Remove text
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Cancel text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete stack dialog text
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove the stack from your account? The stack will remain available in the system.'**
  String get areYouSureYouWantToDeleteStack;

  /// Stack's client ID
  ///
  /// In en, this message translates to:
  /// **'Client ID: {id}'**
  String clientID(String id);

  /// Stack's path
  ///
  /// In en, this message translates to:
  /// **'Path: {path}'**
  String path(String path);

  /// OK text
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Info text
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// Add new stack text
  ///
  /// In en, this message translates to:
  /// **'Add a new stack'**
  String get addNewStack;

  /// Snackbar text
  ///
  /// In en, this message translates to:
  /// **'Stack added successfully'**
  String get stackAddedSuccessfully;

  /// Snackbar text
  ///
  /// In en, this message translates to:
  /// **'Stack deleted successfully'**
  String get stackDeletedSuccessfully;

  /// Stacks empty text
  ///
  /// In en, this message translates to:
  /// **'You have not taken any\nThingsee stacks into use.'**
  String get youHaveNotTakenStacksToUse;

  /// No results text
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// Filter text
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// Error text
  ///
  /// In en, this message translates to:
  /// **'An Error occurred'**
  String get errorOccured;

  /// Error text
  ///
  /// In en, this message translates to:
  /// **'Error: '**
  String get error;

  /// Error text
  ///
  /// In en, this message translates to:
  /// **'Problem connecting to the server'**
  String get problemConnectingToServers;

  /// Error text
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// Edit text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Environment text
  ///
  /// In en, this message translates to:
  /// **'pr - Production'**
  String get envProduction;

  /// Environment text
  ///
  /// In en, this message translates to:
  /// **'rd - Development'**
  String get envDevelopment;

  /// Environment text
  ///
  /// In en, this message translates to:
  /// **'dm - Demo'**
  String get envDemo;

  /// Environment text
  ///
  /// In en, this message translates to:
  /// **'un - Unassigned'**
  String get envUnassigned;

  /// Environment text
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get environment;

  /// Select environment text
  ///
  /// In en, this message translates to:
  /// **'Select environment'**
  String get selectEnvironment;

  /// Country text
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// Country text
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get selectCountry;

  /// Search text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Name text
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Enter group name text
  ///
  /// In en, this message translates to:
  /// **'Enter group name'**
  String get enterGroupName;

  /// Description text
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Enter group description text
  ///
  /// In en, this message translates to:
  /// **'Enter group description'**
  String get enterGroupDescription;

  /// Group adding info text
  ///
  /// In en, this message translates to:
  /// **'The name of the deployment group will be'**
  String get environmentNameWillBe;

  /// Add group text
  ///
  /// In en, this message translates to:
  /// **'Add group'**
  String get addGroup;

  /// Add group text
  ///
  /// In en, this message translates to:
  /// **'Add new deployment group'**
  String get addNewDeploymentGroup;

  /// Add group text
  ///
  /// In en, this message translates to:
  /// **'Group created successfully'**
  String get groupCreatedSuccessfully;

  /// Delete group text
  ///
  /// In en, this message translates to:
  /// **'Group deleted successfully'**
  String get groupDeletedSuccessfully;

  /// Delete group text
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove the deployment group? All devices assigned to this group will be moved to “Unassigned”.'**
  String get areYouSureYouWantToDeleteGroup;

  /// Delete group text
  ///
  /// In en, this message translates to:
  /// **'Remove deployment group?'**
  String get removeDeploymentGroup;

  /// Groups empty text
  ///
  /// In en, this message translates to:
  /// **'There are no deployment\ngroups in this stack.'**
  String get thereAreNoDeploymentGroups;

  /// Add groups text
  ///
  /// In en, this message translates to:
  /// **'Add new stack'**
  String get addNewGroup;

  /// Devices empty text
  ///
  /// In en, this message translates to:
  /// **'There are no devices in this deployment group.'**
  String get thereAreNoDevices;

  /// Add device text
  ///
  /// In en, this message translates to:
  /// **'Add new device'**
  String get addNewDevice;

  /// Device info text
  ///
  /// In en, this message translates to:
  /// **'Device info'**
  String get deviceInfo;

  /// First time open dialog text
  ///
  /// In en, this message translates to:
  /// **'Welcome to Thingsee Toolbox!\n\nStart by entering the details of the Thingsee stack you are going to use.'**
  String get welcomeToThingseeInstaller;

  /// Edit deployment group text
  ///
  /// In en, this message translates to:
  /// **'Edit deployment group'**
  String get editDeploymentGroup;

  /// Save changes text
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChanges;

  /// Edit device text
  ///
  /// In en, this message translates to:
  /// **'Edit device'**
  String get editDevice;

  /// TUID text
  ///
  /// In en, this message translates to:
  /// **'TUID'**
  String get tuid;

  /// Installation status text
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get installed;

  /// Installation status text
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newInstallation;

  /// Installation status text
  ///
  /// In en, this message translates to:
  /// **'Quarantine'**
  String get quarantine;

  /// Installation status text
  ///
  /// In en, this message translates to:
  /// **'Retired'**
  String get retired;

  /// Installation status text
  ///
  /// In en, this message translates to:
  /// **'Uninstalled'**
  String get uninstalled;

  /// Installation status text
  ///
  /// In en, this message translates to:
  /// **'Installation status'**
  String get installationStatus;

  /// Presence operating mode text
  ///
  /// In en, this message translates to:
  /// **'Visitor counter'**
  String get visitorCounter;

  /// Presence operating mode text
  ///
  /// In en, this message translates to:
  /// **'Occupancy'**
  String get occupancy;

  /// Presence operating mode text
  ///
  /// In en, this message translates to:
  /// **'Event-based'**
  String get eventBased;

  /// Installation location text
  ///
  /// In en, this message translates to:
  /// **'In'**
  String get locationIn;

  /// Installation location text
  ///
  /// In en, this message translates to:
  /// **'Out'**
  String get locationOut;

  /// Environment operating mode text
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultMode;

  /// Configuration text
  ///
  /// In en, this message translates to:
  /// **'Fixed interval'**
  String get fixedInterval;

  /// Environment operating mode text
  ///
  /// In en, this message translates to:
  /// **'Operating mode'**
  String get operatingMode;

  /// Configuration text
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// Save text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Save text
  ///
  /// In en, this message translates to:
  /// **'Orientation'**
  String get orientation;

  /// MUM mode text
  ///
  /// In en, this message translates to:
  /// **'MUM mode{newline}(accelerometer)'**
  String mumModeAccelerometer(String newline);

  /// Configuration text
  ///
  /// In en, this message translates to:
  /// **'Installation location'**
  String get installationLocation;

  /// Configuration text
  ///
  /// In en, this message translates to:
  /// **'Deployment group'**
  String get deploymentGroup;

  /// Replace device text
  ///
  /// In en, this message translates to:
  /// **'Replace device'**
  String get replaceDevice;

  /// Device add hint text
  ///
  /// In en, this message translates to:
  /// **'Read QR-code'**
  String get readQrCode;

  /// Configuration text
  ///
  /// In en, this message translates to:
  /// **'Hall mode{newline}(magnetic{newline}sensor)'**
  String hallModeMagneticSensor(String newline);

  /// Replace text
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replace;

  /// Add new device snackbar text
  ///
  /// In en, this message translates to:
  /// **'Device added successfully'**
  String get deviceAddedSuccessfully;

  /// Delete device snackbar text
  ///
  /// In en, this message translates to:
  /// **'Device deleted successfully'**
  String get deviceDeletedSuccessfully;

  /// QR text
  ///
  /// In en, this message translates to:
  /// **' Same device. Please read the QR code from the device that replaces the current one.'**
  String get sameDevice;

  /// QR text
  ///
  /// In en, this message translates to:
  /// **'Unknown QR code! \nPlease make sure that only one code is being read at a time'**
  String get unknownQRcode;

  /// QR text
  ///
  /// In en, this message translates to:
  /// **'You didn\'t provide permission to access the camera.'**
  String get cameraPermissionNotGranted;

  /// Delete device text
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove the device? It will be moved to “Unassigned”'**
  String get areYouSureYouWantToDeleteDevice;

  /// Delete device text
  ///
  /// In en, this message translates to:
  /// **'Remove device'**
  String get removeDevice;

  /// Delete device text
  ///
  /// In en, this message translates to:
  /// **'Device replaced successfully'**
  String get deviceReplacedSuccessfully;

  /// Replace device text
  ///
  /// In en, this message translates to:
  /// **'Original device'**
  String get originalDevice;

  /// Replace device text
  ///
  /// In en, this message translates to:
  /// **'Replace with'**
  String get replaceWith;

  /// Device Status text
  ///
  /// In en, this message translates to:
  /// **'Device status'**
  String get deviceStatus;

  /// Online text
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// Device Offline text
  ///
  /// In en, this message translates to:
  /// **'Offline, last seen: {offline}'**
  String offlineLastSeen(String offline);

  /// Battery level text
  ///
  /// In en, this message translates to:
  /// **'Battery level'**
  String get batteryLevel;

  /// Device Events text
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get deviceEvents;

  /// Edit device text
  ///
  /// In en, this message translates to:
  /// **'Device information updated successfully'**
  String get deviceUpdated;

  /// Vibration message text
  ///
  /// In en, this message translates to:
  /// **'Vibration: {activityLevel} Energy: {energyLevel}'**
  String vibration(num? activityLevel, num? energyLevel);

  /// No description provided for @accConfig.
  ///
  /// In en, this message translates to:
  /// **'Accelerometer sensor configuration'**
  String get accConfig;

  /// system info message text
  ///
  /// In en, this message translates to:
  /// **'Thing system information data'**
  String get systemInfo;

  /// Thing information request message text
  ///
  /// In en, this message translates to:
  /// **'Thing information request'**
  String get infoRequest;

  /// Thing information request message text
  ///
  /// In en, this message translates to:
  /// **'Thing information unavailable'**
  String get infoRequestUnv;

  /// Weather info message text
  ///
  /// In en, this message translates to:
  /// **'Air pressure: {airp} hPa '**
  String weatherInfoAirp(String airp);

  /// Weather info message text
  ///
  /// In en, this message translates to:
  /// **'Humidity: {humd}% '**
  String weatherInfoHumd(num? humd);

  /// Weather info message text
  ///
  /// In en, this message translates to:
  /// **'Temperature: {temp}°C '**
  String weatherInfoTemp(num? temp);

  /// Weather info message text
  ///
  /// In en, this message translates to:
  /// **'Light: {lght} lux '**
  String weatherInfoLght(num? lght);

  /// Magneto switch text
  ///
  /// In en, this message translates to:
  /// **'Hall: {hall} Hall count: {hallCount}'**
  String magnetoInfo(num? hall, num? hallCount);

  /// Leakage resistance data message text
  ///
  /// In en, this message translates to:
  /// **'Leakage resistance: {res}'**
  String leakageResistance(num? res);

  /// Sensor configuration message text
  ///
  /// In en, this message translates to:
  /// **'Sensor configuration message: {tsmId}'**
  String sensorConfig(int tsmId);

  /// Battery info text
  ///
  /// In en, this message translates to:
  /// **'Battery message'**
  String get batteryInfo;

  /// Ping message text
  ///
  /// In en, this message translates to:
  /// **'Ping'**
  String get ping;

  /// Move count message text
  ///
  /// In en, this message translates to:
  /// **'Move count: {moveCount}'**
  String moveCount(num? moveCount);

  /// Count message text
  ///
  /// In en, this message translates to:
  /// **'Count: {count}'**
  String count(num? count);

  /// Heartbeat message text
  ///
  /// In en, this message translates to:
  /// **'Heartbeat'**
  String get heartbeat;

  /// Gateway message text
  ///
  /// In en, this message translates to:
  /// **'Gateway message: {gatewayMessage}'**
  String gatewayMessage(String gatewayMessage);

  /// Edge core state message text
  ///
  /// In en, this message translates to:
  /// **'Edge core state change'**
  String get edgeCoreChange;

  /// Edge core stats message text
  ///
  /// In en, this message translates to:
  /// **'Edge core stats diagnostics data event request'**
  String get edgeCoreStats;

  /// Edge core binary message text
  ///
  /// In en, this message translates to:
  /// **'Edge core binary event'**
  String get edgeCoreBinary;

  /// Jam detection message text
  ///
  /// In en, this message translates to:
  /// **'Jam detection message'**
  String get jamDetection;

  /// Angle message text
  ///
  /// In en, this message translates to:
  /// **'Angle: {angle}°'**
  String angle(num? angle);

  /// Temperature message text
  ///
  /// In en, this message translates to:
  /// **'Temperature: {temperature}°C'**
  String temperature(num? temperature);

  /// Distance message text
  ///
  /// In en, this message translates to:
  /// **'Distance: {dist} mm'**
  String distance(num? dist);

  /// Beam information message text
  ///
  /// In en, this message translates to:
  /// **'Distance: {dist} mm'**
  String beamInfo(num? dist);

  /// Beam 2D area message text
  ///
  /// In en, this message translates to:
  /// **'Beam 2D area information'**
  String get beam2d;

  /// LED control message text
  ///
  /// In en, this message translates to:
  /// **'LED control request'**
  String get ledControl;

  /// Bottomnavigation item text
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get devices;

  /// Bottomnavigation item text
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get logs;

  /// Bottomnavigation item text
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// no battery item text
  ///
  /// In en, this message translates to:
  /// **'No battery data available'**
  String get noBattery;

  /// Sensor network neighbouring data text
  ///
  /// In en, this message translates to:
  /// **'Sensor network neighbouring data\nRSSI:{rssi}'**
  String neighbouringData(num? rssi);

  /// help
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @goToHelp.
  ///
  /// In en, this message translates to:
  /// **'Go to Haltian support center'**
  String get goToHelp;

  /// Licenses page text
  ///
  /// In en, this message translates to:
  /// **'Licenses'**
  String get licenses;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Export csv'**
  String get export;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Stop recording'**
  String get stopRecording;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Start recording'**
  String get startRecording;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Delete log file?'**
  String get deleteLogFile;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove the log file?'**
  String get areYouSureDeleteLogFile;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Recording on'**
  String get recordingOn;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Recording off'**
  String get recordingOff;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Log file deleted'**
  String get logFileDeleted;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'No events in this log file'**
  String get noEventsInThisLogFile;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Adding a device'**
  String get addingADevice;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Replacing a device'**
  String get replacingADevice;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Editing a device'**
  String get editingADevice;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Removing a device'**
  String get removingADevice;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Device added'**
  String get deviceAdded;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Device replaced'**
  String get deviceReplaced;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Device edited'**
  String get deviceEdited;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Device removed'**
  String get deviceRemoved;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Enter title'**
  String get enterTitle;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Enter description'**
  String get enterDescription;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Events included in the log:'**
  String get eventsIncludedInTheLog;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Add new log file'**
  String get addNewLogFile;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Edit log file'**
  String get editLogFile;

  /// Log events text
  ///
  /// In en, this message translates to:
  /// **'Add log'**
  String get addLog;

  /// Log events delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete log entry'**
  String get deleteLogEntry;

  /// Used by this application  text
  ///
  /// In en, this message translates to:
  /// **'Used by this application'**
  String get goToLicenses;

  /// version text
  ///
  /// In en, this message translates to:
  /// **'Version: {version}'**
  String version(String version);

  /// copyright text
  ///
  /// In en, this message translates to:
  /// **'Copyright {year} Haltian'**
  String copyright(String year);

  /// Delete log event text
  ///
  /// In en, this message translates to:
  /// **'Remove log entry?'**
  String get removeLogEntry;

  /// Delete log event text
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this log entry?'**
  String get areYouSureDeleteLogEntry;

  /// Log event text
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get device;

  /// Log event text
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// Log event text
  ///
  /// In en, this message translates to:
  /// **'Old device'**
  String get oldDevice;

  /// Installation notes text
  ///
  /// In en, this message translates to:
  /// **'Installation notes'**
  String get installationNotes;

  /// Log event text
  ///
  /// In en, this message translates to:
  /// **'Log entry deleted'**
  String get logEntryDeleted;

  /// Logging text
  ///
  /// In en, this message translates to:
  /// **'This note is stored in your device and will only be shown in the log.'**
  String get thisNoteIsStoredInYourDevice;

  /// Logging event text
  ///
  /// In en, this message translates to:
  /// **'New device'**
  String get newDevice;

  /// Logging event text
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get offline;

  /// Airquality event text
  ///
  /// In en, this message translates to:
  /// **'CO2: {carbonDioxide} ppm'**
  String carbonInfo(num? carbonDioxide);

  /// Airquality event text
  ///
  /// In en, this message translates to:
  /// **'TVOC: {tvoc} ppm'**
  String tvocInfo(num? tvoc);

  /// Airquality event text
  ///
  /// In en, this message translates to:
  /// **'Carbon Dioxide configure'**
  String get carbonConfig;

  /// Airquality event text
  ///
  /// In en, this message translates to:
  /// **'Carbon Dioxide manual calibrate'**
  String get carbonManual;

  /// Airquality event text
  ///
  /// In en, this message translates to:
  /// **'TVOC configure'**
  String get tvocConfig;

  /// Airquality event text
  ///
  /// In en, this message translates to:
  /// **'Carbon Dioxide read hardware component versions'**
  String get carbonHardware;

  /// Airquality event text
  ///
  /// In en, this message translates to:
  /// **'TVOC Reset'**
  String get tvocReset;

  /// Airquality event text
  ///
  /// In en, this message translates to:
  /// **'In: {countIn} Out: {out}'**
  String countInOut(int? countIn, int? out);

  /// Log event detail text
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// Logs text
  ///
  /// In en, this message translates to:
  /// **'No logs added'**
  String get noLogsAdded;

  /// Enter tuid text in search page
  ///
  /// In en, this message translates to:
  /// **'Enter TUID'**
  String get enterTuid;

  /// Battery level message
  ///
  /// In en, this message translates to:
  /// **'Battery Level: {batl} %'**
  String batl(int? batl);

  /// Save text
  ///
  /// In en, this message translates to:
  /// **'Orientation - x: {accx} - y: {accy} - z: {accz}'**
  String orientationMsg(num? accx, num? accy, num? accz);

  /// Cellular info text
  ///
  /// In en, this message translates to:
  /// **'Rat: {cellRat} '**
  String celluralRfDataRat(String? cellRat);

  /// Cellular info text
  ///
  /// In en, this message translates to:
  /// **'RSSI: {cellRssi} '**
  String celluralRfDataRssi(num? cellRssi);

  /// Cellular info text
  ///
  /// In en, this message translates to:
  /// **'MccMnc: {cellMccMnc} '**
  String cellularInfoMccMnc(String? cellMccMnc);

  /// Cellular info text
  ///
  /// In en, this message translates to:
  /// **'Operator: {operatorName} '**
  String cellularInfoOperator(String? operatorName);

  /// system Message detail text
  ///
  /// In en, this message translates to:
  /// **'System message: {msgId}'**
  String systemMessage(int msgId);

  /// Presence operating mode text
  ///
  /// In en, this message translates to:
  /// **'State: {state}'**
  String occupancyMode(num? state);

  /// CSV error text
  ///
  /// In en, this message translates to:
  /// **'Exporting CSV failed'**
  String get exportingCsvFailed;

  /// CSV error text
  ///
  /// In en, this message translates to:
  /// **'CSV saved in the \'Downloads\'-folder'**
  String get csvSavedToDownloadsFolder;

  /// CSV saving text
  ///
  /// In en, this message translates to:
  /// **'CSV saved'**
  String get csvSaved;

  /// Search device text
  ///
  /// In en, this message translates to:
  /// **'Enter TUID or read QR code'**
  String get enterTuidOrReadQR;

  /// firmware version box device text
  ///
  /// In en, this message translates to:
  /// **'Firmware version'**
  String get firmwareVersion;

  /// logfile updated text
  ///
  /// In en, this message translates to:
  /// **'Log file updated'**
  String get logFileUpdated;

  /// Search device error text
  ///
  /// In en, this message translates to:
  /// **'Device not found in the active stack'**
  String get deviceNotFound;

  /// networkDisconnected  text
  ///
  /// In en, this message translates to:
  /// **'Network disconnected'**
  String get networkDisconnected;

  /// network Connected  text
  ///
  /// In en, this message translates to:
  /// **'Network connected'**
  String get networkConnected;

  /// network Connected  text
  ///
  /// In en, this message translates to:
  /// **'Power cover information\nUSB-Power: {usbpwr}'**
  String powerCoverMessage(String usbpwr);

  /// network Connected  text
  ///
  /// In en, this message translates to:
  /// **'Wirepas node message'**
  String get wirepassNode;

  /// network Connected  text
  ///
  /// In en, this message translates to:
  /// **'USB-powered'**
  String get usbPowered;

  /// never online  text
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// yes text
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No text
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Cellular info text
  ///
  /// In en, this message translates to:
  /// **'RSRP: {cellRsrp} '**
  String celluralRfDataRsrp(num? cellRsrp);

  /// Adding stack failure text
  ///
  /// In en, this message translates to:
  /// **'Adding stack failed'**
  String get addingStackFailed;

  /// Adding stack failure text
  ///
  /// In en, this message translates to:
  /// **'Stack already exists'**
  String get stackAlreadyExists;

  /// Client details text
  ///
  /// In en, this message translates to:
  /// **'Client details'**
  String get clientDetails;

  /// Secret text
  ///
  /// In en, this message translates to:
  /// **'Secret'**
  String get secret;

  /// Path text
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get pathTitle;

  /// Path text
  ///
  /// In en, this message translates to:
  /// **'MUM mode'**
  String get acceloremeter;

  /// Path text
  ///
  /// In en, this message translates to:
  /// **'Hall mode'**
  String get hallMode;

  /// Select group text
  ///
  /// In en, this message translates to:
  /// **'Select group'**
  String get selectGroup;

  /// No description provided for @thingseeStack.
  ///
  /// In en, this message translates to:
  /// **'Thingsee stack'**
  String get thingseeStack;

  /// Replace device error text
  ///
  /// In en, this message translates to:
  /// **'The replacement device cannot be a different device type'**
  String get replacementDeviceCantBeDifferentType;

  /// Mode is enabled
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// amount in message
  ///
  /// In en, this message translates to:
  /// **'Inside: {amountIn}'**
  String amountIn(num? amountIn);

  /// Occupancy testmode message
  ///
  /// In en, this message translates to:
  /// **'Test mode, please update device\'s configuration'**
  String get testMode;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fi': return AppLocalizationsFi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
