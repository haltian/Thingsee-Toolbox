import 'package:flutter/material.dart';
import 'package:thingsee_installer/ui/common/installer_qr_button.dart';
import 'package:thingsee_installer/ui/common/installer_text_field.dart';
import '../../constants/installer_colors.dart';
import '../../constants/installer_text_styles.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddStackInfoContainer extends StatefulWidget {
  final VoidCallback onPressed;
  final String value;
  final bool isSecret;
  final String path;
  final TextEditingController clientIdTextEditingController;
  final TextEditingController secretTextEditingController;
  final TextEditingController pathTextEditingController;
  final FocusNode clientIdFocus;
  final FocusNode secretFocus;
  final FocusNode pathFocus;
  const AddStackInfoContainer(
      {Key? key,
      required this.onPressed,
      required this.value,
      required this.isSecret,
      required this.path,
      required this.clientIdTextEditingController,
      required this.secretTextEditingController,
      required this.clientIdFocus,
      required this.secretFocus,
      required this.pathTextEditingController,
      required this.pathFocus})
      : super(key: key);

  @override
  State<AddStackInfoContainer> createState() => _AddStackInfoContainerState();
}

class _AddStackInfoContainerState extends State<AddStackInfoContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      height: widget.isSecret ? 170 : 270,
      decoration: BoxDecoration(
          border: Border.all(color: InstallerColor.borderColor),
          color: InstallerColor.whiteColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  widget.isSecret
                      ? AppLocalizations.of(context)!.secret
                      : AppLocalizations.of(context)!.clientDetails,
                  style: InstallerTextStyles.titleText
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Visibility(
                visible: (widget.isSecret
                    ? widget.secretTextEditingController.text != ""
                    : widget.clientIdTextEditingController.text != "" &&
                        widget.pathTextEditingController.text != ""),
                child: const Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Icon(Icons.check_circle, color: Colors.green)),
              ),
            ]),
            InstallerQrButton(onPressed: widget.onPressed)
          ],
        ),
        Container(
            width: double.infinity,
            color: InstallerColor.borderColor,
            height: 1),
        SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isSecret)
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 10, left: 15, right: 15),
                  child: InstallerTextField(
                      blackHintText: (widget.value != ""),
                      title: widget.value != ""
                          ? AppLocalizations.of(context)!.secret
                          : "",
                      hintText: widget.value != ""
                          ? widget.value
                          : AppLocalizations.of(context)!.secret,
                      textEditingController: widget.secretTextEditingController,
                      focus: widget.secretFocus,
                      readOnly: true,
                      isStackInfoField: true,
                      inputAction: TextInputAction.done,
                      includeSuffixIcon: false,
                      includeSearchIcon: false),
                ),
              if (!widget.isSecret)
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, bottom: 10, left: 15, right: 15),
                  child: InstallerTextField(
                      blackHintText: (widget.value != ""),
                      title: widget.value != "" ? "ID" : "",
                      hintText: widget.value != "" ? widget.value : "ID",
                      textEditingController:
                          widget.clientIdTextEditingController,
                      focus: widget.clientIdFocus,
                      readOnly: true,
                      isStackInfoField: true,
                      inputAction: TextInputAction.next,
                      includeSuffixIcon: false,
                      includeSearchIcon: false),
                ),
              if (!widget.isSecret)
                Padding(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 10, left: 15, right: 15),
                  child: InstallerTextField(
                      includeSuffixIcon: false,
                      blackHintText: (widget.path != ""),
                      title: widget.path != ""
                          ? AppLocalizations.of(context)!.pathTitle
                          : "",
                      hintText: widget.path != ""
                          ? widget.path
                          : AppLocalizations.of(context)!.pathTitle,
                      textEditingController: widget.pathTextEditingController,
                      focus: widget.pathFocus,
                      inputAction: TextInputAction.done,
                      readOnly: true,
                      isStackInfoField: true,
                      includeSearchIcon: false),
                ),
            ],
          ),
        ),
      ]),
    );
  }
}
