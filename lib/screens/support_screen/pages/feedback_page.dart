import 'package:amanu/screens/support_screen/controllers/feedback_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amanu/components/three_part_header.dart';

class FeedbackPage extends StatelessWidget {
  FeedbackPage({
    super.key,
  });

  final controller = Get.put(FeedbackController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.only(bottom: screenPadding.bottom),
      child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            splashColor: primaryOrangeLight,
            focusColor: primaryOrangeLight.withOpacity(0.5),
            onPressed: () {
              controller.sendFeedback();
            },
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
                top: screenPadding.top + 50,
                left: 0,
                right: 0,
                child: Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    height: size.height - screenPadding.top - 50,
                    width: size.width,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Form(
                        key: controller.feedbackFormKey,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 40, horizontal: 30),
                          child: Column(
                            children: [
                              Container(
                                  width: double.infinity,
                                  child: SvgPicture.asset(iFeedback)),
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
                                alignment: Alignment.center,
                                width: double.infinity,
                                child: FittedBox(
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
                              Obx(() => controller.noSelection.value
                                  ? Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 10, 15, 0),
                                      width: double.infinity,
                                      child: Text(
                                        'Please select a rating.',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.red[700],
                                            fontSize: 11.5),
                                      ))
                                  : Container()),
                              SizedBox(
                                height: 15.0,
                              ),
                              TextFormField(
                                controller: controller.notesController,
                                onSaved: (value) {
                                  controller.additionalNotes = value!;
                                },
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
              IsProcessingWithHeader(
                  condition: controller.isProcessing,
                  size: size,
                  screenPadding: screenPadding),
              ThreePartHeader(
                size: size,
                screenPadding: screenPadding,
                title: tFeedback,
                secondIconDisabled: true,
              ),
            ],
          )),
    );
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
                controller.noSelection.value = false;
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
          height: 5,
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
