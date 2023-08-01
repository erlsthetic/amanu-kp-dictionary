import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ThreePartHeader extends StatelessWidget {
  const ThreePartHeader(
      {super.key,
      required this.size,
      required this.screenPadding,
      required this.title,
      this.firstIcon = Icons.arrow_back_ios_new_rounded,
      this.secondIcon = Icons.help,
      this.firstOnPressed,
      this.secondOnPressed,
      this.additionalHeight = 0});

  final Size size;
  final EdgeInsets screenPadding;
  final String title;
  final IconData? firstIcon;
  final IconData? secondIcon;
  final VoidCallback? firstOnPressed;
  final VoidCallback? secondOnPressed;
  final double? additionalHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Hero(
            tag: "AppBar",
            child: Container(
              width: size.width,
              height: screenPadding.top + 70 + (additionalHeight ?? 0),
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
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag: 'firstButton',
                      child: IconButton(
                        onPressed: firstOnPressed ??
                            () {
                              Get.back();
                            },
                        icon: Icon(
                          firstIcon ?? Icons.arrow_back_ios_new_rounded,
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
                        onPressed: secondOnPressed ?? () {},
                        icon: Icon(secondIcon ?? Icons.help),
                        color: pureWhite,
                        iconSize: 30,
                      ),
                    ),
                  ]),
            )),
      ],
    );
  }
}

class IsProcessingWithHeader extends StatelessWidget {
  const IsProcessingWithHeader({
    super.key,
    required this.condition,
    required this.size,
    required this.screenPadding,
  });

  final RxBool condition;
  final Size size;
  final EdgeInsets screenPadding;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => condition.value
          ? Positioned(
              top: screenPadding.top + 50,
              left: 0,
              right: 0,
              child: Container(
                height: size.height - screenPadding.top - 50,
                width: size.width,
                decoration:
                    BoxDecoration(color: disabledGrey.withOpacity(0.25)),
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
}