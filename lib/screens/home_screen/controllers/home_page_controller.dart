import 'package:coast/coast.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  static HomePageController get instance => Get.find();

  final RxInt currentIdx = 0.obs;

  CoastController coastController = CoastController(initialPage: 0);

  onPageChangedCallback(int activePageIndex) {
    currentIdx.value = activePageIndex;
  }
}
