import 'package:amanu/models/user_model.dart';
import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/drawer_launcher.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/screens/onboarding_screen/onboarding_screen.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/auth/exceptions/auth_failure.dart';
import 'package:amanu/utils/auth/helper_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

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
          UserModel userData = await DatabaseRepository.instance
              .getUserDetails(firebaseUser!.uid);
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
              await appController.saveUserPicToLocal(userData.profileUrl));
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
          .whenComplete(() async {
        if (firebaseUser != null) {
          await appController.changeLoginState(true);
          if (appController.hasConnection.value) {
            UserModel userData = await DatabaseRepository.instance
                .getUserDetails(firebaseUser!.uid);
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
                await appController.saveUserPicToLocal(userData.profileUrl));
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
          Helper.successSnackBar(
              title: "Login successful.",
              message: "Logged in as ${appController.userName ?? ""}");
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

  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      await appController.changeLoginState(false);
      await appController.changeUserDetails(
          null, null, null, null, null, null, null, null, null, null, null);
      if (appController.isFirstTimeUse) {
        await Future.delayed(Duration(milliseconds: 500));
        Get.offAll(() => OnBoardingScreen());
      } else {
        await Future.delayed(Duration(milliseconds: 500));
        final drawerController = Get.find<DrawerXController>();
        drawerController.currentItem.value = DrawerItems.home;
        Get.offAll(() => DrawerLauncher());
      }
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
