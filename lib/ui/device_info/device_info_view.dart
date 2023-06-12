import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:thingsee_installer/constants/installer_icons.dart';
import 'package:thingsee_installer/installer_log_event_manager.dart';
import 'package:thingsee_installer/logic/fetch_device_info/cubit/fetch_device_info_cubit.dart';
import 'package:thingsee_installer/logic/fetch_device_messages/cubit/fetch_device_messages_cubit.dart';
import 'package:thingsee_installer/logic/fetch_installation_status/cubit/fetch_installation_status_cubit.dart';
import 'package:thingsee_installer/models/dim_ui_model.dart';
import 'package:thingsee_installer/protocol/device_command.dart';
import 'package:thingsee_installer/protocol/device_info.dart';
import 'package:thingsee_installer/protocol/device_messages.dart';
import 'package:thingsee_installer/ui/common/installer_close_button.dart';
import 'package:thingsee_installer/ui/common/installer_dialogs.dart';
import 'package:thingsee_installer/ui/common/installer_list_tile.dart';
import 'package:thingsee_installer/ui/device_info/device_info_view_arguments.dart';
import '../../constants/installer_colors.dart';
import '../../constants/installer_routes.dart';
import '../../constants/installer_text_styles.dart';
import '../../logic/commands/cubit/commands_cubit.dart';
import '../../logic/commands/cubit/commands_state.dart';
import '../../logic/fetch_device_list/cubit/fetch_device_list_cubit.dart';
import '../../logic/fetch_group/cubit/fetch_group_cubit.dart';
import '../../logic/set_installation_status/cubit/set_installation_status_cubit.dart';
import '../../models/device_model.dart';
import '../../models/installation_model.dart';
import '../../protocol/installation_status.dart';
import '../add_or_edit_device/add_or_edit_device_view_arguments.dart';
import '../common/installer_button.dart';
import '../../models/message_model.dart';

class DeviceView extends StatefulWidget {
  final DeviceInfoArguments arguments;
  const DeviceView({Key? key, required this.arguments}) : super(key: key);
  @override
  State<DeviceView> createState() => _DeviceViewState();
}

class _DeviceViewState extends State<DeviceView> {
  String _selectedOperatingMode = "";
  String _selectedAccelerometerMode = "";
  String _selectedHallMode = "";
  String _selectedInstallationLocation = "";
  String _deploymentGroup = "";
  DeviceInfo? _deviceInfo;
  InstallationStatus? _status;
  bool _loadingDeviceInfo = true;
  bool _loadingInstallationStatus = true;
  bool _loadingDeviceMessages = true;
  bool _groupLoading = true;
  bool _commandsLoading = true;
  int _selectedPageIndex = 0;
  final DeviceModel _deviceModel = DeviceModel();
  List<DeviceMessages> _messages = [];
  final InstallationModel installationModel = InstallationModel();
  int? _operatingModeInt;
  final PageController controller = PageController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setDefaults(context);
      _fetchDeviceInfo();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fetchDeviceInfo() {
    BlocProvider.of<FetchDeviceInfoCubit>(context).fetchDeviceInfo(
        stack: widget.arguments.stack, deviceID: widget.arguments.deviceID);
    BlocProvider.of<FetchInstallationStatusCubit>(context)
        .fetchInsatllationStatus(
            stack: widget.arguments.stack, deviceID: widget.arguments.deviceID);
    BlocProvider.of<CommandsCubit>(context).fetchAllCommands(
        stack: widget.arguments.stack,
        deviceId: widget.arguments.deviceID,
        limit: 1);
    BlocProvider.of<FetchGroupCubit>(context).fetchGroup(
        stack: widget.arguments.stack, deviceID: widget.arguments.deviceID);
    BlocProvider.of<FetchDeviceMessagesCubit>(context).FetchDeviceMessages(
        stack: widget.arguments.stack,
        deviceId: widget.arguments.deviceID,
        limit: 50);
  }

  void _deleteDevice() {
    BlocProvider.of<SetInstallationStatusCubit>(context).setInstallationStatus(
        stack: widget.arguments.stack,
        newStatus: 'uninstalled',
        deviceId: widget.arguments.deviceID,
        groupId: 'unassigned');
  }

  void _fetchDeviceList() async {
    BlocProvider.of<FetchDeviceListCubit>(context).fetchDeviceList(
        stack: widget.arguments.stack,
        groupId: widget.arguments.group!.group_id);
  }

  void _setDefaults(BuildContext context) {
    setState(() {
      _selectedOperatingMode = AppLocalizations.of(context)!.visitorCounter;
      _selectedAccelerometerMode = AppLocalizations.of(context)!.disabled;
      _selectedInstallationLocation = AppLocalizations.of(context)!.locationIn;
      _selectedHallMode = AppLocalizations.of(context)!.disabled;
    });
  }

  Color _buttonColor(int index) {
    return _selectedPageIndex == index
        ? InstallerColor.whiteColor.withOpacity(0.25)
        : InstallerColor.blueColor;
  }

  Future<void> _pullToRefreshDeviceInfo() {
    _fetchDeviceInfo();
    return Future.delayed(const Duration(seconds: 0), () {});
  }

  Future<void> _pullToRefreshMessages() {
    BlocProvider.of<FetchDeviceMessagesCubit>(context).FetchDeviceMessages(
        stack: widget.arguments.stack,
        deviceId: widget.arguments.deviceID,
        limit: 50);
    return Future.delayed(const Duration(seconds: 0), () {});
  }

  String _formattedInstallationStatus(String status) {
    return "${status[0].toUpperCase()}${status.substring(1)}";
  }

  List<Widget> _messageList(BuildContext context) {
    final List<Widget> items = [];
    items.add(const SizedBox(
      height: 9,
    ));
    _messages.map((DeviceMessages messages) {
      items.add(InstallerListTile(
        title: MessageModel.getMessage(messages.tsmId, context, messages),
        description: _deviceModel.formatTime(messages.tsmTs, context),
        onPressed: () {},
        includeArrowIcon: false,
        includeIconBox: false,
        subtitleColor: InstallerColor.darkGreyColor,
        titleStyle: InstallerTextStyles.bodyText,
      ));
      items.add(const SizedBox(height: 6));
    }).toList();

    return items;
  }

  String _formatDeviceStatusText(
      DeviceInfo info, BuildContext context, ThingseeSensorType sensorType) {
    return _deviceModel.isOnline(info.timestamp, sensorType)
        ? AppLocalizations.of(context)!
            .offlineLastSeen(_deviceModel.formatTime(info.timestamp, context))
        : AppLocalizations.of(context)!.online;
  }

  Widget _deviceInfoBoxes(
      DeviceInfo info, InstallationStatus status, BuildContext context) {
    final sensorType = _deviceModel.getSensorType(widget.arguments.deviceID);
    return Wrap(spacing: 6, runSpacing: 6, children: [
      const SizedBox(
        height: 3,
      ),
      //Offline Online
      InstallerListTile(
          title: AppLocalizations.of(context)!.deviceStatus,
          description: _formatDeviceStatusText(info, context, sensorType),
          onPressed: () {},
          icon: _deviceModel.isOnline(info.timestamp, sensorType)
              ? InstallerIcons.createInstallerAssetImage(
                  assetPath: InstallerIcons.deviceOffline,
                  width: 24,
                  height: 24)
              : InstallerIcons.createInstallerAssetImage(
                  assetPath: InstallerIcons.deviceOnline,
                  width: 24,
                  height: 24),
          includeArrowIcon: false),
      // Battery Status
      InstallerListTile(
        title: AppLocalizations.of(context)!.batteryLevel,
        description:
            _deviceModel.batteryStatus(_deviceModel, context, sensorType, info),
        onPressed: (() {}),
        icon: InstallerIcons.createInstallerAssetImage(
            assetPath: InstallerIcons.batteryIcon, width: 30, height: 30),
        includeArrowIcon: false,
      ),
      //InstallationStatus
      InstallerListTile(
          title: AppLocalizations.of(context)!.installationStatus,
          description:
              _formattedInstallationStatus(status.installation_status!),
          onPressed: () {},
          icon: InstallerIcons.createInstallerAssetImage(
              assetPath: InstallerIcons.installationStatus,
              width: 30,
              height: 30),
          includeArrowIcon: false),
      //Operating mode only show for devices with operatingmode
      if (sensorType == ThingseeSensorType.count ||
          sensorType == ThingseeSensorType.presence)
        InstallerListTile(
          title: AppLocalizations.of(context)!.operatingMode,
          description: sensorType == ThingseeSensorType.count
              ? _selectedInstallationLocation
              : _selectedOperatingMode,
          onPressed: () {},
          icon: InstallerIcons.createInstallerAssetImage(
              assetPath: InstallerIcons.operatingMode, width: 30, height: 30),
          includeArrowIcon: false,
        ), //Enviroment Accelerometer tile
      if (sensorType == ThingseeSensorType.environment ||
          sensorType == ThingseeSensorType.environmentRugged)
        InstallerListTile(
          title: AppLocalizations.of(context)!.acceloremeter,
          description: _selectedAccelerometerMode,
          onPressed: () {},
          icon: InstallerIcons.createInstallerAssetImage(
              assetPath: InstallerIcons.operatingMode, width: 30, height: 30),
          includeArrowIcon: false,
        ),
      //MUM mode
      if (sensorType == ThingseeSensorType.environment ||
          sensorType == ThingseeSensorType.environmentRugged)
        InstallerListTile(
          title: AppLocalizations.of(context)!.hallMode,
          description: _selectedHallMode,
          onPressed: () {},
          icon: InstallerIcons.createInstallerAssetImage(
              assetPath: InstallerIcons.operatingMode, width: 30, height: 30),
          includeArrowIcon: false,
        ),

      //Deployment group Listtile
      InstallerListTile(
        title: AppLocalizations.of(context)!.deploymentGroup,
        description: _deploymentGroup,
        onPressed: (() {}),
        icon: InstallerIcons.createInstallerAssetImage(
            assetPath: InstallerIcons.folderGrey, width: 30, height: 30),
        includeArrowIcon: false,
      ),
    ]);
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
        _selectedHallMode = installationModel
            .hallModes(context, _deviceInfo?.version)
            .firstWhere((element) => element.mode == command.hallMode)
            .name
            .toString();
      });
    }
  }

  void _createLogEventForDelete() {
    InstallerLogEventManager().createLogEvents(
        triggerEvent: IncudedEvent.removingDevice,
        deviceId: widget.arguments.deviceID,
        deviceStatus: null,
        logFileGroupId: widget.arguments.group!.group_id,
        note: null,
        oldDeviceId: null,
        accelerometerMode: null,
        peopleCountingOrientation: null,
        hallMode: null,
        mode: null,
        newGroupId: null,
        version: _deviceInfo!.version,
        measurementInterval: null);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<FetchDeviceInfoCubit, FetchDeviceInfoState>(
            listener: (context, state) {
              if (state is FetchDeviceInfoInProgress) {
                setState(() {
                  _loadingDeviceInfo = true;
                });
              } else if (state is FetchDeviceInfoSuccess) {
                setState(() {
                  _deviceInfo = state.info;
                  _loadingDeviceInfo = false;
                });
              } else if (state is FetchDeviceInfoFailed) {
                setState(() {
                  _loadingDeviceInfo = false;
                });
              }
            },
          ),
          BlocListener<FetchInstallationStatusCubit,
              FetchInstallationStatusState>(
            listener: (context, state) {
              if (state is FetchInstallationStatusInProgress) {
                setState(() {
                  _loadingInstallationStatus = true;
                });
              } else if (state is FetchInstallationStatusSuccess) {
                setState(() {
                  _status = state.status.first;
                  _loadingInstallationStatus = false;
                });
              } else if (state is FetchInstallationStatusFailed) {
                setState(() {
                  _loadingInstallationStatus = false;
                });
              }
            },
            child: Container(),
          ),
          BlocListener<SetInstallationStatusCubit, SetInstallationStatusState>(
            listener: (context, state) {
              if (state is SetInstallationStatusInProgress) {
                setState(() {
                  _loadingDeviceInfo = true;
                });
              } else if (state is SetInstallationStatusSuccess) {
                _createLogEventForDelete();
                InstallerDialogs().showSnackBar(
                    context: context,
                    message: AppLocalizations.of(context)!
                        .deviceDeletedSuccessfully);
                _fetchDeviceList();
                Navigator.pop(context);
              }
            },
          ),
          BlocListener<FetchDeviceMessagesCubit, FetchDeviceMessagesState>(
              listener: (context, state) {
            if (state is FetchDeviceMessagesInProgress) {
              setState(() {
                _loadingDeviceMessages = true;
              });
            } else if (state is FetchDeviceMessagesSuccess) {
              setState(() {
                _messages = List.from(state.messages);
                _loadingDeviceMessages = false;
              });
            } else if (state is FetchDeviceMessagesFailed) {
              setState(() {
                _loadingDeviceMessages = false;
              });
            }
          }),
          BlocListener<CommandsCubit, CommandsState>(
            listener: (context, state) {
              if (state is CommandInProgress) {
                setState(() {
                  _commandsLoading = true;
                });
              } else if (state is CommandSuccess) {
                if (state.commandsResponse != null) {
                  if (state.commandsResponse!.isNotEmpty) {
                    _setConfigurationsNames(
                        state.commandsResponse!.first.command);
                  }
                  setState(() {
                    _commandsLoading = false;
                  });
                }
              } else if (state is CommandFailed) {
                setState(() {
                  _commandsLoading = false;
                });
              }
            },
          ),
          BlocListener<FetchGroupCubit, FetchGroupState>(
            listener: (context, state) {
              if (state is FetchGroupInProgress) {
                setState(() {
                  _groupLoading = true;
                });
              } else if (state is FetchGroupSuccess) {
                _deploymentGroup = state.group.group_id.toString();
                setState(() {
                  _groupLoading = false;
                });
              } else if (state is FetchGroupFailed) {
                setState(() {
                  _groupLoading = false;
                });
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: AppBar(
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark,
            ),
            actions: [
              PopupMenuButton(
                  offset: const Offset(100, 55),
                  color: InstallerColor.blueColor,
                  icon: Image.asset(
                    'assets/menu_dots.png',
                    height: 21,
                    fit: BoxFit.fitWidth,
                  ),
                  onCanceled: () {
                    // Pop dimmer dialog
                    Navigator.pop(context);
                    Provider.of<DimUiModel>(context, listen: false)
                        .setDimmed(false);
                  },
                  itemBuilder: (context) {
                    // Create dim background with dialog
                    InstallerDialogs().dimBackground(context);
                    Provider.of<DimUiModel>(context, listen: false)
                        .setDimmed(true);
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text(
                          AppLocalizations.of(context)!.edit,
                          style: InstallerTextStyles.bodyText.copyWith(
                              color: InstallerColor.whiteColor,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 1,
                        child: Text(
                          AppLocalizations.of(context)!.remove,
                          style: InstallerTextStyles.bodyText.copyWith(
                              color: InstallerColor.whiteColor,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 2,
                        child: Text(
                          AppLocalizations.of(context)!.replace,
                          style: InstallerTextStyles.bodyText.copyWith(
                              color: InstallerColor.whiteColor,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ];
                  },
                  onSelected: (value) {
                    // Pop dimmer dialog
                    Navigator.pop(context);
                    Provider.of<DimUiModel>(context, listen: false)
                        .setDimmed(false);
                    switch (value) {
                      case 0:
                        Navigator.of(context).pushNamed(
                            InstallerRoutes.addOrEditDeviceViewRoute,
                            arguments: AddOrEditDeviceViewArguments(
                                widget.arguments.stack,
                                widget.arguments.deviceID,
                                widget.arguments.group,
                                PageAction.editDevice,
                                _operatingModeInt));
                        break;
                      case 1:
                        InstallerDialogs().showMultiActionDialog(
                            context: context,
                            title: AppLocalizations.of(context)!.removeDevice,
                            message: AppLocalizations.of(context)!
                                .areYouSureYouWantToDeleteDevice,
                            buttonText: AppLocalizations.of(context)!.remove,
                            onPressed: () {
                              _deleteDevice();
                              Navigator.pop(context);
                            });
                        break;
                      case 2:
                        Navigator.of(context).pushNamed(
                            InstallerRoutes.addOrEditDeviceViewRoute,
                            arguments: AddOrEditDeviceViewArguments(
                                widget.arguments.stack,
                                widget.arguments.deviceID,
                                widget.arguments.group,
                                PageAction.replaceDevice,
                                _operatingModeInt));
                        break;
                      default:
                    }
                  }),
            ],
            leading: const InstallerCloseButton(
              icon: Icons.arrow_back_ios_new_rounded,
            ),
            elevation: 0,
            backgroundColor: InstallerColor.blueColor,
            centerTitle: true,
            title: Column(
              children: [
                Text(widget.arguments.deviceID,
                    style: InstallerTextStyles.titleText
                        .copyWith(color: Colors.white, fontSize: 18)),
                Text(DeviceModel().getSensorName(widget.arguments.deviceID),
                    style: InstallerTextStyles.bodyText
                        .copyWith(color: Colors.white)),
              ],
            ),
          ),
          body: Column(children: [
            Container(
                width: double.infinity,
                height: 140,
                color: InstallerColor.blueColor,
                child: Column(children: <Widget>[
                  InstallerIcons.createInstallerAssetImage(
                      assetPath: DeviceModel()
                          .getSensorImage(widget.arguments.deviceID),
                      width: 126,
                      height: 84),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InstallerButton(
                        spashEffect: false,
                        onPressed: () {
                          controller.previousPage(
                              duration: const Duration(milliseconds: 10),
                              curve: Curves.easeIn);
                        },
                        title: AppLocalizations.of(context)!.deviceInfo,
                        loading: false,
                        width: 138,
                        height: 34,
                        color: _buttonColor(0),
                        centerpad: true,
                      ),
                      InstallerButton(
                        spashEffect: false,
                        onPressed: () {
                          controller.nextPage(
                              duration: const Duration(milliseconds: 10),
                              curve: Curves.easeIn);
                        },
                        title: AppLocalizations.of(context)!.deviceEvents,
                        loading: false,
                        width: 138,
                        height: 34,
                        color: _buttonColor(1),
                        centerpad: true,
                      )
                    ],
                  ),
                ])),
            Expanded(
                child: PageView(
              onPageChanged: (int index) {
                setState(() {
                  _selectedPageIndex = index;
                });
              },
              controller: controller,
              children: <Widget>[
                (!_loadingDeviceInfo &&
                        !_loadingInstallationStatus &&
                        !_commandsLoading &&
                        !_groupLoading)
                    ? RefreshIndicator(
                        onRefresh: () => _pullToRefreshDeviceInfo(),
                        child: SizedBox(
                            height: 1000,
                            child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Theme(
                                  data: ThemeData(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.white),
                                  child: _deviceInfoBoxes(
                                      _deviceInfo!, _status!, context),
                                ))))
                    : const Center(child: CircularProgressIndicator()),
                (!_loadingDeviceMessages)
                    ? RefreshIndicator(
                        onRefresh: () => _pullToRefreshMessages(),
                        child: SizedBox(
                            height: 1000,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Theme(
                                data: ThemeData(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.white),
                                child: Column(children: _messageList(context)),
                              ),
                            )))
                    : const Center(child: CircularProgressIndicator())
              ],
            )),
          ]),
        ));
  }
}
