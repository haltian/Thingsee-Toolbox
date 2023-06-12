import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:provider/provider.dart';
import 'package:thingsee_installer/constants/installer_icons.dart';
import 'package:thingsee_installer/constants/installer_routes.dart';
import 'package:thingsee_installer/logic/delete_group/cubit/delete_group_cubit.dart';
import 'package:thingsee_installer/logic/fetch_device_list/cubit/fetch_device_list_cubit.dart';
import 'package:thingsee_installer/models/device_model.dart';
import 'package:thingsee_installer/models/dim_ui_model.dart';
import 'package:thingsee_installer/ui/add_or_edit_device/add_or_edit_device_view_arguments.dart';
import 'package:thingsee_installer/ui/common/installer_close_button.dart';
import 'package:thingsee_installer/ui/common/installer_dialogs.dart';
import 'package:thingsee_installer/ui/common/installer_list_tile.dart';
import 'package:thingsee_installer/ui/common/installer_text_field.dart';
import 'package:thingsee_installer/ui/device_info/device_info_view_arguments.dart';
import '../../constants/installer_colors.dart';
import '../../constants/installer_constants.dart';
import '../../constants/installer_text_styles.dart';
import '../../logic/fetch_group_list/cubit/fetch_group_list_cubit.dart';
import '../add_or_edit_group/add_or_edit_group_view_arguments.dart';
import '../common/empty_list_widget.dart';
import 'device_list_view_arguments.dart';

class DeviceListView extends StatefulWidget {
  final DeviceListViewArguments arguments;
  final ValueNotifier<bool?> bottomNavigationVisible;

  const DeviceListView(
      {Key? key,
      required this.arguments,
      required this.bottomNavigationVisible})
      : super(key: key);

  @override
  State<DeviceListView> createState() => _DeviceListViewState();
}

class _DeviceListViewState extends State<DeviceListView> {
  bool _loading = true;
  List<String> deviceIds = [];
  final DeviceModel deviceModel = DeviceModel();
  final TextEditingController _deviceFilterTextController =
      TextEditingController();
  final FocusNode _deviceFilterFocus = FocusNode();
  String _filterText = "";

  @override
  void initState() {
    _deviceFilterTextController.addListener(_deviceFilterTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.bottomNavigationVisible.value == false) {
        widget.bottomNavigationVisible.value = true;
      }
    });
    _fetchDeviceList();
    super.initState();
  }

  @override
  void dispose() {
    _deviceFilterFocus.unfocus();
    super.dispose();
  }

  void _deviceFilterTextChanged() {
    if (_deviceFilterTextController.text != _filterText) {
      setState(() {
        _filterText = _deviceFilterTextController.text;
      });
    }
  }

  void _fetchDeploymentGroups() {
    BlocProvider.of<FetchGroupListCubit>(context)
        .fetchGroupList(stack: widget.arguments.stack);
  }

  void _deleteGroup() async {
    Navigator.pop(context);

    BlocProvider.of<DeleteGroupCubit>(context).deleteGroup(
        stack: widget.arguments.stack,
        groupId: widget.arguments.group.group_id,
        devicesinGroup: deviceIds);
  }

  void _fetchDeviceList() async {
    BlocProvider.of<FetchDeviceListCubit>(context).fetchDeviceList(
        stack: widget.arguments.stack,
        groupId: widget.arguments.group.group_id);
  }

  Future<void> _pullToRefresh() {
    _fetchDeviceList();
    return Future.delayed(const Duration(seconds: 0), () {});
  }

  List<Widget> _devicesGroupedList(List<String> deviceIDs) {
    final List<Widget> items = [];

    final filteredDevices = deviceIDs
        .where((element) =>
            element.toLowerCase().contains(_filterText.toLowerCase()) ||
            deviceModel
                .getSensorName(element)
                .toLowerCase()
                .contains(_filterText.toLowerCase()))
        .toList();

    items.add(Visibility(
      visible: (deviceIDs.isNotEmpty),
      child: InstallerTextField(
        focus: _deviceFilterFocus,
        hintText: AppLocalizations.of(context)!.filter,
        textEditingController: _deviceFilterTextController,
      ),
    ));

    items.add(GroupedListView<String, String>(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      elements: filteredDevices,
      groupBy: (tuid) => deviceModel.getIdPrefix(tuid: tuid),
      groupSeparatorBuilder: (String groupByValue) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          deviceModel.getSensorName(groupByValue),
          style: InstallerTextStyles.groupTitleText,
        ),
      ),
      itemBuilder: (context, String tuid) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: InstallerListTile(
          title: tuid,
          description: deviceModel.getSensorName(tuid),
          onPressed: () {
            widget.bottomNavigationVisible.value = false;
            _deviceFilterFocus.unfocus();
            Navigator.of(context)
                .pushNamed(InstallerRoutes.deviceInfoRoute,
                    arguments: DeviceInfoArguments(tuid, 8,
                        widget.arguments.stack, widget.arguments.group))
                .then((value) => widget.bottomNavigationVisible.value = true);
          },
          icon: InstallerIcons.createInstallerAssetImage(
              assetPath: deviceModel.getSensorIcon(tuid),
              width: 40,
              height: 30),
        ),
      ),
      itemComparator: deviceIDs.length > 1
          ? (item1, item2) {
              return item1.compareTo(item2);
            }
          : null,
      useStickyGroupSeparators: false, // optional
      floatingHeader: false, // optional
      order: GroupedListOrder.ASC, // optional
    ));

    if (filteredDevices.isEmpty && deviceIDs.isNotEmpty) {
      items.add(Center(
        child: Text(
          AppLocalizations.of(context)!.noResults,
          style: InstallerTextStyles.bodyText,
        ),
      ));
    }
    if (deviceIDs.isEmpty) {
      items.add(EmptyListWidget(
          infoText: AppLocalizations.of(context)!.thereAreNoDevices,
          buttonText: AppLocalizations.of(context)!.addNewDevice,
          onPressed: () {
            widget.bottomNavigationVisible.value = false;
            Navigator.of(context)
                .pushNamed(InstallerRoutes.addOrEditDeviceViewRoute,
                    arguments: AddOrEditDeviceViewArguments(
                        widget.arguments.stack,
                        null,
                        widget.arguments.group,
                        PageAction.addDevice,
                        null))
                .then((value) {
              if (value == InstallerConstants.success) {
                _fetchDeviceList();
              }
              widget.bottomNavigationVisible.value = true;
            });
          }));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<FetchDeviceListCubit, FetchDeviceListState>(
          listener: (context, state) {
            if (state is FetchDeviceListInProgress) {
              setState(() {
                _loading = true;
              });
            } else if (state is FetchDeviceListSuccess) {
              setState(() {
                deviceIds = state.devicesResponse.tuids!;
                _loading = false;
              });
            }
          },
        ),
        BlocListener<DeleteGroupCubit, DeleteGroupState>(
          listener: (context, state) {
            if (state is DeleteGroupInProgress) {
              setState(() {
                _loading = true;
              });
            } else if (state is DeleteGroupSuccess) {
              Navigator.pop(context);
              InstallerDialogs().showSnackBar(
                  context: context,
                  message:
                      AppLocalizations.of(context)!.groupDeletedSuccessfully);
              _fetchDeploymentGroups();
            } else if (state is DeleteGroupFailed) {
              setState(() {
                _loading = false;
              });
            }
          },
        ),
      ],
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: deviceIds.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: FloatingActionButton(
                      child: const Icon(Icons.add),
                      onPressed: () {
                        widget.bottomNavigationVisible.value = false;

                        Navigator.of(context)
                            .pushNamed(InstallerRoutes.addOrEditDeviceViewRoute,
                                arguments: AddOrEditDeviceViewArguments(
                                    widget.arguments.stack,
                                    null,
                                    widget.arguments.group,
                                    PageAction.addDevice,
                                    null))
                            .then((value) {
                          if (value == InstallerConstants.success) {
                            _fetchDeviceList();
                          }
                          widget.bottomNavigationVisible.value = true;
                        });
                      }),
                )
              : null,
          appBar: AppBar(
            actions: [
              Visibility(
                visible: (widget.arguments.group.group_id !=
                    InstallerConstants.unassigned),
                child: PopupMenuButton(
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
                      ];
                    },
                    onSelected: (value) {
                      // Pop dimmer dialog
                      Provider.of<DimUiModel>(context, listen: false)
                          .setDimmed(false);
                      Navigator.pop(context);

                      switch (value) {
                        case 0:
                          widget.bottomNavigationVisible.value = false;

                          Navigator.of(context)
                              .pushNamed(
                                  InstallerRoutes.addOrEditGroupViewRoute,
                                  arguments: AddOrEditGroupViewArguments(
                                      widget.arguments.stack,
                                      widget.arguments.group,
                                      true))
                              .then((value) =>
                                  widget.bottomNavigationVisible.value = true);
                          break;
                        case 1:
                          InstallerDialogs().showMultiActionDialog(
                              context: context,
                              title: AppLocalizations.of(context)!
                                  .removeDeploymentGroup,
                              message: AppLocalizations.of(context)!
                                  .areYouSureYouWantToDeleteGroup,
                              buttonText: AppLocalizations.of(context)!.remove,
                              onPressed: () {
                                _deleteGroup();
                              });
                          break;
                        default:
                      }
                    }),
              ),
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
                  Text(widget.arguments.group.group_id,
                      overflow: TextOverflow.fade,
                      style: InstallerTextStyles.titleText
                          .copyWith(color: Colors.white, fontSize: 18)),
                  Text(widget.arguments.group.group_description.toString(),
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
                  : SizedBox(
                      height: 1000,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(children: _devicesGroupedList(deviceIds)),
                      ),
                    ))),
    );
  }
}
