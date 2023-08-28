import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/home_screen.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/screens/onboarding_screen/onboarding_screen.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:get/get.dart';
import 'package:amanu/firebase_options.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/authentication_repository.dart';
import 'package:firebase_core/firebase_core.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get find => Get.find();

  RxBool animate = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await Future.delayed(Duration(milliseconds: 100));
    animate.value = true;
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await FirebaseAppCheck.instance.activate(
      webRecaptchaSiteKey: 'recaptcha-v3-site-key',
      androidProvider: AndroidProvider.playIntegrity,
    );
    await Get.put(DatabaseRepository(), permanent: true);
    await Get.put(ApplicationController(), permanent: true);
    await Get.put(AuthenticationRepository(), permanent: true);
    await Future.delayed(Duration(milliseconds: 5000));
  }
}
