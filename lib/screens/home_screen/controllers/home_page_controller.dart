import 'package:coast/coast.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  static HomePageController get instance => Get.find();

  final RxInt currentIdx = 0.obs;

  late var coastController = CoastController(initialPage: currentIdx.value);

  onPageChangedCallback(int activePageIndex) {
    currentIdx.value = activePageIndex;
  }
}
