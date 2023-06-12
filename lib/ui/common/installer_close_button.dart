import 'package:flutter/material.dart';

class InstallerCloseButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  const InstallerCloseButton(
      {Key? key, required this.icon, this.color = Colors.white})
      : super(key: key);

  @override
  State<InstallerCloseButton> createState() => _InstallerCloseButtonState();
}

class _InstallerCloseButtonState extends State<InstallerCloseButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          widget.icon,
          color: widget.color,
        ));
  }
}
