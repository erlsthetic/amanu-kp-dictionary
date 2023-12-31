import 'package:amanu/models/user_model.dart';
import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/drawer_launcher.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/screens/signup_screen/account_selection_screen.dart';
import 'package:amanu/screens/signup_screen/controllers/signup_controller.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/auth/exceptions/auth_failure.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final appController = Get.find<ApplicationController>();

  //Variables
  late final Rx<User?> _firebaseUser;
  final _auth = FirebaseAuth.instance;
  //final _phoneVerificationId = ''.obs;

  //Getters
  User? get firebaseUser => _firebaseUser.value;
  String get getUserID => firebaseUser?.uid ?? "";
  String get getUserEmail => firebaseUser?.email ?? "";

  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    //ever(_firebaseUser, updateUserInfo);
  }

  /*updateUserInfo(User? user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (user != null) {
      appController.changeLoginState(true);
      if (appController.hasConnection) {
        UserModel userData =
            await DatabaseRepository.instance.getUserDetails(user.uid);
        await appController.changeUserDetails(
            user.uid,
            userData.userName,
            userData.email,
            userData.phoneNo,
            userData.isExpert,
            userData.expertRequest,
            userData.exFullName,
            userData.exBio,
            userData.profileUrl,
            userData.contributions);
      } else {
        if (prefs.containsKey("userID")) {
          if (prefs.getString("userID") == user.uid) {
            await appController.getSavedUserDetails();
          } else {
            await logout();
          }
        }
      }
    } else {
      await appController.changeLoginState(false);
      await appController.changeUserDetails(
          null, null, null, null, null, null, null, null, null, null);
    }
    if (appController.isFirstTimeUse) {
      await Future.delayed(Duration(milliseconds: 500));
      Get.offAll(() => OnBoardingScreen());
    } else {
      await Future.delayed(Duration(milliseconds: 500));
      final drawerController = Get.find<DrawerXController>();
      drawerController.currentItem.value = DrawerItems.home;
      Get.offAll(() => DrawerLauncher());
    }
  }*/

  Future<Map<String, String>?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = AuthFailure.code(e.code);
      return {"title": ex.title, "message": ex.message};
    } catch (_) {
      final ex = AuthFailure();
      return {"title": ex.title, "message": ex.message};
    }
    return null;
  }

  Future<Map<String, String>?> logInUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (firebaseUser != null) {
        await appController.changeLoginState(true);
        if (appController.hasConnection.value) {
          UserModel? userData = await DatabaseRepository.instance
              .getUserDetails(firebaseUser!.uid);
          if (userData != null) {
            await appController.changeUserDetails(
                firebaseUser!.uid,
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
                userData.isAdmin);
          }
        } else {
          appController.showConnectionSnackbar();
        }
        // if (appController.isFirstTimeUse) {
        //   await Future.delayed(Duration(milliseconds: 500));
        //   Get.offAll(() => OnBoardingScreen(),
        //       duration: Duration(milliseconds: 500),
        //       transition: Transition.downToUp,
        //       curve: Curves.easeInOut);
        // } else {
        await Future.delayed(Duration(milliseconds: 500));
        final drawerController = Get.find<DrawerXController>();
        drawerController.currentItem.value = DrawerItems.home;
        Get.offAll(() => DrawerLauncher(),
            duration: Duration(milliseconds: 500),
            transition: Transition.downToUp,
            curve: Curves.easeInOut);
        // }
        Helper.successSnackBar(
            title: "Login successful.",
            message: "Logged in as ${appController.userName ?? ""}");
      }
    } on FirebaseAuthException catch (e) {
      final ex = AuthFailure.code(e.code);
      return {"title": ex.title, "message": ex.message};
    } catch (_) {
      final ex = AuthFailure();
      return {"title": ex.title, "message": ex.message};
    }
    return null;
  }

  Future<Map<String, String>?> createUserWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      final ex = AuthFailure.code(e.code);
      return {"title": ex.title, "message": ex.message};
    } catch (_) {
      final ex = AuthFailure();
      return {"title": ex.title, "message": ex.message};
    }
    return null;
  }

  Future<Map<String, String>?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance
          .signInWithCredential(credential)
          .then((value) async {
        if (firebaseUser != null) {
          String userID = firebaseUser!.uid;
          QuerySnapshot query = await FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: userID)
              .get();
          if (query.docs.length != 0) {
            await appController.changeLoginState(true);
            if (appController.hasConnection.value) {
              UserModel? userData = await DatabaseRepository.instance
                  .getUserDetails(firebaseUser!.uid);
              if (userData != null) {
                await appController.changeUserDetails(
                    firebaseUser!.uid,
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
                    userData.isAdmin);
              }
            }
            // if (appController.isFirstTimeUse) {
            //   await Future.delayed(Duration(milliseconds: 500));
            //   Get.offAll(() => OnBoardingScreen(),
            //       duration: Duration(milliseconds: 500),
            //       transition: Transition.downToUp,
            //       curve: Curves.easeInOut);
            // } else {
            await Future.delayed(Duration(milliseconds: 500));
            final drawerController = Get.find<DrawerXController>();
            drawerController.currentItem.value = DrawerItems.home;
            Get.offAll(() => DrawerLauncher(),
                duration: Duration(milliseconds: 500),
                transition: Transition.downToUp,
                curve: Curves.easeInOut);
            // }
            Helper.successSnackBar(
                title: "Login successful.",
                message: "Logged in as ${appController.userName ?? ""}");
          } else {
            final controller = Get.put(SignUpController());
            controller.email = firebaseUser!.email ?? '';
            controller.accountFromGoogle = true;
            Get.off(() => AccountSelectionScreen(),
                duration: Duration(milliseconds: 500),
                transition: Transition.rightToLeft,
                curve: Curves.easeInOut);
            Helper.successSnackBar(
                title: "Let's pickup where you left off.",
                message: "Continue setting up your account to gain access.");
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      final ex = AuthFailure.code(e.code);
      return {"title": ex.title, "message": ex.message};
    } catch (_) {
      final ex = AuthFailure();
      return {"title": ex.title, "message": ex.message};
    }
    return null;
  }

  Future<void> resetPassword(String resetEmail) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: resetEmail)
          .then((value) {
        Helper.successSnackBar(
            title: "Password reset email sent!",
            message: "Please check your inbox to reset your password");
      });
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } on FormatException catch (e) {
      throw e.message;
    } catch (e) {
      Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
      throw "Something went wrong. Try again.";
    }
  }

  Future<void> logout() async {
    try {
      while (firebaseUser != null) {
        await GoogleSignIn().signOut();
        await FirebaseAuth.instance.signOut();
      }
      if (firebaseUser == null) {
        await appController.changeLoginState(false);
        await appController.changeUserDetails(null, null, null, null, null,
            null, null, null, null, null, null, null, null, null);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool("isLoggedIn", false);
        prefs.remove('userID');
        prefs.remove('userName');
        prefs.remove('userEmail');
        prefs.remove('userPhone');
        prefs.remove('userIsExpert');
        prefs.remove('userExpertRequest');
        prefs.remove('userFullName');
        prefs.remove('userBio');
        prefs.remove('userPic');
        prefs.remove('userContributions');
        prefs.remove('userPicLocal');
        prefs.remove('userEmailPublic');
        prefs.remove('userPhonePublic');
        prefs.remove('userIsAdmin');
      }
      // if (appController.isFirstTimeUse) {
      //   await Future.delayed(Duration(milliseconds: 500));
      //   Get.offAll(() => OnBoardingScreen(),
      //       duration: Duration(milliseconds: 500),
      //       transition: Transition.downToUp,
      //       curve: Curves.easeInOut);
      // } else {
      await Future.delayed(Duration(milliseconds: 500));
      final drawerController = Get.find<DrawerXController>();
      drawerController.currentItem.value = DrawerItems.home;
      Get.offAll(() => DrawerLauncher(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
          curve: Curves.easeInOut);
      // }
      Helper.successSnackBar(
          title: "Logout success.",
          message: "User has been logged out of this device.");
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } on FormatException catch (e) {
      throw e.message;
    } catch (e) {
      Helper.errorSnackBar(
          title: tOhSnap, message: "Unable to log out. Try again.");
      throw "Unable to log out. Try again.";
    }
  }
}
