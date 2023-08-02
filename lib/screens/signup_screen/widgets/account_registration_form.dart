import 'package:amanu/screens/signup/controllers/signup_controller.dart';
import 'package:amanu/screens/signup/widgets/contributor_form_fields.dart';
import 'package:amanu/screens/signup/widgets/expert_form_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountRegistrationForm extends StatelessWidget {
  AccountRegistrationForm({super.key, required this.userType});

  final int userType;
  final controller = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.registrationFormKey,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child:
              (userType == 0) ? ContributorFormFields() : ExpertFormFields()),
    );
  }
}
