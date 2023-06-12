import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thingsee_installer/protocol/log_event.dart';
import 'package:thingsee_installer/protocol/log_file.dart';
import 'package:thingsee_installer/protocol/stack_identifier.dart';
import 'package:thingsee_installer/ui/common/installer_dialogs.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InstallerUserRepository extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
    encryptedSharedPreferences: true,
  ));
  List<StackIdentifier> _stackList = [];
  StackIdentifier? _activeStack;
  List<LogFile> _logfiles = [];
  List<LogEvent> _logEvents = [];
  Future<void> createLogEvent(LogEvent logEvent) async {
    final id = await getNewID("logEvents");
    _logEvents = (await getSavedLogEventsForId(logEvent.logId, true))!;
    final newLogEvent = LogEvent(
        id!,
        logEvent.logId,
        logEvent.event,
        logEvent.timeStamp,
        logEvent.deviceId,
        logEvent.deviceStatus,
        logEvent.note,
        logEvent.oldDeviceId,
        logEvent.groupId,
        logEvent.acceleroMeterMode,
        logEvent.peopleCountingOrientation,
        logEvent.hallMode,
        logEvent.mode,
        logEvent.newGroupId,
        logEvent.version,
        logEvent.measurementInterval);
    _logEvents.add(newLogEvent);

    await _storage.write(
        key: "logEvents", value: jsonEncode(_logEvents).toString());
  }

  Future<void> setLogFileRecordingValue(
      LogFile logFile, bool isRecording) async {
    await getSavedLogFiles().then((files) {
      files![files.indexWhere((element) => element.id == logFile.id)]
          .recording = isRecording;
      _storage.write(key: "logFiles", value: jsonEncode(files).toString());
    });
  }

  Future<void> updateLogFile(LogFile logFile, BuildContext context) async {
    await getSavedLogFiles().then((files) {
      files![files.indexWhere((element) => element.id == logFile.id)] = logFile;
      _storage.write(key: "logFiles", value: jsonEncode(files).toString());
      InstallerDialogs().showSnackBar(
          context: context,
          message: AppLocalizations.of(context)!.logFileUpdated);
    });
  }

  Future<List<LogEvent>?> getSavedLogEventsForId(int? logFileId,
      [bool returnAll = false]) async {
    String? events = await _storage.read(key: "logEvents");
    final logEvents = jsonDecode(events.toString());
    if (logEvents != null) {
      _logEvents =
          List<LogEvent>.from(logEvents.map((l) => LogEvent.fromJson(l)));
    } else {
      _logfiles = [];
    }
    return returnAll
        ? _logEvents
        : _logEvents.where((element) => element.logId == logFileId).toList();
  }

  Future<void> createLogFile(LogFile logFile) async {
    final id = await getNewID("logFiles");

    final newLogFile = LogFile(
        id,
        logFile.stack,
        logFile.title,
        logFile.description,
        logFile.timeStamp,
        logFile.recording,
        logFile.groupId,
        logFile.includedEvents);
    _logfiles.add(newLogFile);

    await _storage.write(
        key: "logFiles", value: jsonEncode(_logfiles).toString());
    _logfiles.clear();
  }

  Future<void> deleteLog(LogFile logFile) async {
    final logs = await getSavedLogFiles();
    _logfiles = logs!;
    _logfiles.removeWhere((element) =>
        element.id == logFile.id && element.title == element.title);
    await _storage.write(
        key: "logFiles", value: jsonEncode(_logfiles).toString());
    _logfiles.clear();
  }

  Future<void> deleteEventsInLogFile(LogFile logFile) async {
    final events = await getSavedLogEventsForId(null, true);
    _logEvents = events!;
    _logEvents.removeWhere((element) => element.logId == logFile.id);
    await _storage.write(
        key: "logEvents", value: jsonEncode(_logEvents).toString());
    _logEvents.clear();
  }

  Future<void> deleteLogEvent(LogEvent logEvent) async {
    final events = await getSavedLogEventsForId(null, true);
    _logEvents = events!;
    _logEvents.removeWhere((element) => element.id == logEvent.id);
    await _storage.write(
        key: "logEvents", value: jsonEncode(_logEvents).toString());
    _logEvents.clear();
  }

  Future<void> deleteLogs() async {
    _logfiles.clear();
    await _storage.delete(key: "logFiles");
  }

  Future<List<LogFile>?> getSavedLogFiles() async {
    String? logsString = await _storage.read(key: "logFiles");
    StackIdentifier? activeStack = await getActiveStack();
    final logfiles = jsonDecode(logsString.toString());
    if (logfiles != null) {
      _logfiles = List<LogFile>.from(logfiles.map((l) => LogFile.fromJson(l)));
    } else {
      _logfiles = [];
    }

    _logfiles = _logfiles
        .where((element) =>
            element.stack.id == activeStack!.id &&
            element.stack.name == activeStack.name)
        .toList();

    return _logfiles;
  }

  Future<LogFile> getCurrentLogFile(int logId) async {
    String? savedLogs = await _storage.read(key: "logFiles");
    final logfiles = jsonDecode(savedLogs.toString());
    if (logfiles != null) {
      _logfiles = List<LogFile>.from(logfiles.map((l) => LogFile.fromJson(l)));
    } else {
      _logfiles = [];
    }
    return _logfiles.firstWhere((element) => element.id == logId);
  }

  Future<void> saveStack(StackIdentifier stack) async {
    final id = await getNewID("stackList");
    final stackToAdd = StackIdentifier(
        id, stack.name, stack.clientId, stack.apiURL, stack.secret);
    _stackList.add(stackToAdd);

    await _storage.write(
        key: "stackList", value: jsonEncode(_stackList).toString());
    _stackList.clear();
  }

  Future<void> setActiveStack(StackIdentifier? stack) async {
    _activeStack = stack;
    await _storage.write(key: "active_stack", value: json.encode(_activeStack));
  }

  Future<StackIdentifier?> getActiveStack() async {
    final activeStack = await _storage.read(key: "active_stack");
    if (activeStack != null) {
      _activeStack = StackIdentifier.fromJson(jsonDecode(activeStack));
    }

    return _activeStack;
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: "active_token", value: json.encode(token));
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: "active_token");
    return (json.decode(token.toString()));
  }

  Future<void> setFirstTimeUsage() async {
    await _storage.write(key: "first_time_use", value: jsonEncode(true));
  }

  Future<bool> isFirstTimeUse() async {
    var firstTime = await _storage.read(key: "first_time_use");
    firstTime ??= jsonEncode(false);
    return jsonDecode(firstTime.toString());
  }

  Future<void> deleteStack(StackIdentifier stack) async {
    final stacks = await getSavedStacks();
    _stackList = stacks!;
    _stackList.removeWhere((element) =>
        element.clientId == stack.clientId && element.id == stack.id);
    await _storage.write(
        key: "stackList", value: jsonEncode(_stackList).toString());
    _stackList.clear();
  }

  Future<List<StackIdentifier>?> getSavedStacks() async {
    String? stacksString = await _storage.read(key: "stackList");
    final stacks = jsonDecode(stacksString.toString());
    if (stacks != null) {
      _stackList = List<StackIdentifier>.from(
          stacks.map((s) => StackIdentifier.fromJson(s)));
    } else {
      _stackList = [];
    }

    return _stackList;
  }

  Future<int?> getNewID(String key) async {
    int newId;
    List<Object> objectList = [];
    String? fileString = await _storage.read(key: key);
    final object = jsonDecode(fileString.toString());
    if (object != null) {
      if (key == "stackList") {
        objectList = List<StackIdentifier>.from(
            object.map((s) => StackIdentifier.fromJson(s)));
      } else if (key == "logFiles") {
        objectList = List<LogFile>.from(object.map((s) => LogFile.fromJson(s)));
      } else if (key == "logEvents") {
        objectList =
            List<LogEvent>.from(object.map((s) => LogEvent.fromJson(s)));
      }

      newId = objectList.length;
    } else {
      return 0;
    }

    if (objectList is List<LogFile>) {
      while (objectList.any((item) => item.id == newId)) {
        newId = newId + 1;
      }
    } else if (objectList is List<StackIdentifier>) {
      while (objectList.any((item) => item.id == newId)) {
        newId = newId + 1;
      }
    } else if (objectList is List<LogEvent>) {
      while (objectList.any((item) => item.id == newId)) {
        newId = newId + 1;
      }
    }

    return newId;
  }

  Future<void> deleteAll() async {
    _stackList.clear();
    await _storage.deleteAll();
  }
}
