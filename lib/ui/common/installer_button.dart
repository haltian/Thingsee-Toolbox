import 'package:flutter/material.dart';

import '../../constants/installer_colors.dart';
import '../../constants/installer_text_styles.dart';

class InstallerButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String title;
  final bool loading;
  final double width;
  final Color color;
  final TextStyle textStyle;
  final bool includeAddIcon;
  final IconData icon;
  final double height;
  final bool centerpad;
  final Color backgroundColor;
  final bool spashEffect;

  const InstallerButton(
      {Key? key,
      @required required this.onPressed,
      required this.title,
      required this.loading,
      required this.width,
      this.height = 48.0,
      this.color = InstallerColor.blueColor,
      this.textStyle = InstallerTextStyles.buttonText,
      this.includeAddIcon = false,
      this.centerpad = false,
      this.icon = Icons.add_rounded,
      this.backgroundColor = Colors.white,
      this.spashEffect = true})
      : super(key: key);

  @override
  State<InstallerButton> createState() => _InstallerButtonState();
}

class _InstallerButtonState extends State<InstallerButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: _buttonStyle(
          widget.backgroundColor,
          widget.color,
          const EdgeInsets.all(12.0),
          widget.width,
          widget.height,
          widget.centerpad,
          widget.spashEffect),
      onPressed: widget.onPressed,
      child: widget.loading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (widget.includeAddIcon) Icon(widget.icon),
                Text(
                  widget.title,
                  style: widget.textStyle,
                ),
              ],
            ),
    );
  }
}

ButtonStyle _buttonStyle(
    Color textColor,
    Color backgroundColor,
    EdgeInsetsGeometry padding,
    double width,
    double height,
    bool centerpad,
    bool splashEffect) {
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    foregroundColor: textColor,
    backgroundColor: backgroundColor,
    fixedSize: Size(width, height),
    splashFactory: splashEffect ? null : NoSplash.splashFactory,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
    ),
    padding: centerpad ? const EdgeInsets.only(bottom: 2.5) : null,
  );

  return raisedButtonStyle;
}
