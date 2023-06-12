import 'dart:io';
import 'package:csv/csv.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/models/device_model.dart';
import 'package:thingsee_installer/models/dim_ui_model.dart';
import 'package:thingsee_installer/models/installation_model.dart';
import 'package:thingsee_installer/protocol/log_event.dart';
import 'package:thingsee_installer/protocol/log_file.dart';
import 'package:thingsee_installer/ui/add_or_edit_log/add_or_edit_log_arguments.dart';
import 'package:thingsee_installer/ui/common/installer_close_button.dart';
import 'package:thingsee_installer/ui/common/installer_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/installer_colors.dart';
import '../../constants/installer_icons.dart';
import '../../constants/installer_routes.dart';
import '../../constants/installer_text_styles.dart';
import '../common/empty_list_widget.dart';
import '../common/installer_expansion_list_tile.dart';

class LogEventsView extends StatefulWidget {
  final ValueNotifier<bool?> bottomNavigationVisible;
  final LogFile logFile;
  final InstallerUserRepository userRepository;
  const LogEventsView(
      {Key? key,
      required this.bottomNavigationVisible,
      required this.logFile,
      required this.userRepository})
      : super(key: key);

  @override
  State<LogEventsView> createState() => _LogEventsViewState();
}

class _LogEventsViewState extends State<LogEventsView> {
  bool refreshList = true;
  LogFile? _currentLogFile;
  String _logTitle = "";

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLogFile();
    });
    super.initState();
  }

  void _getCurrentLogFile() async {
    await widget.userRepository
        .getCurrentLogFile(widget.logFile.id!)
        .then((value) {
      setState(() {
        _currentLogFile = value;
        _logTitle = value.title;
      });
    });
  }

  void share(File file) async {
    ShareExtend.share(file.path, "file");
  }

  void _exportCSV() async {
    await [
      Permission.storage,
    ].request();

    List<LogEvent>? logEvents =
        await widget.userRepository.getSavedLogEventsForId(widget.logFile.id!);

    List<List<dynamic>> rows = [];

    try {
      List<dynamic> row = [];
      rows.add(["Group ID", widget.logFile.groupId]);
      rows.add([
        "Created",
        "${_formatDate(DateTime.now().toUtc(), 'yyyy-MM-dd HH:mm:ss')} (UTC)"
      ]);
      rows.add([]);
      row.add("Type");
      row.add("Event");
      row.add("Tuid");
      if (logEvents!.any((element) => element.oldDeviceId != null)) {
        row.add("Old device");
      }
      if (logEvents.any((element) => element.hallMode != null)) {
        row.add("HALL-MODE");
      }
      if (logEvents.any((element) => element.acceleroMeterMode != null)) {
        row.add("MUM-mode");
      }
      if (logEvents.any((element) => element.mode != null)) {
        row.add("Operating mode");
      }
      if (logEvents
          .any((element) => element.peopleCountingOrientation != null)) {
        row.add("Installation location");
      }
      row.add("Notes");
      row.add("Event timestamp");
      row.add("SW Version");

      rows.add(row);
      for (int i = 0; i < logEvents.length; i++) {
        List<dynamic> row = [];
        row.add(DeviceModel().getSensorName(logEvents[i].deviceId));
        row.add(InstallationModel()
            .getSavedEventsTitles(logEvents[i].event, context));
        row.add(logEvents[i].deviceId);
        if (logEvents.any((element) => element.oldDeviceId != null)) {
          if (logEvents[i].oldDeviceId != null) {
            row.add(logEvents[i].oldDeviceId!);
          } else {
            row.add("null");
          }
        }
        if (logEvents.any((element) => element.hallMode != null)) {
          if (logEvents[i].hallMode != null) {
            row.add(InstallationModel()
                .hallModeNames(context, logEvents[i].version));
          } else {
            row.add("null");
          }
        }
        if (logEvents.any((element) => element.acceleroMeterMode != null)) {
          if (logEvents[i].acceleroMeterMode != null) {
            row.add(InstallationModel()
                .accelerometerModeNames(context, logEvents[i].version)
                .elementAt(logEvents[i].acceleroMeterMode!));
          } else {
            row.add("null");
          }
        }
        if (logEvents.any((element) => element.mode != null)) {
          if (logEvents[i].mode != null) {
            row.add(InstallationModel()
                .accelerometerModeNames(context, logEvents[i].version)
                .elementAt(logEvents[i].mode!));
          } else {
            row.add("null");
          }
        }
        if (logEvents
            .any((element) => element.peopleCountingOrientation != null)) {
          if (logEvents[i].peopleCountingOrientation != null) {
            row.add(InstallationModel()
                .accelerometerModeNames(context, logEvents[i].version)
                .elementAt(logEvents[i].peopleCountingOrientation!));
          } else {
            row.add("null");
          }
        }
        row.add(logEvents[i].note ?? "null");
        row.add(
            "${_formatDate(logEvents[i].timeStamp.toUtc(), 'yyyy-MM-dd HH:mm:ss')} (UTC)");
        row.add(logEvents[i].version);

        rows.add(row);
      }

      String csv = const ListToCsvConverter().convert(rows);

      String dir = "";
      if (Platform.isAndroid) {
        dir = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS);
      } else {
        dir = (await getApplicationDocumentsDirectory()).path;
      }

      File f = File("$dir/${_currentLogFile!.title}_${_formatDate(DateTime.now(), 'yyyy-MM-dd')}.csv");

      f.writeAsString(csv).then((value) => share(f));
    } catch (e) {
      InstallerDialogs().showInfoDialog(
          context: context,
          title: AppLocalizations.of(context)!.errorOccured,
          message: AppLocalizations.of(context)!.exportingCsvFailed,
          buttonText: AppLocalizations.of(context)!.ok,
          shouldPop: false);
    }
  }

  String _formatDate(DateTime date, String format) {
    return DateFormat(format).format(date);
  }

  Widget _eventsListView() {
    return FutureBuilder(
      future: refreshList
          ? widget.userRepository.getSavedLogEventsForId(widget.logFile.id!)
          : null,
      builder: ((context, AsyncSnapshot<List<LogEvent>?> snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final events = snapshot.data;
          return events!.isNotEmpty
              ? SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(children: [
                    const SizedBox(height: 10),
                    for (int i = 0; i < events.length; i++)
                      InstallerExpansionListTile(
                        timeStamp: DateFormat('yyyy-MM-dd HH:mm:ss')
                            .format(events[i].timeStamp),
                        icon: InstallerIcons.createInstallerAssetImage(
                            assetPath:
                                DeviceModel().getSensorIcon(events[i].deviceId),
                            width: 40,
                            height: 30),
                        title: InstallationModel()
                            .getSavedEventsTitles(events[i].event, context),
                        description: null,
                        event: events[i],
                        deleteButtonPressed: () => InstallerDialogs()
                            .showMultiActionDialog(
                                context: context,
                                title: AppLocalizations.of(context)!
                                    .removeLogEntry,
                                message: AppLocalizations.of(context)!
                                    .areYouSureDeleteLogEntry,
                                buttonText:
                                    AppLocalizations.of(context)!.remove,
                                onPressed: () {
                                  widget.userRepository
                                      .deleteLogEvent(events[i])
                                      .then((value) {
                                    Navigator.pop(context);
                                    setState(() {
                                      refreshList = true;
                                    });
                                  }).then((value) => InstallerDialogs()
                                          .showSnackBar(
                                              context: context,
                                              message:
                                                  AppLocalizations.of(context)!
                                                      .logEntryDeleted));
                                }),
                      ),
                  ]),
                )
              : EmptyListWidget(
                  enableButton: false,
                  infoText: AppLocalizations.of(context)!.noEventsInThisLogFile,
                  buttonText: "",
                  onPressed: () {});
        } else {
          return Container();
        }
      }),
    );
  }

  String _formatRecordingText() {
    return widget.logFile.recording
        ? AppLocalizations.of(context)!.stopRecording
        : AppLocalizations.of(context)!.startRecording;
  }

  Widget _recordingWidget() {
    return Column(children: [
      const SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 15,
            height: 15,
            decoration:
                const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            child: const Icon(
              Icons.circle,
              color: InstallerColor.recordIconColor,
              size: 13,
            ),
          ),
          const SizedBox(width: 7),
          Text(AppLocalizations.of(context)!.recordingOn,
              style: InstallerTextStyles.titleText.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w400)),
        ],
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
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
                          AppLocalizations.of(context)!.export,
                          style: InstallerTextStyles.bodyText.copyWith(
                              color: InstallerColor.whiteColor,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 2,
                        child: Text(
                          AppLocalizations.of(context)!.remove,
                          style: InstallerTextStyles.bodyText.copyWith(
                              color: InstallerColor.whiteColor,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      PopupMenuItem<int>(
                        value: 3,
                        child: Text(
                          _formatRecordingText(),
                          style: InstallerTextStyles.bodyText.copyWith(
                              color: InstallerColor.whiteColor,
                              fontWeight: FontWeight.w300),
                        ),
                      )
                    ];
                  },
                  onSelected: (value) async {
                    // Pop dimmer dialog
                    Navigator.pop(context);
                    Provider.of<DimUiModel>(context, listen: false)
                        .setDimmed(false);
                    switch (value) {
                      case 0:
                        widget.bottomNavigationVisible.value = false;
                        Navigator.pushNamed(
                                context, InstallerRoutes.addOrEditLogViewRoute,
                                arguments: AddOrEditLogViewArguments(
                                    _currentLogFile, true))
                            .then((value) => _getCurrentLogFile())
                            .then((value) =>
                                widget.bottomNavigationVisible.value = true);
                        break;
                      case 1:
                        _exportCSV();
                        break;
                      case 2:
                        InstallerDialogs().showMultiActionDialog(
                            context: context,
                            title: AppLocalizations.of(context)!.deleteLogFile,
                            message: AppLocalizations.of(context)!
                                .areYouSureDeleteLogFile,
                            buttonText: AppLocalizations.of(context)!.remove,
                            onPressed: () {
                              widget.userRepository
                                  .deleteLog(widget.logFile)
                                  .then((value) => widget.userRepository
                                          .deleteEventsInLogFile(widget.logFile)
                                          .then((value) {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        InstallerDialogs().showSnackBar(
                                            context: context,
                                            message:
                                                AppLocalizations.of(context)!
                                                    .logFileDeleted);
                                      }));
                            });
                        break;
                      case 3:
                        widget.userRepository
                            .setLogFileRecordingValue(widget.logFile,
                                widget.logFile.recording ? false : true)
                            .then((value) {
                          Navigator.pop(context);
                          InstallerDialogs().showSnackBar(
                              context: context,
                              message: widget.logFile.recording
                                  ? AppLocalizations.of(context)!.recordingOff
                                  : AppLocalizations.of(context)!.recordingOn);
                        });
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
            title: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_logTitle,
                      overflow: TextOverflow.fade,
                      style: InstallerTextStyles.titleText
                          .copyWith(color: Colors.white, fontSize: 16)),
                  widget.logFile.recording ? _recordingWidget() : Container(),
                ],
              ),
            ),
          ),
          body: _eventsListView(),
        );
      }),
    );
  }
}
