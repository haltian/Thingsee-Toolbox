import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:thingsee_installer/installer_error_model.dart';
import 'package:thingsee_installer/ui/common/installer_dialogs.dart';

class InstallerErrorManager extends StatelessWidget {
  final ValueNotifier<InstallerErrorModel?> errorNotifier;
  final Widget child;
  final GlobalKey<NavigatorState> navigatorState;

  const InstallerErrorManager(
      {Key? key,
      required this.errorNotifier,
      required this.child,
      required this.navigatorState})
      : super(key: key);

  void _handleError(InstallerErrorModel errorModel, BuildContext context) {
    switch (errorModel.errorMessage!.statusCode) {
      case null:
        if (errorModel.type == ErrorType.platFormError) {
          InstallerDialogs().showInfoDialog(
              shouldPop: false,
              context: context,
              title: AppLocalizations.of(context)!.errorOccured,
              message: AppLocalizations.of(context)!.deviceNotFound,
              buttonText: AppLocalizations.of(context)!.ok);
        } else {
          InstallerDialogs().showInfoDialog(
              shouldPop: errorModel.origin != ErrorOrigin.testStack &&
                      errorModel.origin != ErrorOrigin.deviceGroup
                  ? true
                  : false,
              context: context,
              title: AppLocalizations.of(context)!.errorOccured,
              message: kDebugMode
                  ? errorModel.errorMessage!.message.toString()
                  : AppLocalizations.of(context)!.somethingWentWrong,
              buttonText: AppLocalizations.of(context)!.ok);
        }

        break;
      case InstallerErrorModel.forbidden:
      case InstallerErrorModel.unauthrorized:
      case InstallerErrorModel.badRequest:
      case InstallerErrorModel.notFound:
      case InstallerErrorModel.cannotReadProperty:
      case InstallerErrorModel.conflict:
      case InstallerErrorModel.timing:
        // If we don't find device, show specific dialog
        errorModel.errorMessage!.error == "Not Found"
            ? InstallerDialogs().showInfoDialog(
                shouldPop: true,
                context: context,
                title: AppLocalizations.of(context)!.errorOccured,
                message: AppLocalizations.of(context)!.deviceNotFound,
                buttonText: AppLocalizations.of(context)!.ok)
            : InstallerDialogs().showInfoDialog(
                shouldPop: errorModel.origin != ErrorOrigin.testStack &&
                        errorModel.origin != ErrorOrigin.deviceGroup &&
                        errorModel.origin != ErrorOrigin.installationStatus
                    ? true
                    : false,
                context: context,
                title: AppLocalizations.of(context)!.errorOccured,
                message: kDebugMode
                    ? errorModel.errorMessage!.message.toString()
                    : AppLocalizations.of(context)!.somethingWentWrong,
                buttonText: AppLocalizations.of(context)!.ok);
        break;
      default:
        InstallerDialogs().showInfoDialog(
            shouldPop: errorModel.origin != ErrorOrigin.testStack &&
                    errorModel.origin != ErrorOrigin.deviceGroup
                ? true
                : false,
            context: context,
            title: AppLocalizations.of(context)!.error +
                errorModel.errorMessage!.statusCode.toString(),
            message: AppLocalizations.of(context)!.error +
                errorModel.errorMessage!.error.toString(),
            buttonText: AppLocalizations.of(context)!.ok);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<InstallerErrorModel?>(
        valueListenable: errorNotifier,
        builder: (context, error, _) {
          final errorModel = error;
          final currentStateContext = navigatorState.currentState?.context;
          if (errorModel != null && currentStateContext != null) {
            _handleError(errorModel, currentStateContext);

            errorNotifier.value = null;
          }
          return child;
        });
  }
}
