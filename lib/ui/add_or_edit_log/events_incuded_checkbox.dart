import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thingsee_installer/constants/installer_colors.dart';
import 'package:thingsee_installer/models/installation_model.dart';
import 'package:thingsee_installer/protocol/log_file.dart';

class EventsIncludedCheckBox extends StatefulWidget {
  final IncudedEvent incudedEvent;
  final LogFile? logFile;
  const EventsIncludedCheckBox(
      {Key? key, required this.incudedEvent, required this.logFile})
      : super(key: key);

  @override
  State<EventsIncludedCheckBox> createState() => _EventsIncludedCheckBoxState();
}

class _EventsIncludedCheckBoxState extends State<EventsIncludedCheckBox> {
  final InstallationModel installationModel = InstallationModel();
  bool isChecked = false;

  @override
  void initState() {
    if (widget.logFile != null) {
      if (widget.logFile!.includedEvents.contains(widget.incudedEvent)) {
        setState(() {
          isChecked = true;
        });
      }
    }

    super.initState();
  }

  Color getColor(Set<MaterialState> states) {
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: InstallerColor.borderColor)),
            child: Checkbox(
              fillColor: MaterialStateProperty.resolveWith(getColor),
              activeColor: Colors.grey,
              checkColor: Colors.green,
              side: BorderSide.none,
              value: isChecked,
              onChanged: (bool? value) {
                setState(() {
                  isChecked = value!;
                  Provider.of<InstallationModel>(context, listen: false)
                      .addOrRemoveEventsToLog(widget.incudedEvent, isChecked);
                });
              },
            ),
          ),
        ),
        Text(installationModel.getIncudedEventsTitles(
            widget.incudedEvent, context))
      ],
    );
  }
}
