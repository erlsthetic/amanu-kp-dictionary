import 'package:amanu/screens/login_screen/widgets/forgot_password_email.dart';
import 'package:amanu/screens/login_screen/widgets/forgot_password_phone.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/text_strings.dart';
import 'forgot_password_options.dart';

class ForgotPasswordScreen {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tForgetPasswordTitle,
              style: GoogleFonts.poppins(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: muteBlack,
                height: 1,
              ),
            ),
            Text(
              tForgetPasswordSubtitle,
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: muteBlack,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ForgotPasswordOption(
              btnIcon: Icons.mail_outline_rounded,
              title: tEmail,
              subtitle: tResetViaEmail,
              onTap: () {
                Navigator.pop(context);
                Get.to(() => ForgotPasswordEmail());
              },
            ),
            SizedBox(
              height: 20,
            ),
            ForgotPasswordOption(
              btnIcon: Icons.mobile_friendly_outlined,
              title: tContact,
              subtitle: tResetViaSMS,
              onTap: () {
                Navigator.pop(context);
                Get.to(() => ForgotPasswordPhone());
              },
            ),
          ],
        ),
      ),
    );
  }
}
