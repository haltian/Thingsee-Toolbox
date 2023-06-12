import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:thingsee_installer/constants/installer_routes.dart';
import 'package:thingsee_installer/logic/fetch_group_list/cubit/fetch_group_list_cubit.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thingsee_installer/models/installation_model.dart';
import 'package:thingsee_installer/protocol/log_file.dart';
import 'package:thingsee_installer/protocol/stack_identifier.dart';
import 'package:thingsee_installer/ui/add_or_edit_log/add_or_edit_log_arguments.dart';
import 'package:thingsee_installer/ui/add_or_edit_log/events_incuded_checkbox.dart';
import 'package:thingsee_installer/ui/common/group_select_view.dart';
import 'package:thingsee_installer/ui/common/installer_close_button.dart';
import '../../constants/installer_colors.dart';
import '../../constants/installer_text_styles.dart';
import '../../protocol/group.dart';
import '../common/installer_button.dart';
import '../common/installer_dropdown_button.dart';
import '../common/installer_text_field.dart';

class AddOrEditLogView extends StatefulWidget {
  final InstallerUserRepository userRepository;
  final AddOrEditLogViewArguments arguments;
  const AddOrEditLogView(
      {Key? key, required this.userRepository, required this.arguments})
      : super(key: key);

  @override
  State<AddOrEditLogView> createState() => _AddLogViewState();
}

class _AddLogViewState extends State<AddOrEditLogView> {
  final TextEditingController _titleTextEditingController =
      TextEditingController();
  final TextEditingController _descriptionTextEditingController =
      TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  String? _title;
  String? _description;
  bool _loading = true;
  String? _selectedGroupId;
  List<Group> _groups = [];
  List<String> _groupIds = [];
  StackIdentifier? _activeStack;
  InstallationModel? installationModel;
  final ValueNotifier<String?> groupIdNotifier = ValueNotifier<String?>(null);
  bool _anyFieldChanged = false;
  List<IncudedEvent> _oldIncludedEvents = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      groupIdNotifier.addListener(() {
        setState(() {
          _selectedGroupId = groupIdNotifier.value!;
        });
      });
      installationModel =
          Provider.of<InstallationModel>(context, listen: false);

      _getActiveStack();
      _titleTextEditingController.addListener(_titleTextChanged);
      _descriptionTextEditingController.addListener(_descriptionTextChanged);
      _setFieldsIfEditing();
      setState(() {
        _oldIncludedEvents.addAll(
            Provider.of<InstallationModel>(context, listen: false)
                .getIncudedEvents());
      });
    });
    super.initState();
  }

  void _setFieldsIfEditing() {
    if (widget.arguments.editingLogFile) {
      setState(() {
        _title = widget.arguments.logFile!.title;
        _titleTextEditingController.text = widget.arguments.logFile!.title;
        _description = widget.arguments.logFile!.description;
        _descriptionTextEditingController.text =
            widget.arguments.logFile!.description;
        _selectedGroupId = widget.arguments.logFile!.groupId;
        groupIdNotifier.value = _selectedGroupId;
        installationModel!
            .updateEventsList(widget.arguments.logFile!.includedEvents);
      });
    }
  }

  void _getActiveStack() async {
    await widget.userRepository.getActiveStack().then((value) {
      if (value != null) {
        setState(() {
          _activeStack = value;
        });
        _fetchDeploymentGroups(_activeStack!);
      }
    });
  }

  void _fetchDeploymentGroups(StackIdentifier stack) {
    BlocProvider.of<FetchGroupListCubit>(context).fetchGroupList(stack: stack);
  }

  @override
  void dispose() {
    _descriptionTextEditingController.dispose();
    _descriptionFocus.dispose();
    _titleTextEditingController.dispose();
    _nameFocus.dispose();
    groupIdNotifier.dispose();
    super.dispose();
  }

  void _titleTextChanged() {
    if (_titleTextEditingController.text != _title) {
      setState(() {
        _anyFieldChanged = true;
        _title = _titleTextEditingController.text;
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

  bool validateFields(InstallationModel model) {
    return widget.arguments.editingLogFile
        ? (_title != null &&
                _title != "" &&
                _description != null &&
                _description != "" &&
                groupIdNotifier.value != null &&
                _anyFieldChanged ||
            const DeepCollectionEquality()
                    .equals(model.getIncudedEvents(), _oldIncludedEvents) ==
                false)
        : (_title != null &&
            _title != "" &&
            _description != null &&
            _description != "" &&
            groupIdNotifier.value != null &&
            model.getIncudedEvents().isNotEmpty);
  }

  void _createLog(InstallationModel model) async {
    widget.userRepository
        .createLogFile(LogFile(null, _activeStack!, _title!, _description!,
            DateTime.now(), true, _selectedGroupId!, model.getIncudedEvents()))
        .then((value) => model.clearIncludedEvents())
        .then((value) => Navigator.pop(context));
  }

  void _updateLog(InstallationModel model) async {
    widget.userRepository
        .updateLogFile(
            LogFile(
                widget.arguments.logFile!.id,
                _activeStack!,
                _title!,
                _description!,
                DateTime.now(),
                true,
                _selectedGroupId!,
                model.getIncudedEvents()),
            context)
        .then((value) => model.clearIncludedEvents())
        .then((value) => Navigator.pop(context));
  }

  Widget _buildPage() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 20),

          // Log title textfield
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: InstallerTextField(
              inputAction: TextInputAction.next,
              title: AppLocalizations.of(context)!.title,
              includeSearchIcon: false,
              hintText: _title != null && _title != ""
                  ? _title!
                  : AppLocalizations.of(context)!.enterTitle,
              focus: _nameFocus,
              textEditingController: _titleTextEditingController,
            ),
          ),
          const SizedBox(height: 10),

          // Log description textfield
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: InstallerTextField(
              inputAction: TextInputAction.next,
              title: AppLocalizations.of(context)!.description,
              includeSearchIcon: false,
              hintText: _description != null && _description != ""
                  ? _description.toString()
                  : AppLocalizations.of(context)!.enterDescription,
              focus: _descriptionFocus,
              textEditingController: _descriptionTextEditingController,
            ),
          ),
          const SizedBox(height: 30),

          InstallerDropDownButton(
            blackHintText: _selectedGroupId != null,
            iconVisible: false,
            title: AppLocalizations.of(context)!.deploymentGroup,
            hintText: _selectedGroupId != null
                ? _selectedGroupId!
                : AppLocalizations.of(context)!.selectGroup,
            items: const [],
            onChanged: (_) {},
            onTap: () {
              _anyFieldChanged = true;
              _nameFocus.unfocus();
              _descriptionFocus.unfocus();
              Navigator.of(context).pushNamed(InstallerRoutes.groupSelectView,
                  arguments:
                      GroupSelectViewArguments(_groups, groupIdNotifier));
            },
          ),

          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 28.0),
              child: Text(AppLocalizations.of(context)!.eventsIncludedInTheLog,
                  style: InstallerTextStyles.bodyText),
            ),
          ),
          const SizedBox(height: 10),

          for (final event in IncudedEvent.values)
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: EventsIncludedCheckBox(
                  incudedEvent: event, logFile: widget.arguments.logFile),
            ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          Consumer<InstallationModel>(builder: (context, model, _) {
            return Visibility(
              visible: (validateFields(model)),
              child: InstallerButton(
                  icon: Icons.check,
                  includeAddIcon: false,
                  width: 220,
                  loading: _loading,
                  onPressed: () async {
                    _createOrEditLogFile(model);
                    print(installationModel!.getIncudedEvents());
                  },
                  title: widget.arguments.editingLogFile
                      ? AppLocalizations.of(context)!.saveChanges
                      : AppLocalizations.of(context)!.save),
            );
          }),
        ]);
  }

  void _createOrEditLogFile(InstallationModel model) {
    if (widget.arguments.editingLogFile) {
      _updateLog(model);
    } else {
      _createLog(model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FetchGroupListCubit, FetchGroupListState>(
      listener: (context, state) {
        if (state is FetchGroupListSuccess) {
          setState(() {
            _groups = state.groups;
            _groupIds.addAll(state.groups.map((e) => e.group_id));
            _loading = false;
          });
        } else if (state is FetchGroupListFailed) {
          setState(() {
            _loading = false;
          });
        }
      },
      child: GestureDetector(
        onTap: () {
          _nameFocus.unfocus();
          _descriptionFocus.unfocus();
        },
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
                    widget.arguments.editingLogFile
                        ? AppLocalizations.of(context)!.editLogFile
                        : AppLocalizations.of(context)!.addNewLogFile,
                    style: InstallerTextStyles.titleText
                        .copyWith(color: Colors.white, fontSize: 18)),
              ),
            ),
            body: _loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(child: _buildPage())),
      ),
    );
  }
}
