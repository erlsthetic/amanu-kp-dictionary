import 'package:amanu/components/button_loading_widget.dart';
import 'package:amanu/screens/home_screen/home_screen.dart';
import 'package:amanu/screens/login_screen/controllers/login_controller.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../signup_screen/signup_screen.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/text_strings.dart';
import 'package:flutter/material.dart';

class LoginFooterWidget extends StatelessWidget {
  LoginFooterWidget({
    super.key,
  });

  final controller = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "OR",
          style:
              GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16.0),
        ),
        SizedBox(
          height: 10.0,
        ),
        SizedBox(
          width: double.infinity,
          child: Obx(
            () => OutlinedButton.icon(
              icon: controller.isGoogleLoading.value
                  ? SizedBox()
                  : SvgPicture.asset(
                      iGoogleIcon,
                      width: 20.0,
                    ),
              onPressed: controller.isLoading.value
                  ? () {}
                  : controller.isGoogleLoading.value
                      ? () {}
                      : () => controller.googleSignIn(),
              label: controller.isGoogleLoading.value
                  ? ButtonLoadingWidget()
                  : Text(
                      tSignUpWithGoogle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: muteBlack,
                        letterSpacing: 1.0,
                      ),
                    ),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(100, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        TextButton(
          onPressed: () => Get.off(() => SignupScreen()),
          style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0))),
          child: Text.rich(TextSpan(
              text: tDontHaveAnAccount,
              children: [
                TextSpan(
                    text: tSignup, style: TextStyle(color: primaryOrangeDark))
              ],
              style: GoogleFonts.poppins(
                  color: muteBlack, fontWeight: FontWeight.w600))),
        ),
      ],
    );
  }
}
