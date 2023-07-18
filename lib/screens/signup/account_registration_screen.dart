import 'package:amanu/screens/signup/controllers/signup_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/screens/signup/widgets/account_registration_form.dart';
import 'package:amanu/widgets/components/header_subheader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountRegistrationScreen extends StatelessWidget {
  AccountRegistrationScreen({super.key});

  final controller = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
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
                HeaderSubheader(
                    size: size,
                    header: controller.userType == 0
                        ? tContributorRegistrationHead
                        : tExpertRegistrationHead,
                    subHeader: controller.userType == 0
                        ? tFillInformation
                        : tWeNeedToKnowMore),
                AccountRegistrationForm(
                  userType: controller.userType,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
