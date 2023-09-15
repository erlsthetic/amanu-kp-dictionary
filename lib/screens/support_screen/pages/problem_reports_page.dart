import 'package:amanu/screens/support_screen/controllers/problem_reports_controller.dart';
import 'package:amanu/screens/support_screen/widgets/expert_request_card.dart';
import 'package:amanu/screens/support_screen/widgets/problem_report_card.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProblemReportsPage extends StatelessWidget {
  ProblemReportsPage({
    super.key,
  });

  final controller = Get.put(ProblemReportsController());
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
              child: appController.hasConnection.value
                  ? FutureBuilder(
                      future: controller.getReports(),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done)
                          return Container(
                            height: size.height - 110,
                            width: size.width,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        else
                          return Container(
                            height: size.height - 110,
                            width: size.width,
                            child: controller.reports.length != 0
                                ? ListView.builder(
                                    physics: BouncingScrollPhysics(),
                                    padding:
                                        EdgeInsets.only(top: 30, bottom: 50),
                                    itemCount: controller.reports.length,
                                    itemBuilder: (context, index) {
                                      return ProblemReportCard(
                                          timestamp: controller
                                              .reports[index].timestamp,
                                          subject:
                                              controller.reports[index].subject,
                                          details:
                                              controller.reports[index].details,
                                          problemType: controller
                                              .reports[index].problemType,
                                          email:
                                              controller.reports[index].email,
                                          onTap: () {},
                                          imgUrl:
                                              controller.reports[index].imgUrl);
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      "No problem reports at the moment.",
                                      style: TextStyle(
                                          fontSize: 16, color: disabledGrey),
                                    ),
                                  ),
                          );
                      },
                    )
                  : Container(
                      height: size.height - 110,
                      width: size.width,
                      child: Center(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.signal_wifi_connected_no_internet_4_rounded,
                            color: disabledGrey,
                            size: 40,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "No internet connection.",
                            style: TextStyle(color: disabledGrey, fontSize: 16),
                          )
                        ],
                      )),
                    )),
          ThreePartHeader(
            size: size,
            screenPadding: screenPadding,
            title: tExpertRequests,
          ),
        ],
      )),
    );
  }
}
