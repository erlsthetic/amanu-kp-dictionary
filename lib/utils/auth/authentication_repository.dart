import 'package:amanu/utils/auth/exceptions/login_email_failure_catch.dart';
import 'package:amanu/utils/auth/exceptions/signup_email_failure_catch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //Variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    //ever(firebaseUser, _setInitialScreen);
  }

  //_setInitialScreen(User? user) {}

  Future<String?> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      /*firebaseUser.value != null
          ? Get.offAll(() => HomeScreen())
          : Get.to(() => WelcomeScreen());*/
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

  Future<void> logout() async => await _auth.signOut();
}
