import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thingsee_installer/constants/installer_colors.dart';
import 'package:thingsee_installer/constants/installer_routes.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/logic/test_stack/cubit/test_stack_cubit.dart';
import 'package:thingsee_installer/protocol/stack_identifier.dart';
import 'package:thingsee_installer/ui/add_stack/add_stack_info_container.dart';
import 'package:thingsee_installer/ui/common/installer_button.dart';
import 'package:thingsee_installer/ui/common/installer_close_button.dart';
import 'package:thingsee_installer/ui/common/installer_dialogs.dart';
import 'package:thingsee_installer/ui/stack_list/stack_list_view.dart';
import '../../constants/installer_text_styles.dart';
import 'package:encrypt/encrypt.dart' as encryptionLib;

class AddStackView extends StatefulWidget {
  final InstallerUserRepository userRepository;
  const AddStackView({Key? key, required this.userRepository})
      : super(key: key);

  @override
  State<AddStackView> createState() => _AddStackViewState();
}

class _AddStackViewState extends State<AddStackView> {
  bool _scanningSecret = false;
  String _stackName = "";
  String _clientId = "";
  String _path = "";
  String _secret = "";
  bool _loading = false;
  bool qrError = false;
  final ValueNotifier<String> qrResult = ValueNotifier<String>("");
  final TextEditingController _clientIdTextEditingController =
      TextEditingController();
  final FocusNode _clientIdFocus = FocusNode();
  final TextEditingController _secretTextEditingController =
      TextEditingController();
  final FocusNode _secretFocus = FocusNode();
  final TextEditingController _pathTextEditingController =
      TextEditingController();
  final FocusNode _pathFocus = FocusNode();

  @override
  void initState() {
    qrResult.addListener(_resultChanged);
    _clientIdTextEditingController.addListener(_clientIdChanged);
    _secretTextEditingController.addListener(_secretChanged);
    _pathTextEditingController.addListener(_pathChanged);
    widget.userRepository.isFirstTimeUse().then((value) {
      if (value == false) {
        InstallerDialogs().showInfoDialog(
            context: context,
            title: "",
            message: AppLocalizations.of(context)!.welcomeToThingseeInstaller,
            buttonText: AppLocalizations.of(context)!.ok,
            installerImageAsTitle: true,
            shouldPop: false);
        widget.userRepository.setFirstTimeUsage();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _clientIdTextEditingController.dispose();
    _clientIdFocus.dispose();
    _secretTextEditingController.dispose();
    _secretFocus.dispose();
    _pathTextEditingController.dispose();
    _pathFocus.dispose();
    super.dispose();
  }

  void _clientIdChanged() {
    if (_clientIdTextEditingController.text != _clientId) {
      setState(() {
        _clientId = _clientIdTextEditingController.text;
      });
    }
  }

  void _secretChanged() {
    if (_secretTextEditingController.text != _secret) {
      setState(() {
        _secret = _secretTextEditingController.text;
      });
    }
  }

  void _pathChanged() {
    if (_pathTextEditingController.text != _path) {
      setState(() {
        _path = _pathTextEditingController.text;
      });
    }
  }

  void _resultChanged() {
    if (qrResult.value == "") return;
    Navigator.pop(context);
    try {
      //ECB, 256bits
      final key =
          encryptionLib.Key.fromUtf8("QzW6bFHywU9019sSWEtoym181QwSPpu7");
      final iv = encryptionLib.IV.fromLength(16);
      final encrypter = encryptionLib.Encrypter(
          encryptionLib.AES(key, mode: encryptionLib.AESMode.ecb)); //256bit
      final encryptionLib.Encrypted code =
          encryptionLib.Encrypted.fromBase64(qrResult.value);
      final String decrypted = encrypter.decrypt(code, iv: iv);
      qrError = true;

      List<String> parts = decrypted.split(",");
      if (parts.length == 2 || parts.length == 4) {
        if (parts[0] == "V1") {
          if (parts.length == 2 && _scanningSecret) {
            setState(() {
              _secret = parts[1];
              qrError = false;
            });
          } else if (parts.length == 4 && !_scanningSecret) {
            setState(() {
              _stackName = parts[1];
              _path = parts[2];
              _clientId = parts[3];
              qrError = false;
            });
          }
        }
      }
      _clientIdTextEditingController.text = _clientId;
      _pathTextEditingController.text = _path;
      _secretTextEditingController.text = _secret;
      if (qrError) {
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

  void _testStack() {
    BlocProvider.of<TestStackCubit>(context)
        .testStack(url: _path, clientId: _clientId, secret: _secret);
  }

  void _checkIfStackAlreadyExistsAndSave(String token) async {
    await widget.userRepository.getSavedStacks().then((savedStacks) {
      if (!savedStacks!.any((element) =>
          element.clientId == _clientId && element.name == _stackName)) {
        widget.userRepository
            .saveStack(
                StackIdentifier(0, _stackName, _clientId, _path, _secret))
            .then((value) => widget.userRepository.setToken(token))
            .then((value) => Navigator.of(context).pushNamedAndRemoveUntil(
                InstallerRoutes.stackListViewRoute, (_) => false,
                arguments: DeletedOrAdded.added));
      } else {
        InstallerDialogs().showInfoDialog(
            context: context,
            title: AppLocalizations.of(context)!.addingStackFailed,
            message: AppLocalizations.of(context)!.stackAlreadyExists,
            buttonText: AppLocalizations.of(context)!.ok,
            shouldPop: false);
        setState(() {
          _loading = false;
        });
      }
    });
  }

  _requestPermission({required bool scanningSecret}) async {
    setState(() {
      _scanningSecret = scanningSecret;
    });
    if (await Permission.camera.request().isGranted) {
      qrResult.value = "";
      Navigator.of(context)
          .pushNamed(InstallerRoutes.qrViewRoute, arguments: qrResult);
    } else {
      InstallerDialogs().showInfoDialog(
          shouldPop: false,
          context: context,
          title: AppLocalizations.of(context)!.errorOccured,
          message: AppLocalizations.of(context)!.cameraPermissionNotGranted,
          buttonText: AppLocalizations.of(context)!.ok);
    }
  }

  void _unfocusAllFields() {
    _clientIdFocus.unfocus();
    _pathFocus.unfocus();
    _secretFocus.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TestStackCubit, TestStackState>(
      listener: (context, state) {
        if (state is TestStackInProgress) {
          setState(() {
            _loading = true;
          });
        }
        if (state is TestStackSuccess) {
          _checkIfStackAlreadyExistsAndSave(state.token.token);
        } else if (state is TestStackFailed) {
          setState(() {
            _loading = false;
          });
        }
      },
      child: GestureDetector(
        onTap: () {
          _unfocusAllFields();
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
                child: Text(AppLocalizations.of(context)!.addNewStack,
                    style: InstallerTextStyles.titleText
                        .copyWith(color: Colors.white, fontSize: 18)),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 30),
                    AddStackInfoContainer(
                      onPressed: () =>
                          _requestPermission(scanningSecret: false),
                      value: _clientId,
                      isSecret: false,
                      path: _path,
                      clientIdFocus: _clientIdFocus,
                      clientIdTextEditingController:
                          _clientIdTextEditingController,
                      secretFocus: _secretFocus,
                      secretTextEditingController: _secretTextEditingController,
                      pathTextEditingController: _pathTextEditingController,
                      pathFocus: _pathFocus,
                    ),
                    const SizedBox(height: 30),
                    AddStackInfoContainer(
                      onPressed: () => _requestPermission(scanningSecret: true),
                      value: _secret,
                      isSecret: true,
                      path: "",
                      clientIdFocus: _clientIdFocus,
                      clientIdTextEditingController:
                          _clientIdTextEditingController,
                      secretFocus: _secretFocus,
                      secretTextEditingController: _secretTextEditingController,
                      pathTextEditingController: _pathTextEditingController,
                      pathFocus: _pathFocus,
                    ),
                    Visibility(
                      visible:
                          (_path != "" && _clientId != "" && _secret != ""),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: InstallerButton(
                              includeAddIcon: false,
                              width: 196,
                              loading: _loading,
                              onPressed: () async {
                                // Test stack from backend
                                _unfocusAllFields();
                                _testStack();
                              },
                              title: AppLocalizations.of(context)!.save),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ]),
            )),
      ),
    );
  }
}
