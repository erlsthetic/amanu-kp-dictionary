import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/support_screen/pages/feedback_page.dart';
import 'package:amanu/screens/support_screen/pages/report_page.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportScreen extends StatelessWidget {
  SupportScreen({
    super.key,
  });

  final drawerController = Get.find<DrawerXController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Scaffold(
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
              child: Column(
                children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      child: Column(
                        children: [
                          SelectionOption(
                            title: tReportAProblem,
                            image: iWelcomePageAnim,
                            onPressed: () => Get.to(() => ReportProblemPage()),
                          ),
                          SelectionOption(
                            title: tFeedback,
                            image: iWelcomePageAnim,
                            onPressed: () => Get.to(() => FeedbackPage()),
                          ),
                          SelectionOption(
                            title: tRateApp,
                            image: iWelcomePageAnim,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
        ThreePartHeader(
          size: size,
          screenPadding: screenPadding,
          title: tSupport,
        ),
      ],
    ));
  }
}

class SelectionOption extends StatelessWidget {
  SelectionOption({
    super.key,
    required this.title,
    required this.image,
    required this.onPressed,
  });
  final String title;
  final String image;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: InkWell(
        splashColor: primaryOrangeLight,
        highlightColor: primaryOrangeLight.withOpacity(0.5),
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          height: 100,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: pureWhite,
              boxShadow: [
                BoxShadow(
                  color: primaryOrangeDark.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: -8,
                ),
              ]),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Text(
                    title,
                    overflow: TextOverflow.fade,
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: darkGrey.withOpacity(0.8),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(20))),
                  height: double.infinity,
                  child: Image.asset(image),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}