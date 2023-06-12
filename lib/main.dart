import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';

import 'installer_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.dark,
  ));
  runApp(InstallerApp(userRepository: InstallerUserRepository()));
}
