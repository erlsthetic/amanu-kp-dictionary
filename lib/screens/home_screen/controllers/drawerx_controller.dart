import 'package:amanu/screens/bookmarks_screen/bookmarks_screen.dart';
import 'package:amanu/screens/home_screen/controllers/home_page_controller.dart';
import 'package:amanu/screens/home_screen/home_screen.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/models/drawer_item_model.dart';
import 'package:amanu/screens/onboarding_screen/onboarding_screen.dart';
import 'package:amanu/screens/requests_screen/requests_screen.dart';
import 'package:amanu/screens/support_screen/support_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class DrawerXController extends GetxController {
  static DrawerXController get instance => Get.find();
  final homeController = Get.find<HomePageController>();

  Rx<DrawerItem> currentItem = DrawerItems.home.obs;

  drawerToggle(context) {
    ZoomDrawer.of(context)!.toggle();
  }

  Widget getScreen() {
    switch (currentItem.value) {
      case DrawerItems.home:
        homeController.currentIdx.value = 0;
        return HomeScreen();
      case DrawerItems.browse:
        homeController.currentIdx.value = 1;
        return HomeScreen();
      case DrawerItems.bookmarks:
        return BookmarksScreen();
      case DrawerItems.kulitan:
        return HomeScreen();
      case DrawerItems.join:
        return OnBoardingScreen();
      case DrawerItems.profile:
        return SupportScreen();
      case DrawerItems.requests:
        return RequestsScreen();
      case DrawerItems.support:
        return SupportScreen();
      default:
        return HomeScreen();
    }
  }
}
