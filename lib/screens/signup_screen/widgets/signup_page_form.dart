import 'package:amanu/screens/signup/controllers/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/text_strings.dart';

class SignupForm extends StatelessWidget {
  SignupForm({
    super.key,
  });
  final controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.signUpFormKey,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              autofillHints: [AutofillHints.email],
              onSaved: (value) {
                controller.email = value!;
              },
              onChanged: (value) {
                controller.checkEmail();
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
                  prefixIcon: Icon(Icons.mail_outline),
                  labelText: tEmail,
                  hintText: tEmail,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0))),
            ),
            SizedBox(
              height: 10.0,
            ),
            Obx(
              () => TextFormField(
                controller: controller.passwordController,
                obscureText: controller.isObscure.value,
                onSaved: (value) {
                  controller.password = value!;
                },
                validator: (value) {
                  if (value != null) {
                    return controller.validatePassword(value);
                  } else {
                    return "Enter a valid password";
                  }
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.key_outlined),
                    suffixIcon: IconButton(
                      onPressed: () {
                        controller.isObscure.value =
                            !controller.isObscure.value;
                      },
                      icon: controller.isObscure.value
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                    ),
                    labelText: tPassword,
                    hintText: tPassword,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0))),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    controller.checkCredentials();
                  },
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    minimumSize: Size(100, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(
                    tSignup.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: pureWhite,
                      letterSpacing: 1.0,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
