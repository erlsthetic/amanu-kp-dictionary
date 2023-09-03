import 'package:amanu/screens/onboarding_screen/welcome_screen.dart';
import 'package:amanu/screens/signup_screen/controllers/signup_controller.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/header_subheader_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/signup_page_footer.dart';
import 'widgets/signup_page_form.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.only(bottom: screenPadding.bottom),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: WillPopScope(
          onWillPop: () {
            Get.off(() => WelcomeScreen());
            return Future.value(false);
          },
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderSubheaderWithImage(
                        size: size,
                        header: tSignupHead,
                        subHeader: tSignupSubHead,
                        imgString: iSignupPageAnim),
                    SignupForm(),
                    SignupFooterWidget()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
