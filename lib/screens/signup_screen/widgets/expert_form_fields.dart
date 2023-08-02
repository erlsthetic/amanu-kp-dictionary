import 'package:amanu/screens/signup_screen/controllers/signup_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/text_strings.dart';

class ExpertFormFields extends StatelessWidget {
  ExpertFormFields({
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
          controller: controller.exFullNameController,
          onSaved: (value) {
            controller.exFullName = value!;
          },
          validator: (value) {
            if (value != null) {
              return controller.validateExFullName(value);
            } else {
              return "Enter a valid name";
            }
          },
          decoration: InputDecoration(
              prefixIcon: Icon(Icons.person_outline_outlined),
              labelText: tName,
              hintText: tName,
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
          height: 10.0,
        ),
        TextFormField(
          controller: controller.exBioController,
          onSaved: (value) {
            controller.exBio = value!;
          },
          validator: (value) {
            if (value != null) {
              return controller.validateBio(value);
            } else {
              return "Please describe your self and profession.";
            }
          },
          maxLines: 5,
          maxLength: 200,
          decoration: InputDecoration(
              labelText: tBio,
              alignLabelWithHint: true,
              hintText: tEnterBio,
              hintMaxLines: 5,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0))),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          tUploadCV,
          textAlign: TextAlign.left,
          style: GoogleFonts.poppins(
            fontSize: 14.0,
            fontWeight: FontWeight.normal,
            color: muteBlack,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        SizedBox(
          width: double.infinity,
          height: 60.0,
          child: Stack(
            children: [
              Container(
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(color: Color(0xFF9B9B9B)),
                ),
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Obx(
                        () => ElevatedButton(
                          onPressed: () {
                            controller.selectEmpty.value
                                ? controller.selectCV()
                                : controller.removeSelection();
                          },
                          style: ElevatedButton.styleFrom(
                              minimumSize: Size(80.0, double.infinity),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(20.0)))),
                          child: Icon(
                            controller.selectEmpty.value
                                ? Icons.attach_file
                                : Icons.close,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        height: 60,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Obx(
                            () => Text(
                              controller.selectedText.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                color: darkGrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Obx(() => controller.selectEmpty.value
            ? controller.cvError.value
                ? Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                    width: double.infinity,
                    child: Text(
                      'Please upload your resume',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.red[700], fontSize: 11.5),
                    ))
                : Container()
            : controller.fileAccepted.value
                ? Container()
                : Container(
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                    width: double.infinity,
                    child: Text(
                      'File must not exceed 10MB',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.red[700], fontSize: 11.5),
                    ))),
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
                tRequestExpertAccount.toUpperCase(),
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
