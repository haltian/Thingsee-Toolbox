import 'package:flutter/material.dart';
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/constants/installer_icons.dart';
import 'package:thingsee_installer/constants/installer_text_styles.dart';
import 'package:thingsee_installer/models/device_model.dart';
import 'package:thingsee_installer/models/installation_model.dart';
import 'package:thingsee_installer/protocol/log_event.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/installer_colors.dart';

class InstallerExpansionListTile extends StatefulWidget {
  final String title;
  final String? description;
  final Widget? icon;
  final bool includeIconBox;
  final Color? subtitleColor;
  final TextStyle titleStyle;
  final String? timeStamp;
  final LogEvent event;
  final VoidCallback deleteButtonPressed;
  const InstallerExpansionListTile(
      {Key? key,
      required this.title,
      required this.description,
      this.icon,
      this.includeIconBox = true,
      this.subtitleColor,
      this.titleStyle = InstallerTextStyles.titleText,
      this.timeStamp,
      required this.event,
      required this.deleteButtonPressed})
      : super(key: key);

  @override
  State<InstallerExpansionListTile> createState() =>
      _InstallerExpansionListTileState();
}

class _InstallerExpansionListTileState
    extends State<InstallerExpansionListTile> {
  bool _tileExpanded = false;

  Widget _titleAndValue(String title, String value, [String? deviceName]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            children: [
              Text(
                title,
                style: InstallerTextStyles.logEventDetails,
                textAlign: TextAlign.end,
              ),
            ],
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width / 1.8),
                child: Text(
                  deviceName != null ? value + "\n" + deviceName : value,
                  style: InstallerTextStyles.logEventDetails
                      .copyWith(color: Colors.black),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _deleteLogEntryButton() {
    return TextButton(
        onPressed: widget.deleteButtonPressed,
        child: SizedBox(
          width: 200,
          child: Row(
            children: [
              InstallerIcons.createInstallerAssetImage(
                  assetPath: InstallerIcons.trash, width: 24, height: 24),
              const SizedBox(width: 20),
              Text(AppLocalizations.of(context)!.deleteLogEntry,
                  style: InstallerTextStyles.logEntryDeleteText)
            ],
          ),
        ));
  }

  Widget _expandedChildren() {
    List<Widget> items = [];
    // Log details
    items.add(_titleAndValue(
        widget.event.event != IncudedEvent.replacingDevice
            ? AppLocalizations.of(context)!.device
            : AppLocalizations.of(context)!.newDevice,
        widget.event.deviceId,
        DeviceModel().getSensorName(widget.event.deviceId)));

    if (widget.event.oldDeviceId != null) {
      items.add(const SizedBox(height: 10));

      items.add(_titleAndValue(AppLocalizations.of(context)!.oldDevice,
          widget.event.oldDeviceId.toString()));
    }
    if (widget.event.note != null) {
      items.add(const SizedBox(height: 10));

      items.add(_titleAndValue(
          AppLocalizations.of(context)!.note, widget.event.note.toString()));
    }
    if (widget.event.deviceStatus != null) {
      items.add(const SizedBox(height: 10));

      items.add(_titleAndValue(
          AppLocalizations.of(context)!.deviceStatus,
          widget.event.deviceStatus == InstallerConstants.online
              ? AppLocalizations.of(context)!.online
              : AppLocalizations.of(context)!.offline));
    }
    if (widget.event.groupId != null &&
        widget.event.event == IncudedEvent.editingDevice) {
      items.add(const SizedBox(height: 10));

      items.add(_titleAndValue(AppLocalizations.of(context)!.group,
          widget.event.groupId.toString()));
    }

    if (widget.event.acceleroMeterMode != null) {
      items.add(const SizedBox(height: 10));

      items.add(_titleAndValue(
          AppLocalizations.of(context)!.mumModeAccelerometer("\n"),
          InstallationModel().selectedMode(
              context,
              widget.event.acceleroMeterMode,
              widget.event.measurementInterval,
              widget.event.version.toString())));
    }

    if (widget.event.hallMode != null) {
      items.add(const SizedBox(height: 10));

      items.add(_titleAndValue(
          AppLocalizations.of(context)!.hallModeMagneticSensor("\n"),
          InstallationModel()
              .hallModeNames(context, widget.event.version)
              .elementAt(widget.event.hallMode!)
              .toString()));
    }

    if (widget.event.mode != null) {
      items.add(const SizedBox(height: 10));

      items.add(_titleAndValue(
          AppLocalizations.of(context)!.operatingMode,
          InstallationModel()
              .presenceModes(context)
              .elementAt(widget.event.mode!)
              .toString()));
    }

    if (widget.event.peopleCountingOrientation != null) {
      items.add(const SizedBox(height: 10));

      items.add(_titleAndValue(
          AppLocalizations.of(context)!.installationLocation,
          InstallationModel()
              .installationLocations(context)
              .elementAt(widget.event.peopleCountingOrientation!)
              .toString()));
    }
    items.add(const SizedBox(height: 20));
    items.add(_deleteLogEntryButton());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: items),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: InstallerColor.borderColor),
            borderRadius: BorderRadius.circular(10)),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ExpansionTile(
                children: [
                  const Divider(
                    thickness: 1,
                    color: InstallerColor.borderColor,
                    indent: 10,
                    endIndent: 10,
                  ),
                  _expandedChildren(),
                ],
                onExpansionChanged: (bool expanded) {
                  setState(() {
                    _tileExpanded = expanded;
                  });
                },
                backgroundColor: InstallerColor.whiteColor,
                collapsedBackgroundColor: InstallerColor.whiteColor,
                leading: widget.includeIconBox
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(child: widget.icon),
                      )
                    : null,
                title: Padding(
                  padding:
                      EdgeInsets.only(top: widget.timeStamp != null ? 8.0 : 0),
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    style:
                        widget.titleStyle.copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    widget.description != null
                        ? Text(
                            widget.description!,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: InstallerTextStyles.titleText.copyWith(
                                fontWeight: FontWeight.w400,
                                color: widget.subtitleColor),
                          )
                        : Container(),
                    widget.timeStamp != null
                        ? Text(
                            widget.timeStamp.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: InstallerTextStyles.titleText.copyWith(
                                fontWeight: FontWeight.w400,
                                color: InstallerColor.darkGreyColor),
                          )
                        : Container(),
                  ],
                ),
                trailing: _tileExpanded
                    ? InstallerIcons.createInstallerAssetImage(
                        assetPath: InstallerIcons.arrowUp,
                        width: 24,
                        height: 24)
                    : InstallerIcons.createInstallerAssetImage(
                        assetPath: InstallerIcons.arrowDown,
                        width: 24,
                        height: 24)),
          ),
        ),
      ),
    );
  }
}
