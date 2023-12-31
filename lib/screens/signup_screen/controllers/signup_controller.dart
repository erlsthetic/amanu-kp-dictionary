import 'dart:io';

import 'package:amanu/components/info_dialog.dart';
import 'package:amanu/models/user_model.dart';
import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/drawer_launcher.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/screens/signup_screen/account_selection_screen.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/authentication_repository.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();
  final authRepo = Get.find<AuthenticationRepository>();
  final appController = Get.find<ApplicationController>();
  final dbRepo = Get.put(DatabaseRepository());

  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registrationFormKey = GlobalKey<FormState>();

  RxBool isObscure = true.obs;
  RxBool isContributor = true.obs;

  RxBool isProcessing = false.obs;
  RxBool isGoogleLoading = false.obs;
  bool accountFromGoogle = false;

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

  void showPrivacyPolicy(BuildContext context) {
    showInfoDialog(
        context,
        tPrivacyPolicy,
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: EdgeInsets.only(bottom: 10),
              height: 150,
              width: double.infinity,
              child: SvgPicture.asset(iPrivacyPolicy),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                tPrivacyPolicyHeader,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: primaryOrangeDark,
                    height: 1.1),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                tPrivacyPolicyBody,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: cardText),
              ),
            ),
          ]),
        ),
        null,
        null,
        true.obs);
  }

//Validation
  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "Enter a valid email";
    } else if (emailAlreadyInUse) {
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
    } else if (passwordController.text.length < 6) {
      return "Password should be at least 6 characters in length";
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

  void checkCredentials() {
    if (appController.hasConnection.value) {
      final isValid = signUpFormKey.currentState!.validate();
      if (!isValid) {
        return;
      }
      signUpFormKey.currentState!.save();
      accountFromGoogle = false;
      Get.to(() => AccountSelectionScreen(),
          duration: Duration(milliseconds: 500),
          transition: Transition.rightToLeft,
          curve: Curves.easeInOut);
    } else {
      appController.showConnectionSnackbar();
    }
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
    if (appController.hasConnection.value) {
      final path = 'users/${uid}/cv/${pickedFile!.name}';
      final file = File(pickedFile!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      try {
        await ref.putFile(file);
        await ref.getDownloadURL().then((downloadUrl) {
          cvUrl = downloadUrl;
        });
      } catch (e) {
        cvUrl = '';
      }
    }
  }

  Future<void> registerUser() async {
    if (appController.hasConnection.value) {
      isProcessing.value = true;
      if (userType == 0) {
        final credentialsValid = signUpFormKey.currentState!.validate();
        final registrationValid = registrationFormKey.currentState!.validate();
        if (!registrationValid || !credentialsValid) {
          isProcessing.value = false;
          return;
        }
      } else {
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
          isProcessing.value = false;
          return;
        }
      }

      signUpFormKey.currentState!.save();
      registrationFormKey.currentState!.save();

      Map<String, String>? error = await AuthenticationRepository.instance
          .createUserWithEmailAndPassword(email, password);
      if (error != null) {
        Helper.errorSnackBar(title: error["title"], message: error["message"]);
      } else {
        uid = authRepo.firebaseUser!.uid;

        if (userType == 1) {
          await uploadCV(uid);
        }

        final userData = UserModel(
            uid: uid,
            email: email.trim(),
            phoneNo: int.tryParse(phoneNo.trim()) ?? 0,
            isExpert: false,
            expertRequest: userType == 1 ? true : false,
            userName: userName.trim(),
            exFullName: exFullName == '' ? null : exFullName.trim(),
            exBio: exBio == '' ? null : exBio.trim(),
            cvUrl: cvUrl == '' ? null : cvUrl,
            profileUrl: null,
            contributions: null,
            emailPublic: false,
            phonePublic: false,
            isAdmin: false);

        await dbRepo.createUserOnDB(userData, uid).then((value) async {
          await appController.changeLoginState(true);
          await appController
              .changeUserDetails(
                  userData.uid,
                  userData.userName,
                  userData.email,
                  userData.phoneNo,
                  userData.isExpert,
                  userData.expertRequest,
                  userData.exFullName,
                  userData.exBio,
                  userData.profileUrl,
                  userData.contributions,
                  await appController.saveUserPicToLocal(userData.profileUrl),
                  userData.emailPublic,
                  userData.phonePublic,
                  userData.isAdmin)
              .then((value) {
            final drawerController = Get.find<DrawerXController>();
            drawerController.currentItem.value = DrawerItems.home;
            Get.offAll(() => DrawerLauncher(),
                duration: Duration(milliseconds: 500),
                transition: Transition.downToUp,
                curve: Curves.easeInOut);
          });
        });
      }
      isProcessing.value = false;
    } else {
      appController.showConnectionSnackbar();
    }
  }

  Future<void> googleSignUp() async {
    if (appController.hasConnection.value) {
      try {
        isGoogleLoading.value = true;
        Map<String, String>? error =
            await AuthenticationRepository.instance.createUserWithGoogle();
        if (error != null) {
          Helper.errorSnackBar(
              title: error["title"], message: error["message"]);
        }
        isGoogleLoading.value = false;
        if (await authRepo.firebaseUser != null) {
          accountFromGoogle = true;
          Get.to(() => AccountSelectionScreen(),
              duration: Duration(milliseconds: 500),
              transition: Transition.rightToLeft,
              curve: Curves.easeInOut);
        }
      } catch (e) {
        isGoogleLoading.value = false;
      }
    } else {
      appController.showConnectionSnackbar();
    }
  }

  Future<void> registerUserFromGoogle() async {
    if (appController.hasConnection.value) {
      isProcessing.value = true;
      if (userType == 0) {
        final registrationValid = registrationFormKey.currentState!.validate();
        if (!registrationValid) {
          isProcessing.value = false;
          return;
        }
      } else {
        if (selectEmpty.value == true) {
          cvError.value = true;
        }
        final registrationValid = registrationFormKey.currentState!.validate();
        if (!registrationValid ||
            cvError.value == true ||
            fileAccepted == false ||
            selectEmpty == true ||
            authRepo.firebaseUser == null) {
          isProcessing.value = false;
          return;
        }
      }

      registrationFormKey.currentState!.save();

      uid = authRepo.firebaseUser!.uid;
      email = authRepo.firebaseUser!.email!;

      String? photoURLUploaded;
      if (authRepo.firebaseUser!.photoURL != null) {
        print(authRepo.firebaseUser!.photoURL);
        photoURLUploaded =
            await dbRepo.uploadPic(uid, authRepo.firebaseUser!.photoURL!, true);
      }

      await uploadCV(uid);

      final userData = UserModel(
          uid: uid,
          email: email.trim(),
          phoneNo: int.tryParse(phoneNo.trim()) ?? 0,
          isExpert: false,
          expertRequest: userType == 1 ? true : false,
          userName: userName.trim(),
          exFullName: exFullName == '' ? null : exFullName.trim(),
          exBio: exBio == '' ? null : exBio.trim(),
          cvUrl: cvUrl == '' ? null : cvUrl,
          profileUrl: photoURLUploaded ?? null,
          contributions: null,
          emailPublic: false,
          phonePublic: false,
          isAdmin: false);

      await dbRepo.createUserOnDB(userData, uid).then((value) async {
        await appController.changeLoginState(true);
        await appController
            .changeUserDetails(
                userData.uid,
                userData.userName,
                userData.email,
                userData.phoneNo,
                userData.isExpert,
                userData.expertRequest,
                userData.exFullName,
                userData.exBio,
                userData.profileUrl,
                userData.contributions,
                await appController.saveUserPicToLocal(userData.profileUrl),
                userData.emailPublic,
                userData.phonePublic,
                userData.isAdmin)
            .then((value) {
          final drawerController = Get.find<DrawerXController>();
          drawerController.currentItem.value = DrawerItems.home;
          Get.offAll(() => DrawerLauncher(),
              duration: Duration(milliseconds: 500),
              transition: Transition.downToUp,
              curve: Curves.easeInOut);
        });
      });
      isProcessing.value = false;
    } else {
      appController.showConnectionSnackbar();
    }
  }
}
