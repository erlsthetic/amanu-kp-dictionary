import 'package:amanu/models/report_model.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseRepository extends GetxController {
  static DatabaseRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createReportOnDB(ReportModel report) async {
    await _db.collection("users").add(report.toJson()).whenComplete(() {
      Get.snackbar("Report has been sent.",
          "We'll try our best to resolve this immediately.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryOrangeDark.withOpacity(0.5),
          colorText: pureWhite);
      // ignore: body_might_complete_normally_catch_error
    }).catchError((error, stackTrace) {
      Get.snackbar("Error", "Something went wrong. Please try again.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.5),
          colorText: muteBlack);
      print(error.toString());
    });
  }
}
