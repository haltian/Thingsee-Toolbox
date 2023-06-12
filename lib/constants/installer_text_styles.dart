import 'package:flutter/material.dart';
import 'package:thingsee_installer/constants/installer_colors.dart';

abstract class InstallerTextStyles {
  static const fontFamily = 'SourceSanspro-Light.ttf';
  static const dialogFontFamily = 'Inter-Regural.ttf';

  // Flutter takes line height as multiplier to fontSize instead of
  // fixed line height, so line height is calculated with font size and
  // designed line height

  static const headLine = TextStyle(
      fontFamily: fontFamily,
      fontStyle: FontStyle.normal,
      color: Colors.black,
      fontSize: 22,
      letterSpacing: 0);

  static const subHeadLine = TextStyle(
      fontFamily: fontFamily,
      fontStyle: FontStyle.normal,
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 20,
      height: 26 / 20,
      letterSpacing: 0);

  static const bodyText = TextStyle(
      fontFamily: fontFamily,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      height: 20 / 16,
      color: Colors.black,
      fontSize: 16,
      letterSpacing: 0);

  static const dialogTitle = TextStyle(
      fontFamily: dialogFontFamily,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      height: 26 / 16,
      color: Colors.white,
      fontSize: 16,
      letterSpacing: 0);

  static const dialogText = TextStyle(
      fontFamily: dialogFontFamily,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      height: 22 / 16,
      color: Colors.white,
      fontSize: 16,
      letterSpacing: 0);

  static const titleText = TextStyle(
      fontFamily: fontFamily,
      fontStyle: FontStyle.normal,
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 16,
      height: 20 / 16,
      letterSpacing: 0);

  static const buttonText = TextStyle(
      fontFamily: fontFamily,
      fontStyle: FontStyle.normal,
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 18,
      height: 24 / 18,
      letterSpacing: 0);

  static const groupTitleText = TextStyle(
      fontFamily: fontFamily,
      fontStyle: FontStyle.normal,
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 14,
      height: 20 / 14,
      letterSpacing: 0);

  static const dropDownText = TextStyle(
      fontFamily: fontFamily,
      fontStyle: FontStyle.normal,
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 20 / 16,
      letterSpacing: 0);

  static const informationBoxText = TextStyle(
      fontFamily: fontFamily,
      fontStyle: FontStyle.normal,
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 24 / 16,
      letterSpacing: 0);

  static const bottomSheetTitle = TextStyle(
      fontFamily: fontFamily,
      fontStyle: FontStyle.normal,
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 18,
      height: 20 / 18,
      letterSpacing: 0);

  static const timeStampText = TextStyle(
      fontFamily: fontFamily,
      fontStyle: FontStyle.normal,
      color: InstallerColor.darkGreyColor,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 24 / 16,
      letterSpacing: 0);

  static const bottomNavigationText = TextStyle(
      fontFamily: fontFamily,
      fontStyle: FontStyle.normal,
      color: InstallerColor.darkGreyColor,
      fontWeight: FontWeight.w600,
      fontSize: 12,
      height: 20 / 12,
      letterSpacing: 0);

  static const aboutInstallerText = TextStyle(
    fontFamily: fontFamily,
    fontStyle: FontStyle.normal,
    color: InstallerColor.blueColor,
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 26 / 18,
  );
  static const logEventDetails = TextStyle(
      fontFamily: fontFamily,
      fontStyle: FontStyle.normal,
      color: InstallerColor.darkGreyColor,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 20 / 16,
      letterSpacing: 0);

  static const logEntryDeleteText = TextStyle(
      fontFamily: fontFamily,
      fontStyle: FontStyle.normal,
      color: InstallerColor.blueColor,
      fontWeight: FontWeight.w400,
      fontSize: 18,
      height: 24 / 18,
      letterSpacing: 0);
}
