import 'package:amanu/screens/home_screen/drawer_launcher.dart';
import 'package:amanu/screens/onboarding_screen/onboarding_screen.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:get/get.dart';
import 'package:amanu/firebase_options.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get find => Get.find();

  RxBool animate = false.obs;

  Future startAnimation() async {
    await Future.delayed(Duration(milliseconds: 100));
    animate.value = true;
    await Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform)
        .then((value) => Get.put(AuthenticationRepository(), permanent: true))
        .then((value) => Get.put(ApplicationController(), permanent: true))
        .then((value) => Get.put(DatabaseRepository(), permanent: true));
    final appController = Get.find<ApplicationController>();
    await Future.delayed(Duration(milliseconds: 3000));
    if (appController.isFirstTimeUse) {
      Get.offAll(() => OnBoardingScreen());
    } else {
      Get.offAll(() => DrawerLauncher());
    }
  }
}
