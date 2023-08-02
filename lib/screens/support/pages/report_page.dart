import 'package:amanu/screens/support/controllers/report_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportProblemPage extends StatelessWidget {
  ReportProblemPage({
    super.key,
  });

  final controller = Get.put(ReportController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          splashColor: primaryOrangeLight,
          focusColor: primaryOrangeLight.withOpacity(0.5),
          onPressed: () {
            controller.sendReport();
          },
          label: Text(
            tSendReport.toUpperCase(),
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
                      key: controller.reportFormKey,
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
                                tReportInstructions,
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
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              autofillHints: [AutofillHints.email],
                              onSaved: (value) {
                                controller.email = value!;
                              },
                              validator: (value) {
                                if (value == null || value == '') {
                                  return null;
                                } else {
                                  return controller.validateEmail(value);
                                }
                              },
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.mail_outline),
                                  labelText: tReportEmail,
                                  hintText: tReportEmail,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Divider(
                              thickness: 2,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            DropdownButtonFormField(
                              items: controller.typeDropItems,
                              onChanged: (String? newValue) {
                                controller.typeSelected?.value = newValue!;
                              },
                              onSaved: (value) {
                                controller.reportType = value!;
                              },
                              validator: (value) {
                                if (value == null || value == "") {
                                  return "Please select a problem type.";
                                } else {
                                  return null;
                                }
                              },
                              value: controller.typeSelected?.value,
                              decoration: InputDecoration(
                                  labelText: tReportType + " *",
                                  hintText: tReportType + " *",
                                  hintMaxLines: 5,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              controller: controller.subjectController,
                              onSaved: (value) {
                                controller.subject = value!;
                              },
                              validator: (value) {
                                if (value == null || value.trim() == "") {
                                  return "Please give a brief subject on the report.";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: tReportSubject + " *",
                                  hintText: tReportSubject + " *",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              controller: controller.detailsController,
                              onSaved: (value) {
                                controller.reportDetail = value!;
                              },
                              validator: (value) {
                                if (value == null || value.trim() == "") {
                                  return "Please provide details about the problem.";
                                } else {
                                  return null;
                                }
                              },
                              maxLines: 8,
                              decoration: InputDecoration(
                                  labelText: tReportDetails + " *",
                                  alignLabelWithHint: true,
                                  hintText: tReportDetailsTip,
                                  hintMaxLines: 5,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              tReportAttach,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.poppins(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                color: muteBlack,
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 60.0,
                              child: Stack(
                                children: [
                                  Container(
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      border:
                                          Border.all(color: Color(0xFF9B9B9B)),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 3,
                                          child: Obx(
                                            () => ElevatedButton(
                                              onPressed: () {
                                                controller.selectEmpty.value
                                                    ? controller.selectFile()
                                                    : controller
                                                        .removeSelection();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  minimumSize: Size(
                                                      80.0, double.infinity),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius
                                                          .horizontal(
                                                              left: Radius
                                                                  .circular(
                                                                      20.0)))),
                                              child: Icon(
                                                controller.selectEmpty.value
                                                    ? Icons.attach_file
                                                    : Icons.close,
                                                size: 30.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 8,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            height: 60,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Obx(
                                                () => Text(
                                                  controller.selectedText.value,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 14.0,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: darkGrey,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Obx(() => controller.selectEmpty.value
                                ? Container()
                                : controller.fileAccepted.value
                                    ? Container()
                                    : Container(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 10, 15, 0),
                                        width: double.infinity,
                                        child: Text(
                                          'File must not exceed 10MB.',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.red[700],
                                              fontSize: 11.5),
                                        ))),
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
              title: tReportAProblem,
            ),
          ],
        ));
  }
}
