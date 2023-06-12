import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thingsee_installer/constants/installer_colors.dart';
import 'package:thingsee_installer/constants/installer_text_styles.dart';

class InstallerTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final FocusNode focus;
  final bool includeSearchIcon;
  final String title;
  final TextInputAction inputAction;
  final bool blackHintText;
  final bool readOnly;
  final bool includeSuffixIcon;
  final double rightPadding;
  final int maxLenght;
  final bool isStackInfoField;
  const InstallerTextField(
      {Key? key,
      required this.hintText,
      required this.textEditingController,
      required this.focus,
      this.includeSearchIcon = true,
      this.title = "",
      this.inputAction = TextInputAction.done,
      this.blackHintText = false,
      this.readOnly = false,
      this.includeSuffixIcon = true,
      this.rightPadding = 20,
      this.maxLenght = 120,
      this.isStackInfoField = false})
      : super(key: key);

  @override
  State<InstallerTextField> createState() => _InstallerTextFieldState();
}

class _InstallerTextFieldState extends State<InstallerTextField> {
  Widget _buildSuffixIcon() {
    return Visibility(
      visible: (widget.textEditingController.text.isNotEmpty),
      child: GestureDetector(
        child: const Icon(
          Icons.close_rounded,
          color: InstallerColor.searchGreyColor,
        ),
        onTap: () {
          setState(() {
            widget.textEditingController.clear();
            widget.focus.unfocus();
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: (widget.title != ""),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 8),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title,
                  style: InstallerTextStyles.buttonText
                      .copyWith(fontSize: 14, color: Colors.grey),
                )),
          ),
        ),
        TextField(
          inputFormatters: [
            LengthLimitingTextInputFormatter(
              widget.maxLenght,
            ), //n is maximum number of characters you want in textfield
          ],
          textInputAction: widget.inputAction,
          readOnly: widget.readOnly,
          style: InstallerTextStyles.dropDownText
              .copyWith(fontSize: 16)
              .copyWith(
                  color: widget.readOnly && !widget.isStackInfoField
                      ? InstallerColor.darkGreyColor.withOpacity(0.5)
                      : Colors.black),
          focusNode: widget.focus,
          controller: widget.textEditingController,
          decoration: InputDecoration(
            prefixIcon: widget.includeSearchIcon
                ? const Icon(
                    Icons.search,
                    color: InstallerColor.searchGreyColor,
                  )
                : null,
            suffixIcon: widget.includeSuffixIcon ? _buildSuffixIcon() : null,
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.zero),
                borderSide: BorderSide(color: InstallerColor.borderColor)),
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.zero),
                borderSide: BorderSide(color: InstallerColor.borderColor)),
            hoverColor: InstallerColor.borderColor,
            hintText: widget.hintText,
            hintStyle: InstallerTextStyles.bodyText.copyWith(
                color: widget.blackHintText
                    ? Colors.black
                    : InstallerColor.middleGreyColor,
                overflow: TextOverflow.fade),
            filled: true,
            fillColor: widget.readOnly ? Colors.transparent : Colors.white,
            contentPadding: EdgeInsets.only(
                left: 20, right: widget.rightPadding, bottom: 20, top: 20),
          ),
        ),
      ],
    );
  }
}
