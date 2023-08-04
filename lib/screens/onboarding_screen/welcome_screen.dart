import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/drawer_launcher.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/screens/login_screen/login_screen.dart';
import 'package:amanu/screens/signup_screen/signup_screen.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final drawerController = Get.find<DrawerXController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(gradient: orangeGradient),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Image(
                image: AssetImage(iWelcomePageAnim),
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
                          onPressed: () => Get.to(() => LoginScreen()),
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
                          onPressed: () => Get.to(() => SignupScreen()),
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
                        drawerController.currentItem = DrawerItems.home.obs;
                        Get.offAll(() => DrawerLauncher(
                              pageIndex: 0,
                            ));
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
    );
  }
}
