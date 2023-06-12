import '../../protocol/group.dart';
import '../../protocol/stack_identifier.dart';

class AddOrEditGroupViewArguments {
  final StackIdentifier stack;
  final Group? group;
  final bool editingGroup;

  AddOrEditGroupViewArguments(this.stack, this.group, this.editingGroup);
}
