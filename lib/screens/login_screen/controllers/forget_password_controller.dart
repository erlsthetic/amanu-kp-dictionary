import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/authentication_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  static ResetPasswordController get instance => Get.find();
  late TextEditingController emailController;
  final GlobalKey<FormState> resetFormKey = GlobalKey<FormState>();

  final appController = Get.find<ApplicationController>();

  var resetEmail = '';

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
  }

  bool userFound = false;

  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "Enter a valid email";
    } else if (!userFound) {
      return "User not found. Please check email provided.";
    }
    return null;
  }

  Future checkUserExists() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: emailController.text)
        .get();

    if (query.docs.length == 0) {
      userFound = false;
    } else {
      userFound = true;
    }
  }

  Future sendResetEmail() async {
    final credentialsValid = resetFormKey.currentState!.validate();
    if (!credentialsValid) {
      return;
    }
    resetFormKey.currentState!.save();

    String rEmail = resetEmail.toLowerCase().trim();

    if (appController.hasConnection.value) {
      await AuthenticationRepository.instance.resetPassword(rEmail);
    } else {
      appController.showConnectionSnackbar();
    }
  }
}
