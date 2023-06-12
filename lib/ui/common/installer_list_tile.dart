import 'package:flutter/material.dart';
import 'package:thingsee_installer/constants/installer_text_styles.dart';

import '../../constants/installer_colors.dart';

class InstallerListTile extends StatefulWidget {
  final String title;
  final String? description;
  final VoidCallback onPressed;
  final Widget? icon;
  final bool includeArrowIcon;
  final bool includeIconBox;
  final Color? subtitleColor;
  final TextStyle titleStyle;
  final String? timeStamp;
  const InstallerListTile({
    Key? key,
    required this.title,
    required this.description,
    required this.onPressed,
    this.icon,
    this.includeArrowIcon = true,
    this.includeIconBox = true,
    this.subtitleColor,
    this.titleStyle = InstallerTextStyles.titleText,
    this.timeStamp,
  }) : super(key: key);

  @override
  State<InstallerListTile> createState() => _InstallerListTileState();
}

class _InstallerListTileState extends State<InstallerListTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: ListTile(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: InstallerColor.borderColor),
            borderRadius: BorderRadius.circular(
              10.0,
            ),
          ),
          onTap: widget.onPressed,
          tileColor: InstallerColor.whiteColor,
          leading: widget.includeIconBox
              ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: SizedBox(child: widget.icon),
                )
              : null,
          title: Padding(
            padding: EdgeInsets.only(top: widget.timeStamp != null ? 8.0 : 0),
            child: Text(
              widget.title,
              style: widget.titleStyle,
              softWrap: true,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              widget.description != null
                  ? Text(
                      widget.description!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: InstallerTextStyles.titleText.copyWith(
                          fontWeight: FontWeight.w400,
                          color: widget.subtitleColor),
                    )
                  : Container(),
              widget.timeStamp != null
                  ? Text(
                      widget.timeStamp.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: InstallerTextStyles.titleText.copyWith(
                          fontWeight: FontWeight.w400,
                          color: InstallerColor.darkGreyColor),
                    )
                  : Container(),
            ],
          ),
          trailing: widget.includeArrowIcon
              ? const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: InstallerColor.greyIconColor,
                )
              : null),
    );
  }
}
