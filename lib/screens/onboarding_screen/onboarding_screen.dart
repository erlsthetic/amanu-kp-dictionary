import 'package:amanu/screens/onboarding_screen/controllers/onboarding_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/constants/app_colors.dart';

class OnBoardingScreen extends StatelessWidget {
  OnBoardingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final obController = OnBoardingController();

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
          Obx(() {
            if (obController.currentPage.value == 0 ||
                obController.currentPage.value == 1) {
              return Positioned(
                bottom: 20.0 + MediaQuery.of(context).padding.bottom,
                left: 30.0,
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    splashColor: primaryOrangeLight,
                    highlightColor: primaryOrangeLight.withOpacity(0.5),
                    onTap: () => obController.skip(),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: Text("SKIP",
                          style: GoogleFonts.poppins(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: obController.currentPage.value == 0
                                ? primaryOrangeDark
                                : pureWhite,
                          )),
                    ),
                  ),
                ),
              );
            } else {
              return Positioned(
                bottom: 50.0 + MediaQuery.of(context).padding.bottom,
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    splashColor: primaryOrangeLight,
                    highlightColor: primaryOrangeLight.withOpacity(0.5),
                    onTap: () {
                      obController.getStarted();
                    },
                    child: Ink(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: orangeGradient),
                      child: Row(
                        children: [
                          Text(tGetStarted.toUpperCase(),
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: pureWhite,
                              )),
                          SizedBox(
                            width: 5.0,
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: pureWhite,
                            size: 20.0,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }),
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
