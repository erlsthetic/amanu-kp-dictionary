import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/drawer_launcher.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/screens/onboarding_screen/welcome_screen.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/onboarding_model.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/text_strings.dart';
import '../widgets/onboarding_page_widget.dart';

class OnBoardingController extends GetxController {
  final controller = LiquidController();
  RxInt currentPage = 0.obs;
  final appController = Get.find<ApplicationController>();

  List<OnBoardingPage> onBoardingPages = [
    OnBoardingPage(
        model: OnBoardingModel(
      image: iWalkthrough1,
      header: tOnBoardingHead1,
      subheading: tOnBoardingSubHead1,
      colors: [pureWhite, pureWhite],
      headColor: primaryOrangeDark,
      subHeadColor: darkGrey,
      hasSkip: true,
      hasButton: false,
      pageNo: 0,
    )),
    OnBoardingPage(
        model: OnBoardingModel(
      image: iWalkthrough2,
      header: tOnBoardingHead2,
      subheading: tOnBoardingSubHead2,
      colors: [primaryOrangeLight, primaryOrangeDark],
      headColor: darkGrey,
      subHeadColor: pureWhite,
      hasSkip: true,
      hasButton: false,
      pageNo: 1,
    )),
    OnBoardingPage(
        model: OnBoardingModel(
      image: iWalkthrough3,
      header: tOnBoardingHead3,
      subheading: tOnBoardingSubHead3,
      colors: [pureWhite, pureWhite],
      headColor: primaryOrangeDark,
      subHeadColor: darkGrey,
      hasSkip: false,
      hasButton: true,
      pageNo: 2,
    )),
  ];

  onPageChangedCallback(int activePageIndex) {
    currentPage.value = activePageIndex;
  }

  void getStarted() async {
    if (appController.isFirstTimeUse) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool("isFirstTimeUse", false);
      appController.isFirstTimeUse = false;
      final drawerController = Get.find<DrawerXController>();
      drawerController.currentItem.value = DrawerItems.home;
      Get.offAll(() => DrawerLauncher(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
          curve: Curves.easeInOut);
    } else {
      Get.off(() => WelcomeScreen(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
          curve: Curves.easeInOut);
    }
  }

  void skip() => controller.jumpToPage(page: 2);
}
