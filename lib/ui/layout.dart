import 'package:flutter/material.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';
import 'package:provider/provider.dart';
import 'package:thingsee_installer/constants/installer_colors.dart';
import 'package:thingsee_installer/constants/installer_icons.dart';
import 'package:thingsee_installer/constants/installer_routes.dart';
import 'package:thingsee_installer/constants/installer_text_styles.dart';
import 'package:thingsee_installer/models/dim_ui_model.dart';
import 'package:thingsee_installer/ui/stack_list/stack_list_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LayOut extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  final ValueNotifier<bool?> bottomNavigationVisible;
  LayOut(
      {Key? key,
      required this.child,
      required this.navigatorKey,
      required this.bottomNavigationVisible})
      : super(key: key);
  @override
  State<LayOut> createState() => _LayOutState();
}

class _LayOutState extends State<LayOut> {
  int _selectedIndex = 0;
  int historyCount = 0;
  int poppedCount = 0;
  int newRoutesCount = -1;
  bool pushedNewRoute = false;
  final NavigationHistoryObserver historyObserver = NavigationHistoryObserver();
  List<int> _selectedPages = [0];
  @override
  void initState() {
    historyCount = historyObserver.history.length;
    poppedCount = historyObserver.poppedRoutes.length;
    historyObserver.historyChangeStream.listen((change) => setState(() {
          historyCount = historyObserver.history.length;
          poppedCount = historyObserver.poppedRoutes.length;
          HistoryChange changeAction = change;

          // if action is push
          if (changeAction.action!.index == 0 && _selectedIndex == 2 ||
              _selectedIndex == 3 && changeAction.action!.index == 0 ||
              _selectedIndex == 1 && changeAction.action!.index == 0) {
            setState(() {
              newRoutesCount += 1;
            });
          }

          if (_selectedIndex != 0 &&
              changeAction.action!.index == 0 &&
              !pushedNewRoute) {
            if (newRoutesCount == 0) {
              newRoutesCount += 1;
            }
          }

          // If action is pop
          if (changeAction.action!.index == 1 && !pushedNewRoute) {
            if (newRoutesCount > 0) {
              setState(() {
                newRoutesCount -= 1;
              });
            } else if (newRoutesCount <= 0) {
              if (widget.bottomNavigationVisible.value == true) {
                if (historyCount > 1 &&
                    _selectedPages.length > 1 &&
                    newRoutesCount <= 0) {
                  setState(() {
                    if (_selectedIndex != 1 ||
                        _selectedIndex == 1 && newRoutesCount <= 0) {
                      _selectedPages.removeLast();
                      _selectedIndex = _selectedPages.last;
                    }
                  });
                }
              }
            }
          }
          _wait();
        }));
    super.initState();
  }

  void _wait() async {
    await Future.delayed(Duration(milliseconds: 50)).then((value) {
      setState(() {
        pushedNewRoute = false;
      });
    });
  }

  void _popNewRoutes() {
    if (newRoutesCount > 0) {
      for (int i = 0; i < newRoutesCount; i++) {
        widget.navigatorKey.currentState!.pop();
      }
      setState(() {
        newRoutesCount = -1;
      });
    }
  }

  void _popPreviousPages(int _index, String route, [Object? arguments]) {
    setState(() {
      pushedNewRoute = true;
    });
    _popNewRoutes();
    if (_index != 0 && _selectedPages.length > 1) {
      widget.navigatorKey.currentState!
          .pushReplacementNamed(route, arguments: arguments);
    } else if (_index != 0 && _selectedPages.length <= 1) {
      widget.navigatorKey.currentState!.pushNamed(route, arguments: arguments);
    } else {
      _selectedPages.clear();
      widget.navigatorKey.currentState!.pop();
    }
    setState(() {
      newRoutesCount = -1;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      if (index != _selectedIndex) {
        _selectedIndex = index;
        switch (_selectedIndex) {
          case 0:
            _popPreviousPages(
                0, InstallerRoutes.stackListViewRoute, DeletedOrAdded.none);
            break;
          case 1:
            _popPreviousPages(1, InstallerRoutes.searchDeviceViewRoute);
            break;
          case 2:
            _popPreviousPages(2, InstallerRoutes.logListViewRoute);
            break;
          case 3:
            _popPreviousPages(3, InstallerRoutes.aboutViewRoute);
            break;
          default:
        }
        setState(() {
          if (_selectedPages.length > 1) {
            _selectedPages.removeLast();
          }
          _selectedPages.add(_selectedIndex);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool?>(
        valueListenable: widget.bottomNavigationVisible,
        builder: (context, value, _) {
          final notifier = value;
          if (notifier == true || notifier == null) {
            return Consumer<DimUiModel>(builder: (context, model, _) {
              return Scaffold(
                bottomNavigationBar: AbsorbPointer(
                  absorbing: model.getDimmed(),
                  child: SizedBox(
                    height: 98,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: BottomNavigationBar(
                            type: BottomNavigationBarType.fixed,
                            unselectedLabelStyle:
                                InstallerTextStyles.bottomNavigationText,
                            selectedLabelStyle: InstallerTextStyles
                                .bottomNavigationText
                                .copyWith(color: InstallerColor.blueColor),
                            backgroundColor: Colors.white,
                            items: <BottomNavigationBarItem>[
                              BottomNavigationBarItem(
                                icon: InstallerIcons.createInstallerAssetImage(
                                    assetPath:
                                        InstallerIcons.navDeviceUnselected,
                                    width: 32,
                                    height: 32),
                                activeIcon:
                                    InstallerIcons.createInstallerAssetImage(
                                        assetPath:
                                            InstallerIcons.navDeviceSelected,
                                        width: 32,
                                        height: 32),
                                label: AppLocalizations.of(context)!.devices,
                              ),
                              BottomNavigationBarItem(
                                icon: InstallerIcons.createInstallerAssetImage(
                                    assetPath:
                                        InstallerIcons.navSearchUnselected,
                                    width: 32,
                                    height: 32),
                                activeIcon:
                                    InstallerIcons.createInstallerAssetImage(
                                        assetPath:
                                            InstallerIcons.navSearchSelected,
                                        width: 32,
                                        height: 32),
                                label: AppLocalizations.of(context)!.search,
                              ),
                              BottomNavigationBarItem(
                                icon: InstallerIcons.createInstallerAssetImage(
                                    assetPath: InstallerIcons.navLogsUnselected,
                                    width: 32,
                                    height: 32),
                                activeIcon:
                                    InstallerIcons.createInstallerAssetImage(
                                        assetPath:
                                            InstallerIcons.navLogsSelected,
                                        width: 32,
                                        height: 32),
                                label: AppLocalizations.of(context)!.logs,
                              ),
                              BottomNavigationBarItem(
                                icon: InstallerIcons.createInstallerAssetImage(
                                    assetPath: InstallerIcons.navMoreUnselected,
                                    width: 32,
                                    height: 32),
                                activeIcon:
                                    InstallerIcons.createInstallerAssetImage(
                                        assetPath:
                                            InstallerIcons.navMoreSelected,
                                        width: 32,
                                        height: 32),
                                label: AppLocalizations.of(context)!.more,
                              ),
                            ],
                            currentIndex: _selectedIndex,
                            selectedItemColor: Colors.blue,
                            unselectedItemColor: Colors.grey,
                            selectedIconTheme: const IconThemeData(
                                color: InstallerColor.blueColor),
                            unselectedIconTheme: const IconThemeData(
                                color: InstallerColor.darkGreyColor),
                            onTap: _onItemTapped,
                          ),
                        ),
                        Positioned(
                          child: Container(
                            child: AnimatedContainer(
                              height: model.getDimmed() == true ? 98 : 0,
                              color: Colors.black.withOpacity(0.7),
                              duration: Duration(milliseconds: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: widget.child,
              );
            });
          } else {
            return Scaffold(
              body: widget.child,
            );
          }
        });
  }
}
