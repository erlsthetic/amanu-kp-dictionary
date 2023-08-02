import 'package:amanu/screens/onboarding_screen/onboarding_screen.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get find => Get.find();

  RxBool animate = false.obs;

  Future startAnimation() async {
    await Future.delayed(Duration(milliseconds: 100));
    animate.value = true;
    await Future.delayed(Duration(milliseconds: 3000));
    //Get.to(WidgetTree());
    Get.off(() => OnBoardingScreen());
  }
}
