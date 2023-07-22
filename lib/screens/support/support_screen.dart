import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportScreen extends StatelessWidget {
  SupportScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: topPadding + 50,
          left: 0,
          right: 0,
          child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              height: size.height - 110,
              width: size.width,
              child: Column(
                children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 20.0),
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(20),
                              child: Stack(
                                children: [
                                  Positioned(
                                      child: Container(
                                    height: 150,
                                    width: 150,
                                    child: Image.asset(iOnBoardingAnim1),
                                  )),
                                  Ink(
                                    height: 120,
                                    width: double.infinity,
                                    padding:
                                        EdgeInsets.fromLTRB(20, 10, 10, 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: pureWhite,
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryOrangeDark
                                                .withOpacity(0.5),
                                            blurRadius: 15,
                                            spreadRadius: -8,
                                          ),
                                        ]),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            child: Text(
                                              tKulitanEditor,
                                              overflow: TextOverflow.fade,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 20,
                                                  color: darkGrey,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 250,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Crab(
            tag: "AppBar",
            child: Container(
              width: size.width,
              height: topPadding + 70,
              decoration: BoxDecoration(
                  gradient: orangeGradient,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30.0))),
            ),
          ),
        ),
        Positioned(
            top: topPadding,
            left: 0,
            child: Container(
              height: 70,
              width: size.width,
              padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Crab(
                      tag: 'BackButton',
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          weight: 10,
                        ),
                        color: pureWhite,
                        iconSize: 30,
                      ),
                    ),
                    Text(
                      tKulitanEditor,
                      style: GoogleFonts.robotoSlab(
                          fontSize: 24,
                          color: pureWhite,
                          fontWeight: FontWeight.bold),
                    ),
                    Crab(
                      tag: 'HelpButton',
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.help),
                        color: pureWhite,
                        iconSize: 30,
                      ),
                    ),
                  ]),
            )),
      ],
    ));
  }
}
