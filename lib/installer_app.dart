import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:thingsee_installer/constants/installer_routes.dart';
import 'package:thingsee_installer/installer_error_manager.dart';
import 'package:thingsee_installer/installer_error_model.dart';
import 'package:thingsee_installer/logic/create_group/cubit/create_group_cubit.dart';
import 'package:thingsee_installer/logic/create_group_backend.dart';
import 'package:thingsee_installer/logic/delete_group/cubit/delete_group_cubit.dart';
import 'package:thingsee_installer/logic/delete_group_backend.dart';
import 'package:thingsee_installer/logic/edit_group/edit_group.dart';
import 'package:thingsee_installer/logic/edit_group_backend.dart';
import 'package:thingsee_installer/logic/fetch_device_info/fetch_device_info.dart';
import 'package:thingsee_installer/logic/fetch_device_info_backend.dart';
import 'package:thingsee_installer/logic/fetch_device_list/cubit/fetch_device_list_cubit.dart';
import 'package:thingsee_installer/logic/fetch_device_list_backend.dart';
import 'package:thingsee_installer/logic/fetch_device_messages/cubit/fetch_device_messages_cubit.dart';
import 'package:thingsee_installer/logic/fetch_device_messages_backend.dart';
import 'package:thingsee_installer/logic/fetch_group/cubit/fetch_group_cubit.dart';
import 'package:thingsee_installer/logic/fetch_group_backend.dart';
import 'package:thingsee_installer/logic/fetch_group_list/cubit/fetch_group_list_cubit.dart';
import 'package:thingsee_installer/logic/fetch_group_list_backend.dart';
import 'package:thingsee_installer/logic/fetch_installation_status/cubit/fetch_installation_status_cubit.dart';
import 'package:thingsee_installer/logic/fetch_installation_status_backend.dart';
import 'package:thingsee_installer/logic/installer_user_repository.dart';
import 'package:thingsee_installer/logic/send_command_backend.dart';
import 'package:thingsee_installer/logic/set_device_group_backend.dart';
import 'package:thingsee_installer/logic/set_installation_status/set_installation_status.dart';
import 'package:thingsee_installer/logic/set_installation_status_backend.dart';
import 'package:thingsee_installer/logic/test_stack/cubit/test_stack_cubit.dart';
import 'package:thingsee_installer/logic/test_stack_backend.dart';
import 'package:thingsee_installer/models/dim_ui_model.dart';
import 'package:thingsee_installer/models/installation_model.dart';
import 'package:thingsee_installer/protocol/log_file.dart';
import 'package:thingsee_installer/protocol/stack_identifier.dart';
import 'package:thingsee_installer/ui/about/about_view.dart';
import 'package:thingsee_installer/ui/about/licenses.dart';
import 'package:thingsee_installer/ui/add_or_edit_device/add_or_edit_device_view.dart';
import 'package:thingsee_installer/ui/add_or_edit_device/add_or_edit_device_view_arguments.dart';
import 'package:thingsee_installer/ui/add_or_edit_group/add_or_edit_group_view.dart';
import 'package:thingsee_installer/ui/add_or_edit_group/add_or_edit_group_view_arguments.dart';
import 'package:thingsee_installer/ui/add_or_edit_group/country_select_view.dart';
import 'package:thingsee_installer/ui/add_or_edit_log/add_or_edit_log_arguments.dart';
import 'package:thingsee_installer/ui/add_or_edit_log/add_or_edit_log_view.dart';
import 'package:thingsee_installer/ui/add_stack/add_stack_view.dart';
import 'package:thingsee_installer/ui/common/group_select_view.dart';
import 'package:thingsee_installer/ui/common/qr_view.dart';
import 'package:thingsee_installer/ui/device_info/device_info_view.dart';
import 'package:thingsee_installer/ui/device_info/device_info_view_arguments.dart';
import 'package:thingsee_installer/ui/device_list/device_list_view.dart';
import 'package:thingsee_installer/ui/device_list/device_list_view_arguments.dart';
import 'package:thingsee_installer/ui/group_list/group_list_view.dart';
import 'package:thingsee_installer/ui/layout.dart';
import 'package:thingsee_installer/ui/log_events/log_events_view.dart';
import 'package:thingsee_installer/ui/log_list/log_list_view.dart';
import 'package:thingsee_installer/ui/search_device/search_device_view.dart';
import 'package:thingsee_installer/ui/splash/splash_screen.dart';
import 'package:thingsee_installer/ui/stack_list/stack_list_view.dart';
import 'constants/installer_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;

import 'logic/commands/cubit/commands_cubit.dart';

class InstallerApp extends StatelessWidget {
  final httpClient = http.Client();
  final InstallerUserRepository userRepository;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  final ValueNotifier<InstallerErrorModel?> errorNotifier =
      ValueNotifier<InstallerErrorModel?>(null);
  final ValueNotifier<bool?> bottomNavigationVisible =
      ValueNotifier<bool?>(false);
  final int _transitionDurationMs = 1;

  InstallerApp({Key? key, required this.userRepository}) : super(key: key);

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case InstallerRoutes.splashScreenViewRoute:
        return _generateSplashScreenRoute(settings);
      case InstallerRoutes.addStackViewRoute:
        return _generateAddStackViewRoute(settings);
      case InstallerRoutes.stackListViewRoute:
        return _generateStackListViewRoute(settings);
      case InstallerRoutes.groupListViewRoute:
        return _generateGroupListViewRoute(settings);
      case InstallerRoutes.deviceListViewRoute:
        return _generateDeviceListViewRoute(settings);
      case InstallerRoutes.addOrEditGroupViewRoute:
        return _generateAddOrEditGroupViewRoute(settings);
      case InstallerRoutes.countrySelectView:
        return _generateCountrySelectViewRoute(settings);
      case InstallerRoutes.deviceInfoRoute:
        return _generateDeviceInfoRoute(settings);
      case InstallerRoutes.addOrEditDeviceViewRoute:
        return _generateAddOrEditDeviceViewRoute(settings);
      case InstallerRoutes.searchDeviceViewRoute:
        return _generateSearchDeviceViewRoute(settings);
      case InstallerRoutes.logListViewRoute:
        return _generateLogListViewRoute(settings);
      case InstallerRoutes.aboutViewRoute:
        return _generateAboutViewRoute(settings);
      case InstallerRoutes.addOrEditLogViewRoute:
        return _generateAddOrEditLogViewRoute(settings);
      case InstallerRoutes.logDetailsViewRoute:
        return _generateLogDetailsViewRoute(settings);
      case InstallerRoutes.licensesRoute:
        return _generateLicensesRoute(settings);
      case InstallerRoutes.qrViewRoute:
        return _generateQrCodeViewRoute(settings);
      case InstallerRoutes.groupSelectView:
        return _generateGroupSelectViewRoute(settings);
    }
    return null;
  }

  Route<dynamic> _generateSplashScreenRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: ((context) => const SplashScreen()));
  }

  Route<dynamic> _generateLicensesRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: ((context) => customLicenses()));
  }

  Route<dynamic> _generateQrCodeViewRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: ((context) => QrView(
              qrResult: settings.arguments as ValueNotifier<String?>,
            )));
  }

  Route<dynamic> _generateAddOrEditLogViewRoute(RouteSettings settings) {
    return ModalSheetRoute(
      enableDrag: false,
      isDismissible: false,
      expanded: true,
      builder: ((context) => AddOrEditLogView(
            userRepository: userRepository,
            arguments: settings.arguments as AddOrEditLogViewArguments,
          )),
    );
  }

  Route<dynamic> _generateLogDetailsViewRoute(RouteSettings settings) {
    return Platform.isIOS
        ? PageTransition(
            reverseDuration: Duration(milliseconds: _transitionDurationMs),
            child: LogEventsView(
              bottomNavigationVisible: bottomNavigationVisible,
              userRepository: userRepository,
              logFile: settings.arguments as LogFile,
            ),
            type: PageTransitionType.rightToLeft,
            isIos: true)
        : MaterialPageRoute(
            builder: ((context) => LogEventsView(
                  bottomNavigationVisible: bottomNavigationVisible,
                  userRepository: userRepository,
                  logFile: settings.arguments as LogFile,
                )));
  }

  Route<dynamic> _generateSearchDeviceViewRoute(RouteSettings settings) {
    return PageTransition(
        duration: Duration(milliseconds: _transitionDurationMs),
        reverseDuration: Duration(milliseconds: _transitionDurationMs),
        child: BlocProvider<FetchGroupCubit>(
          create: (context) => FetchGroupCubit(TestStackBackend(httpClient),
              errorNotifier, FetchGroupBackend(httpClient)),
          child: SearchDeviceView(
            userRepository: userRepository,
            bottomNavigationVisible: bottomNavigationVisible,
          ),
        ),
        type: PageTransitionType.fade);
  }

  Route<dynamic> _generateLogListViewRoute(RouteSettings settings) {
    return PageTransition(
        duration: Duration(milliseconds: _transitionDurationMs),
        reverseDuration: Duration(milliseconds: _transitionDurationMs),
        child: LogListView(
          bottomNavigationVisible: bottomNavigationVisible,
          userRepository: userRepository,
        ),
        type: PageTransitionType.fade);
  }

  Route<dynamic> _generateAboutViewRoute(RouteSettings settings) {
    return PageTransition(
        duration: Duration(milliseconds: _transitionDurationMs),
        reverseDuration: Duration(milliseconds: _transitionDurationMs),
        child: AboutView(bottomNavigationVisible: bottomNavigationVisible),
        type: PageTransitionType.fade);
  }

  Route<dynamic> _generateAddOrEditDeviceViewRoute(RouteSettings settings) {
    return ModalSheetRoute(
        enableDrag: false,
        isDismissible: false,
        expanded: true,
        builder: ((context) => MultiBlocProvider(
              providers: [
                BlocProvider<SetInstallationStatusCubit>(
                  create: (context) => SetInstallationStatusCubit(
                      TestStackBackend(httpClient),
                      SetInstallationStatusBackend(httpClient),
                      SetDeviceGroupBackend(httpClient),
                      errorNotifier),
                ),
                BlocProvider<FetchDeviceInfoCubit>(
                  create: (context) => FetchDeviceInfoCubit(
                      TestStackBackend(httpClient),
                      FetchDeviceInfoBackend(httpClient),
                      errorNotifier),
                ),
              ],
              child: AddOrEditDeviceView(
                  arguments:
                      settings.arguments as AddOrEditDeviceViewArguments),
            )));
  }

  Route<dynamic> _generateDeviceInfoRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: ((context) => MultiBlocProvider(
              providers: [
                BlocProvider<FetchDeviceInfoCubit>(
                  create: (context) => FetchDeviceInfoCubit(
                      TestStackBackend(httpClient),
                      FetchDeviceInfoBackend(httpClient),
                      errorNotifier),
                ),
                BlocProvider<FetchInstallationStatusCubit>(
                    create: (context) => FetchInstallationStatusCubit(
                        TestStackBackend(httpClient),
                        FetchInstallationStatusBackend(httpClient),
                        errorNotifier)),
                BlocProvider<SetInstallationStatusCubit>(
                  create: (context) => SetInstallationStatusCubit(
                      TestStackBackend(httpClient),
                      SetInstallationStatusBackend(httpClient),
                      SetDeviceGroupBackend(httpClient),
                      errorNotifier),
                ),
                BlocProvider<FetchDeviceMessagesCubit>(
                  create: (context) => FetchDeviceMessagesCubit(
                      TestStackBackend(httpClient),
                      FetchDeviceMessagesBackend(httpClient),
                      errorNotifier),
                ),
                BlocProvider<FetchGroupCubit>(
                  create: (context) => FetchGroupCubit(
                      TestStackBackend(httpClient),
                      errorNotifier,
                      FetchGroupBackend(httpClient)),
                )
              ],
              child: DeviceView(
                arguments: settings.arguments as DeviceInfoArguments,
              ),
            )));
  }

  Route<dynamic> _generateDeviceListViewRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: ((context) => MultiBlocProvider(
              providers: [
                BlocProvider<DeleteGroupCubit>(
                  create: (context) => DeleteGroupCubit(
                      TestStackBackend(httpClient),
                      DeleteGroupBackend(httpClient),
                      SetInstallationStatusBackend(httpClient),
                      SetDeviceGroupBackend(httpClient),
                      errorNotifier),
                ),
              ],
              child: DeviceListView(
                arguments: settings.arguments as DeviceListViewArguments,
                bottomNavigationVisible: bottomNavigationVisible,
              ),
            )));
  }

  Route<dynamic> _generateCountrySelectViewRoute(RouteSettings settings) {
    return CupertinoModalBottomSheetRoute(
        bounce: false,
        builder: ((context) => CountrySelectView(
              arguments: settings.arguments as CountrySelectViewArguments,
            )),
        expanded: false);
  }

  Route<dynamic> _generateGroupSelectViewRoute(RouteSettings settings) {
    return CupertinoModalBottomSheetRoute(
        bounce: false,
        builder: ((context) => GroupSelectView(
              arguments: settings.arguments as GroupSelectViewArguments,
            )),
        expanded: false);
  }

  Route<dynamic> _generateStackListViewRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: ((context) => StackListView(
            userRepository: userRepository,
            navigatedFor: settings.arguments as DeletedOrAdded,
            bottomNavigationVisible: bottomNavigationVisible)));
  }

  Route<dynamic> _generateAddOrEditGroupViewRoute(RouteSettings settings) {
    return ModalSheetRoute(
        enableDrag: false,
        isDismissible: false,
        expanded: true,
        builder: ((context) => MultiBlocProvider(
              providers: [
                BlocProvider<CreateGroupCubit>(
                  create: (context) => CreateGroupCubit(
                      TestStackBackend(httpClient),
                      CreateGroupBackend(httpClient),
                      errorNotifier),
                ),
              ],
              child: AddOrEditGroupView(
                arguments: settings.arguments as AddOrEditGroupViewArguments,
              ),
            )));
  }

  Route<dynamic> _generateGroupListViewRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: ((context) => GroupListView(
              stackIdentifier: settings.arguments as StackIdentifier,
              bottomNavigationVisible: bottomNavigationVisible,
            )));
  }

  Route<dynamic> _generateAddStackViewRoute(RouteSettings settings) {
    return ModalSheetRoute(
        enableDrag: false,
        isDismissible: false,
        builder: ((context) => BlocProvider<TestStackCubit>(
              create: (context) =>
                  TestStackCubit(TestStackBackend(httpClient), errorNotifier),
              child: AddStackView(
                userRepository: userRepository,
              ),
            )),
        expanded: false);
  }

  @override
  Widget build(BuildContext context) {
    // Provide this cubit to update group list after editing
    return MultiBlocProvider(
      providers: [
        BlocProvider<EditGroupCubit>(
          create: (context) => EditGroupCubit(TestStackBackend(httpClient),
              EditGroupBackend(httpClient), errorNotifier),
        ),
        BlocProvider<FetchDeviceListCubit>(
          create: (context) => FetchDeviceListCubit(
              TestStackBackend(httpClient),
              FetchDeviceListBackend(httpClient),
              errorNotifier),
        ),
        BlocProvider<FetchGroupListCubit>(
          create: (context) => FetchGroupListCubit(TestStackBackend(httpClient),
              FetchGroupListBackend(httpClient), errorNotifier),
        ),
        BlocProvider<CommandsCubit>(
          create: (context) => CommandsCubit(TestStackBackend(httpClient),
              SendCommandBackend(httpClient), errorNotifier),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => InstallationModel()),
          ChangeNotifierProvider(create: (_) => errorNotifier),
          ChangeNotifierProvider(create: (context) => DimUiModel()),
        ],
        child: InstallerErrorManager(
          errorNotifier: errorNotifier,
          navigatorState: navigatorKey,
          child: MaterialApp(
              navigatorKey: navigatorKey,
              title: 'Thingsee Toolbox',
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context)!.installerTitle,
              theme: ThemeData(
                  canvasColor: InstallerColor.canvasColor,
                  primarySwatch: InstallerColor.themeColor,
                  fontFamily: 'Source Sans pro'),
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              onGenerateRoute: (RouteSettings settings) {
                return _generateRoute(settings);
              },
              navigatorObservers: [NavigationHistoryObserver()],
              initialRoute: InstallerRoutes.splashScreenViewRoute,
              builder: (context, child) => Overlay(
                    initialEntries: [
                      OverlayEntry(
                        builder: (context) => LayOut(
                          navigatorKey: navigatorKey,
                          bottomNavigationVisible: bottomNavigationVisible,
                          child: child!,
                        ),
                      )
                    ],
                  )),
        ),
      ),
    );
  }
}
