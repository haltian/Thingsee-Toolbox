import 'package:flutter/material.dart';
import 'package:thingsee_installer/constants/installer_text_styles.dart';

class customLicenses extends StatefulWidget {
  const customLicenses({Key? key}) : super(key: key);

  @override
  State<customLicenses> createState() => _customLicensesState();
}

class _customLicensesState extends State<customLicenses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Theme(
      data: Theme.of(context).copyWith(
        textTheme: TextTheme(
            headline5: InstallerTextStyles.headLine,
            bodyText2: InstallerTextStyles.bodyText,
            headline6: InstallerTextStyles.headLine,
            subtitle1: InstallerTextStyles.bodyText),
      ),
      child: LicensePage(),
    ));
  }
}
