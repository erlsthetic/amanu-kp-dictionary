import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/drawer_launcher.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/screens/login_screen/login_screen.dart';
import 'package:amanu/screens/signup_screen/signup_screen.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final drawerController = Get.find<DrawerXController>();

  @override
  Widget build(BuildContext context) {
    final screenPadding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.only(bottom: screenPadding.bottom),
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(30.0),
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(gradient: orangeGradient),
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: SvgPicture.asset(
                  iWelcomeScreen,
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Text(
                        tWelcomeHead,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold,
                          color: pureWhite,
                          height: 1,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tWelcomeSubHead,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w400,
                          color: pureWhite.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.to(() => LoginScreen(),
                                duration: Duration(milliseconds: 500),
                                transition: Transition.rightToLeft,
                                curve: Curves.easeInOut),
                            child: Text(tLogin.toUpperCase()),
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                foregroundColor: pureWhite,
                                side: BorderSide(color: pureWhite, width: 2.0),
                                padding: EdgeInsets.all(10.0),
                                minimumSize: Size(100, 50)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Get.to(() => SignupScreen(),
                                duration: Duration(milliseconds: 500),
                                transition: Transition.rightToLeft,
                                curve: Curves.easeInOut),
                            child: Text(tSignup.toUpperCase()),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                foregroundColor: primaryOrangeDark,
                                backgroundColor: pureWhite,
                                padding: EdgeInsets.all(10.0),
                                minimumSize: Size(100, 50)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: Feedback.wrapForTap(() {
                          final drawerController =
                              Get.find<DrawerXController>();
                          drawerController.currentItem.value = DrawerItems.home;
                          Get.offAll(() => DrawerLauncher(),
                              duration: Duration(milliseconds: 500),
                              transition: Transition.downToUp,
                              curve: Curves.easeInOut);
                        }, context),
                        child: Text(
                          tCancel.toUpperCase(),
                          style: TextStyle(color: pureWhite, fontSize: 15),
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
    );
  }
}
