import 'package:amanu/components/info_dialog.dart';
import 'package:amanu/components/loader_dialog.dart';
import 'package:amanu/models/report_model.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ProblemReportsController extends GetxController
    with GetTickerProviderStateMixin {
  static ProblemReportsController get instance => Get.find();
  final appController = Get.find<ApplicationController>();
  RxList<ReportModel> reports = <ReportModel>[].obs;
  RxBool isVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
    if (appController.hasConnection.value) {
      getReports();
    } else {
      appController.showConnectionSnackbar();
    }
  }

  Future getReports() async {
    var snapshot = await DatabaseRepository.instance.getAllReports();
    reports.clear();
    for (ReportModel i in snapshot) {
      reports.add(i);
    }
    reports.refresh();
  }

  Future resolveProblem(String timestamp, String problemType, String subject,
      BuildContext context) async {
    showLoaderDialog(context);
    await DatabaseRepository.instance
        .deleteReportOnDB(problemType, subject, timestamp)
        .then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  void openReport(BuildContext context, String timestamp, String problemType,
      String? email, String subject, String details, String? imgUrl) async {
    TransformationController? transController = TransformationController();
    Animation<Matrix4>? anim;
    AnimationController zoomAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            if (transController == null)
              transController = TransformationController();
            transController!.value = anim!.value;
          });
    ;

    showInfoDialog(
        context,
        timestamp,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.topLeft,
              height: 14,
              child: Text(
                problemType.toUpperCase(),
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: disabledGrey,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                "[SUBJECT] " + subject,
                style: GoogleFonts.roboto(
                    fontSize: 18, color: cardText, fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Text(
                details,
                style: GoogleFonts.roboto(
                    fontSize: 16,
                    color: cardText,
                    fontWeight: FontWeight.normal),
              ),
            ),
            imgUrl != null
                ? Container(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: InteractiveViewer(
                      clipBehavior: Clip.none,
                      transformationController: transController,
                      onInteractionStart: (details) {
                        isVisible.value = false;
                      },
                      onInteractionEnd: (details) {
                        if (transController == null)
                          transController = TransformationController();
                        anim = Matrix4Tween(
                                begin: transController!.value,
                                end: Matrix4.identity())
                            .animate(CurveTween(curve: Curves.easeOut)
                                .animate(zoomAnimController));
                        zoomAnimController.forward(from: 0);
                        isVisible.value = true;
                      },
                      minScale: 1,
                      maxScale: 5,
                      panEnabled: false,
                      child: Image.network(
                        imgUrl,
                        errorBuilder: (context, error, stackTrace) {
                          return Shimmer.fromColors(
                              child: Container(
                                height: double.infinity,
                                width: double.infinity,
                              ),
                              baseColor: disabledGrey,
                              highlightColor: lightGrey);
                        },
                      ),
                    ),
                  )
                : Container(),
            SizedBox(
              height: 15,
            ),
            Obx(
              () => isVisible.value
                  ? Container(
                      alignment: Alignment.center,
                      height: 22,
                      child: Text(
                        timestamp,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: disabledGrey,
                            fontWeight: FontWeight.w400),
                      ),
                    )
                  : Container(height: 22),
            ),
            SizedBox(
              height: 10,
            ),
          ]),
        ),
        Container(
          height: 70,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            children: [
              Obx(
                () => Visibility(
                  visible: isVisible.value,
                  child: Expanded(
                    child: Material(
                      borderRadius: BorderRadius.circular(25),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () async {
                          await resolveProblem(
                              timestamp, problemType, subject, context);
                          if (transController != null)
                            transController!.dispose();
                          zoomAnimController.dispose();
                          getReports();
                        },
                        splashColor: primaryOrangeLight,
                        highlightColor: primaryOrangeLight.withOpacity(0.5),
                        child: Ink(
                          height: 50.0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "RESOLVE".toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: pureWhite,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: primaryOrangeDark,
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ), () {
      if (transController != null) transController!.dispose();
      zoomAnimController.dispose();
    }, isVisible);
  }
}
