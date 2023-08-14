import 'package:amanu/models/feedback_model.dart';
import 'package:amanu/models/report_model.dart';
import 'package:amanu/models/user_model.dart';
import 'package:amanu/utils/auth/helper_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseRepository extends GetxController {
  static DatabaseRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _realtimeDB = FirebaseDatabase.instance.ref();

  createUserOnDB(UserModel user, String uid) async {
    await _db.collection("users").doc(uid).set(user.toJson()).whenComplete(() {
      Helper.successSnackBar(
        title: tSuccess,
        message: tAccountCreated,
      );
      // ignore: body_might_complete_normally_catch_error
    }).catchError((error, stackTrace) {
      Helper.errorSnackBar(
        title: tOhSnap,
        message: tSomethingWentWrong,
      );
      print(error.toString());
    });
  }

  Future<UserModel> getUserDetails(String uid) async {
    final snapshot =
        await _db.collection("users").where("uid", isEqualTo: uid).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<String> getWordOfTheDay() async {
    final snapshot = await _db.collection("amanu").doc("wordOfTheDay").get();
    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data();
      return data?["wordOfTheDay"];
    } else {
      return "amanu";
    }
  }

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
