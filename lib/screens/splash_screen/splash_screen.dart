import 'package:amanu/screens/splash_screen/controllers/splashscreen_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final splashController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    splashController.startAnimation();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(
        () => Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(gradient: orangeGradient),
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: splashController.animate.value ? 1 : 0,
              child: Padding(
                padding: EdgeInsets.all(size.width / 6),
                child: Image(
                  image: AssetImage(amanuLogoAnim),
                  height: size.width / 2,
                  width: size.width / 2,
                ),
              ),
            )),
      ),
    );
  }
}
