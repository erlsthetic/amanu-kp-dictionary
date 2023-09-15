import 'package:amanu/screens/support_screen/controllers/report_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProblemReportsPage extends StatelessWidget {
  ProblemReportsPage({
    super.key,
  });

  final controller = Get.put(ReportController());

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
                    physics: BouncingScrollPhysics(), child: Container())),
          ),
          ThreePartHeader(
            size: size,
            screenPadding: screenPadding,
            title: tProblemReports,
          ),
        ],
      )),
    );
  }
}
