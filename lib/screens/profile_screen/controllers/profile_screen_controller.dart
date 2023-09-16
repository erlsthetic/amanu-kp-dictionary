import 'dart:io';

import 'package:amanu/models/user_model.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/utils/image_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

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
  final imageHelper = Get.put(ImageHelper());

  var newUserName = '';
  var newPhoneNo = '';
  var newExFullName = '';
  var newExBio = '';
  File newProfile = File("");
  RxString newProfilePath = ''.obs;
  bool newExpertRequest = false;
  RxBool newEmailPublic = false.obs;
  RxBool newPhonePublic = false.obs;

  RxString userName = ''.obs,
      userEmail = ''.obs,
      userFullName = ''.obs,
      userBio = ''.obs,
      userPic = ''.obs;
  RxBool userIsExpert = false.obs,
      userIsAdmin = false.obs,
      userExpertRequest = false.obs,
      userEmailPublic = false.obs,
      userPhonePublic = false.obs;
  RxInt userPhoneNo = 0.obs;
  List<String> userContributions = [];
  String contributionCount = '';
  RxBool userNotFound = true.obs;
  RxBool isProcessing = false.obs;
  RxBool userNameAlreadyInUse = false.obs;

  @override
  void onInit() async {
    super.onInit();
    userNameController = TextEditingController();
    phoneNoController = TextEditingController();
    exFullNameController = TextEditingController();
    exBioController = TextEditingController();
    if (isOtherProfile) {
      await getUserDetails();
    } else {
      getCurrentUserDetails();
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

  void getCurrentUserDetails() {
    isProcessing.value = true;
    userName.value = appController.userName ?? '';
    userEmail.value = appController.userEmail ?? '';
    userPhoneNo.value = appController.userPhone ?? 0;
    userIsExpert.value = appController.userIsExpert ?? false;
    userIsAdmin.value = appController.userIsAdmin ?? false;
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
    userEmailPublic.value = appController.userEmailPublic ?? false;
    userPhonePublic.value = appController.userPhonePublic ?? false;
    userNotFound.value = false;
    isProcessing.value = false;
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
    newProfilePath.value = '';
    newExpertRequest = userExpertRequest.value;
    newEmailPublic.value = userEmailPublic.value;
    newPhonePublic.value = userPhonePublic.value;
  }

  Future getUserDetails() async {
    if (userID == null) {
      Get.back();
      Helper.errorSnackBar(
          title: tOhSnap, message: "Unable to get user details.");
    }
    try {
      isProcessing.value = true;
      UserModel? user =
          await DatabaseRepository.instance.getUserDetails(userID!);
      if (user != null) {
        print("User found.");
        userName.value = user.userName;
        userEmail.value = user.email;
        userPhoneNo.value = user.phoneNo;
        userIsExpert.value = user.isExpert;
        userIsAdmin.value = user.isAdmin;
        userEmailPublic.value = user.emailPublic;
        userPhonePublic.value = user.phonePublic;
        userExpertRequest.value = user.expertRequest;
        userPic.value = user.profileUrl ?? '';
        if (user.isExpert) {
          userFullName.value = user.exFullName ?? '';
          userBio.value = user.exBio ?? '';
        }
        userContributions = user.contributions == null
            ? []
            : user.contributions!.map((e) => e.toString()).toList();
        userNotFound.value = false;
        if (userContributions.length > 0) {
          contributionCount = userContributions.length.toString();
        } else {
          contributionCount = '';
        }
      } else {
        userNotFound.value = true;
        contributionCount = '';
      }
    } catch (e) {
      userNotFound.value = true;
      contributionCount = '';
    }
    isProcessing.value = false;
  }

  String? validateUserName(String value) {
    if (userNameController.text.isEmpty) {
      return "Enter a valid username";
    } else if (userNameController.text == userName.value) {
    } else if (userNameAlreadyInUse.value) {
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
      userNameAlreadyInUse.value = false;
    } else {
      userNameAlreadyInUse.value = true;
    }
  }

  String? validatePhone(String value) {
    if (phoneNoController.text.length != 10) {
      return "Enter a valid 10-digit number";
    } else if (int.tryParse(phoneNoController.text) == null) {
      return "Must only contain numbers";
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

  Future getUserPhoto(ImageSource imageSource) async {
    final files = await imageHelper.pickImage(source: imageSource);
    if (files.isNotEmpty) {
      final croppedFile = await imageHelper.cropImage(
          file: files.first!, cropStyle: CropStyle.circle);
      if (croppedFile != null) {
        newProfilePath.value = croppedFile.path;
        newProfile = File(croppedFile.path);
      }
    }
  }

  Future updateUserDetails() async {
    if (appController.hasConnection.value) {
      if (!isOtherProfile) {
        bool editFormIsValid = editAccountFormKey.currentState!.validate();
        if (!editFormIsValid) {
          return;
        }
        editAccountFormKey.currentState!.save();

        String newUserPicURL = '';
        if (newProfilePath.value != '') {
          try {
            newUserPicURL = (await DatabaseRepository.instance.uploadPic(
                appController.userID!, newProfilePath.value, false))!;
            print("Profile uploaded at: " + newUserPicURL.toString());
          } catch (e) {
            Helper.errorSnackBar(
                title: tOhSnap,
                message:
                    "Unable to upload image. Please check your internet connection or contact support for help.");
            return;
          }
        }

        Map<String, dynamic> userChanges = {};
        if (newPhoneNo != '' &&
            int.tryParse(newPhoneNo) != appController.userPhone) {
          userChanges["phoneNo"] = newPhoneNo != ''
              ? int.tryParse(newPhoneNo) ?? 0
              : appController.userPhone;
        }
        if (newExpertRequest != appController.userExpertRequest) {
          userChanges["expertRequest"] = newExpertRequest;
        }
        if (newUserName != '' && newUserName != appController.userName) {
          userChanges["userName"] =
              newUserName != '' ? newUserName : appController.userName;
        }
        if (newExFullName != '' &&
            newExFullName != appController.userFullName) {
          userChanges["exFullName"] =
              newExFullName != '' ? newExFullName : appController.userFullName;
        }
        if (newExBio != '' && newExBio != appController.userBio) {
          userChanges["exBio"] =
              newExBio != '' ? newExBio : appController.userBio;
        }
        if (newUserPicURL != '') {
          userChanges["profileUrl"] =
              newUserPicURL != '' ? newUserPicURL : appController.userPic;
        }
        if (newEmailPublic.value != appController.userEmailPublic) {
          userChanges["emailPublic"] = newEmailPublic.value;
        }
        if (newPhonePublic.value != appController.userPhonePublic) {
          userChanges["phonePublic"] = newPhonePublic.value;
        }

        print("User changes: " + userChanges.toString());

        if (userChanges.length <= 0) {
          Helper.successSnackBar(
              title: "No change detected.",
              message: "Account details remained the same.");
        } else {
          await DatabaseRepository.instance
              .updateUserOnDB(userChanges, appController.userID!)
              .then((value) async {
            await appController.changeLoginState(true);
            await appController
                .changeUserDetails(
              appController.userID,
              userChanges.containsKey("userName")
                  ? userChanges["userName"]
                  : appController.userName,
              appController.userEmail,
              userChanges.containsKey("phoneNo")
                  ? userChanges["phoneNo"]
                  : appController.userPhone,
              appController.userIsExpert,
              userChanges.containsKey("expertRequest")
                  ? userChanges["expertRequest"]
                  : appController.userExpertRequest,
              userChanges.containsKey("exFullName")
                  ? userChanges["exFullName"]
                  : appController.userFullName,
              userChanges.containsKey("exBio")
                  ? userChanges["exBio"]
                  : appController.userBio,
              userChanges.containsKey("profileUrl")
                  ? userChanges["profileUrl"]
                  : appController.userPic,
              appController.userContributions,
              userChanges.containsKey("profileUrl")
                  ? await appController
                      .saveUserPicToLocal(userChanges["profileUrl"])
                  : appController.userPicLocal,
              userChanges.containsKey("emailPublic")
                  ? userChanges["emailPublic"]
                  : appController.userEmailPublic,
              userChanges.containsKey("phonePublic")
                  ? userChanges["phonePublic"]
                  : appController.userPhonePublic,
              appController.userIsAdmin,
            )
                .then((value) {
              appController.update();
              getCurrentUserDetails();
            });
          });
        }
      }
    } else {
      appController.showConnectionSnackbar();
    }
  }
}
