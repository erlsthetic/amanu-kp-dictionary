import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/screens/support_screen/pages/about_page.dart';
import 'package:amanu/screens/support_screen/pages/expert_requests_page.dart';
import 'package:amanu/screens/support_screen/pages/feedback_page.dart';
import 'package:amanu/screens/support_screen/pages/feedbacks_page.dart';
import 'package:amanu/screens/support_screen/pages/problem_reports_page.dart';
import 'package:amanu/screens/support_screen/pages/report_page.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SupportScreen extends StatelessWidget {
  SupportScreen({
    super.key,
  });

  final drawerController = Get.find<DrawerXController>();
  final appController = Get.find<ApplicationController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.only(bottom: screenPadding.bottom),
      child: Scaffold(
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
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    child: Column(
                      children: [
                        appController.userIsAdmin ?? false
                            ? SelectionOption(
                                title: tExpertRequests,
                                image: iExpertRequests,
                                onPressed: () {
                                  if (appController.hasConnection.value) {
                                    Get.to(() => ExpertRequestsPage(),
                                        duration: Duration(milliseconds: 500),
                                        transition: Transition.rightToLeft,
                                        curve: Curves.easeInOut); //TODO
                                  } else {
                                    appController.showConnectionSnackbar();
                                  }
                                })
                            : Container(),
                        appController.userIsAdmin ?? false
                            ? SelectionOption(
                                title: tProblemReports,
                                image: iProblemReports,
                                onPressed: () {
                                  if (appController.hasConnection.value) {
                                    Get.to(() => ProblemReportsPage(),
                                        duration: Duration(milliseconds: 500),
                                        transition: Transition.rightToLeft,
                                        curve: Curves.easeInOut); //TODO
                                  } else {
                                    appController.showConnectionSnackbar();
                                  }
                                })
                            : SelectionOption(
                                title: tReportAProblem,
                                image: iReportAProblem,
                                onPressed: () {
                                  if (appController.hasConnection.value) {
                                    Get.to(() => ReportProblemPage(),
                                        duration: Duration(milliseconds: 500),
                                        transition: Transition.rightToLeft,
                                        curve: Curves.easeInOut);
                                  } else {
                                    appController.showConnectionSnackbar();
                                  }
                                }),
                        appController.userIsAdmin ?? false
                            ? SelectionOption(
                                title: tFeedbacks,
                                image: iFeedbacks,
                                onPressed: () {
                                  if (appController.hasConnection.value) {
                                    Get.to(() => FeedbacksPage(),
                                        duration: Duration(milliseconds: 500),
                                        transition: Transition.rightToLeft,
                                        curve: Curves.easeInOut); //TODO
                                  } else {
                                    appController.showConnectionSnackbar();
                                  }
                                })
                            : SelectionOption(
                                title: tFeedback,
                                image: iFeedback,
                                onPressed: () {
                                  if (appController.hasConnection.value) {
                                    Get.to(() => FeedbackPage(),
                                        duration: Duration(milliseconds: 500),
                                        transition: Transition.rightToLeft,
                                        curve: Curves.easeInOut);
                                  } else {
                                    appController.showConnectionSnackbar();
                                  }
                                }),
                        SelectionOption(
                          title: tRateApp,
                          image: iRateAmanu,
                          onPressed: () {
                            if (appController.hasConnection.value) {
                            } else {
                              appController.showConnectionSnackbar();
                            }
                          },
                        ),
                        SelectionOption(
                          title: tAboutAmanu,
                          image: iAboutAmanu,
                          onPressed: () => Get.to(() => AboutPage(),
                              duration: Duration(milliseconds: 500),
                              transition: Transition.rightToLeft,
                              curve: Curves.easeInOut),
                        ),
                      ],
                    ),
                  ),
                )),
          ),
          ThreePartHeader(
            size: size,
            screenPadding: screenPadding,
            title: tSupport,
            firstIcon: Icons.menu_rounded,
            firstOnPressed: () {
              drawerController.drawerToggle(context);
              drawerController.currentItem.value = DrawerItems.support;
            },
            secondIconDisabled: true,
          ),
        ],
      )),
    );
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
                  child: SvgPicture.asset(image),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
