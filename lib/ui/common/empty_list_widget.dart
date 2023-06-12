import 'package:flutter/material.dart';
import '../../constants/installer_text_styles.dart';
import 'installer_button.dart';

class EmptyListWidget extends StatelessWidget {
  final String infoText;
  final String buttonText;
  final VoidCallback onPressed;
  final bool enableButton;
  final double buttonWidth;
  const EmptyListWidget(
      {Key? key,
      required this.infoText,
      required this.buttonText,
      required this.onPressed,
      this.enableButton = true,
      this.buttonWidth = 196})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            infoText,
            textAlign: TextAlign.center,
            style: InstallerTextStyles.buttonText.copyWith(color: Colors.black),
          ),
          const SizedBox(height: 40),
          enableButton
              ? InstallerButton(
                  loading: false,
                  includeAddIcon: true,
                  onPressed: onPressed,
                  title: buttonText,
                  width: buttonWidth)
              : Container()
        ],
      )),
    );
  }
}
