import 'package:thingsee_installer/protocol/group.dart';
import 'package:thingsee_installer/protocol/stack_identifier.dart';

class DeviceListViewArguments {
  final Group group;
  final StackIdentifier stack;
  const DeviceListViewArguments(this.group, this.stack);
}
