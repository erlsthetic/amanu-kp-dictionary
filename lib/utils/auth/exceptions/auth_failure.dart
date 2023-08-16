class AuthFailure {
  final String title;
  final String message;

  AuthFailure({
    this.title = "An unknown error has occurred.",
    this.message = "Please try again later or contact support for help.",
  });

  factory AuthFailure.code(String code) {
    switch (code) {
      case 'email-already-exists':
        return AuthFailure(
            title: "Email is already taken.",
            message: "Please use another email, or sign in instead.");
      case 'id-token-expired':
        return AuthFailure(
            title: "Token expired.",
            message: "Please logout and sign in again.");
      case 'id-token-revoked':
        return AuthFailure(
            title: "Token revoked.",
            message: "Please contact support for help.");
      case 'captcha-check-failed':
        return AuthFailure(
            title: "reCaptcha failed.",
            message:
                "The reCAPTCHA response token provided is either invalid, expired, already used or does not match.");
      case 'credential-already-in-use':
        return AuthFailure(
            title: "Credential is already in use.",
            message: "Credential used is already linked with another account.");
      case 'email-already-in-used':
        return AuthFailure(
            title: "Email already exist.",
            message:
                "The email provided is already in use by another account, sign in instead.");
      case 'cancelled-popup-request':
        return AuthFailure(
            title: "Oh Snap!",
            message:
                "This operation has been cancelled due to another conflicting popup being opened.");
      case 'invalid-user-token':
        return AuthFailure(
            title: "Invalid user token.",
            message: "Please contact support for help.");
      case 'invalid-verification-code':
        return AuthFailure(
            title: "Invalid verification code.",
            message: "Please check the verification code and try again.");
      case 'invalid-email':
        return AuthFailure(
            title: "Invalid email.",
            message: "The email address is badly formatted.");
      case 'invalid-credential':
        return AuthFailure(
            title: "Invalid credential.",
            message: "Please contact support for help.");
      case 'wrong-password':
        return AuthFailure(
            title: "Wrong password.", message: "Check password and try again.");
      case 'network-request-failed':
        return AuthFailure(
            title: "Network error occurred.",
            message: "Please try again later.");
      case 'timeout':
        return AuthFailure(
            title: "Request time out.",
            message: "Check your connection and try again.");
      case 'too-many-requests':
        return AuthFailure(
            title: "Too many requests.",
            message:
                "We have blocked all requests from this device due to unusual activity. Try again later.");
      case 'unverified-email':
        return AuthFailure(
            title: "Email is unverified.",
            message:
                "Please check verification in your email's inbox and try again.");
      case 'user-not-found':
        return AuthFailure(
            title: "User not found.",
            message:
                "There is no user record corresponding to this identifier. The user may have been deleted.");
      case 'user-disable':
        return AuthFailure(
            title: "This user has been disabled.",
            message:
                "This user account has been disabled. Please contact support for help.");
      case 'weak-password':
        return AuthFailure(
            title: "Weak password",
            message: "The password must be 6 characters long or more.");
      case 'email-already-in-use':
        return AuthFailure(
            title: "Email already exist.",
            message:
                "The email provided is already in use by another account, sign in instead.");
      case 'operation-not-allowed':
        return AuthFailure(
            title: "Oh Snap!",
            message: "Operation is not allowed. Please contact support.");
      case 'user-disabled':
        return AuthFailure(
            title: "This user has been disabled.",
            message:
                "This user account has been disabled. Please contact support for help.");
      default:
        return AuthFailure(
            title: "An unknown error has occurred.",
            message: "Please try again later or contact support for help.");
    }
  }
}
