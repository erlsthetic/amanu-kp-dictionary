import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

List<Widget> threePartHeader(
    Size size,
    EdgeInsets screenPadding,
    String title,
    IconData firstIcon,
    IconData secondIcon,
    VoidCallback firstOnPressed,
    VoidCallback secondOnPressed,
    double additionalHeight) {
  return [
    Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Hero(
        tag: "AppBar",
        child: Container(
          width: size.width,
          height: screenPadding.top + 70 + additionalHeight,
          decoration: BoxDecoration(
              gradient: orangeGradient,
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(30.0))),
        ),
      ),
    ),
    Positioned(
        top: screenPadding.top,
        left: 0,
        child: Container(
          height: 70,
          width: size.width,
          padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Hero(
              tag: 'firstButton',
              child: IconButton(
                onPressed: firstOnPressed,
                icon: Icon(
                  firstIcon,
                  weight: 10,
                ),
                color: pureWhite,
                iconSize: 30,
              ),
            ),
            Hero(
              tag: "title",
              child: Text(
                title,
                style: GoogleFonts.robotoSlab(
                    fontSize: 24,
                    color: pureWhite,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Hero(
              tag: 'secondButton',
              child: IconButton(
                onPressed: secondOnPressed,
                icon: Icon(secondIcon),
                color: pureWhite,
                iconSize: 30,
              ),
            ),
          ]),
        )),
  ];
}

Obx isProcessingWithHeader(
    bool condition, Size size, EdgeInsets screenPadding) {
  return Obx(
    () => condition
        ? Positioned(
            top: screenPadding.top + 50,
            left: 0,
            right: 0,
            child: Container(
              height: size.height - screenPadding.top - 50,
              width: size.width,
              decoration: BoxDecoration(color: disabledGrey.withOpacity(0.25)),
              child: Center(
                child: SizedBox(
                  height: 50.0,
                  width: 50.0,
                  child: CircularProgressIndicator(
                    color: primaryOrangeDark,
                    strokeWidth: 6.0,
                  ),
                ),
              ),
            ))
        : Container(),
  );
}
