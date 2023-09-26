import 'package:amanu/components/text_span_builder.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ThreePartHeader extends StatelessWidget {
  const ThreePartHeader({
    super.key,
    required this.size,
    required this.screenPadding,
    required this.title,
    this.firstIcon = Icons.arrow_back_ios_new_rounded,
    this.firstIconColor = pureWhite,
    this.secondIconColor = pureWhite,
    this.secondIcon = Icons.help,
    this.firstOnPressed,
    this.secondOnPressed,
    this.additionalHeight = 0,
    this.iconWeight = 10,
    this.secondIconDisabled = false,
    this.hasTitle = true,
    this.hasBG = true,
  });

  final Size size;
  final EdgeInsets screenPadding;
  final String title;
  final IconData? firstIcon;
  final Color? firstIconColor;
  final Color? secondIconColor;
  final double? iconWeight;
  final IconData? secondIcon;
  final VoidCallback? firstOnPressed;
  final VoidCallback? secondOnPressed;
  final double? additionalHeight;
  final bool? secondIconDisabled;
  final bool? hasTitle;
  final bool? hasBG;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (hasBG ?? true)
            ? Positioned(
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
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(30.0))),
                  ),
                ),
              )
            : Container(),
        Positioned(
            top: screenPadding.top,
            left: 0,
            child: Container(
              height: 70,
              width: size.width,
              padding: EdgeInsets.fromLTRB(15, 0, 20, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag: 'firstButton',
                      child: Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: Feedback.wrapForTap(
                              firstOnPressed ??
                                  () {
                                    Get.back();
                                  },
                              context),
                          child: Icon(
                            firstIcon ?? Icons.arrow_back_ios_new_rounded,
                            weight: iconWeight ?? 10,
                            color: firstIconColor ?? pureWhite,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    hasTitle ?? true
                        ? Expanded(
                            child: Center(
                              child: Hero(
                                tag: title,
                                child: Text.rich(
                                  TextSpan(children: [
                                    buildTextSpan(
                                        text: title,
                                        style: GoogleFonts.robotoSlab(
                                            fontSize: 24,
                                            color: pureWhite,
                                            fontWeight: FontWeight.bold),
                                        boldWeight: FontWeight.bold,
                                        isBoldDefault: true)
                                  ]),
                                  style: GoogleFonts.robotoSlab(
                                      fontSize: 24,
                                      color: pureWhite,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    secondIconDisabled ?? false
                        ? Container(width: 30, height: 30)
                        : Hero(
                            tag: 'secondButton',
                            child: Container(
                              height: 30,
                              width: 30,
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: Feedback.wrapForTap(
                                    secondOnPressed ?? () {}, context),
                                child: Icon(
                                  secondIcon ?? Icons.help,
                                  size: 30,
                                  color: secondIconColor ?? pureWhite,
                                ),
                              ),
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
