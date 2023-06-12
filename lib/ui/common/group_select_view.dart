import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thingsee_installer/constants/installer_constants.dart';
import 'package:thingsee_installer/protocol/group.dart';

import '../../constants/installer_colors.dart';
import '../../constants/installer_text_styles.dart';
import '../common/installer_text_field.dart';

class GroupSelectViewArguments {
  final List<Group> groups;
  final ValueNotifier<String?> groupIdNotifier;

  GroupSelectViewArguments(this.groups, this.groupIdNotifier);
}

class GroupSelectView extends StatefulWidget {
  final GroupSelectViewArguments arguments;
  const GroupSelectView({Key? key, required this.arguments}) : super(key: key);

  @override
  State<GroupSelectView> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<GroupSelectView> {
  final TextEditingController _countryTextEditingController =
      TextEditingController();
  final FocusNode _countryfocus = FocusNode();
  String? _country;

  @override
  void initState() {
    _countryTextEditingController.addListener(_countrySearchTextChanged);

    super.initState();
  }

  void _countrySearchTextChanged() {
    if (_countryTextEditingController.text != _country) {
      setState(() {
        _country = _countryTextEditingController.text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = widget.arguments.groups
        .where((element) =>
            element.group_id != InstallerConstants.unassigned &&
            element.group_id
                .toLowerCase()
                .contains(_countryTextEditingController.text.toLowerCase()))
        .toList();
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      child: Material(
        child: SizedBox(
          height: 450,
          child: Column(
            children: [
              Container(
                height: 120,
                color: InstallerColor.blueColor,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 13.0, right: 130),
                            child: Text(
                              AppLocalizations.of(context)!.selectGroup,
                              style: InstallerTextStyles.bottomSheetTitle,
                            ),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(right: 8, top: 10),
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ))
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(12),
                      child: InstallerTextField(
                          includeSearchIcon: false,
                          hintText: AppLocalizations.of(context)!.search,
                          textEditingController: _countryTextEditingController,
                          focus: _countryfocus),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: filteredList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        onTap: () {
                          setState(() {
                            widget.arguments.groupIdNotifier.value =
                                filteredList[index].group_id;
                            Navigator.pop(context);
                          });
                        },
                        leading: Icon(Icons.check,
                            color: widget.arguments.groupIdNotifier.value !=
                                        null &&
                                    widget.arguments.groupIdNotifier.value! ==
                                        filteredList[index].group_id
                                ? Colors.blue
                                : Colors.transparent),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              filteredList[index].group_id,
                              style: InstallerTextStyles.dropDownText,
                            ),
                            Text(
                              filteredList[index].group_description!,
                              style: InstallerTextStyles.timeStampText,
                            ),
                          ],
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
