import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/drawer_launcher.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/screens/onboarding_screen/onboarding_screen.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/exceptions/login_email_failure_catch.dart';
import 'package:amanu/utils/auth/exceptions/signup_email_failure_catch.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
//import 'package:shared_preferences/shared_preferences.dart';

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
  /*
  updateUserInfo(User? user) async {
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
      Get.offAll(() => DrawerLauncher());
    }
  }
  */

  Future<String?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      return ex.message;
    } catch (_) {
      final ex = SignUpWithEmailAndPasswordFailure();
      return ex.message;
    }
    return null;
  }

  Future<String?> logInUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final ex = LogInWithEmailAndPasswordFailure.code(e.code);
      return ex.message;
    } catch (_) {
      final ex = LogInWithEmailAndPasswordFailure();
      return ex.message;
    }
    return null;
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      final ex = LogInWithEmailAndPasswordFailure.code(e.code);
      throw ex.message;
    } catch (_) {
      final ex = LogInWithEmailAndPasswordFailure();
      throw ex.message;
    }
  }

  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      await appController.changeLoginState(false);
      await appController.changeUserDetails(
          null, null, null, null, null, null, null, null, null, null);
      if (appController.isFirstTimeUse) {
        await Future.delayed(Duration(milliseconds: 500));
        Get.offAll(() => OnBoardingScreen());
      } else {
        await Future.delayed(Duration(milliseconds: 500));
        Get.offAll(() => DrawerLauncher());
        final drawerController = Get.find<DrawerXController>();
        drawerController.currentItem.value = DrawerItems.home;
      }
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } on FormatException catch (e) {
      throw e.message;
    } catch (e) {
      throw "Unable to log out. Try again.";
    }
  }
}
