import 'package:amanu/screens/signup/controllers/signup_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/text_strings.dart';

class ContributorFormFields extends StatelessWidget {
  ContributorFormFields({
    super.key,
  });
  final controller = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: controller.userNameController,
          onChanged: (value) {
            controller.checkUserName();
          },
          onSaved: (value) {
            controller.userName = value!;
          },
          validator: (value) {
            if (value != null) {
              return controller.validateUserName(value);
            } else {
              return "Enter a valid username";
            }
          },
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline_outlined),
              labelText: tUsername,
              hintText: tUsername,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0))),
        ),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          controller: controller.phoneNoController,
          onSaved: (value) {
            controller.phoneNo = value!;
          },
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value != null) {
              return controller.validatePhone(value);
            } else {
              return "Enter a valid 10-digit number";
            }
          },
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.phone_outlined),
              prefixText: "+63 ",
              labelText: tContact,
              hintText: "xxxxxxxxxx",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0))),
        ),
        SizedBox(
          height: 40.0,
        ),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
              onPressed: () {
                controller.registerUser();
                //Get.off(() => HomeScreen());
              },
              style: ElevatedButton.styleFrom(
                alignment: Alignment.center,
                minimumSize: Size(100, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                tSignUpAsContributor.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: pureWhite,
                  letterSpacing: 1.0,
                ),
              )),
        ),
        SizedBox(
          height: 10.0,
        ),
        SizedBox(
          height: 30.0,
          width: double.infinity,
          child: Text.rich(
            TextSpan(
              text: "By signing up, you agree to the ",
              style: GoogleFonts.poppins(
                fontSize: 12.0,
                fontWeight: FontWeight.normal,
                color: muteBlack,
              ),
              children: [
                TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(color: primaryOrangeDark),
                    recognizer: TapGestureRecognizer()..onTap = () {}),
                TextSpan(text: ".")
              ],
            ),
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
