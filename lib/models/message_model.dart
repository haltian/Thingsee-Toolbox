import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thingsee_installer/protocol/device_messages.dart';

class MessageModel {
  static String getMessage(
      int tsmId, BuildContext context, DeviceMessages messages) {
    if (tsmId >= 1000 && tsmId < 2000) {
      return commonProfile(tsmId, context, messages);
    } else if (tsmId >= 12000 && tsmId < 13000) {
      return enviromentProfile(tsmId, context, messages);
    } else if (tsmId >= 11000 && tsmId < 12000) {
      return gatewayProfile(tsmId, context);
    } else if (tsmId >= 3000 && tsmId < 4000) {
      return edgeProfile(tsmId, context);
    } else if (tsmId >= 2000 && tsmId < 2999) {
      return commonAnalyticsProfile(tsmId, context, messages);
    } else if (tsmId >= 18000 && tsmId < 19000) {
      return angleProfile(tsmId, context, messages);
    } else if (tsmId >= 13000 && tsmId < 13999) {
      return presenceProfile(tsmId, context, messages);
    } else if (tsmId >= 16000 && tsmId < 17000) {
      return machineUsageProfile(tsmId, context, messages);
    } else if (tsmId >= 17000 && tsmId <= 17999) {
      return distanceProfile(tsmId, context, messages);
    } else if (tsmId >= 24000 && tsmId <= 24999) {
      return airQualityProfile(tsmId, context, messages);
    } else if (tsmId >= 25000) {
      return miscMessages(tsmId, context, messages);
    } else {
      return tsmId.toString();
    }
  }
}

String machineUsageProfile(
    int tsmId, BuildContext context, DeviceMessages messages) {
  if (tsmId == 16100) {
    return AppLocalizations.of(context)!
        .vibration(messages.activityLevel, messages.energyLevel);
  } else if (tsmId == 16200) {
    return AppLocalizations.of(context)!.accConfig;
  } else {
    return tsmId.toString();
  }
}

String airQualityProfile(
    int tsmId, BuildContext context, DeviceMessages messages) {
  if (tsmId == 24100) {
    return AppLocalizations.of(context)!.carbonInfo(messages.carbonDioxide);
  } else if (tsmId == 24101) {
    return AppLocalizations.of(context)!.tvocInfo(messages.tvoc);
  } else if (tsmId == 24200) {
    return AppLocalizations.of(context)!.carbonConfig;
  } else if (tsmId == 24201) {
    return AppLocalizations.of(context)!.carbonManual;
  } else if (tsmId == 24202) {
    return AppLocalizations.of(context)!.tvocConfig;
  } else if (tsmId == 24500) {
    return AppLocalizations.of(context)!.carbonHardware;
  } else if (tsmId == 24501) {
    return AppLocalizations.of(context)!.tvocReset;
  }
  return tsmId.toString();
}

String commonProfile(int tsmId, BuildContext context, DeviceMessages messages) {
  if (tsmId == 1000) {
    if (messages.tsmEv == 18) {
      return AppLocalizations.of(context)!.networkDisconnected;
    } else if (messages.tsmEv == 17) {
      return AppLocalizations.of(context)!.networkConnected;
    }
  }
  if (tsmId == 1100) {
    return AppLocalizations.of(context)!.systemInfo;
  } else if (tsmId == 1101) {
    return AppLocalizations.of(context)!.infoRequest;
  } else if (tsmId == 1102) {
    return AppLocalizations.of(context)!.infoRequestUnv;
  } else if (tsmId == 1110) {
    return AppLocalizations.of(context)!.batl(messages.batl);
  } else if (tsmId == 1111) {
    return AppLocalizations.of(context)!
        .orientationMsg(messages.accx, messages.accy, messages.accz);
  } else if (tsmId == 1212) {
    String celluralInfo = "";
    if (messages.mcc_mnc != null) {
      celluralInfo +=
          AppLocalizations.of(context)!.cellularInfoMccMnc(messages.mcc_mnc);
    }
    if (messages.operatorName != null) {
      celluralInfo += AppLocalizations.of(context)!
          .cellularInfoOperator(messages.operatorName?.split(' ').first);
    }
    return celluralInfo;
  } else if (tsmId == 1211) {
    String message1211 = "";
    if (messages.cellRssi != null) {
      message1211 +=
          AppLocalizations.of(context)!.celluralRfDataRssi(messages.cellRssi);
    }
    if (messages.cellRat != null) {
      message1211 +=
          AppLocalizations.of(context)!.celluralRfDataRat(messages.cellRat);
    }
    if (messages.cellRsrp != null) {
      message1211 +=
          AppLocalizations.of(context)!.celluralRfDataRsrp(messages.cellRsrp);
    }

    return message1211;
  } else if (tsmId == 1600) {
    return AppLocalizations.of(context)!.ping;
  } else if (tsmId == 1202) {
    return AppLocalizations.of(context)!.neighbouringData(messages.rssi);
  } else if (tsmId == 1201 || tsmId == 1220) {
    return AppLocalizations.of(context)!.wirepassNode;
  } else {
    return AppLocalizations.of(context)!.systemMessage(tsmId);
  }
}

String enviromentProfile(
    int tsmId, BuildContext context, DeviceMessages messages) {
  if (tsmId == 12100) {
    String weatherInfo = "";
    if (messages.airp != null) {
      num? airp = (messages.airp! / 100);
      weatherInfo += AppLocalizations.of(context)!
          .weatherInfoAirp(airp.toStringAsFixed(2));
    }
    if (messages.humd != null) {
      weatherInfo +=
          AppLocalizations.of(context)!.weatherInfoHumd(messages.humd);
    }
    if (messages.lght != null) {
      weatherInfo +=
          AppLocalizations.of(context)!.weatherInfoLght(messages.lght);
    }
    if (messages.temp != null) {
      weatherInfo +=
          AppLocalizations.of(context)!.weatherInfoTemp(messages.temp);
    }
    return weatherInfo;
  } else if (tsmId == 12101) {
    return AppLocalizations.of(context)!
        .magnetoInfo(messages.hall, messages.hallCount);
  } else if (tsmId == 12102) {
    return AppLocalizations.of(context)!.leakageResistance(messages.resistance);
  } else if (tsmId >= 12200 && tsmId < 12300) {
    return AppLocalizations.of(context)!.sensorConfig(tsmId);
  } else {
    return tsmId.toString();
  }
}

String presenceProfile(
    int tsmId, BuildContext context, DeviceMessages messages) {
  if (tsmId == 13100) {
    return AppLocalizations.of(context)!.moveCount(messages.moveCount);
  } else if (tsmId == 13102) {
    return AppLocalizations.of(context)!.count(messages.count);
  } else if (tsmId == 13103) {
    String countmsg = "";
    countmsg += AppLocalizations.of(context)!
        .countInOut(messages.countIn, messages.out);
    if (messages.amountIn != null) {
      countmsg += ", ";
      countmsg += AppLocalizations.of(context)!.amountIn(messages.amountIn);
    }
    return countmsg;
  } else if (tsmId >= 13200 && tsmId < 13300) {
    return AppLocalizations.of(context)!.sensorConfig(tsmId);
  } else {
    return tsmId.toString();
  }
}

String gatewayProfile(int tsmId, BuildContext context) {
  if (tsmId == 11200) {
    return AppLocalizations.of(context)!.heartbeat;
  } else {
    return AppLocalizations.of(context)!.gatewayMessage(tsmId.toString());
  }
}

String edgeProfile(int tsmId, BuildContext context) {
  if (tsmId == 3100) {
    return AppLocalizations.of(context)!.edgeCoreChange;
  } else if (tsmId == 3300) {
    return AppLocalizations.of(context)!.edgeCoreStats;
  } else if (tsmId == 3400) {
    return AppLocalizations.of(context)!.edgeCoreBinary;
  } else {
    return tsmId.toString();
  }
}

String commonAnalyticsProfile(
    int tsmId, BuildContext context, DeviceMessages messages) {
  if (tsmId == 2100) {
    return AppLocalizations.of(context)!.occupancyMode(messages.state);
  } else if (tsmId == 2101) {
    return AppLocalizations.of(context)!.jamDetection;
  } else {
    return tsmId.toString();
  }
}

String angleProfile(int tsmId, BuildContext context, DeviceMessages messages) {
  if (tsmId == 18100) {
    return AppLocalizations.of(context)!.angle(messages.angle);
  } else if (tsmId == 18101) {
    return AppLocalizations.of(context)!.temperature(messages.temp);
  } else if (tsmId == 18200) {
    return AppLocalizations.of(context)!.ledControl;
  } else {
    return tsmId.toString();
  }
}

String distanceProfile(
    int tsmId, BuildContext context, DeviceMessages messages) {
  if (tsmId == 17100 || tsmId == 17200) {
    return AppLocalizations.of(context)!.distance(messages.dist);
  } else if (tsmId == 17110) {
    return AppLocalizations.of(context)!.sensorConfig(tsmId);
  } else if (tsmId == 17201) {
    return AppLocalizations.of(context)!.beam2d;
  } else if (tsmId == 17210) {
    return AppLocalizations.of(context)!.temperature(messages.temp);
  } else if (tsmId == 17220) {
    return AppLocalizations.of(context)!.sensorConfig(tsmId);
  } else {
    return tsmId.toString();
  }
}

String miscMessages(int tsmId, BuildContext context, DeviceMessages messages) {
  if (tsmId == 25100) {
    if (messages.usbState == 1) {
      return AppLocalizations.of(context)!
          .powerCoverMessage(AppLocalizations.of(context)!.yes);
    } else {
      return AppLocalizations.of(context)!
          .powerCoverMessage(AppLocalizations.of(context)!.no);
    }
  } else {
    return tsmId.toString();
  }
}
