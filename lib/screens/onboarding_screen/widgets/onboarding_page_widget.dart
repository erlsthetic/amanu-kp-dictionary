import 'package:amanu/screens/onboarding_screen/controllers/onboarding_controller.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/onboarding_model.dart';

class OnBoardingPage extends StatelessWidget {
  OnBoardingPage({super.key, required this.model});

  final OnBoardingModel model;
  final appController = Get.find<ApplicationController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: SvgPicture.asset(
              model.image,
            ),
          ),
          Expanded(
            flex: model.hasButton ? 4 : 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      model.header,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: model.headColor,
                          height: 1),
                    ),
                    Text(
                      model.subheading,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: model.subHeadColor,
                      ),
                    ),
                  ],
                ),
                model.hasButton
                    ? Container(
                        child: Material(
                          borderRadius: BorderRadius.circular(20),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            splashColor: primaryOrangeLight,
                            highlightColor: primaryOrangeLight.withOpacity(0.5),
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              if (!appController.isFirstTimeHome) {
                                prefs.setBool("isFirstTimeOnboarding", false);
                                appController.isFirstTimeOnboarding = false;
                              }
                              final obController =
                                  Get.find<OnBoardingController>();
                              obController.getStarted();
                            },
                            child: Ink(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: orangeGradient),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
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
                      )
                    : Container()
              ],
            ),
          ),
          model.hasSkip
              ? Expanded(
                  flex: 1,
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        splashColor: primaryOrangeLight,
                        highlightColor: primaryOrangeLight.withOpacity(0.5),
                        onTap: () {
                          final obController = Get.find<OnBoardingController>();
                          obController.skip();
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text("SKIP",
                              style: GoogleFonts.poppins(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: model.pageNo == 0
                                    ? primaryOrangeDark
                                    : pureWhite,
                              )),
                        ),
                      ),
                    ),
                  ))
              : Container()
        ],
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(-0.9, -1),
              end: Alignment(0.9, 1),
              stops: [0.0, 0.75],
              colors: model.colors)),
    );
  }
}
