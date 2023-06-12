import 'package:flutter/material.dart';
import 'package:thingsee_installer/constants/installer_icons.dart';

import '../../constants/installer_colors.dart';

class InstallerQrButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool circularCorner;
  final double height;
  final bool loading;
  const InstallerQrButton(
      {Key? key,
      required this.onPressed,
      this.circularCorner = true,
      this.height = 48,
      this.loading = false})
      : super(key: key);

  @override
  State<InstallerQrButton> createState() => _InstallerQrButtonState();
}

class _InstallerQrButtonState extends State<InstallerQrButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Material(
      color: InstallerColor.blueColor,
      child: InkWell(
        onTap: widget.onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(widget.circularCorner ? 10.0 : 0),
            ),
          ),
          width: 87,
          height: widget.height,
          child: Container(
            margin: const EdgeInsets.all(15),
            child: widget.loading
                ? const Center(
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  )
                : InstallerIcons.createInstallerAssetImage(
                    assetPath: InstallerIcons.qr, width: 24, height: 24),
          ),
        ),
      ),
    ));
  }
}
