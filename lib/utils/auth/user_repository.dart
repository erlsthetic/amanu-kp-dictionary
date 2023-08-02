import 'package:amanu/models/report_model.dart';
import 'package:amanu/models/user_model.dart';
import 'package:amanu/utils/auth/helper_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

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

  createReportOnDB(ReportModel report) async {
    await _db.collection("users").add(report.toJson()).whenComplete(() {
      Helper.successSnackBar(
        title: tReportSent,
        message: tReportSentBody,
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
}
