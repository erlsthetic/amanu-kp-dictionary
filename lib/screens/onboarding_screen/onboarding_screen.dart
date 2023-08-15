import 'package:amanu/screens/onboarding_screen/controllers/onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/constants/app_colors.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final obController = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Obx(
            () => LiquidSwipe(
              pages: obController.onBoardingPages,
              liquidController: obController.controller,
              onPageChangeCallback: obController.onPageChangedCallback,
              slideIconWidget: obController.currentPage.value == 2
                  ? Container()
                  : Icon(Icons.arrow_back_ios),
              enableSideReveal: true,
              enableLoop: false,
              positionSlideIcon: 0.6,
            ),
          ),
          Obx(
            () => Positioned(
              bottom: 20 + MediaQuery.of(context).padding.bottom,
              child: AnimatedSmoothIndicator(
                activeIndex: obController.currentPage.value,
                count: 3,
                effect: const WormEffect(
                  dotColor: primaryOrangeLight,
                  activeDotColor: darkGrey,
                  dotHeight: 5.0,
                  dotWidth: 20.0,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
