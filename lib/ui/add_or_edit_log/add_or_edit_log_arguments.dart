import 'package:thingsee_installer/protocol/log_file.dart';

class AddOrEditLogViewArguments {
  final LogFile? logFile;
  final bool editingLogFile;

  AddOrEditLogViewArguments(this.logFile, this.editingLogFile);
}
