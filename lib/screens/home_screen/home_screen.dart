import 'package:amanu/screens/user_tools/modify_word_page.dart';
import 'package:amanu/screens/user_tools/modify_search_page.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/components/floating_button.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:get/get.dart';
import 'widgets/browse_screen_page.dart';
import 'package:amanu/components/bottom_nav_bar.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';

import 'widgets/home_screen_page.dart';
import 'controllers/home_page_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final controller = Get.find<HomePageController>();
  final appController = Get.find<ApplicationController>();

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    final _topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(
        children: [
          Coast(
            beaches: [
              Beach(
                  builder: (context) => HomeScreenPage(
                        size: _size,
                        topPadding: _topPadding,
                      )),
              Beach(
                  builder: (context) => BrowseScreenPage(
                        size: _size,
                        topPadding: _topPadding,
                      )),
            ],
            controller: controller.coastController,
            onPageChanged: (page) {
              controller.currentIdx.value = page;
            },
            observers: [CrabController()],
          ),
          BottomNavBar(size: _size, pController: controller),
          appController.isLoggedIn
              ? CustomFloatingPanel(
                  onPressed: (index) {
                    print("Clicked $index");
                    if (index == 0) {
                      if (appController.hasConnection.value) {
                        Get.to(() => ModifyWordPage());
                      } else {
                        appController.showConnectionSnackbar();
                      }
                    } else if (index == 1) {
                      if (appController.hasConnection.value) {
                        Get.to(() => ModifySearchPage(
                              editMode: true,
                            ));
                      } else {
                        appController.showConnectionSnackbar();
                      }
                    } else if (index == 2) {
                      if (appController.hasConnection.value) {
                        Get.to(() => ModifySearchPage(
                              editMode: false,
                            ));
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
      ),
    );
  }
}
