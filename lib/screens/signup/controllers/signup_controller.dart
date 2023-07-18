import 'dart:io';

import 'package:amanu/models/user_model.dart';
import 'package:amanu/screens/signup/account_selection_screen.dart';
import 'package:amanu/utils/auth/authentication_repository.dart';
import 'package:amanu/utils/auth/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();
  final authRepo = Get.find<AuthenticationRepository>();
  final userRepo = Get.put(UserRepository());

  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registrationFormKey = GlobalKey<FormState>();

  RxBool isObscure = true.obs;
  RxBool isContributor = true.obs;

  String uid = '';
  var email = '';
  var password = '';
  var userType = 0;
  var userName = '';
  var phoneNo = '';
  var exFullName = '';
  var exBio = '';
  var cvUrl = '';
  var profileUrl = '';

  bool emailAlreadyInUse = false;
  bool userNameAlreadyInUse = false;

  late TextEditingController emailController,
      passwordController,
      userNameController,
      phoneNoController,
      exFullNameController,
      exBioController;

  @override
  void onInit() {
    super.onInit();

    emailController = TextEditingController();
    passwordController = TextEditingController();
    userNameController = TextEditingController();
    phoneNoController = TextEditingController();

    exFullNameController = TextEditingController();
    exBioController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    passwordController.dispose();
    userNameController.dispose();
    phoneNoController.dispose();

    exFullNameController.dispose();
    exBioController.dispose();
  }

//Validation
  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "Enter a valid email";
    } else if (emailAlreadyInUse) {
      print("${emailController} found on system.");
      return "Email already in use";
    }
    return null;
  }

  Future checkEmail() async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: emailController.text)
        .get();

    if (query.docs.length == 0) {
      emailAlreadyInUse = false;
    } else {
      emailAlreadyInUse = true;
    }
  }

  String? validatePassword(String value) {
    final RegExp hasUppercase = RegExp(r'[A-Z]');
    final RegExp hasDigits = RegExp(r'[0-9]');
    final RegExp hasSpecialCharacters = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    if (value.isEmpty) {
      return "Enter a valid password";
    } else if (passwordController.text.length < 8) {
      return "Password should be at least 8 characters in length";
    } else if (hasSpecialCharacters.hasMatch(passwordController.text)) {
      return "Password should not contain special characters";
    } else if (!hasUppercase.hasMatch(passwordController.text)) {
      return "Password should have at least one UPPERCASE character";
    } else if (!hasDigits.hasMatch(passwordController.text)) {
      return "Password should have at least one digit";
    }
    return null;
  }

  String? validateUserName(String value) {
    if (userNameController.text.isEmpty) {
      return "Enter a valid username";
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

/*
  Future checkEmailAvailability() async {
    final isValid = signUpFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: emailController.text)
        .get();

    bool emailAvailable;
    if (query.docs.length == 0) {
      emailAvailable = true;
    } else {
      emailAvailable = false;
    }

    if (emailAvailable) {
      signUpFormKey.currentState!.save();
      Get.to(() => AccountSelectionScreen());
    } else {
      Get.snackbar(
          "Email is already in use", "Use other email or login instead.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.5),
          colorText: pureWhite);
    }
  }
*/
  void checkCredentials() {
    final isValid = signUpFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    signUpFormKey.currentState!.save();
    Get.to(() => AccountSelectionScreen());
  }

  void checkRegistration() {
    final isValid = registrationFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    registrationFormKey.currentState!.save();

    print("Email: ${email}");
    print("Password: ${password}");
    print("Account type: ${userType}");
    print("Username: ${userName}");
    print("Fullname: ${exFullName}");
    print("Phone No: +63 ${phoneNo}");
    print("Bio: ${exBio}");
    print("Ready to Register.");
    //Get.to(() => AccountSelectionScreen());
  }

// CV Select
  PlatformFile? pickedFile = null;
  RxBool selectEmpty = true.obs;
  RxBool cvError = false.obs;
  RxBool fileAccepted = false.obs;
  RxString selectedText = 'No file selected.'.obs;

  Future<void> selectCV() async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf', 'doc', 'docx'],
      type: FileType.custom,
    );
    if (result != null) {
      final _file = File(result.files.first.path!);
      if ((_file.lengthSync() / (1024 * 1024)) < 10) {
        pickedFile = result.files.first;
        fileAccepted.value = true;
        selectEmpty.value = false;
        cvError.value = false;
        selectedText.value = pickedFile!.name.toString();
      } else {
        pickedFile = result.files.first;
        selectEmpty.value = false;
        selectedText.value = pickedFile!.name.toString();
        fileAccepted.value = false;
        cvError.value = false;
      }
    } else {
      cvError.value = true;
      return;
    }
  }

  void removeSelection() {
    pickedFile = null;
    selectEmpty.value = true;
    fileAccepted.value = false;
    selectedText.value = 'No file selected.';
  }

  Future<void> uploadCV(String uid) async {
    final path = 'users/${uid}/cv/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    await ref.getDownloadURL().then((downloadUrl) {
      cvUrl = downloadUrl;
    });
  }

  Future<void> registerUser() async {
    if (selectEmpty.value == true) {
      cvError.value = true;
    }
    final credentialsValid = signUpFormKey.currentState!.validate();
    final registrationValid = registrationFormKey.currentState!.validate();
    if (!registrationValid ||
        !credentialsValid ||
        cvError.value == true ||
        fileAccepted == false ||
        selectEmpty == true) {
      return;
    }
    signUpFormKey.currentState!.save();
    registrationFormKey.currentState!.save();

    String? error = await AuthenticationRepository.instance
        .createUserWithEmailAndPassword(email, password);
    if (error != null) {
      Get.showSnackbar(GetSnackBar(
        message: error.toString(),
      ));
    } else {
      uid = authRepo.firebaseUser.value!.uid;

      await uploadCV(uid);

      final userData = UserModel(
          uid: uid,
          email: email.trim(),
          phoneNo: int.parse(phoneNo.trim()),
          isExpert: userType == 1 ? true : false,
          userName: userName.trim(),
          exFullName: exFullName == '' ? null : exFullName.trim(),
          exBio: exBio == '' ? null : exBio.trim(),
          cvUrl: cvUrl == '' ? null : cvUrl,
          profileUrl: null);

      await userRepo.createUserOnDB(userData, uid);
    }
  }
}
