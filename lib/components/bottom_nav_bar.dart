import 'package:amanu/screens/home_screen/controllers/home_page_controller.dart';
import 'package:amanu/screens/kulitan_scanner_screen/kulitan_scanner_screen.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({
    super.key,
    required this.size,
    required HomePageController pController,
  }) : _pController = pController;

  final Size size;
  final HomePageController _pController;
  final appController = Get.find<ApplicationController>();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        width: size.width,
        height: 80,
        child: Stack(
          children: [
            CustomPaint(
              key: appController.isFirstTimeHome
                  ? _pController.navigationKey
                  : null,
              size: Size(size.width, 80),
              painter: BNBCustomPainter(),
            ),
            Center(
              heightFactor: 0.6,
              child: SizedBox(
                key: appController.isFirstTimeHome
                    ? _pController.scannerKey
                    : null,
                height: size.width * 0.17,
                width: size.width * 0.17,
                child: FittedBox(
                  child: FloatingActionButton(
                      splashColor: primaryOrangeLight,
                      focusColor: primaryOrangeLight.withOpacity(0.5),
                      backgroundColor: primaryOrangeDark,
                      child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            child: SvgPicture.asset(iAmanuWhiteButtonIcon),
                          )),
                      elevation: 3,
                      onPressed: () {
                        if (!appController.cameraError &&
                            appController.cameras.length > 0) {
                          Get.to(
                              () => KulitanScannerScreen(
                                    fromDrawer: false,
                                  ),
                              duration: Duration(milliseconds: 500),
                              transition: Transition.downToUp,
                              curve: Curves.easeInOut);
                        } else {
                          Helper.errorSnackBar(
                              title: "No Cameras Detected.",
                              message: "This device has no cameras.");
                        }
                      }),
                ),
              ),
            ),
            GetBuilder<HomePageController>(builder: (ctl) {
              return Container(
                width: size.width,
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: Container(
                        height: 30,
                        width: 30,
                        child: SvgPicture.asset(
                          iHomeIcon,
                          colorFilter: ColorFilter.mode(
                              ctl.currentIdx.value == 0
                                  ? primaryOrangeDark
                                  : disabledGrey,
                              BlendMode.srcIn),
                        ),
                      ),
                      onTap: Feedback.wrapForTap(() async {
                        ctl.currentIdx.value = 0;
                        await ctl.coastController.animateTo(
                            beach: 0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                        ctl.update();
                      }, context),
                    ),
                    Container(
                      width: size.width * 0.20,
                    ),
                    GestureDetector(
                      child: Container(
                        height: 30,
                        width: 30,
                        child: SvgPicture.asset(
                          iDictionaryIcon,
                          colorFilter: ColorFilter.mode(
                              ctl.currentIdx.value == 1
                                  ? primaryOrangeDark
                                  : disabledGrey,
                              BlendMode.srcIn),
                        ),
                      ),
                      onTap: Feedback.wrapForTap(() async {
                        ctl.currentIdx.value = 1;
                        await ctl.coastController.animateTo(
                            beach: 1,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                        ctl.update();
                      }, context),
                    ),
                  ],
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 20); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20),
        radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 20);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, primaryOrangeDark, 30, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
