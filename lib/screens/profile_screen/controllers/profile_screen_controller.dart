import 'dart:io';

import 'package:amanu/models/user_model.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  ProfileController({required this.isOtherProfile, this.userID});
  late TextEditingController userNameController,
      phoneNoController,
      exFullNameController,
      exBioController;

  final GlobalKey<FormState> editAccountFormKey = GlobalKey<FormState>();
  final bool isOtherProfile;
  final String? userID;
  final appController = Get.find<ApplicationController>();

  var newUserName = '';
  var newPhoneNo = '';
  var newExFullName = '';
  var newExBio = '';
  Rx<File?>? newProfile = null.obs;
  bool newExpReq = false;

  RxString userName = ''.obs,
      userEmail = ''.obs,
      userFullName = ''.obs,
      userBio = ''.obs,
      userPic = ''.obs;
  RxBool userIsExpert = false.obs, userExpertRequest = false.obs;
  int userPhoneNo = 0;
  List<String> userContributions = [];
  String contributionCount = '';
  bool userNotFound = true;

  bool userNameAlreadyInUse = false;

  @override
  void onInit() async {
    super.onInit();
    userNameController = TextEditingController();
    phoneNoController = TextEditingController();
    exFullNameController = TextEditingController();
    exBioController = TextEditingController();
    if (isOtherProfile) {
      await getUserDetails();
      if (userContributions.length > 0) {
        contributionCount = userContributions.length.toString();
      } else {
        contributionCount = '';
      }
    } else {
      userName.value = appController.userName ?? '';
      userEmail.value = appController.userEmail ?? '';
      userPhoneNo = appController.userPhone ?? 0;
      userIsExpert.value = appController.userIsExpert ?? false;
      userExpertRequest.value = appController.userExpertRequest ?? false;
      userPic.value = appController.userPicLocal ?? '';
      userFullName.value = appController.userFullName ?? '';
      userBio.value = appController.userBio ?? '';
      userContributions = appController.userContributions ?? [];
      if (appController.userContributions != null &&
          appController.userContributions!.length > 0) {
        contributionCount = appController.userContributions!.length.toString();
      } else {
        contributionCount = '';
      }
      userNotFound = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    userNameController.dispose();
    phoneNoController.dispose();
    exFullNameController.dispose();
    exBioController.dispose();
  }

  void populateFields() {
    userName.value != '' ? userNameController.text = userName.value : null;
    userPhoneNo != 0 ? phoneNoController.text = userPhoneNo.toString() : null;
    userFullName.value != ''
        ? exFullNameController.text = userFullName.value
        : null;
    userBio.value != '' ? exBioController.text = userBio.value : null;
    newUserName = '';
    newPhoneNo = '';
    newExFullName = '';
    newExBio = '';
    newProfile = null;
    newExpReq = false;
  }

  Future getUserDetails() async {
    if (userID == null) {
      Get.back();
      Helper.errorSnackBar(
          title: tOhSnap, message: "Unable to get user details.");
    }
    try {
      UserModel user =
          await DatabaseRepository.instance.getUserDetails(userID!);
      userName.value = user.userName;
      userEmail.value = user.email;
      userPhoneNo = user.phoneNo;
      userIsExpert.value = user.isExpert;
      userExpertRequest.value = user.expertRequest;
      userPic.value = user.profileUrl ?? '';
      if (user.isExpert) {
        userFullName.value = user.exFullName ?? '';
        userBio.value = user.exBio ?? '';
      }
      userContributions = user.contributions == null
          ? []
          : user.contributions!.map((e) => e.toString()).toList();
      userNotFound = false;
    } catch (e) {
      userNotFound = true;
      contributionCount = '';
    }

    print("User not found: " + userNotFound.toString());
  }

  String? validateUserName(String value) {
    if (userNameController.text.isEmpty) {
      return "Enter a valid username";
    } else if (userNameController.text == userName.value) {
    } else if (userNameAlreadyInUse) {
      return "Username already in use";
    }
    return null;
  }

  Future checkUserName() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: userNameController.text)
        .get();

    if (query.docs.length == 0) {
      userNameAlreadyInUse = false;
    } else {
      userNameAlreadyInUse = true;
    }
  }

  String? validatePhone(String value) {
    if (phoneNoController.text.length != 10) {
      return "Enter a valid 10-digit number";
    }
    return null;
  }

  String? validateExFullName(String value) {
    final nameRegExp =
        new RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    if (exFullNameController.text.isEmpty) {
      return "Enter a valid name";
    } else if (!nameRegExp.hasMatch(exFullNameController.text)) {
      return "Enter a valid name";
    }
    return null;
  }

  String? validateBio(String value) {
    if (exBioController.text.isEmpty) {
      return "Please describe your self and profession.";
    }
    return null;
  }
}
