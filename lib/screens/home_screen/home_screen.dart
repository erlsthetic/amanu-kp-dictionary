import 'dart:ui';

import 'package:amanu/screens/user_tools/modify_word_page.dart';
import 'package:amanu/screens/user_tools/modify_search_page.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/components/floating_button.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'widgets/browse_screen_page.dart';
import 'package:amanu/components/bottom_nav_bar.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';

import 'widgets/home_screen_page.dart';
import 'controllers/home_page_controller.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = Get.find<HomePageController>();
  final appController = Get.find<ApplicationController>();

  TutorialCoachMark? tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (appController.isFirstTimeHome) {
        Future.delayed(Duration(seconds: 1), () {
          tutorialCoachMark = TutorialCoachMark(
              pulseEnable: false,
              targets: controller.initTarget(),
              imageFilter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
              onClickTarget: (target) async {
                if (target.identify == "navigation-key") {
                  await controller.coastController.animateTo(beach: 1);
                  controller.currentIdx.value = 1;
                } else if (target.identify == "browse-card-key") {
                  await controller.coastController.animateTo(beach: 0);
                  controller.currentIdx.value = 0;
                }
              },
              onFinish: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("isFirstTimeHome", false);
                appController.isFirstTimeHome = false;
              },
              onSkip: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setBool("isFirstTimeHome", false);
                appController.isFirstTimeHome = false;
              },
              hideSkip: true)
            ..show(context: context);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    final _size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: appController.isFirstTimeHome ? controller.homeScreenKey : null,
      body: GetBuilder<HomePageController>(builder: (ctl) {
        return Stack(
          children: [
            Coast(
              beaches: [
                Beach(
                    builder: (context) => HomeScreenPage(
                          size: _size,
                          topPadding: screenPadding.top,
                        )),
                Beach(
                    builder: (context) => BrowseScreenPage(
                          size: _size,
                          topPadding: screenPadding.top,
                        )),
              ],
              controller: ctl.coastController,
              onPageChanged: (page) {
                ctl.currentIdx.value = page;
              },
              observers: [ctl.crabController],
            ),
            BottomNavBar(size: _size, pController: ctl),
            appController.isLoggedIn
                ? CustomFloatingPanel(
                    onPressed: (index) {
                      print("Clicked $index");
                      if (index == 0) {
                        if (appController.hasConnection.value) {
                          Get.to(() => ModifyWordPage(),
                              duration: Duration(milliseconds: 500),
                              transition: Transition.downToUp,
                              curve: Curves.easeInOut);
                        } else {
                          appController.showConnectionSnackbar();
                        }
                      } else if (index == 1) {
                        if (appController.hasConnection.value) {
                          Get.to(
                              () => ModifySearchPage(
                                    editMode: true,
                                  ),
                              duration: Duration(milliseconds: 500),
                              transition: Transition.downToUp,
                              curve: Curves.easeInOut);
                        } else {
                          appController.showConnectionSnackbar();
                        }
                      } else if (index == 2) {
                        if (appController.hasConnection.value) {
                          Get.to(
                              () => ModifySearchPage(
                                    editMode: false,
                                  ),
                              duration: Duration(milliseconds: 500),
                              transition: Transition.downToUp,
                              curve: Curves.easeInOut);
                        } else {
                          appController.showConnectionSnackbar();
                        }
                      }
                    },
                    positionBottom: _size.height * 0.1,
                    positionLeft: _size.width - 85,
                    size: 70,
                    iconSize: 30,
                    panelIcon: iToolBox,
                    dockType: DockType.inside,
                    dockOffset: 15,
                    backgroundColor: pureWhite,
                    contentColor: pureWhite,
                    panelShape: PanelShape.rounded,
                    borderRadius: BorderRadius.circular(40),
                    borderColor: primaryOrangeDark,
                    buttons: [
                      iToolsAdd,
                      iToolsEdit,
                      iToolsDelete,
                    ],
                    iconBGColors: [
                      primaryOrangeDark,
                      primaryOrangeLight,
                      darkerOrange.withOpacity(0.8)
                    ],
                    iconBGSize: 60,
                    mainIconColor: primaryOrangeDark,
                    shadowColor: primaryOrangeDark,
                  )
                : Container()
          ],
        );
      }),
    );
  }
}
