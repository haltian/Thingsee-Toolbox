import 'package:flutter/material.dart';
import 'package:thingsee_installer/constants/installer_icons.dart';
import 'package:thingsee_installer/constants/installer_routes.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/protocol/stack_identifier.dart';
import 'package:thingsee_installer/ui/common/empty_list_widget.dart';
import 'package:thingsee_installer/ui/common/installer_dialogs.dart';
import 'package:thingsee_installer/ui/common/installer_list_tile.dart';
import '../../constants/installer_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum DeletedOrAdded { deleted, added, none }

class StackListView extends StatefulWidget {
  final InstallerUserRepository userRepository;
  final DeletedOrAdded navigatedFor;
  final ValueNotifier<bool?> bottomNavigationVisible;

  const StackListView(
      {Key? key,
      required this.userRepository,
      required this.navigatedFor,
      required this.bottomNavigationVisible})
      : super(key: key);

  @override
  State<StackListView> createState() => _StackListViewState();
}

class _StackListViewState extends State<StackListView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.bottomNavigationVisible.value = false;
      // Check if reason for navigating is deleting or adding stack
      // If so, show a snackbar to inform user
      if (widget.navigatedFor != DeletedOrAdded.none) {
        InstallerDialogs().showSnackBar(
            context: context,
            message: _formatSnackBarMessage(widget.navigatedFor));
      }
    });
    super.initState();
  }

  String _formatSnackBarMessage(DeletedOrAdded navigatedFor) {
    return navigatedFor == DeletedOrAdded.added
        ? AppLocalizations.of(context)!.stackAddedSuccessfully
        : navigatedFor == DeletedOrAdded.deleted
            ? AppLocalizations.of(context)!.stackDeletedSuccessfully
            : "";
  }

  List<Widget> _stackList(List<StackIdentifier>? stacks) {
    List<Widget> items = [];
    items.add(const SizedBox(height: 12));
    stacks!.map((StackIdentifier stack) {
      items.add(InstallerListTile(
        icon: InstallerIcons.createInstallerAssetImage(
            assetPath: InstallerIcons.stack, width: 30, height: 30),
        title: stack.name.toString(),
        description: AppLocalizations.of(context)!.thingseeStack,
        onPressed: () async {
          //Set active stack
          await widget.userRepository.setActiveStack(stack);
          //Navigate to groups view and set nav bar visible. When returning to view hide nav bar
          widget.bottomNavigationVisible.value = true;
          if (!mounted) {
            return;
          }
          Navigator.of(context)
              .pushNamed(InstallerRoutes.groupListViewRoute, arguments: stack)
              .then((value) => widget.bottomNavigationVisible.value = false);
        },
      ));
      items.add(const SizedBox(
        height: 6,
      ));
    }).toList();

    if (stacks.isEmpty) {
      items.add(EmptyListWidget(
          infoText: AppLocalizations.of(context)!.youHaveNotTakenStacksToUse,
          buttonText: AppLocalizations.of(context)!.addNewStack,
          onPressed: () {
            Navigator.of(context)
                .pushNamed(InstallerRoutes.addStackViewRoute, arguments: false);
          }));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return Scaffold(
          floatingActionButton: FutureBuilder(
              future: widget.userRepository.getSavedStacks(),
              builder:
                  ((context, AsyncSnapshot<List<StackIdentifier>?> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: FloatingActionButton(
                        child: const Icon(Icons.add),
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              InstallerRoutes.addStackViewRoute,
                              arguments: false);
                        }),
                  );
                } else {
                  return Container();
                }
              })),
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
          body: FutureBuilder(
              future: widget.userRepository.getSavedStacks(),
              builder:
                  ((context, AsyncSnapshot<List<StackIdentifier>?> snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final stacks = snapshot.data;
                  stacks!.sort(((a, b) =>
                      a.name.toLowerCase().compareTo(b.name.toLowerCase())));

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Column(
                      children: _stackList(stacks),
                    ),
                  );
                } else {
                  return Container();
                }
              })),
        );
      }),
    );
  }
}
