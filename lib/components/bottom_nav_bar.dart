import 'package:amanu/screens/home_screen/controllers/home_page_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.size,
    required HomePageController pController,
  }) : _pController = pController;

  final Size size;
  final HomePageController _pController;

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
              size: Size(size.width, 80),
              painter: BNBCustomPainter(),
            ),
            Center(
              heightFactor: 0.6,
              child: SizedBox(
                height: size.width * 0.17,
                width: size.width * 0.17,
                child: FittedBox(
                  child: FloatingActionButton(
                      splashColor: primaryOrangeLight,
                      focusColor: primaryOrangeLight.withOpacity(0.5),
                      backgroundColor: primaryOrangeDark,
                      child: Icon(Icons.camera),
                      elevation: 0.1,
                      onPressed: () {}),
                ),
              ),
            ),
            Container(
              width: size.width,
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Obx(
                    () => IconButton(
                      highlightColor: primaryOrangeLight.withOpacity(0.5),
                      icon: Icon(
                        Icons.home,
                        size: 30,
                        color: _pController.currentIdx.value == 0
                            ? primaryOrangeDark
                            : disabledGrey,
                      ),
                      onPressed: () {
                        _pController.currentIdx.value = 0;
                        _pController.coastController.animateTo(
                            beach: 0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease);
                      },
                      splashColor: Colors.white,
                    ),
                  ),
                  Container(
                    width: size.width * 0.20,
                  ),
                  Obx(
                    () => IconButton(
                        highlightColor: primaryOrangeLight.withOpacity(0.5),
                        icon: Icon(
                          Icons.book_rounded,
                          size: 30,
                          color: _pController.currentIdx.value == 1
                              ? primaryOrangeDark
                              : disabledGrey,
                        ),
                        onPressed: () {
                          _pController.currentIdx.value = 1;
                          _pController.coastController.animateTo(
                              beach: 1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease);
                        }),
                  ),
                ],
              ),
            )
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