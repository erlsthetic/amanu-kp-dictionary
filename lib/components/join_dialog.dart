import 'package:amanu/screens/onboarding_screen/onboarding_screen.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future<dynamic> showJoinDialog(
    BuildContext context,
    String title,
    String content,
    String option1Text,
    String option2Text,
    VoidCallback option1Tap,
    VoidCallback option2Tap) {
  final size = MediaQuery.of(context).size;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                    color: pureWhite,
                    borderRadius: BorderRadius.circular(30.0)),
                margin:
                    EdgeInsets.only(right: 12, top: 12 + (size.width * 0.08)),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: (size.width * 0.65) -
                                  20 -
                                  (size.width * 0.08),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              child: Text(
                                "Join the Amánu Community",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    height: 1.1,
                                    fontSize: 24,
                                    color: primaryOrangeDark,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                "Be a contributor/expert and share your Kapampangan knowledge with the Amánu community.",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: cardText, fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Material(
                              borderRadius: BorderRadius.circular(25),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(25),
                                onTap: () {
                                  Get.to(() => OnBoardingScreen());
                                },
                                splashColor: primaryOrangeLight,
                                highlightColor:
                                    primaryOrangeLight.withOpacity(0.5),
                                child: Ink(
                                  height: 50.0,
                                  width: double.infinity,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      "JOIN AMÁNU",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: pureWhite,
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: primaryOrangeDark,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                              ),
                            ),
                          ]),
                    )
                  ],
                ),
              ),
              Positioned(
                  top: 0,
                  child: Container(
                    height: size.width * 0.65,
                    width: size.width * 0.65,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: SvgPicture.asset(iJoinAmanuIllus),
                    ),
                  )),
              Positioned(
                top: (size.width * 0.08),
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 18.0,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.close, color: primaryOrangeDark),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
