import 'package:amanu/models/feedback_model.dart';
import 'package:amanu/models/report_model.dart';
import 'package:amanu/utils/auth/helper_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseRepository extends GetxController {
  static DatabaseRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  final _realtimeDB = FirebaseDatabase.instance.ref();

  createReportOnDB(ReportModel report, String timestamp) async {
    await _db
        .collection("reports")
        .doc(timestamp)
        .set(report.toJson())
        .whenComplete(() {
      Get.back();
      Helper.successSnackBar(title: tReportSent, message: tReportSentBody);
    }).catchError((error, stackTrace) {
      Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
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
      Helper.successSnackBar(title: tFeedbackSent, message: tFeedbackSentBody);
    }).catchError((error, stackTrace) {
      Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
      print(error.toString());
    });
  }

  addWordOnDB(String word, Map details) async {
    await _realtimeDB
        .child("dictionary")
        .child(word)
        .set(details)
        .whenComplete(() {
      Helper.successSnackBar(title: tSuccess, message: tAddSuccess);
    }).catchError((error, stackTrace) {
      Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
  }

  updateWordOnDB(String word, Map details) async {
    await _realtimeDB
        .child("dictionary")
        .child(word)
        .set(details)
        .whenComplete(() {
      Helper.successSnackBar(title: tSuccess, message: tEditSuccess);
    }).catchError((error, stackTrace) {
      Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
  }

  removeWordOnDB(String word, Map details) async {
    await _realtimeDB.child("dictionary").child(word).remove().whenComplete(() {
      Helper.successSnackBar(title: tSuccess, message: tDeleteSuccess);
    }).catchError((error, stackTrace) {
      Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
  }
}
