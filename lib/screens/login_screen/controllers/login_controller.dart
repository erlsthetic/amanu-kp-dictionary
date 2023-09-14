import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/authentication_repository.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final authRepo = Get.find<AuthenticationRepository>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final appController = Get.find<ApplicationController>();

  RxBool isObscure = true.obs;
  RxBool isContributor = true.obs;

  RxBool isProcessing = false.obs;
  RxBool isGoogleLoading = false.obs;

  late TextEditingController emailController, passwordController;

  var email = '';
  var password = '';

  bool userFound = false;

  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "Enter a valid email";
    } else if (!userFound) {
      return "User not found. Please sign up instead.";
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

  Future<void> userSignIn() async {
    isProcessing.value = true;
    if (appController.hasConnection.value) {
      final credentialsValid = loginFormKey.currentState!.validate();
      if (!credentialsValid) {
        return;
      }
      loginFormKey.currentState!.save();
      Map<String, String>? error = await AuthenticationRepository.instance
          .logInUserWithEmailAndPassword(email, password);
      if (error != null) {
        Helper.errorSnackBar(title: error["title"], message: error["message"]);
      }
    } else {
      appController.showConnectionSnackbar();
    }
    isProcessing.value = false;
  }

  Future<void> googleSignIn() async {
    if (appController.hasConnection.value) {
      try {
        isGoogleLoading.value = true;
        Map<String, String>? error =
            await AuthenticationRepository.instance.signInWithGoogle();
        if (error != null) {
          Helper.errorSnackBar(
              title: error["title"], message: error["message"]);
        }
        isGoogleLoading.value = false;
      } catch (e) {
        isGoogleLoading.value = false;
      }
    } else {
      appController.showConnectionSnackbar();
    }
  }

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }
}
