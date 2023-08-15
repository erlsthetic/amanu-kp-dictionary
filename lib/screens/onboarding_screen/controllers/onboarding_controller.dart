import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/drawer_launcher.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/screens/onboarding_screen/welcome_screen.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
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
      image: iOnBoardingAnim1,
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
      image: iOnBoardingAnim2,
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
      image: iOnBoardingAnim3,
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

  void getStarted() {
    if (appController.isFirstTimeUse) {
      appController.isFirstTimeUse = false;
      final drawerController = Get.find<DrawerXController>();
      drawerController.currentItem.value = DrawerItems.home;
      Get.offAll(() => DrawerLauncher());
    } else {
      Get.off(() => WelcomeScreen());
    }
  }

  void skip() => controller.jumpToPage(page: 2);
}
