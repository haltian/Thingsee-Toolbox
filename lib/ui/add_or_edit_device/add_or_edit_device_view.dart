import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/constants/installer_routes.dart';
import 'package:thingsee_installer/installer_log_event_manager.dart';
import 'package:thingsee_installer/logic/commands/cubit/commands_cubit.dart';
import 'package:thingsee_installer/logic/commands/cubit/commands_state.dart';
import 'package:thingsee_installer/logic/fetch_device_info/cubit/fetch_device_info_cubit.dart';
import 'package:thingsee_installer/logic/fetch_device_list/cubit/fetch_device_list_cubit.dart';
import 'package:thingsee_installer/logic/fetch_group_list/cubit/fetch_group_list_cubit.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/logic/set_installation_status/set_installation_status.dart';
import 'package:thingsee_installer/models/device_model.dart';
import 'package:thingsee_installer/models/installation_model.dart';
import 'package:thingsee_installer/protocol/device_command.dart';
import 'package:thingsee_installer/protocol/device_info.dart';
import 'package:thingsee_installer/protocol/group.dart';
import 'package:thingsee_installer/protocol/log_event.dart';
import 'package:thingsee_installer/ui/add_or_edit_device/add_or_edit_device_view_arguments.dart';
import 'package:thingsee_installer/ui/common/group_select_view.dart';
import 'package:thingsee_installer/ui/common/installer_close_button.dart';
import 'package:thingsee_installer/ui/common/installer_qr_button.dart';
import 'package:thingsee_installer/ui/common/installer_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thingsee_installer/ui/device_list/device_list_view_arguments.dart';
import '../../constants/installer_colors.dart';
import '../../constants/installer_icons.dart';
import '../../constants/installer_text_styles.dart';
import '../common/installer_button.dart';
import '../common/installer_dialogs.dart';
import '../common/installer_dropdown_button.dart';

class AddOrEditDeviceView extends StatefulWidget {
  final AddOrEditDeviceViewArguments arguments;
  const AddOrEditDeviceView({Key? key, required this.arguments})
      : super(key: key);

  @override
  State<AddOrEditDeviceView> createState() => _AddOrEditDeviceViewState();
}

class _AddOrEditDeviceViewState extends State<AddOrEditDeviceView> {
  String _selectedOperatingMode = "";
  String _selectedAccelerometerMode = "";
  String _selectedHallMode = "";
  String _selectedInstallationLocation = "";
  String? _selectedDeviceID;
  String? _selectedGroupId;
  String? _originalDeviceId;
  final InstallationModel installationModel = InstallationModel();
  final DeviceModel deviceModel = DeviceModel();
  bool _groupsLoading = false;
  bool _commandsLoading = false;
  bool _deviceInfoLoading = false;
  List<String> _groupIds = [];
  List<Group> _groups = [];
  List<DeviceCommand> _givenCommands = [];
  bool _updatingValues = false;
  bool _hasLogFile = false;
  final TextEditingController _installationNotesController =
      TextEditingController();
  final FocusNode _notesFocus = FocusNode();
  DeviceCommand? _currentCommand;
  String? _givenNotes;
  bool _alreadyCreatedLogFile = false;
  final ValueNotifier<String> qrResult = ValueNotifier<String>("");
  final ValueNotifier<String?> groupIdNotifier = ValueNotifier<String?>(null);
  final TextEditingController _deviceIdTextEditingController =
      TextEditingController();
  final FocusNode _deviceIdFocus = FocusNode();
  String? _writtenDeviceId;
  bool _notesChanged = false;
  DeviceInfo? _deviceInfo;
  bool _fetchedFromInit = true;
  AccelerometerMode _accelometerConfigItems = AccelerometerMode();
  HallMode _hallModeConfig = HallMode();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isAddPage()) {
        _fetchDeviceInfo(widget.arguments.deviceId!, true);
      }
      qrResult.addListener(_resultChanged);
      _deviceIdTextEditingController.addListener(_deviceIdChanged);
      groupIdNotifier.addListener(() {
        setState(() {
          _selectedGroupId = groupIdNotifier.value!;
        });
      });
      _installationNotesController.addListener(_notesTextChanged);

      if (!_isAddPage()) {
        _fetchDeploymentGroups();
      }
      if (_isEditPage()) {
        setState(() {
          _deviceInfoLoading = true;
          _commandsLoading = true;
        });
        _fetchDeviceCommands();
      } else {
        setState(() {
          _groupsLoading = false;
        });
      }

      _setDefaults(context);
      _doGroupHaveLogFile();
    });
    super.initState();
  }

  @override
  void dispose() {
    _notesFocus.dispose();
    groupIdNotifier.dispose();
    _deviceIdTextEditingController.dispose();
    _deviceIdFocus.dispose();
    _installationNotesController.dispose();
    super.dispose();
  }

  void _deviceIdChanged() {
    if (_deviceIdTextEditingController.text != _writtenDeviceId) {
      setState(() {
        _writtenDeviceId = _deviceIdTextEditingController.text;
      });
    }
  }

  void _setAccelerometerConfigs() {
    if (_selectedAccelerometerMode == AppLocalizations.of(context)!.disabled) {
      _accelometerConfigItems = installationModel
          .accelerometerModes(context, _deviceInfo!.version)
          .first;
    } else if (_selectedAccelerometerMode ==
        AppLocalizations.of(context)!.fixedInterval) {
      _accelometerConfigItems = installationModel
          .accelerometerModes(context, _deviceInfo!.version)
          .elementAt(1);
    } else if (_selectedAccelerometerMode ==
        AppLocalizations.of(context)!.eventBased) {
      _accelometerConfigItems = installationModel
          .accelerometerModes(context, _deviceInfo!.version)
          .last;
    }
  }

  bool _isGateway() {
    ThingseeSensorType originalType =
        deviceModel.getSensorType(widget.arguments.deviceId!);
    ThingseeSensorType selectedType =
        deviceModel.getSensorType(_selectedDeviceID!);
    if ((originalType == ThingseeSensorType.gatewayGlobal ||
            originalType == ThingseeSensorType.gatewayLan) &&
        (selectedType == ThingseeSensorType.gatewayGlobal ||
            selectedType == ThingseeSensorType.gatewayLan)) {
      return true;
    }
    return false;
  }

  void _setHallmodeConfig() {
    _hallModeConfig = installationModel
        .hallModes(context, _deviceInfo?.version)
        .firstWhere((element) => element.name == _selectedHallMode);
  }

  void _resultChanged() {
    if (qrResult.value == "") return;
    Navigator.pop(context);
    try {
      List<String> tuidParts = qrResult.value.split(',');
      if (tuidParts.length > 1 &&
          tuidParts[0].length == 11 &&
          tuidParts[1].length == 6) {
        setState(() {
          _selectedDeviceID = tuidParts[1] + tuidParts[0];
          _fetchDeviceCommands();
          _fetchDeviceInfo(_selectedDeviceID!, false);

          if (_isReplacePage()) {
            if ((deviceModel.getSensorType(widget.arguments.deviceId!) !=
                    deviceModel.getSensorType(_selectedDeviceID!)) &&
                (_isGateway() == false)) {
              InstallerDialogs().showInfoDialog(
                  context: context,
                  title: AppLocalizations.of(context)!.errorOccured,
                  message: AppLocalizations.of(context)!
                      .replacementDeviceCantBeDifferentType,
                  buttonText: AppLocalizations.of(context)!.ok,
                  shouldPop: false);
              _selectedDeviceID = null;
              return;
            }
          }
        });
        if (_selectedDeviceID == widget.arguments.deviceId) {
          InstallerDialogs().showInfoDialog(
              context: context,
              title: AppLocalizations.of(context)!.errorOccured,
              message: AppLocalizations.of(context)!.sameDevice,
              buttonText: AppLocalizations.of(context)!.ok,
              shouldPop: false);
          setState(() {
            _selectedDeviceID = null;
          });
        }
      } else {
        throw Exception();
      }
    } catch (e) {
      InstallerDialogs().showInfoDialog(
          context: context,
          title: AppLocalizations.of(context)!.errorOccured,
          message: AppLocalizations.of(context)!.unknownQRcode,
          buttonText: AppLocalizations.of(context)!.ok,
          shouldPop: false);
    }
  }

  void _notesTextChanged() {
    if (_installationNotesController.text != _givenNotes) {
      setState(() {
        _givenNotes = _installationNotesController.text;
        _notesChanged = true;
      });
    }
  }

  void _checkLogFiles(IncudedEvent event) async {
    await InstallerLogEventManager()
        .logFilesToCreate(widget.arguments.group!.group_id, event)
        .then((value) {
      if (value.isNotEmpty) {
        InstallerUserRepository()
            .getSavedLogEventsForId(value
                .firstWhere((element) =>
                    element.groupId == widget.arguments.group!.group_id)
                .id)
            .then((events) {
          _setNotesText(events);
        });
        setState(() {
          _hasLogFile = true;
        });
      }
    });
  }

  void _setNotesText(List<LogEvent>? _events) {
    setState(() {
      List<LogEvent> _logEventsForTheDevice = [];
      if (_events != null && _events.isNotEmpty) {
        try {
          _logEventsForTheDevice = _events
              .where((element) => element.deviceId == _selectedDeviceID)
              .toList();
          _givenNotes = _logEventsForTheDevice.last.note != null
              ? _logEventsForTheDevice.last.note
              : null;
          if (_givenNotes != null) {
            _installationNotesController.text = _givenNotes.toString();
          }
        } catch (e) {
          print(e);
        }
      }
    });
  }

  void _doGroupHaveLogFile() {
    if (_isReplacePage()) {
      _checkLogFiles(IncudedEvent.replacingDevice);
    } else if (_isEditPage()) {
      _checkLogFiles(IncudedEvent.editingDevice);
    } else if (_isAddPage()) {
      _checkLogFiles(IncudedEvent.addingDevice);
    }
  }

  void _saveLogEvent(DeviceInfo? info) {
    if (_hasLogFile) {
      try {
        InstallerLogEventManager().createLogEvents(
          triggerEvent: _isEditPage()
              ? IncudedEvent.editingDevice
              : _isReplacePage()
                  ? IncudedEvent.replacingDevice
                  : IncudedEvent.addingDevice,
          deviceId: _selectedDeviceID!,
          deviceStatus:
              // Log event isOnline funktion checks new devices online function
              deviceModel.isOnline(info!.timestamp,
                      deviceModel.getSensorType(_selectedDeviceID!))
                  ? InstallerConstants.offline
                  : InstallerConstants.online,
          logFileGroupId: widget.arguments.group!.group_id,
          note: _givenNotes,
          oldDeviceId: _originalDeviceId,
          accelerometerMode: _givenCommands.isNotEmpty &&
                  _givenCommands.first.accelerometerMode != null &&
                  _givenCommands.first.accelerometerMode !=
                      _currentCommand!.accelerometerMode
              ? _givenCommands.first.accelerometerMode
              : null,
          peopleCountingOrientation: _givenCommands.isNotEmpty &&
                  _givenCommands.first.peopleCountingOrientation != null &&
                  _givenCommands.first.peopleCountingOrientation !=
                      _currentCommand!.peopleCountingOrientation
              ? _givenCommands.first.peopleCountingOrientation
              : null,
          hallMode: _givenCommands.isNotEmpty &&
                  _givenCommands.first.hallMode != null &&
                  _currentCommand!.hallMode != null &&
                  _givenCommands.first.hallMode != _currentCommand!.hallMode
              ? _givenCommands.first.hallMode
              : null,
          mode: _givenCommands.isNotEmpty &&
                  _givenCommands.first.mode != null &&
                  _givenCommands.first.mode != _currentCommand!.mode
              ? _givenCommands.first.mode
              : null,
          newGroupId: _selectedGroupId != widget.arguments.group!.group_id
              ? _selectedGroupId
              : null,
          version: info.version,
          measurementInterval: _givenCommands.isNotEmpty &&
                  _givenCommands.first.accelerometerMode != null &&
                  _givenCommands.first.accelerometerMode !=
                      _currentCommand!.accelerometerMode
              ? _givenCommands.first.measurementInterval
              : null,
        );
      } catch (error) {
        InstallerDialogs().showInfoDialog(
            context: context,
            title: "Log saving failed",
            message: "Error: $error",
            buttonText: AppLocalizations.of(context)!.ok,
            shouldPop: false);
      }
    }
  }

  void _fetchDeviceInfo(String deviceId, bool fetchedFromInit) async {
    setState(() {
      _fetchedFromInit = fetchedFromInit;
    });

    BlocProvider.of<FetchDeviceInfoCubit>(context)
        .fetchDeviceInfo(stack: widget.arguments.stack, deviceID: deviceId);
  }

  void _fetchDeploymentGroups() {
    BlocProvider.of<FetchGroupListCubit>(context)
        .fetchGroupList(stack: widget.arguments.stack);
  }

  void _fetchDeviceCommands() {
    BlocProvider.of<CommandsCubit>(context).fetchAllCommands(
        stack: widget.arguments.stack,
        deviceId: _selectedDeviceID != null
            ? _selectedDeviceID!
            : widget.arguments.deviceId!,
        limit: 1);
  }

  void _setInstallationStatusAndGroup() {
    // Check if page is add, edit or replace and do requests for these actions
    if (_isReplacePage()) {
      // Replace device
      BlocProvider.of<SetInstallationStatusCubit>(context)
          .setInstallationStatus(
              stack: widget.arguments.stack,
              newStatus: InstallerConstants.installed,
              deviceId: _selectedDeviceID!,
              groupId: _selectedGroupId!);
      if (_givenCommands.isNotEmpty) {
        BlocProvider.of<CommandsCubit>(context).sendCommands(
            stack: widget.arguments.stack,
            deviceId: _selectedDeviceID!,
            commands: _givenCommands);
      }
    } else if (_isAddPage()) {
      BlocProvider.of<SetInstallationStatusCubit>(context)
          .setInstallationStatus(
              stack: widget.arguments.stack,
              newStatus: InstallerConstants.installed,
              deviceId: _selectedDeviceID!,
              groupId: _selectedGroupId!);
      if (_givenCommands.isNotEmpty) {
        BlocProvider.of<CommandsCubit>(context).sendCommands(
            stack: widget.arguments.stack,
            deviceId: _getDeviceId(),
            commands: _givenCommands);
      }
    } else if (_isEditPage()) {
      if (widget.arguments.group!.group_id != _selectedGroupId) {
        BlocProvider.of<SetInstallationStatusCubit>(context)
            .setInstallationStatus(
                stack: widget.arguments.stack,
                newStatus: null,
                deviceId: _selectedDeviceID!,
                groupId: _selectedGroupId!);
      }
      if (_givenCommands.isNotEmpty) {
        BlocProvider.of<CommandsCubit>(context).sendCommands(
            stack: widget.arguments.stack,
            deviceId: _getDeviceId(),
            commands: _givenCommands);
      } else if (_notesChanged == true) {
        BlocProvider.of<SetInstallationStatusCubit>(context)
            .setInstallationStatus(
                stack: widget.arguments.stack,
                newStatus: null,
                deviceId: _selectedDeviceID!,
                groupId: _selectedGroupId!);
      }
    }
  }

  void _setDefaults(BuildContext context) {
    setState(() {
      if (widget.arguments.deviceId != null) {
        if (_isReplacePage()) {
          _originalDeviceId = widget.arguments.deviceId;
        } else {
          _selectedDeviceID = widget.arguments.deviceId;
        }
      }
      if (widget.arguments.group != null) {
        _selectedGroupId = widget.arguments.group!.group_id;
        groupIdNotifier.value = widget.arguments.group!.group_id;
      }
      _selectedOperatingMode = AppLocalizations.of(context)!.visitorCounter;
      _selectedAccelerometerMode = AppLocalizations.of(context)!.disabled;
      _selectedInstallationLocation = AppLocalizations.of(context)!.locationIn;
      _selectedHallMode = AppLocalizations.of(context)!.disabled;
    });
  }

  _requestPermission() async {
    if (await Permission.camera.request().isGranted) {
      qrResult.value = "";
      Navigator.of(context)
          .pushNamed(InstallerRoutes.qrViewRoute, arguments: qrResult);
    } else {
      InstallerDialogs().showInfoDialog(
          shouldPop: false,
          context: context,
          title: AppLocalizations.of(context)!.errorOccured,
          message: AppLocalizations.of(context)!.cameraPermissionNotGranted,
          buttonText: AppLocalizations.of(context)!.ok);
    }
  }

  bool _isReplacePage() {
    return widget.arguments.pageAction == PageAction.replaceDevice;
  }

  bool _isAddPage() {
    return widget.arguments.pageAction == PageAction.addDevice;
  }

  bool _isEditPage() {
    return widget.arguments.pageAction == PageAction.editDevice;
  }

  bool validateFields() {
    if (_isEditPage()) {
      return _selectedGroupId != widget.arguments.group!.group_id ||
          _givenCommands.isNotEmpty ||
          _notesChanged == true;
    } else if (_isReplacePage() || _isAddPage()) {
      return _selectedDeviceID != null && _selectedDeviceID != "" ||
          _writtenDeviceId != null && _writtenDeviceId!.length > 5;
    } else {
      return _selectedDeviceID != null && _selectedDeviceID != "";
    }
  }

  bool _checkSensorTypeAndID(
      String? selectedTuid, ThingseeSensorType sensorType) {
    return (selectedTuid != null &&
        deviceModel.getSensorType(_selectedDeviceID!) == sensorType);
  }

  String _formatSnackBarText() {
    return _isReplacePage()
        ? AppLocalizations.of(context)!.deviceReplacedSuccessfully
        : _isAddPage()
            ? AppLocalizations.of(context)!.deviceAddedSuccessfully
            : AppLocalizations.of(context)!.deviceUpdated;
  }

  void _popPagesAndGoToDeviceListView(String newGroupID) {
    // Pop old pages
    final updatedGroup =
        _groups.firstWhere((element) => element.group_id == newGroupID);
    _popPages();
    Navigator.of(context).pushNamed(InstallerRoutes.deviceListViewRoute,
        arguments:
            DeviceListViewArguments(updatedGroup, widget.arguments.stack));
  }

  void _popPages() {
    for (int i = 0; i < 2; i++) {
      Navigator.pop(context);
    }
  }

  void _addCommandsToUpdate(DeviceCommand? commandToSend) {
    setState(() {
      _givenCommands.clear();
      _givenCommands.add(commandToSend!);
    });
  }

  String _formatTUID() {
    String _value = AppLocalizations.of(context)!.readQrCode;
    if (_originalDeviceId != null) {
      _value = _originalDeviceId.toString();
    } else if (_selectedDeviceID != null) {
      _value = _selectedDeviceID.toString();
    }
    return _value;
  }

  String _getDeviceId() {
    if (_isAddPage()) {
      return _selectedDeviceID!;
    } else {
      return widget.arguments.deviceId!;
    }
  }

  Widget _buildPage() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          // TUID
          if (_isAddPage())
            Padding(
                padding: const EdgeInsets.only(left: 27, right: 27, top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: SizedBox(
                        child: InstallerTextField(
                          inputAction: TextInputAction.next,
                          title: widget.arguments.pageAction !=
                                  PageAction.replaceDevice
                              ? AppLocalizations.of(context)!.tuid
                              : AppLocalizations.of(context)!.originalDevice,
                          includeSearchIcon: false,
                          readOnly: true,
                          includeSuffixIcon:
                              _deviceIdTextEditingController.text.isNotEmpty,
                          blackHintText: widget.arguments.pageAction !=
                                  PageAction.addDevice ||
                              _selectedDeviceID != null,
                          hintText: _formatTUID(),
                          textEditingController: _deviceIdTextEditingController,
                          focus: _deviceIdFocus,
                        ),
                      ),
                    ),
                    if (widget.arguments.pageAction != PageAction.replaceDevice)
                      InstallerQrButton(
                          height: 58,
                          circularCorner: false,
                          onPressed: () async {
                            _requestPermission();
                          })
                  ],
                )),

          // Original TUID
          if (_isReplacePage())
            Padding(
              padding: const EdgeInsets.only(left: 27, right: 27, top: 20),
              child: Stack(
                fit: StackFit.passthrough,
                children: [
                  InstallerTextField(
                      readOnly: true,
                      blackHintText: true,
                      inputAction: TextInputAction.next,
                      title: AppLocalizations.of(context)!.originalDevice,
                      includeSearchIcon: false,
                      hintText: _formatTUID(),
                      textEditingController: TextEditingController(),
                      focus: FocusNode()),
                  if (widget.arguments.pageAction != PageAction.replaceDevice)
                    Positioned(
                        right: 0,
                        bottom: 1,
                        child: InstallerQrButton(
                            height: 58,
                            circularCorner: false,
                            onPressed: () {
                              _requestPermission();
                            })),
                ],
              ),
            ),

          // Replace page new tuid
          if (_isReplacePage())
            Padding(
              padding: EdgeInsets.only(left: 27, right: 27, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: SizedBox(
                      child: InstallerTextField(
                        inputAction: TextInputAction.next,
                        title: AppLocalizations.of(context)!.replaceWith,
                        includeSearchIcon: false,
                        readOnly: true,
                        includeSuffixIcon:
                            _deviceIdTextEditingController.text.isNotEmpty,
                        blackHintText: widget.arguments.pageAction !=
                                    PageAction.addDevice &&
                                !_isReplacePage() ||
                            _selectedDeviceID != null,
                        hintText: _selectedDeviceID != null
                            ? _selectedDeviceID.toString()
                            : AppLocalizations.of(context)!.readQrCode,
                        textEditingController: _deviceIdTextEditingController,
                        focus: _deviceIdFocus,
                      ),
                    ),
                  ),
                  InstallerQrButton(
                      height: 58,
                      circularCorner: false,
                      onPressed: () async {
                        _requestPermission();
                      })
                ],
              ),
            ),

          if (_isReplacePage()) const SizedBox(height: 50),

          // Presence operating mode select
          if (_checkSensorTypeAndID(
              _selectedDeviceID, ThingseeSensorType.presence))
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InstallerDropDownButton(
                  blackHintText: true,
                  title: AppLocalizations.of(context)!.operatingMode,
                  hintText: _selectedOperatingMode,
                  items: installationModel.presenceModes(context).sublist(1),
                  onChanged: (value) {
                    setState(() {
                      _selectedOperatingMode = value!;
                    });
                    // First send messasge 1500 to add measurment intervals for the device after that add operating mode to device
                    _addCommandsToUpdate((DeviceCommand(
                        1500,
                        30,
                        widget.arguments.deviceId != null
                            ? widget.arguments.deviceId.toString()
                            : _selectedDeviceID.toString(),
                        null,
                        null,
                        installationModel
                            .presenceModes(context)
                            .indexOf(value!),
                        null,
                        null,
                        null,
                        deviceModel.getReportingInterval(
                            context, _deviceInfo!.version!, value),
                        deviceModel.getPassiveReportingInterval(
                            context, _deviceInfo!.version!, value),
                        null)));
                    //Use _givecommands to avoid clearing _addCommandsToUpdate second time and not sending 2 messages
                    _givenCommands.add(DeviceCommand(
                        deviceModel.getTsmId(_selectedDeviceID.toString(),
                            ConfigurationItem.operatingMode),
                        30,
                        widget.arguments.deviceId != null
                            ? widget.arguments.deviceId.toString()
                            : _selectedDeviceID.toString(),
                        null,
                        null,
                        installationModel.presenceModes(context).indexOf(value),
                        null,
                        null,
                        null,
                        null,
                        deviceModel.getPassiveReportingInterval(
                            context, _deviceInfo!.version!, value),
                        null));
                  }),
            ),

          // Environment MUM mode
          if (_checkSensorTypeAndID(
                  _selectedDeviceID, ThingseeSensorType.environment) ||
              _checkSensorTypeAndID(
                  _selectedDeviceID, ThingseeSensorType.environmentRugged))
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InstallerDropDownButton(
                  blackHintText: true,
                  title:
                      AppLocalizations.of(context)!.mumModeAccelerometer(" "),
                  hintText: _selectedAccelerometerMode,
                  items: installationModel.accelerometerModeNames(
                      context, _deviceInfo!.version),
                  onChanged: (value) {
                    setState(() {
                      _selectedAccelerometerMode = value!;
                      _setAccelerometerConfigs();
                      _setHallmodeConfig();
                    });
                    // Sending 2 messages because MUM and Hall mode use different tsmid for config change message
                    // 1st add mum mode command
                    _addCommandsToUpdate(DeviceCommand(
                        deviceModel.getTsmId(
                            _isEditPage()
                                ? widget.arguments.deviceId!
                                : _selectedDeviceID!,
                            ConfigurationItem.accelerometer,
                            _deviceInfo!.version!),
                        30,
                        _isEditPage()
                            ? widget.arguments.deviceId!
                            : _selectedDeviceID!,
                        null,
                        null,
                        null,
                        _accelometerConfigItems.mode,
                        _hallModeConfig.mode,
                        deviceModel.getMeasurementInterval(context,
                            _deviceInfo!.version!, _selectedAccelerometerMode),
                        deviceModel.getReportingInterval(context,
                            _deviceInfo!.version!, _selectedAccelerometerMode),
                        null,
                        null));
                    // Use _givenCommands.add to add message without clearing _addCommandsToUpdate
                    // Then add Hall mode command
                    _givenCommands.add(DeviceCommand(
                        deviceModel.getTsmId(_getDeviceId(),
                            ConfigurationItem.hall, _deviceInfo!.version!),
                        30,
                        _getDeviceId(),
                        null,
                        null,
                        null,
                        _accelometerConfigItems.mode,
                        _hallModeConfig.mode,
                        deviceModel.getMeasurementInterval(context,
                            _deviceInfo!.version!, _selectedAccelerometerMode),
                        deviceModel.getReportingInterval(context,
                            _deviceInfo!.version!, _selectedAccelerometerMode),
                        null,
                        null));
                    //1500 messages to add measurement intervals for the sensor
                    _givenCommands.add(DeviceCommand(
                        1500,
                        30,
                        _getDeviceId(),
                        null,
                        null,
                        null,
                        _accelometerConfigItems.mode,
                        _hallModeConfig.mode,
                        deviceModel.getMeasurementInterval(context,
                            _deviceInfo!.version!, _selectedAccelerometerMode),
                        deviceModel.getReportingInterval(context,
                            _deviceInfo!.version!, _selectedAccelerometerMode),
                        null,
                        null));
                  }),
            ),
          // Hall mode select
          if (_checkSensorTypeAndID(
                  _selectedDeviceID, ThingseeSensorType.environment) ||
              _checkSensorTypeAndID(
                  _selectedDeviceID, ThingseeSensorType.environmentRugged))
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InstallerDropDownButton(
                blackHintText: true,
                title:
                    AppLocalizations.of(context)!.hallModeMagneticSensor(" "),
                hintText: _selectedHallMode,
                items: installationModel.hallModeNames(
                    context, _deviceInfo?.version),
                onChanged: (value) {
                  setState(() {
                    _selectedHallMode = value!;
                    _setAccelerometerConfigs();
                    _setHallmodeConfig();
                  });
                  // Sending 2 messages because MUM and Hall mode use different tsmid for config change message
                  // 1st use Hall mode
                  _addCommandsToUpdate(DeviceCommand(
                      deviceModel.getTsmId(
                          _isEditPage()
                              ? widget.arguments.deviceId!
                              : _selectedDeviceID!,
                          ConfigurationItem.accelerometer,
                          _deviceInfo!.version!),
                      30,
                      _getDeviceId(),
                      null,
                      null,
                      null,
                      _accelometerConfigItems.mode,
                      _hallModeConfig.mode,
                      deviceModel.getMeasurementInterval(context,
                          _deviceInfo!.version!, _selectedAccelerometerMode),
                      deviceModel.getReportingInterval(context,
                          _deviceInfo!.version!, _selectedAccelerometerMode),
                      null,
                      null));
                  // Use _givenCommands.add to add message without clearing _addCommandsToUpdate
                  // Then add MUM mode command
                  _givenCommands.add(DeviceCommand(
                      deviceModel.getTsmId(
                          _isEditPage()
                              ? widget.arguments.deviceId!
                              : _selectedDeviceID!,
                          ConfigurationItem.hall,
                          _deviceInfo!.version!),
                      30,
                      _isEditPage()
                          ? widget.arguments.deviceId!
                          : _selectedDeviceID!,
                      null,
                      null,
                      null,
                      _accelometerConfigItems.mode,
                      _hallModeConfig.mode,
                      deviceModel.getMeasurementInterval(context,
                          _deviceInfo!.version!, _selectedAccelerometerMode),
                      deviceModel.getReportingInterval(context,
                          _deviceInfo!.version!, _selectedAccelerometerMode),
                      null,
                      null));

                  //1500 message to add measurement intervals for the sensor
                  _givenCommands.add(DeviceCommand(
                      1500,
                      30,
                      _getDeviceId(),
                      null,
                      null,
                      null,
                      _accelometerConfigItems.mode,
                      _hallModeConfig.mode,
                      deviceModel.getMeasurementInterval(context,
                          _deviceInfo!.version!, _selectedAccelerometerMode),
                      deviceModel.getReportingInterval(context,
                          _deviceInfo!.version!, _selectedAccelerometerMode),
                      null,
                      null));
                },
              ),
            ),

          // IN/OUT mode select
          if (_checkSensorTypeAndID(
              _selectedDeviceID, ThingseeSensorType.count))
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InstallerDropDownButton(
                blackHintText: true,
                title: AppLocalizations.of(context)!.installationLocation,
                hintText: _selectedInstallationLocation,
                items: installationModel.installationLocations(context),
                onChanged: (value) {
                  _addCommandsToUpdate(DeviceCommand(
                      deviceModel.getTsmId(_getDeviceId(),
                          ConfigurationItem.installationLocation),
                      30,
                      _getDeviceId(),
                      installationModel
                          .installationLocations(context)
                          .indexOf(value!),
                      null,
                      null,
                      null,
                      null,
                      null,
                      null,
                      null,
                      null));
                },
              ),
            ),

          // Group select
          if (!_isAddPage())
            _isReplacePage()
                ? Padding(
                    padding:
                        const EdgeInsets.only(left: 27, right: 27, top: 10),
                    child: InstallerTextField(
                        readOnly: true,
                        blackHintText: false,
                        inputAction: TextInputAction.next,
                        title: AppLocalizations.of(context)!.deploymentGroup,
                        includeSearchIcon: false,
                        hintText: _selectedGroupId!,
                        textEditingController: TextEditingController(),
                        focus: FocusNode()),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: InstallerDropDownButton(
                      blackHintText: _selectedGroupId != null,
                      iconVisible: false,
                      title: AppLocalizations.of(context)!.deploymentGroup,
                      hintText: _selectedGroupId != null
                          ? _selectedGroupId!
                          : AppLocalizations.of(context)!.selectGroup,
                      items: const [],
                      onChanged: (_) {},
                      onTap: () {
                        Navigator.of(context).pushNamed(
                            InstallerRoutes.groupSelectView,
                            arguments: GroupSelectViewArguments(
                                _groups, groupIdNotifier));
                      },
                    ),
                  ),

          // Installation notes
          if (_hasLogFile)
            Padding(
              padding: const EdgeInsets.only(left: 27, right: 27, top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InstallerTextField(
                      readOnly: false,
                      inputAction: TextInputAction.done,
                      title: "",
                      includeSearchIcon: false,
                      blackHintText: (_givenNotes != null && _givenNotes != ""),
                      hintText: _givenNotes != null && _givenNotes != ""
                          ? _givenNotes.toString()
                          : AppLocalizations.of(context)!.installationNotes,
                      textEditingController: _installationNotesController,
                      focus: _notesFocus),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: 300,
                      child: Text(
                        AppLocalizations.of(context)!
                            .thisNoteIsStoredInYourDevice,
                        style: InstallerTextStyles.logEventDetails
                            .copyWith(fontSize: 14, height: 16 / 14),
                      ),
                    ),
                  )
                ],
              ),
            ),
        ]);
  }

  Widget _deviceInfoWidget() {
    return _selectedDeviceID != null && !_isReplacePage()
        ? Container(
            width: double.infinity,
            height: 110.0,
            color: InstallerColor.blueColor,
            child: Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    InstallerIcons.createInstallerAssetImage(
                        assetPath:
                            deviceModel.getSensorImage(_selectedDeviceID!),
                        width: 85,
                        height: 56),
                    const SizedBox(width: 25),
                    Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(_selectedDeviceID!,
                              style: InstallerTextStyles.titleText
                                  .copyWith(color: Colors.white, fontSize: 18)),
                          Text(deviceModel.getSensorName(_selectedDeviceID!),
                              style: InstallerTextStyles.bodyText
                                  .copyWith(color: Colors.white)),
                        ],
                      ),
                    ),
                  ]),
            ))
        : Container();
  }

  void _setConfigurationsNames(DeviceCommand? command) {
    if (command!.mode != null) {
      setState(() {
        _selectedOperatingMode =
            installationModel.presenceModes(context).elementAt(command.mode!);
      });
    }
    if (command.peopleCountingOrientation != null) {
      setState(() {
        _selectedInstallationLocation = installationModel
            .installationLocations(context)
            .elementAt(command.peopleCountingOrientation!);
      });
    }
    if (command.accelerometerMode != null) {
      setState(() {
        // Fetch true accelerometermode to UI
        _selectedAccelerometerMode = installationModel.selectedMode(
            context,
            command.accelerometerMode,
            command.measurementInterval,
            _deviceInfo!.version.toString());
      });
    }
    if (command.hallMode != null) {
      setState(() {
        _selectedHallMode =
            installationModel.selectedHallMode(context, command.hallMode);
      });
    }
  }

  void _fetchDeviceList() async {
    BlocProvider.of<FetchDeviceListCubit>(context).fetchDeviceList(
        stack: widget.arguments.stack,
        groupId: widget.arguments.group!.group_id);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CommandsCubit, CommandsState>(
          listener: (context, state) {
            if (state is CommandInProgress) {
              if (state.isSending) {
                setState(() {
                  _updatingValues = true;
                });
              } else {
                setState(() {
                  _commandsLoading = true;
                });
              }
            } else if (state is CommandSuccess) {
              // If state.commands is not null, we updated commands
              if (state.commands != null) {
                if (_isAddPage()) {
                  _setConfigurationsNames(state.commands!.first);
                } else {
                  _saveLogEvent(_deviceInfo);
                  InstallerDialogs().showSnackBar(
                      context: context, message: _formatSnackBarText());
                  if (_isReplacePage()) {
                    _fetchDeviceList();
                    _popPagesAndGoToDeviceListView(_selectedGroupId!);
                  } else {
                    Navigator.pop(context);
                    // Fetch commands to update device info page
                    BlocProvider.of<CommandsCubit>(context).fetchAllCommands(
                        stack: widget.arguments.stack,
                        deviceId: _getDeviceId(),
                        limit: 1);
                  }
                }

                // Else if state.commandsResponse is not null, we fetched commands
              } else if (state.commandsResponse != null &&
                  state.commandsResponse!.isNotEmpty) {
                if (_isAddPage()) {
                  _fetchDeviceInfo(_selectedDeviceID!, true);
                }
                setState(() {
                  _currentCommand = state.commandsResponse!.first.command;
                });
                _setConfigurationsNames(state.commandsResponse!.first.command);
              }
              setState(() {
                _commandsLoading = false;
              });
            } else if (state is CommandFailed) {
              setState(() {
                _commandsLoading = false;
              });
            }
          },
        ),
        BlocListener<FetchGroupListCubit, FetchGroupListState>(
          listener: (context, state) {
            if (state is FetchDeviceInfoInProgress) {
              setState(() {
                _groupsLoading = true;
              });
            } else if (state is FetchGroupListSuccess) {
              setState(() {
                _groups = state.groups;
                _groupIds.addAll(state.groups.map((e) => e.group_id));
                _groupsLoading = false;
              });
            } else if (state is FetchGroupListFailed) {
              setState(() {
                _groupsLoading = false;
              });
            }
          },
        ),
        BlocListener<SetInstallationStatusCubit, SetInstallationStatusState>(
          listener: (context, state) {
            if (state is SetInstallationStatusInProgress) {
              setState(() {
                _updatingValues = true;
              });
            } else if (state is SetInstallationStatusSuccess) {
              setState(() {
                if (_isAddPage()) {
                  InstallerDialogs().showSnackBar(
                      context: context, message: _formatSnackBarText());
                  _saveLogEvent(_deviceInfo);
                  Navigator.pop(context, InstallerConstants.success);
                } else if (_isReplacePage()) {
                  if (_alreadyCreatedLogFile == false &&
                      _givenCommands.isEmpty) {
                    _saveLogEvent(_deviceInfo);
                    setState(() {
                      _alreadyCreatedLogFile = true;
                    });

                    if (state.installationStatus.installation_status ==
                            InstallerConstants.installed &&
                        state.installationStatus.tuid == _selectedDeviceID) {
                      // If new device is successfully installed, then set old device as retired
                      BlocProvider.of<SetInstallationStatusCubit>(context)
                          .setInstallationStatus(
                              stack: widget.arguments.stack,
                              newStatus: InstallerConstants.retired,
                              deviceId: _originalDeviceId!,
                              groupId: InstallerConstants.unassigned);
                    }
                  } else if (_givenCommands.isNotEmpty) {
                    if (state.installationStatus.installation_status ==
                            InstallerConstants.installed &&
                        state.installationStatus.tuid == _selectedDeviceID) {
                      // If new device is successfully installed, then set old device as retired
                      BlocProvider.of<SetInstallationStatusCubit>(context)
                          .setInstallationStatus(
                              stack: widget.arguments.stack,
                              newStatus: InstallerConstants.retired,
                              deviceId: _originalDeviceId!,
                              groupId: InstallerConstants.unassigned);
                    }
                  }
                  // Make sure the device is retired and the group is changed before leaving this page

                  if (state.installationStatus.installation_status ==
                          InstallerConstants.retired &&
                      state.installationStatus.tuid == _originalDeviceId &&
                      _givenCommands.isEmpty) {
                    InstallerDialogs().showSnackBar(
                        context: context, message: _formatSnackBarText());
                    _popPagesAndGoToDeviceListView(_selectedGroupId!);
                  }
                } else {
                  _saveLogEvent(_deviceInfo);
                  InstallerDialogs().showSnackBar(
                      context: context, message: _formatSnackBarText());
                  Navigator.pop(context);

                  if (_isEditPage() &&
                      _selectedGroupId != widget.arguments.group!.group_id) {
                    _popPagesAndGoToDeviceListView(
                        state.installationStatus.group_id!);
                  } else {
                    Navigator.pop(context);
                  }
                  _updatingValues = false;
                }
              });
            } else if (state is SetInstallationStatusFailed) {
              setState(() {
                _updatingValues = false;
                _selectedDeviceID = null;
                _deviceIdTextEditingController.clear();
                _writtenDeviceId = null;
              });
            }
          },
        ),
        BlocListener<FetchDeviceInfoCubit, FetchDeviceInfoState>(
          listener: (context, state) {
            if (state is FetchDeviceInfoInProgress) {
              setState(() {
                _deviceInfoLoading = true;
              });
            } else if (state is FetchDeviceInfoSuccess) {
              if (_fetchedFromInit ||
                  _isAddPage() ||
                  _isEditPage() ||
                  _isReplacePage()) {
                setState(() {
                  _deviceInfo = state.info;
                  _deviceInfoLoading = false;
                });
              } else {
                _saveLogEvent(state.info);
                InstallerDialogs().showSnackBar(
                    context: context, message: _formatSnackBarText());
                setState(() {
                  _updatingValues = false;
                });
                Navigator.pop(context);
              }
            }
          },
        ),
      ],
      child: GestureDetector(
        onTap: (() {
          _notesFocus.unfocus();
          _deviceIdFocus.unfocus();
        }),
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: [
                InstallerCloseButton(
                  icon: Icons.close_rounded,
                ),
              ],
              elevation: 0,
              backgroundColor: InstallerColor.blueColor,
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    _isAddPage()
                        ? AppLocalizations.of(context)!.addNewDevice
                        : _isEditPage()
                            ? AppLocalizations.of(context)!.editDevice
                            : AppLocalizations.of(context)!.replaceDevice,
                    style: InstallerTextStyles.titleText
                        .copyWith(color: Colors.white, fontSize: 18)),
              ),
            ),
            body: _groupsLoading || _commandsLoading || _deviceInfoLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      _deviceInfoWidget(),
                      Expanded(
                        child: SingleChildScrollView(
                          child: SizedBox(
                              child: Column(
                            children: [
                              _buildPage(),
                              Visibility(
                                visible: (validateFields()),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: _isAddPage() ? 100 : 20.0,
                                      bottom: 20),
                                  child: InstallerButton(
                                      icon: Icons.check,
                                      includeAddIcon: false,
                                      width: 220,
                                      loading: _updatingValues,
                                      onPressed: () {
                                        if (_selectedDeviceID == null) {
                                          setState(() {
                                            _selectedDeviceID =
                                                _writtenDeviceId;
                                            _writtenDeviceId = null;
                                          });
                                        }
                                        _setInstallationStatusAndGroup();
                                      },
                                      title: _isAddPage()
                                          ? AppLocalizations.of(context)!.save
                                          : _isEditPage()
                                              ? AppLocalizations.of(context)!
                                                  .saveChanges
                                              : AppLocalizations.of(context)!
                                                  .saveChanges),
                                ),
                              ),
                            ],
                          )),
                        ),
                      ),
                    ],
                  )),
      ),
    );
  }
}
