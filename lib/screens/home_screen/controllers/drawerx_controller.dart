import 'package:amanu/components/loader_dialog.dart';
import 'package:amanu/screens/bookmarks_screen/bookmarks_screen.dart';
import 'package:amanu/screens/home_screen/controllers/home_page_controller.dart';
import 'package:amanu/screens/home_screen/home_screen.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/models/drawer_item_model.dart';
import 'package:amanu/screens/kulitan_scanner_screen/kulitan_scanner_screen.dart';
import 'package:amanu/screens/onboarding_screen/onboarding_screen.dart';
import 'package:amanu/screens/onboarding_screen/welcome_screen.dart';
import 'package:amanu/screens/profile_screen/profile_screen.dart';
import 'package:amanu/screens/requests_screen/requests_screen.dart';
import 'package:amanu/screens/support_screen/support_screen.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/authentication_repository.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class DrawerXController extends GetxController {
  static DrawerXController get instance => Get.find();
  final homeController = Get.find<HomePageController>();
  final appController = Get.find<ApplicationController>();

  Rx<DrawerItem> currentItem = DrawerItems.home.obs;
  RxBool isProcessing = false.obs;

  drawerToggle(context) {
    ZoomDrawer.of(context)!.toggle();
  }

  Widget getScreen() {
    switch (currentItem.value) {
      case DrawerItems.home:
        homeController.coastController = new CoastController(initialPage: 0);
        homeController.currentIdx.value = 0;
        homeController.crabController = new CrabController();
        return HomeScreen();
      case DrawerItems.browse:
        homeController.coastController = new CoastController(initialPage: 1);
        homeController.currentIdx.value = 1;
        homeController.crabController = new CrabController();
        return HomeScreen();
      case DrawerItems.bookmarks:
        return BookmarksScreen();
      case DrawerItems.kulitan:
        if (!appController.cameraError && appController.cameras.length > 0) {
          return KulitanScannerScreen();
        } else {
          homeController.coastController = new CoastController(initialPage: 0);
          homeController.currentIdx.value = 0;
          homeController.crabController = new CrabController();
          Helper.errorSnackBar(
              title: "No Cameras Detected.",
              message:
                  "Error getting cameras. Either this device has no cameras or permissions has not been set.");
          return HomeScreen();
        }
      case DrawerItems.join:
        if (appController.isFirstTimeOnboarding) {
          return OnBoardingScreen();
        } else {
          return WelcomeScreen();
        }
      case DrawerItems.profile:
        return ProfileScreen();
      case DrawerItems.requests:
        if (appController.hasConnection.value) {
          return RequestsScreen();
        } else {
          homeController.coastController = new CoastController(initialPage: 0);
          homeController.currentIdx.value = 0;
          homeController.crabController = new CrabController();
          appController.showConnectionSnackbar();
          return HomeScreen();
        }
      case DrawerItems.support:
        return SupportScreen();
      default:
        return HomeScreen();
    }
  }

  Future<void> logoutUser(BuildContext context) async {
    if (appController.hasConnection.value) {
      isProcessing.value = true;
      showLoaderDialog(context);
      await AuthenticationRepository.instance.logout();
      isProcessing.value = false;
    } else {
      appController.showConnectionSnackbar();
    }
  }
}
