import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:thingsee_installer/constants/installer_colors.dart';
import 'package:thingsee_installer/constants/installer_icons.dart';
import 'package:thingsee_installer/constants/installer_routes.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/ui/stack_list/stack_list_view.dart';
import '../../constants/installer_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _waitAndNavigate();
    });
    super.initState();
  }

  Future<void> _waitAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3)).then((value) =>
        InstallerUserRepository().getSavedStacks().then((value) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              InstallerRoutes.stackListViewRoute, (route) => false,
              arguments: DeletedOrAdded.none);
          if (value!.isEmpty) {
            Navigator.of(context)
                .pushNamed(InstallerRoutes.addStackViewRoute, arguments: true);
          }
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: InstallerColor.blueColor,
        constraints: const BoxConstraints.expand(),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 20, 0, 0),
            child: Column(children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        width: 130,
                        height: 100,
                        child: Image.asset(InstallerIcons.thingseeLogoWhite)),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Column(children: <Widget>[
                        Text(
                          "Toolbox",
                          style: InstallerTextStyles.subHeadLine.copyWith(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: 27),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Align(
                          alignment: FractionalOffset.bottomLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
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
                    ),
                    const Align(
                      alignment: FractionalOffset.bottomRight,
                      child: SizedBox(
                          width: 140,
                          height: 230,
                          child: Image(
                              image: AssetImage(
                                  'assets/splash_screen_pattern_tstb@3x.png'))),
                    ),
                  ],
                ),
              ),
            ])));
  }
}
