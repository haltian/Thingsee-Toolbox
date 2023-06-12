import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thingsee_installer/constants/installer_routes.dart';
import 'package:thingsee_installer/logic/fetch_group/cubit/fetch_group_cubit.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/protocol/group.dart';
import 'package:thingsee_installer/ui/common/installer_button.dart';
import 'package:thingsee_installer/ui/device_info/device_info_view_arguments.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thingsee_installer/ui/common/installer_dialogs.dart';
import 'package:thingsee_installer/ui/common/installer_qr_button.dart';
import '../../constants/installer_colors.dart';
import '../../protocol/stack_identifier.dart';
import '../common/installer_text_field.dart';

class SearchDeviceView extends StatefulWidget {
  final InstallerUserRepository userRepository;
  final ValueNotifier<bool?> bottomNavigationVisible;
  const SearchDeviceView(
      {Key? key,
      required this.userRepository,
      required this.bottomNavigationVisible})
      : super(key: key);

  @override
  State<SearchDeviceView> createState() => _SearchDeviceViewState();
}

class _SearchDeviceViewState extends State<SearchDeviceView> {
  String? _selectedDeviceID;
  StackIdentifier? _activeStack;
  final FocusNode _searchFocus = FocusNode();
  bool _loading = false;
  final TextEditingController _searchDeviceTextController =
      TextEditingController();
  bool _qrRead = false;
  final ValueNotifier<String> qrResult = ValueNotifier<String>("");

  @override
  void initState() {
    _searchDeviceTextController.addListener(_searchTextChanged);
    qrResult.addListener(_resultChanged);
    _getActiveStack();
    super.initState();
  }

  void _resultChanged() {
    if (qrResult.value == "") return;
    Navigator.pop(context);
    try {
      List<String> tuidParts = [];
      tuidParts = qrResult.value.split(',');

      if (tuidParts.length > 1 &&
          tuidParts[0].length == 11 &&
          tuidParts[1].length == 6) {
        setState(() {
          _searchDeviceTextController.clear();

          setState(() {
            _selectedDeviceID = tuidParts[1] + tuidParts[0];
            _qrRead = true;
          });
        });
        if (_selectedDeviceID != null) {
          _fetchDeviceGroup(true);
        }
      } else {
        throw Exception();
      }
    } catch (e) {
      InstallerDialogs().showInfoDialog(
          context: context,
          title: AppLocalizations.of(context)!.errorOccured,
          message: AppLocalizations.of(context)!.unknownQRcode,
          buttonText: AppLocalizations.of(context)!.ok,
          shouldPop: false);
    }
  }

  @override
  void dispose() {
    _searchDeviceTextController.dispose();
    _searchFocus.unfocus();
    _searchFocus.dispose();
    super.dispose();
  }

  void _searchTextChanged() {
    if (_searchDeviceTextController.text != _selectedDeviceID) {
      setState(() {
        _selectedDeviceID = _searchDeviceTextController.text;
        // Backend won't find device if tuid isn't capitalized
        // Also trim out spaces
        _selectedDeviceID = _selectedDeviceID!.toUpperCase().trim();
      });
    }
  }

  void _getActiveStack() async {
    await widget.userRepository.getActiveStack().then((value) {
      if (value != null) {
        setState(() {
          _activeStack = value;
        });
      }
    });
  }

  _requestPermission() async {
    if (await Permission.camera.request().isGranted) {
      qrResult.value = "";
      widget.bottomNavigationVisible.value = false;
      Navigator.of(context)
          .pushNamed(InstallerRoutes.qrViewRoute, arguments: qrResult)
          .then((value) => widget.bottomNavigationVisible.value = true);
    } else {
      InstallerDialogs().showInfoDialog(
          shouldPop: false,
          context: context,
          title: AppLocalizations.of(context)!.errorOccured,
          message: AppLocalizations.of(context)!.cameraPermissionNotGranted,
          buttonText: AppLocalizations.of(context)!.ok);
    }
  }

  void _fetchDeviceGroup(bool wasQR) {
    BlocProvider.of<FetchGroupCubit>(context)
        .fetchGroup(deviceID: _selectedDeviceID!, stack: _activeStack!);
  }

  void _navigateToDeviceInfoView(String groupID) {
    widget.bottomNavigationVisible.value = false;
    Navigator.of(context)
        .pushNamed(InstallerRoutes.deviceInfoRoute,
            arguments: DeviceInfoArguments(_selectedDeviceID!, 8, _activeStack!,
                Group(groupID, null, false)))
        .then((value) {
      widget.bottomNavigationVisible.value = true;
      if (_qrRead) {
        setState(() {
          _selectedDeviceID = null;
        });
      }
    });
  }

  Widget _searchBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 256,
          child: InstallerTextField(
            includeSearchIcon: false,
            readOnly: false,
            includeSuffixIcon: _searchDeviceTextController.text.isNotEmpty,
            blackHintText: _selectedDeviceID != null && _loading,
            hintText: (_selectedDeviceID != null && _loading)
                ? _selectedDeviceID!
                : AppLocalizations.of(context)!.enterTuidOrReadQR,
            textEditingController: _searchDeviceTextController,
            focus: _searchFocus,
          ),
        ),
        InstallerQrButton(
            loading: (_loading && _searchDeviceTextController.text.isEmpty),
            height: 58,
            circularCorner: false,
            onPressed: () async {
              _requestPermission();
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FetchGroupCubit, FetchGroupState>(
      listener: (context, state) {
        if (state is FetchGroupSuccess) {
          setState(() {
            _loading = false;
          });
          _navigateToDeviceInfoView(state.group.group_id);
        } else if (state is FetchGroupInProgress) {
          setState(() {
            _loading = true;
          });
        } else if (state is FetchGroupFailed) {
          setState(() {
            _loading = false;
          });
        }
      },
      child: GestureDetector(
          onTap: (() => _searchFocus.unfocus()),
          child: Scaffold(
              resizeToAvoidBottomInset: false,
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
              body:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                const SizedBox(
                  height: 42,
                ),
                _searchBar(),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 10,
                ),
                Visibility(
                  visible: (_selectedDeviceID != null &&
                      _selectedDeviceID!.length > 5 &&
                      !_qrRead),
                  child: InstallerButton(
                      onPressed: () {
                        _fetchDeviceGroup(false);
                      },
                      title: AppLocalizations.of(context)!.search,
                      loading: _loading,
                      width: 150),
                )
              ]))),
    );
  }
}
