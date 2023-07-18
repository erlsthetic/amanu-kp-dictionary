import 'package:amanu/controllers/animated_toggle_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/constants/app_colors.dart';

class AnimatedToggle extends StatelessWidget {
  AnimatedToggle({
    super.key,
    required this.onToggleCallback,
  });
  final controller = AnimatedToggleController();
  final ValueChanged onToggleCallback;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              controller.onTapGesture();
              onToggleCallback(controller.idx.value);
            },
            child: Container(
              width: double.infinity,
              height: 40.0,
              decoration: ShapeDecoration(
                color: controller.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  controller.values.length,
                  (index) => Expanded(
                    child: Container(
                      child: Text(
                        controller.values[index],
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: darkGrey.withOpacity(0.8),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Obx(
            () => AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.decelerate,
              alignment: controller.initialPosition.value
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: Get.width * 0.45,
                height: 40.0,
                decoration: ShapeDecoration(
                  color: controller.buttonColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Get.width * 0.1),
                  ),
                ),
                child: Text(
                  controller.initialPosition.value
                      ? controller.values[0]
                      : controller.values[1],
                  style: GoogleFonts.poppins(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w600,
                    color: controller.textColor,
                    letterSpacing: 1.0,
                  ),
                ),
                alignment: Alignment.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
