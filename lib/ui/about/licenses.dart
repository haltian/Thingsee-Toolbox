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
        textTheme: const TextTheme(
            headlineSmall: InstallerTextStyles.headLine,
            bodyMedium: InstallerTextStyles.bodyText,
            titleLarge: InstallerTextStyles.headLine,
            titleMedium: InstallerTextStyles.bodyText),
      ),
      child: const LicensePage(),
    ));
  }
}
