import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimatedToggleController extends GetxController {
  final List<String> values = [tContributor, tExpert];
  final Color backgroundColor = primaryOrangeDark.withOpacity(0.5);
  final Color buttonColor = primaryOrangeDark;
  final Color textColor = pureWhite;

  RxBool initialPosition = true.obs;
  RxInt idx = 0.obs;

  onTapGesture() {
    initialPosition.value = !initialPosition.value;
    if (initialPosition.value == true) {
      idx = 0.obs;
    } else {
      idx = 1.obs;
    }
  }
}
