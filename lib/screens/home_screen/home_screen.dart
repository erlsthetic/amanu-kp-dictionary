import 'package:amanu/screens/user_tools/add_word_page.dart';
import 'package:amanu/screens/user_tools/modify_search_page.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/components/floating_button.dart';
import 'package:get/get.dart';
import 'widgets/browse_screen_page.dart';
import 'package:amanu/components/bottom_nav_bar.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';

import 'widgets/home_screen_page.dart';
import 'controllers/home_page_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, this.pageIndex});

  final bool isLoggedIn = true;
  final bool isExpert = true;
  final int? pageIndex;

  final controller = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    controller.currentIdx.value = pageIndex ?? 0;
    controller.coastController = CoastController(initialPage: pageIndex ?? 0);
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
          CustomFloatingPanel(
            onPressed: (index) {
              print("Clicked $index");
              if (index == 0) {
                Get.to(() => AddWordPage());
              } else if (index == 1) {
                Get.to(() => ModifySearchPage(editMode: true));
              } else if (index == 2) {
                Get.to(() => ModifySearchPage(editMode: false));
              }
            },
            positionBottom: _size.height * 0.1,
            positionLeft: _size.width - 85,
            size: 70,
            iconSize: 30,
            panelIcon: Icons.edit_note,
            dockType: DockType.inside,
            dockOffset: 15,
            backgroundColor: pureWhite,
            contentColor: pureWhite,
            panelShape: PanelShape.rounded,
            borderRadius: BorderRadius.circular(40),
            borderColor: primaryOrangeDark,
            buttons: [
              Icons.library_add,
              Icons.edit_document,
              Icons.delete_forever_rounded,
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
        ],
      ),
    );
  }
}
