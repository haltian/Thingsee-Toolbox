import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/constants/installer_icons.dart';
import 'package:thingsee_installer/constants/installer_routes.dart';
import 'package:thingsee_installer/logic/fetch_group_list/cubit/fetch_group_list_cubit.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/models/dim_ui_model.dart';
import 'package:thingsee_installer/protocol/stack_identifier.dart';
import 'package:thingsee_installer/ui/common/installer_close_button.dart';
import 'package:thingsee_installer/ui/common/installer_dialogs.dart';
import 'package:thingsee_installer/ui/common/installer_list_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thingsee_installer/ui/common/installer_text_field.dart';
import 'package:thingsee_installer/ui/device_list/device_list_view_arguments.dart';
import 'package:thingsee_installer/ui/stack_list/stack_list_view.dart';

import '../../constants/installer_colors.dart';
import '../../constants/installer_text_styles.dart';
import '../../logic/edit_group/cubit/edit_group_cubit.dart';
import '../../protocol/group.dart';
import '../add_or_edit_group/add_or_edit_group_view_arguments.dart';
import '../common/empty_list_widget.dart';

class GroupListView extends StatefulWidget {
  final StackIdentifier stackIdentifier;
  final ValueNotifier<bool?> bottomNavigationVisible;

  const GroupListView(
      {Key? key,
      required this.stackIdentifier,
      required this.bottomNavigationVisible})
      : super(key: key);

  @override
  State<GroupListView> createState() => _GroupListViewState();
}

class _GroupListViewState extends State<GroupListView> {
  bool _loading = true;
  List<Group> _groups = [];
  final TextEditingController _filterTextController = TextEditingController();
  final FocusNode _filterFocus = FocusNode();
  String _filterText = "";

  @override
  void initState() {
    _filterTextController.addListener(_filterTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.bottomNavigationVisible.value = true;
      _fetchGroupList();
    });
    super.initState();
  }

  @override
  void dispose() {
    _filterTextController.dispose();
    _filterFocus.unfocus();
    _filterFocus.dispose();
    super.dispose();
  }

  void _fetchGroupList() async {
    BlocProvider.of<FetchGroupListCubit>(context)
        .fetchGroupList(stack: widget.stackIdentifier);
  }

  void _filterTextChanged() {
    if (_filterTextController.text != _filterText) {
      setState(() {
        _filterText = _filterTextController.text;
      });
    }
  }

  List<Widget> _groupList(List<Group> _groupList) {
    final List<Widget> items = [];

    _groupList.sort(((a, b) =>
        a.group_id.toLowerCase().compareTo(b.group_id.toLowerCase())));
    // Move 'unassigned' group to bottom of the list
    Group groupUnassigned = _groups.firstWhere(
        (element) => element.group_id == InstallerConstants.unassigned);
    _groups.remove(groupUnassigned);
    _groups.add(groupUnassigned);
    var filteredList = _groupList
        .where((element) => element.group_id
            .toLowerCase()
            .contains(_filterTextController.text.toLowerCase()))
        .toList();

    items.add(Visibility(
      visible: (_groups.isNotEmpty),
      child: InstallerTextField(
        focus: _filterFocus,
        hintText: AppLocalizations.of(context)!.filter,
        textEditingController: _filterTextController,
      ),
    ));
    items.add(const SizedBox(height: 10));
    filteredList.map((Group group) {
      items.add(InstallerListTile(
          icon: InstallerIcons.createInstallerAssetImage(
              assetPath: InstallerIcons.folder, width: 30, height: 30),
          title: group.group_id,
          description: group.group_description.toString(),
          onPressed: () {
            _filterFocus.unfocus();
            Navigator.of(context).pushNamed(InstallerRoutes.deviceListViewRoute,
                arguments:
                    DeviceListViewArguments(group, widget.stackIdentifier));
          }));
      items.add(const SizedBox(
        height: 6,
      ));
    }).toList();

    if (filteredList.isEmpty && _groups.isNotEmpty) {
      items.add(Center(
        child: Text(
          AppLocalizations.of(context)!.noResults,
          style: InstallerTextStyles.bodyText,
        ),
      ));
    }
    if (_groups.isEmpty) {
      items.add(EmptyListWidget(
          infoText: AppLocalizations.of(context)!.thereAreNoDeploymentGroups,
          buttonText: AppLocalizations.of(context)!.addNewGroup,
          onPressed: () {
            widget.bottomNavigationVisible.value = false;

            Navigator.of(context)
                .pushNamed(InstallerRoutes.addOrEditGroupViewRoute,
                    arguments: AddOrEditGroupViewArguments(
                        widget.stackIdentifier, null, false))
                .then((value) => widget.bottomNavigationVisible.value = true);
          }));
    }

    return items;
  }

  void _deleteStackAndRefresh(StackIdentifier stack) {
    InstallerUserRepository().deleteStack(stack).then((value) =>
        Navigator.of(context).pushNamedAndRemoveUntil(
            InstallerRoutes.stackListViewRoute, (route) => false,
            arguments: DeletedOrAdded.deleted));
  }

  String _formatStackInfoText() {
    return "${AppLocalizations.of(context)!.clientID(widget.stackIdentifier.clientId)}${"\n\n"}${AppLocalizations.of(context)!.path(widget.stackIdentifier.apiURL!)}";
  }

  Future<void> _pullToRefresh() {
    _fetchGroupList();
    return Future.delayed(Duration(seconds: 1), () {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FetchGroupListCubit, FetchGroupListState>(
          listener: (context, state) {
            if (state is FetchGroupListSuccess) {
              setState(() {
                _groups = state.groups;
                _loading = false;
              });
            } else if (state is FetchGroupListFailed) {
              setState(() {
                _loading = false;
              });
            }
          },
        ),
        BlocListener<EditGroupCubit, EditGroupState>(
          listener: (context, state) {
            if (state is EditGroupInProgress) {
              setState(() {
                _loading = true;
              });
            } else if (state is EditGroupSuccess) {
              _fetchGroupList();
            } else if (state is EditGroupFailed) {
              setState(() {
                _loading = false;
              });
            }
          },
        ),
      ],
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: _groups.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () {
                        _filterFocus.unfocus();
                        widget.bottomNavigationVisible.value = false;
                        Navigator.of(context)
                            .pushNamed(InstallerRoutes.addOrEditGroupViewRoute,
                                arguments: AddOrEditGroupViewArguments(
                                    widget.stackIdentifier, null, false))
                            .then((value) =>
                                widget.bottomNavigationVisible.value = true);
                      }),
                )
              : null,
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
                    // Pop the dialog
                    Navigator.pop(context);
                    Provider.of<DimUiModel>(context, listen: false)
                        .setDimmed(false);
                  },
                  itemBuilder: (context) {
                    _filterFocus.unfocus();
                    // Create dim background with dialog
                    InstallerDialogs().dimBackground(context);
                    Provider.of<DimUiModel>(context, listen: false)
                        .setDimmed(true);
                    return [
                      PopupMenuItem<int>(
                        value: 0,
                        child: Text(
                          AppLocalizations.of(context)!.info,
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
                    ];
                  },
                  onSelected: (value) {
                    Navigator.pop(context);
                    Provider.of<DimUiModel>(context, listen: false)
                        .setDimmed(false);

                    switch (value) {
                      case 0:
                        InstallerDialogs().showInfoDialog(
                            shouldPop: false,
                            context: context,
                            title: widget.stackIdentifier.name,
                            message: _formatStackInfoText(),
                            buttonText: AppLocalizations.of(context)!.ok);

                        break;
                      case 1:
                        InstallerDialogs().showMultiActionDialog(
                            context: context,
                            title: AppLocalizations.of(context)!.removeStack,
                            message: AppLocalizations.of(context)!
                                .areYouSureYouWantToDeleteStack,
                            buttonText: AppLocalizations.of(context)!.remove,
                            onPressed: () {
                              // Pop dialog
                              Navigator.pop(context);
                              _deleteStackAndRefresh(widget.stackIdentifier);
                            });
                        break;
                      default:
                    }
                  }),
            ],
            leading: InstallerCloseButton(
              icon: Icons.arrow_back_ios_new_rounded,
            ),
            elevation: 0,
            backgroundColor: InstallerColor.blueColor,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.stackIdentifier.name,
                      style: InstallerTextStyles.titleText
                          .copyWith(color: Colors.white, fontSize: 18)),
                  Text(AppLocalizations.of(context)!.thingseeStack,
                      overflow: TextOverflow.fade,
                      style: InstallerTextStyles.bodyText
                          .copyWith(color: Colors.white)),
                ],
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () => _pullToRefresh(),
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(children: _groupList(_groups))),
          )),
    );
  }
}
