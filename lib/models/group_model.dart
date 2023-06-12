import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:iso_countries/country.dart';

class GroupModel {
  String formatGroupName(
      {required String? environment,
      required Country? country,
      required String? name}) {
    String env = environment!.substring(0, 2);
    String countryCode = country!.countryCode.toLowerCase();
    String name0 = name!.toLowerCase();
    String fullName = "$env${countryCode}00$name0";

    return fullName;
  }

  List<String> environments(BuildContext context) {
    return [
      AppLocalizations.of(context)!.envProduction,
      AppLocalizations.of(context)!.envDevelopment,
    ];
  }

  String getEnvironmentPrefix(String groupId) {
    return groupId.substring(0, 2);
  }

  String getCountryCode(String groupId) {
    return groupId.substring(2, 4);
  }

  String getName(String groupId) {
    String name = "";
    if (groupId.contains("00")) {
      name = groupId.substring(6);
    } else {
      name = groupId;
    }
    return name;
  }
}
