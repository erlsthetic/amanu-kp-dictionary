import 'package:amanu/screens/onboarding_screen/welcome_screen.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/header_subheader_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/login_page_footer.dart';
import 'widgets/login_page_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
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
                      header: tLoginHead,
                      subHeader: tLoginSubHead,
                      imgString: iLoginPageAnim),
                  LoginForm(),
                  LoginFooterWidget()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
