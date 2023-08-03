import 'package:amanu/utils/auth/authentication_repository.dart';
import 'package:amanu/utils/auth/helper_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  final authRepo = Get.find<AuthenticationRepository>();
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  RxBool isObscure = true.obs;
  RxBool isContributor = true.obs;

  RxBool isLoading = false.obs;
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

  Future<void> googleSignIn() async {
    try {
      isGoogleLoading.value = true;
      await AuthenticationRepository.instance.signInWithGoogle();
      isGoogleLoading.value = true;
      //Get.to(() => AccountSelectionScreen());
    } catch (e) {
      isGoogleLoading.value = false;
      Helper.errorSnackBar(title: tOhSnap, message: e.toString());
    }
  }

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }
}
