import 'package:amanu/screens/support/controllers/feedback_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackPage extends StatelessWidget {
  FeedbackPage({
    super.key,
  });

  final controller = Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: Text(
            tFeedback.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: pureWhite,
              letterSpacing: 1.0,
            ),
          ),
          icon: Icon(Icons.send),
        ),
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
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                        child: Column(
                          children: [
                            Container(
                                width: double.infinity,
                                child: Image.asset(iOnBoardingAnim1)),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                tFeedbackInstructions,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                  color: darkGrey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                tFeedbackRate,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                  color: darkGrey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                child: Row(children: [
                                  for (int i = 0; i < 5; i++)
                                    RateOption(
                                        label: controller.ratesText[i],
                                        value: i + 1,
                                        controller: controller,
                                        icon: controller.ratesIcon[i])
                                ]),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              //controller: controller.exBioController,
                              onSaved: (value) {
                                //controller.exBio = value!;
                              },
                              /*validator: (value) {
                                if (value != null) {
                                  return controller.validateBio(value);
                                } else {
                                  return "Please describe your self and profession.";
                                }
                              },*/
                              maxLines: 5,
                              decoration: InputDecoration(
                                  labelText: tFeedbackNotes,
                                  alignLabelWithHint: true,
                                  hintText: tFeedbackNotesTip,
                                  hintMaxLines: 5,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
                          ],
                        ),
                      ),
                    ),
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
                          tag: 'HamburgerMenu',
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
                          tFeedback,
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

class RateOption extends StatelessWidget {
  RateOption({
    super.key,
    required this.label,
    required this.value,
    required this.controller,
    required this.icon,
  });
  final String label;
  final int value;
  final FeedbackController controller;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Obx(
          () => Container(
            height: 70,
            width: 70,
            margin: EdgeInsets.symmetric(horizontal: 5.0),
            child: InkWell(
              splashColor: primaryOrangeLight,
              highlightColor: primaryOrangeLight.withOpacity(0.5),
              onTap: () {
                controller.selectedRate.value = value;
              },
              borderRadius: BorderRadius.circular(20),
              child: Ink(
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: controller.selectedRate.value == value
                          ? primaryOrangeDark
                          : pureWhite,
                      boxShadow: [
                        BoxShadow(
                          color: primaryOrangeDark.withOpacity(0.75),
                          blurRadius: 15,
                          spreadRadius: -6,
                        ),
                      ]),
                  child: Center(
                    child: SvgPicture.asset(
                      icon,
                      colorFilter: ColorFilter.mode(
                          controller.selectedRate.value == value
                              ? pureWhite
                              : disabledGrey,
                          BlendMode.srcIn),
                    ),
                  )),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Obx(() => AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: controller.selectedRate.value == value
                  ? Container(
                      child: Text(
                        label,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 12.0,
                          fontWeight: FontWeight.normal,
                          color: disabledGrey,
                        ),
                      ),
                    )
                  : Container(),
            ))
      ],
    );
  }
}