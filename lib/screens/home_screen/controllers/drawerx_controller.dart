import 'package:amanu/screens/bookmarks_screen/bookmarks_screen.dart';
import 'package:amanu/screens/home_screen/controllers/home_page_controller.dart';
import 'package:amanu/screens/home_screen/home_screen.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/models/drawer_item_model.dart';
import 'package:amanu/screens/kulitan_scanner_screen/kulitan_scanner_screen.dart';
import 'package:amanu/screens/onboarding_screen/onboarding_screen.dart';
import 'package:amanu/screens/profile_screen/profile_screen.dart';
import 'package:amanu/screens/requests_screen/requests_screen.dart';
import 'package:amanu/screens/support_screen/support_screen.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/authentication_repository.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerXController extends GetxController {
  static DrawerXController get instance => Get.find();
  final homeController = Get.find<HomePageController>();
  final appController = Get.find<ApplicationController>();

  Rx<DrawerItem> currentItem = DrawerItems.home.obs;

  drawerToggle(context) {
    ZoomDrawer.of(context)!.toggle();
  }

  Widget getScreen() {
    switch (currentItem.value) {
      case DrawerItems.home:
        homeController.coastController = new CoastController(initialPage: 0);
        homeController.currentIdx.value = 0;
        return HomeScreen();
      case DrawerItems.browse:
        homeController.coastController = new CoastController(initialPage: 1);
        homeController.currentIdx.value = 1;
        return HomeScreen();
      case DrawerItems.bookmarks:
        return BookmarksScreen();
      case DrawerItems.kulitan:
        return KulitanScannerScreen();
      case DrawerItems.join:
        return OnBoardingScreen();
      case DrawerItems.profile:
        return ProfileScreen();
      case DrawerItems.requests:
        return RequestsScreen();
      case DrawerItems.support:
        return SupportScreen();
      default:
        return HomeScreen();
    }
  }

  Future<void> logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", false);
    prefs.remove('userID');
    prefs.remove('userName');
    prefs.remove('userEmail');
    prefs.remove('userPhone');
    prefs.remove('userIsExpert');
    prefs.remove('userExpertRequest');
    prefs.remove('userFullName');
    prefs.remove('userBio');
    prefs.remove('userPic');
    prefs.remove('userContributions');
    AuthenticationRepository.instance.logout();
  }
}
