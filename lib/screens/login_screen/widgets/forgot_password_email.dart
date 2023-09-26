import 'package:amanu/screens/login_screen/controllers/forget_password_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/header_subheader_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordEmail extends StatelessWidget {
  ForgotPasswordEmail({super.key});
  final controller = Get.put(ResetPasswordController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                HeaderSubheaderWithImage(
                  size: size,
                  header: tResetViaEmail,
                  subHeader: tForgotEmailSub,
                  imgString: iResetUsingEmail,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30,
                ),
                SizedBox(
                  height: 30,
                ),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: [AutofillHints.email],
                        onSaved: (value) {
                          controller.resetEmail = value!;
                        },
                        onChanged: (value) {
                          controller.checkUserExists();
                        },
                        validator: (value) {
                          if (value != null) {
                            return controller.validateEmail(value);
                          } else {
                            return "Enter a valid email";
                          }
                        },
                        controller: controller.emailController,
                        decoration: InputDecoration(
                            label: Text(tEmail),
                            hintText: tEmail,
                            prefixIcon: Icon(Icons.mail_outline_rounded),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0))),
                      ),
                      SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(double.infinity, 45.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0))),
                          onPressed: () {
                            controller.sendResetEmail(context);
                          },
                          child: Text(
                            tResetPassword.toUpperCase(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: pureWhite,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
