import 'package:amanu/models/feedback_model.dart';
import 'package:amanu/models/report_model.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseRepository extends GetxController {
  static DatabaseRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createReportOnDB(ReportModel report, String timestamp) async {
    await _db
        .collection("reports")
        .doc(timestamp)
        .set(report.toJson())
        .whenComplete(() {
      Get.back();
      Get.snackbar("Report has been sent.",
          "We'll try our best to resolve this immediately.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryOrangeDark.withOpacity(0.5),
          colorText: pureWhite);
    }).catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.5),
          colorText: muteBlack);
      print(error.toString());
    });
  }

  createFeedbackOnDB(FeedbackModel feedback, String timestamp) async {
    await _db
        .collection("feedbacks")
        .doc(timestamp)
        .set(feedback.toJson())
        .whenComplete(() {
      Get.back();
      Get.snackbar("Report has been sent.",
          "We'll try our best to resolve this immediately.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryOrangeDark.withOpacity(0.5),
          colorText: pureWhite);
    }).catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.5),
          colorText: muteBlack);
      print(error.toString());
    });
  }
}
