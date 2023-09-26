import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/header_subheader_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class ForgotPasswordOTP extends StatelessWidget {
  const ForgotPasswordOTP({super.key});

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
                  header: tOTPTitle,
                  subHeader: tOTPSubtitle + "\n sample@sample.com",
                  imgString: iResetUsingEmail,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  heightBetween: 30,
                ),
                SizedBox(
                  height: 30,
                ),
                OTPTextField(
                  length: 6,
                  width: double.infinity,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  otpFieldStyle:
                      OtpFieldStyle(focusBorderColor: primaryOrangeDark),
                  fieldWidth: 50,
                  outlineBorderRadius: 15,
                  style: GoogleFonts.poppins(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: muteBlack,
                    letterSpacing: 1.0,
                  ),
                  onChanged: (code) => print(
                    "OTP changed: $code",
                  ),
                  onCompleted: (code) => print(
                    "OTP entered: $code",
                  ),
                ),
                SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(double.infinity, 45.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0))),
                    onPressed: () {},
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
