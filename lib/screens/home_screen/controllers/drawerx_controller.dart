import 'package:amanu/screens/home_screen/controllers/home_page_controller.dart';
import 'package:amanu/screens/home_screen/home_screen.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/screens/home_screen/widgets/drawer_item.dart';
import 'package:amanu/screens/support/support_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class DrawerXController extends GetxController {
  static DrawerXController get instance => Get.find();

  Rx<DrawerItem> currentItem = DrawerItems.home.obs;

  drawerToggle(context) {
    ZoomDrawer.of(context)!.toggle();
  }

  Widget getScreen() {
    switch (currentItem.value) {
      case DrawerItems.home:
        return HomeScreen(pageIndex: 0);
      case DrawerItems.browse:
        return HomeScreen(pageIndex: 1);
      case DrawerItems.bookmarks:
        return HomeScreen(pageIndex: 0);
      case DrawerItems.kulitan:
        return HomeScreen(pageIndex: 1);
      case DrawerItems.join:
        return SupportScreen();
      case DrawerItems.support:
        return SupportScreen();
      default:
        return HomeScreen(pageIndex: 0);
    }
  }
}
