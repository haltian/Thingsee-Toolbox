import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/models/installation_model.dart';
import 'package:thingsee_installer/protocol/log_event.dart';
import 'package:thingsee_installer/protocol/log_file.dart';

class InstallerLogEventManager {
  void createLogEvents(
      {required IncudedEvent triggerEvent,
      required String deviceId,
      required String? deviceStatus,
      required String logFileGroupId,
      required String? note,
      required String? oldDeviceId,
      required int? accelerometerMode,
      required int? peopleCountingOrientation,
      required int? hallMode,
      required int? mode,
      required String? newGroupId,
      required String? version,
      required int? measurementInterval}) async {
    await logFilesToCreate(logFileGroupId, triggerEvent).then((files) {
      for (final logfile in files) {
        InstallerUserRepository().createLogEvent(LogEvent(
            null,
            logfile.id!,
            triggerEvent,
            DateTime.now(),
            deviceId,
            deviceStatus,
            note,
            oldDeviceId,
            newGroupId,
            accelerometerMode,
            peopleCountingOrientation,
            hallMode,
            mode,
            newGroupId,
            version,
            measurementInterval));
      }
    });
  }

  Future<List<LogFile>> logFilesToCreate(
      String groupId, IncudedEvent triggerEvent) async {
    List<LogFile> filesToCreate = [];
    List<LogFile>? savedLogFiles =
        await InstallerUserRepository().getSavedLogFiles();

    if (savedLogFiles != null) {
      for (final log in savedLogFiles) {
        if (log.recording && log.groupId == groupId) {
          for (final event in log.includedEvents) {
            if (event == triggerEvent) {
              filesToCreate.add(log);
            }
          }
        }
      }
    }

    return filesToCreate;
  }
}
