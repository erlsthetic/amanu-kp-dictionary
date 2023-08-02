import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Helper extends GetxController {
  static successSnackBar({required title, required message}) {
    Get.snackbar(title, message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: pureWhite,
        backgroundColor: primaryOrangeDark.withOpacity(0.5),
        duration: Duration(seconds: 6),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
        icon: Icon(
          Icons.check_circle_outline,
          color: pureWhite,
        ));
  }

  static errorSnackBar({required title, required message}) {
    Get.snackbar(title, message,
        isDismissible: true,
        shouldIconPulse: true,
        colorText: pureWhite,
        backgroundColor: Colors.redAccent.withOpacity(0.5),
        duration: Duration(seconds: 6),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
        icon: Icon(
          Icons.error_outline,
          color: pureWhite,
        ));
  }
}
