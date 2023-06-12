import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:thingsee_installer/constants/installer_colors.dart';
import 'package:thingsee_installer/models/dim_ui_model.dart';
import 'package:thingsee_installer/ui/common/installer_button.dart';
import '../../constants/installer_text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InstallerDialogs {
  InstallerDialogs();

  void dimBackground(BuildContext context) {
    Provider.of<DimUiModel>(context, listen: false).setDimmed(true);
    showGeneralDialog(
        barrierLabel: "",
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.7),
        context: context,
        pageBuilder: ((_, __, ___) => Container()));
  }

  void showInfoDialog(
      {required BuildContext context,
      required String title,
      required String message,
      required String buttonText,
      required bool shouldPop,
      bool installerImageAsTitle = false}) {
    Provider.of<DimUiModel>(context, listen: false).setDimmed(true);

    showGeneralDialog(
            barrierColor: Colors.black.withOpacity(0.7),
            barrierLabel: "",
            barrierDismissible: true,
            context: context,
            pageBuilder: (_, __, ___) {
              return Center(
                  child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      color: InstallerColor.blueColor,
                      borderRadius: BorderRadius.circular(10)),
                  height: !installerImageAsTitle ? 272 : 305,
                  width: 337,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),
                        !installerImageAsTitle
                            ? Text(
                                title,
                                style: InstallerTextStyles.dialogTitle,
                              )
                            : SizedBox(
                                width: 130,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 130,
                                      height: 50,
                                      child: SvgPicture.asset(
                                        'assets/thingsee_logo_white_tstb.svg',
                                        color: InstallerColor.whiteColor,
                                      ),
                                    ),
                                    Text(
                                      "Toolbox",
                                      style: InstallerTextStyles.subHeadLine
                                          .copyWith(
                                              color: Colors.white,
                                              decoration: TextDecoration.none),
                                    ),
                                  ],
                                ),
                              ),
                        Divider(
                          indent: 14,
                          endIndent: 14,
                          thickness: 1,
                          color: InstallerColor.whiteColor.withOpacity(0.2),
                        ),
                        SizedBox(
                          width: 267,
                          child: Text(
                            message,
                            style: InstallerTextStyles.dialogText,
                          ),
                        ),
                        const SizedBox(height: 20),
                        InstallerButton(
                            loading: false,
                            textStyle: InstallerTextStyles.bodyText.copyWith(
                                fontWeight: FontWeight.w700,
                                color: InstallerColor.blueColor),
                            color: InstallerColor.whiteColor,
                            onPressed: () {
                              Navigator.pop(context);
                              shouldPop ? Navigator.pop(context) : null;
                            },
                            title: buttonText,
                            width: 121),
                        const SizedBox(
                          height: 10,
                        )
                      ]),
                ),
              ));
            })
        .then((value) =>
            Provider.of<DimUiModel>(context, listen: false).setDimmed(false));
  }

  void showSnackBar({required BuildContext context, required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(message),
    ));
  }

  void showMultiActionDialog(
      {required BuildContext context,
      required String title,
      required String message,
      required String buttonText,
      required VoidCallback onPressed}) {
    Provider.of<DimUiModel>(context, listen: false).setDimmed(true);

    showGeneralDialog(
            barrierLabel: "",
            barrierDismissible: true,
            barrierColor: Colors.black.withOpacity(0.7),
            context: context,
            pageBuilder: (_, __, ___) {
              return Center(
                  child: Material(
                color: Colors.transparent,
                child: Container(
                  decoration: BoxDecoration(
                      color: InstallerColor.blueColor,
                      borderRadius: BorderRadius.circular(10)),
                  height: 272,
                  width: 337,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 5),
                        Text(
                          title,
                          style: InstallerTextStyles.dialogTitle,
                        ),
                        Divider(
                          indent: 14,
                          endIndent: 14,
                          thickness: 1,
                          color: InstallerColor.whiteColor.withOpacity(0.2),
                        ),
                        SizedBox(
                          width: 267,
                          height: 88,
                          child: Text(
                            message,
                            style: InstallerTextStyles.dialogText,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InstallerButton(
                                backgroundColor: InstallerColor.blueColor,
                                loading: false,
                                textStyle: InstallerTextStyles.bodyText
                                    .copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: InstallerColor.blueColor),
                                color: InstallerColor.whiteColor,
                                onPressed: onPressed,
                                title: buttonText,
                                width: 121),
                            InstallerButton(
                                loading: false,
                                textStyle: InstallerTextStyles.bodyText
                                    .copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: InstallerColor.whiteColor),
                                color: InstallerColor.blueColor,
                                onPressed: () => Navigator.pop(context),
                                title: AppLocalizations.of(context)!.cancel,
                                width: 121),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ]),
                ),
              ));
            })
        .then((value) =>
            Provider.of<DimUiModel>(context, listen: false).setDimmed(false));
  }
}
