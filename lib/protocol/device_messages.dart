import 'package:json_annotation/json_annotation.dart';
part 'device_messages.g.dart';

@JsonSerializable()
class DeviceMessages {
  final int tsmId;
  final int tsmTs;
  final String deploymentGroupId;
  final int? tsmEv;
  final num? dist;
  final int? batl;
  final num? count;
  final num? moveCount;
  final num? airp;
  final num? humd;
  final num? lght;
  final num? temp;
  final num? resistance;
  final num? state;
  final num? angle;
  final num? hall;
  final num? tvoc;
  final num? cellLac;
  final num? cellRssi;
  final String? cellRat;
  final String? mcc_mnc;
  final String? operatorName;
  final num? activityLevel;
  final num? totalIn;
  final num? totalOut;
  final num? accx;
  final num? accy;
  final num? accz;
  final num? carbonDioxide;
  final num? hallCount;
  final num? energyLevel;
  final num? usbState;
  final num? rssi;
  final num? cellRsrp;

  @JsonKey(name: 'in')
  final int? countIn;
  final int? out;
  final num? amountIn;
  DeviceMessages(
    this.tsmId,
    this.tsmTs,
    this.deploymentGroupId,
    this.tsmEv,
    this.dist,
    this.batl,
    this.count,
    this.moveCount,
    this.airp,
    this.humd,
    this.lght,
    this.temp,
    this.resistance,
    this.state,
    this.angle,
    this.hall,
    this.tvoc,
    this.cellLac,
    this.cellRssi,
    this.mcc_mnc,
    this.operatorName,
    this.activityLevel,
    this.totalIn,
    this.totalOut,
    this.accx,
    this.accy,
    this.accz,
    this.carbonDioxide,
    this.hallCount,
    this.energyLevel,
    this.cellRat,
    this.usbState,
    this.rssi,
    this.cellRsrp,
    this.out,
    this.countIn,
    this.amountIn,
  );

  factory DeviceMessages.fromJson(Map<String, dynamic> json) =>
      _$DeviceMessagesFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceMessagesToJson(this);
}
