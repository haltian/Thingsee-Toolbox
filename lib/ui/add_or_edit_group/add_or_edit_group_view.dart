import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thingsee_installer/constants/installer_routes.dart';
import 'package:thingsee_installer/logic/create_group/cubit/create_group_cubit.dart';
import 'package:thingsee_installer/logic/edit_group/edit_group.dart';
import 'package:thingsee_installer/logic/fetch_group_list/cubit/fetch_group_list_cubit.dart';
import 'package:thingsee_installer/models/group_model.dart';
import 'package:thingsee_installer/protocol/group.dart';
import 'package:thingsee_installer/ui/add_or_edit_group/add_or_edit_group_view_arguments.dart';
import 'package:thingsee_installer/ui/common/installer_dialogs.dart';
import 'package:thingsee_installer/ui/common/installer_text_field.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/installer_colors.dart';
import '../../constants/installer_text_styles.dart';
import '../common/installer_button.dart';
import '../common/installer_close_button.dart';
import '../common/installer_dropdown_button.dart';
import 'package:iso_countries/iso_countries.dart';

import '../device_list/device_list_view_arguments.dart';
import 'country_select_view.dart';

class AddOrEditGroupView extends StatefulWidget {
  final AddOrEditGroupViewArguments arguments;
  const AddOrEditGroupView({Key? key, required this.arguments})
      : super(key: key);

  @override
  State<AddOrEditGroupView> createState() => _AddOrEditGroupViewState();
}

class _AddOrEditGroupViewState extends State<AddOrEditGroupView> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _descriptionTextEditingController =
      TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  late List<String> environments;
  Country? _selectedCountry;
  String? _selectedEnvironment;
  String? _name;
  String? _description;
  final GroupModel groupModel = GroupModel();
  bool _loading = false;
  List<Country> countryList = <Country>[];
  final ValueNotifier<Country?> countryNotifier = ValueNotifier<Country?>(null);
  bool _anyFieldChanged = false;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _nameTextEditingController.addListener(_nameTextChanged);
      _descriptionTextEditingController.addListener(_descriptionTextChanged);
      countryNotifier.addListener(() {
        setState(() {
          _selectedCountry = countryNotifier.value;
        });
      });
      prepareDefaultCountries().then((value) {
        if (value.isNotEmpty) {
          _setFieldsIfEditing(context);
        }
      });
    });
    super.initState();
  }

  void _fetchGroupList() async {
    BlocProvider.of<FetchGroupListCubit>(context)
        .fetchGroupList(stack: widget.arguments.stack);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<List<Country>> prepareDefaultCountries() async {
    List<Country>? countries;
    try {
      countries = await IsoCountries.isoCountries;
      setState(() {
        countryList = countries!;
      });
    } catch (e) {
      countries = null;
    }

    return countries!;
  }

  void _setFieldsIfEditing(BuildContext context) {
    if (widget.arguments.editingGroup) {
      setState(() {
        _name = groupModel.getName(widget.arguments.group!.group_id);
        _nameTextEditingController.text =
            groupModel.getName(widget.arguments.group!.group_id);
        _description = widget.arguments.group!.group_description;
        _descriptionTextEditingController.text =
            widget.arguments.group!.group_description.toString();
        groupModel.getName(widget.arguments.group!.group_id);
        try {
          _selectedCountry = countryList.firstWhere((element) =>
              element.countryCode.toLowerCase() ==
              groupModel.getCountryCode(widget.arguments.group!.group_id));
          countryNotifier.value = _selectedCountry;
          _selectedEnvironment = groupModel.environments(context).firstWhere(
              (element) => element.contains(groupModel
                  .getEnvironmentPrefix(widget.arguments.group!.group_id)));
        } catch (err) {}
      });
    }
  }

  @override
  void dispose() {
    _descriptionTextEditingController.dispose();
    _descriptionFocus.dispose();
    _nameTextEditingController.dispose();
    _nameFocus.dispose();
    countryNotifier.dispose();
    super.dispose();
  }

  void _nameTextChanged() {
    if (_nameTextEditingController.text != _name) {
      setState(() {
        _anyFieldChanged = true;

        _name = _nameTextEditingController.text;
        // Remove special characters
        _name =
            _name!.replaceAll(" ", "0").replaceAll(RegExp('[^A-Za-z0-9]'), '');
      });
    }
  }

  void _descriptionTextChanged() {
    if (_descriptionTextEditingController.text != _description) {
      setState(() {
        _anyFieldChanged = true;

        _description = _descriptionTextEditingController.text;
      });
    }
  }

  bool validateFields() {
    return (_selectedEnvironment != null &&
        _selectedEnvironment != "" &&
        _selectedCountry != null &&
        _name != null &&
        _name != "" &&
        _anyFieldChanged);
  }

  void _editOrCreateGroup() {
    if (widget.arguments.editingGroup) {
      BlocProvider.of<EditGroupCubit>(context).editGroup(
          stack: widget.arguments.stack,
          oldGroupId: widget.arguments.group!.group_id,
          newGroupId: groupModel.formatGroupName(
              environment: _selectedEnvironment!,
              country: _selectedCountry!,
              name: _name!));
    } else {
      BlocProvider.of<CreateGroupCubit>(context).createNewGroup(
          stack: widget.arguments.stack,
          groupId: groupModel.formatGroupName(
              environment: _selectedEnvironment!,
              country: _selectedCountry!,
              name: _name!),
          description: _description);
    }
  }

  Widget _buildPage() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 20),
          // Environment select
          InstallerDropDownButton(
            blackHintText:
                widget.arguments.editingGroup && _selectedEnvironment != null,
            title: AppLocalizations.of(context)!.environment,
            hintText: _selectedEnvironment != null
                ? _selectedEnvironment.toString()
                : AppLocalizations.of(context)!.selectEnvironment,
            items: groupModel.environments(context),
            onChanged: (value) {
              setState(() {
                _anyFieldChanged = true;
                _selectedEnvironment = value;
              });
            },
          ),
          const SizedBox(height: 10),
          // Country select
          InstallerDropDownButton(
            blackHintText: _selectedCountry != null,
            iconVisible: false,
            title: AppLocalizations.of(context)!.country,
            hintText: _selectedCountry != null
                ? ("${(_selectedCountry!.countryCode).toLowerCase()} - ${_selectedCountry!.name}")
                : AppLocalizations.of(context)!.selectCountry,
            items: const [],
            onChanged: (_) {},
            onTap: () {
              setState(() {
                _anyFieldChanged = true;
              });
              Navigator.of(context).pushNamed(InstallerRoutes.countrySelectView,
                  arguments:
                      CountrySelectViewArguments(countryList, countryNotifier));
            },
          ),
          const SizedBox(height: 30),

          // Group name field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: InstallerTextField(
                maxLenght: 64,
                blackHintText: widget.arguments.editingGroup &&
                    _nameTextEditingController.text.isNotEmpty,
                inputAction: TextInputAction.next,
                title: AppLocalizations.of(context)!.name,
                includeSearchIcon: false,
                hintText:
                    _name != null && _nameTextEditingController.text.isNotEmpty
                        ? _name.toString()
                        : AppLocalizations.of(context)!.enterGroupName,
                textEditingController: _nameTextEditingController,
                focus: _nameFocus),
          ),
          // Group description field
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: InstallerTextField(
                maxLenght: 100,
                readOnly: widget.arguments.editingGroup,
                blackHintText: widget.arguments.editingGroup,
                title: AppLocalizations.of(context)!.description,
                includeSearchIcon: false,
                hintText: _description != null &&
                        _descriptionTextEditingController.text.isNotEmpty
                    ? _description.toString()
                    : AppLocalizations.of(context)!.enterGroupDescription,
                textEditingController: _descriptionTextEditingController,
                focus: _descriptionFocus),
          ),
          const SizedBox(height: 50),

          // Information box
          Visibility(
            visible: (validateFields()),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              height: 100,
              decoration: BoxDecoration(
                  color: InstallerColor.blueColor,
                  border: Border.all(
                    color: InstallerColor.blueColor,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              child: Center(
                child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Icon(
                        Icons.info_outline_rounded,
                        color: InstallerColor.whiteColor,
                        size: 30,
                      ),
                    ),
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.environmentNameWillBe,
                            maxLines: 1,
                            style: InstallerTextStyles.informationBoxText,
                          ),
                          Text(
                              validateFields()
                                  ? groupModel.formatGroupName(
                                      environment: _selectedEnvironment!,
                                      country: _selectedCountry!,
                                      name: _name!)
                                  : "",
                              overflow: TextOverflow.fade,
                              maxLines: 2,
                              style: InstallerTextStyles.informationBoxText
                                  .copyWith(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 90),

          Visibility(
            visible: (validateFields()),
            child: InstallerButton(
                icon: Icons.check,
                includeAddIcon: false,
                width: 220,
                loading: _loading,
                onPressed: () {
                  _editOrCreateGroup();
                },
                title: widget.arguments.editingGroup
                    ? AppLocalizations.of(context)!.saveChanges
                    : AppLocalizations.of(context)!.save),
          ),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _nameFocus.unfocus();
        _descriptionFocus.unfocus();
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<CreateGroupCubit, CreateGroupState>(
            listener: (context, state) {
              if (state is CreateGroupInProgress) {
                setState(() {
                  _loading = true;
                });
              } else if (state is CreateGroupSuccess) {
                _fetchGroupList();
                InstallerDialogs().showSnackBar(
                    context: context,
                    message:
                        AppLocalizations.of(context)!.groupCreatedSuccessfully);
                Navigator.of(context).pushReplacementNamed(
                    InstallerRoutes.deviceListViewRoute,
                    arguments: DeviceListViewArguments(
                        state.group, widget.arguments.stack));
                setState(() {
                  _loading = false;
                });
              } else if (state is CreateGroupFailed) {
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
                Navigator.pop(context);
                setState(() {
                  _loading = false;
                });
                Navigator.of(context).pushReplacementNamed(
                    InstallerRoutes.deviceListViewRoute,
                    arguments: DeviceListViewArguments(
                        Group(state.editedGroup.group_id, _description, null),
                        widget.arguments.stack));
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
            appBar: AppBar(
              automaticallyImplyLeading: false,
              actions: const [
                InstallerCloseButton(
                  icon: Icons.close_rounded,
                ),
              ],
              elevation: 0,
              backgroundColor: InstallerColor.blueColor,
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    widget.arguments.editingGroup
                        ? AppLocalizations.of(context)!.editDeploymentGroup
                        : AppLocalizations.of(context)!.addNewDeploymentGroup,
                    style: InstallerTextStyles.titleText
                        .copyWith(color: Colors.white, fontSize: 18)),
              ),
            ),
            body: SingleChildScrollView(child: _buildPage())),
      ),
    );
  }
}
