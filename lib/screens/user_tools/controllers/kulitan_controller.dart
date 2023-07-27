import 'package:get/get.dart';

class KulitanController extends GetxController {
  static KulitanController get instance => Get.find();

  RxBool buttonHoldController = false.obs;
  RxBool buttonClick = false.obs;

  void buttonHoldToggle() {
    buttonHoldController.value = !buttonHoldController.value;
    buttonClick.value = false;
  }

  void buttonClickToggle() {
    buttonHoldController.value ? null : buttonClick.value = !buttonClick.value;
  }

  void upperButtonRelease() {
    print("clicked Ki");
  }

  void lowerButtonRelease() {
    print("clicked Ku");
  }
}
