import 'package:amanu/screens/home_screen/drawer_launcher.dart';
import 'package:amanu/screens/onboarding_screen/welcome_screen.dart';
import 'package:amanu/utils/auth/exceptions/login_email_failure_catch.dart';
import 'package:amanu/utils/auth/exceptions/signup_email_failure_catch.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

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
    ever(_firebaseUser, setInitialScreen);
  }

  setInitialScreen(User? user) {
    user == null
        ? Get.offAll(() => DrawerLauncher())
        : Get.offAll(() => DrawerLauncher());
  }

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
      Get.offAll(() => DrawerLauncher());
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } on FormatException catch (e) {
      throw e.message;
    } catch (e) {
      throw "Unable to log out. Try again.";
    }
  }
}
