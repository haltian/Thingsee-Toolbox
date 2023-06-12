import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thingsee_installer/constants/installer_icons.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/ui/add_or_edit_log/add_or_edit_log_arguments.dart';
import 'package:thingsee_installer/ui/common/empty_list_widget.dart';
import 'package:thingsee_installer/ui/common/installer_list_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/installer_colors.dart';
import '../../constants/installer_routes.dart';
import '../../protocol/log_file.dart';

class LogListView extends StatefulWidget {
  final ValueNotifier<bool?> bottomNavigationVisible;
  final InstallerUserRepository userRepository;
  const LogListView(
      {Key? key,
      required this.bottomNavigationVisible,
      required this.userRepository})
      : super(key: key);

  @override
  State<LogListView> createState() => _LogListViewState();
}

class _LogListViewState extends State<LogListView> {
  // This is for triggering futurebuilder
  bool refreshList = true;

  void _navigateToAddOrEditPage() {
    widget.bottomNavigationVisible.value = false;
    refreshList = false;
    Navigator.of(context)
        .pushNamed(InstallerRoutes.addOrEditLogViewRoute,
            arguments: AddOrEditLogViewArguments(null, false))
        .then((value) => widget.bottomNavigationVisible.value = true)
        .then((value) {
      setState(() {
        refreshList = true;
      });
    });
  }

  Widget _logFileList(AsyncSnapshot<List<LogFile>?> snapshot) {
    if (snapshot.hasData && snapshot.data != null) {
      final logs = snapshot.data;
      if (logs!.isNotEmpty) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(children: [
            const SizedBox(height: 10),
            for (int i = 0; i < logs.length; i++)
              Container(
                padding: const EdgeInsets.only(bottom: 5),
                child: InstallerListTile(
                    timeStamp: DateFormat('yyyy-MM-dd HH:mm:ss')
                        .format(logs[i].timeStamp),
                    icon: logs[i].recording
                        ? InstallerIcons.createInstallerAssetImage(
                            assetPath: InstallerIcons.recording,
                            width: 25,
                            height: 25)
                        : InstallerIcons.createInstallerAssetImage(
                            assetPath: InstallerIcons.savedLog,
                            width: 32,
                            height: 32),
                    title: logs[i].title.toString() + " | " + logs[i].groupId,
                    description: logs[i].description,
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(InstallerRoutes.logDetailsViewRoute,
                              arguments: logs[i])
                          .then((value) {
                        setState(() {
                          refreshList = true;
                        });
                      });
                    }),
              )
          ]),
        );
      } else {
        return EmptyListWidget(
            buttonWidth: 220,
            infoText: AppLocalizations.of(context)!.noLogsAdded,
            buttonText: AppLocalizations.of(context)!.addNewLogFile,
            onPressed: () {
              _navigateToAddOrEditPage();
            });
      }
    }
    return Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return FutureBuilder(
            future:
                refreshList ? widget.userRepository.getSavedLogFiles() : null,
            builder: ((context, AsyncSnapshot<List<LogFile>?> snapshot) {
              return Scaffold(
                floatingActionButton: Visibility(
                  visible: (snapshot.hasData &&
                      snapshot.data != null &&
                      snapshot.data!.isNotEmpty),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: FloatingActionButton(
                        child: const Icon(Icons.add),
                        onPressed: () {
                          _navigateToAddOrEditPage();
                        }),
                  ),
                ),
                appBar: AppBar(
                    automaticallyImplyLeading: false,
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: InstallerColor.blueColor,
                    title: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/haltian_brandmark.png',
                          width: 35,
                          height: 33,
                          color: InstallerColor.whiteColor,
                        ),
                        const SizedBox(width: 10),
                        Image.asset(
                          'assets/haltian_logo_text.png',
                          width: 84,
                          height: 20,
                          color: InstallerColor.whiteColor,
                        ),
                      ],
                    )),
                body: _logFileList(snapshot),
              );
            }));
      }),
    );
  }
}
