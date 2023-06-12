import 'package:thingsee_installer/protocol/stack_identifier.dart';

import '../../protocol/group.dart';

class DeviceInfoArguments {
  final String deviceID;
  final int limit;
  final StackIdentifier stack;
  final Group? group;
  const DeviceInfoArguments(this.deviceID, this.limit, this.stack, this.group);
}
