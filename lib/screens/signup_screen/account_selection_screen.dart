import 'package:amanu/components/confirm_dialog.dart';
import 'package:amanu/screens/signup_screen/account_registration_screen.dart';
import 'package:amanu/screens/signup_screen/controllers/signup_controller.dart';
import 'package:amanu/utils/auth/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:themed/themed.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/header_subheader.dart';

class AccountSelectionScreen extends StatelessWidget {
  AccountSelectionScreen({super.key});
  final controller = Get.find<SignUpController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () {
          showConfirmDialog(
              context,
              "Exit account setup?",
              "Your account details are not yet set. However, if you wish to exit now, you may still continue setting up your account by logging in.",
              "Exit",
              "Cancel", () {
            AuthenticationRepository.instance.logout();
          }, () {
            Navigator.of(context).pop();
          });
          return Future.value(false);
        },
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.all(30.0),
            child: Column(children: [
              Container(
                width: double.infinity,
                child: HeaderSubheader(
                    size: size,
                    header: tAccountRegistrationHead,
                    subHeader: tChooseAccountType),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    _OptionCard(
                      isContributor: controller.isContributor,
                      size: size,
                      condition: true,
                      optionIdx: 0,
                      header: tContributor,
                      description: tContributorDesc,
                      imgString: iContributorIllus,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    _OptionCard(
                      isContributor: controller.isContributor,
                      size: size,
                      condition: false,
                      optionIdx: 1,
                      header: tExpert,
                      description: tExpertDesc,
                      imgString: iExpertIllus,
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                          onPressed: () {
                            if (controller.isContributor.value) {
                              controller.userType = 0;
                              controller.exFullName = '';
                              controller.exBio = '';
                              controller.cvUrl = '';
                              Get.to(() => AccountRegistrationScreen());
                              print("Email: ${controller.email}");
                              print("Password: ${controller.password}");
                              print(
                                  "Account type: ${controller.userType} | Contributor");
                            } else {
                              controller.userType = 1;
                              Get.to(() => AccountRegistrationScreen());
                              print("Email: ${controller.email}");
                              print("Password: ${controller.password}");
                              print(
                                  "Account type: ${controller.userType} | Expert");
                            }
                          },
                          child: Text(
                            controller.isContributor.value
                                ? tSignUpAsContributor.toUpperCase()
                                : tRequestExpertAccount.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: pureWhite,
                              letterSpacing: 1.0,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.isContributor,
    required this.size,
    required this.condition,
    required this.optionIdx,
    required this.header,
    required this.description,
    required this.imgString,
  });

  final RxBool isContributor;
  final bool condition;
  final int optionIdx;
  final String header;
  final String description;
  final String imgString;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => InkWell(
          onTap: () {
            isContributor.value = condition;
            print(optionIdx);
          },
          borderRadius: BorderRadius.circular(20.0),
          splashColor: primaryOrangeLight,
          highlightColor: primaryOrangeLight.withOpacity(0.5),
          child: Ink(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 10.0, 0),
            width: double.infinity,
            height: size.height * 0.32,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: condition == isContributor.value
                      ? primaryOrangeDark.withOpacity(0.6)
                      : lightGrey,
                  blurRadius: 15,
                  spreadRadius: -5,
                )
              ],
              borderRadius: BorderRadius.circular(20.0),
              gradient: condition == isContributor.value
                  ? orangeGradient
                  : whiteGradient,
            ),
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        header.toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontSize: 34.0,
                          fontWeight: FontWeight.bold,
                          color: condition == isContributor.value
                              ? pureWhite
                              : disabledGrey,
                          height: 1,
                        ),
                      ),
                      Container(
                        width: size.width * 0.5,
                        child: Text(
                          description,
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            fontWeight: FontWeight.w500,
                            color: condition == isContributor.value
                                ? darkGrey
                                : disabledGrey,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: ChangeColors(
                    brightness: condition == isContributor.value ? 0.0 : 0.5,
                    child: SvgPicture.asset(
                      imgString,
                      alignment: Alignment.bottomRight,
                      colorFilter:
                          condition == isContributor.value ? null : greyscale,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
