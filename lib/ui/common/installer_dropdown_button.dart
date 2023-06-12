import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:thingsee_installer/constants/installer_colors.dart';
import 'package:thingsee_installer/constants/installer_text_styles.dart';

class InstallerDropDownButton extends StatefulWidget {
  final String title;
  final String hintText;
  final List<String> items;
  final Function(String?)? onChanged;
  final VoidCallback? onTap;
  final bool iconVisible;
  final bool blackHintText;
  const InstallerDropDownButton(
      {Key? key,
      required this.title,
      required this.hintText,
      required this.items,
      required this.onChanged,
      this.onTap,
      this.iconVisible = true,
      this.blackHintText = false})
      : super(key: key);

  @override
  State<InstallerDropDownButton> createState() =>
      _InstallerDropDownButtonState();
}

class _InstallerDropDownButtonState extends State<InstallerDropDownButton> {
  String? selectedValue;
  bool opened = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 27),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, bottom: 8),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.title,
                  style: InstallerTextStyles.buttonText
                      .copyWith(fontSize: 14, color: Colors.grey),
                )),
          ),
          GestureDetector(
            onTap: widget.onTap,
            child: DropdownButtonFormField2(
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                    borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.zero),
                    borderSide: BorderSide(color: Colors.transparent)),
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.zero),
                ),
              ),
              isExpanded: true,
              hint: Text(
                widget.hintText,
                style: InstallerTextStyles.dropDownText.copyWith(
                    fontSize: 16,
                    color: widget.blackHintText
                        ? Colors.black
                        : InstallerColor.searchGreyColor),
              ),
              icon: !opened
                  ? Icon(
                      Icons.arrow_drop_down,
                      color: widget.iconVisible
                          ? InstallerColor.blueColor
                          : Colors.transparent,
                    )
                  : Icon(
                      Icons.arrow_drop_up,
                      color: widget.iconVisible
                          ? InstallerColor.blueColor
                          : Colors.transparent,
                    ),
              onMenuStateChange: (_) {
                setState(() {
                  !opened ? opened = true : opened = false;
                });
              },
              iconSize: 30,
              buttonHeight: 60,
              buttonPadding: const EdgeInsets.only(right: 10),
              dropdownDecoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.zero)),
              buttonDecoration: BoxDecoration(
                border: Border.all(
                  color: InstallerColor.borderColor,
                ),
                color: InstallerColor.whiteColor,
              ),
              items: widget.items
                  .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child:
                            Text(item, style: InstallerTextStyles.dropDownText),
                      ))
                  .toList(),
              onChanged: widget.onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
