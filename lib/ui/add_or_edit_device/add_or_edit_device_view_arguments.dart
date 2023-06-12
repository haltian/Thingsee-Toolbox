import '../../protocol/group.dart';
import '../../protocol/stack_identifier.dart';

enum PageAction { addDevice, editDevice, replaceDevice }

class AddOrEditDeviceViewArguments {
  final StackIdentifier stack;
  final String? deviceId;
  final Group? group;
  final PageAction pageAction;
  final int? operatingMode;

  AddOrEditDeviceViewArguments(this.stack, this.deviceId, this.group,
      this.pageAction, this.operatingMode);
}
