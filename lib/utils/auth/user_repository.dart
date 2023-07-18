import 'package:amanu/models/user_model.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  createUserOnDB(UserModel user, String uid) async {
    await _db.collection("users").doc(uid).set(user.toJson()).whenComplete(() {
      Get.snackbar("Success",
          "Account has been created. Check email and verify your account.",
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
