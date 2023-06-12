import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:thingsee_installer/constants/installer_routes.dart';
import 'package:thingsee_installer/constants/installer_text_styles.dart';
import 'package:thingsee_installer/ui/common/installer_list_tile.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/installer_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AboutView extends StatefulWidget {
  final ValueNotifier<bool?> bottomNavigationVisible;

  const AboutView({Key? key, required this.bottomNavigationVisible})
      : super(key: key);

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  String version = "";
  DateTime now = DateTime.now();

  final Uri _url = Uri.parse("https://support.haltian.com/");

  @override
  void initState() {
    _packageInfo();
    super.initState();
  }

  void _packageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  Widget _aboutBoxes() {
    return Column(children: [
      InstallerListTile(
        title: AppLocalizations.of(context)!.help,
        description: AppLocalizations.of(context)!.goToHelp,
        onPressed: _launchUrl,
        includeArrowIcon: true,
        includeIconBox: false,
      ),
      const SizedBox(
        height: 6,
      ),
      InstallerListTile(
        title: AppLocalizations.of(context)!.licenses,
        description: AppLocalizations.of(context)!.goToLicenses,
        onPressed: () {
          widget.bottomNavigationVisible.value = false;
          Navigator.of(context)
              .pushNamed(InstallerRoutes.licensesRoute)
              .then((value) => widget.bottomNavigationVisible.value = true);
        },
        includeArrowIcon: true,
        includeIconBox: false,
      )
    ]);
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }

  Widget _logoAndVersion() {
    return Column(
      children: [
        const SizedBox(
          height: 27,
        ),
        Image.asset(
          'assets/thingsee_logo.png',
          width: 150,
          height: 47,
        ),
        const Text(
          "TOOLBOX",
          style: InstallerTextStyles.aboutInstallerText,
        ),
        const SizedBox(
          height: 23,
        ),
        Text(
          AppLocalizations.of(context)!.version(version),
          style: InstallerTextStyles.dropDownText,
        ),
        Text(
          AppLocalizations.of(context)!.copyright(now.year.toString()),
          style: InstallerTextStyles.dropDownText,
        ),
        const SizedBox(
          height: 34,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Column(children: [_logoAndVersion(), _aboutBoxes()]));
  }
}
