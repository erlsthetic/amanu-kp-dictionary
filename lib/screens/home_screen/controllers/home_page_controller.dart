
import 'package:coast/coast.dart';
import 'package:get/get.dart';

class HomePageContoller extends GetxController {
  final RxInt currentIdx = 0.obs;
  final coastController = new CoastController(initialPage: 0);

  onPageChangedCallback(int activePageIndex) {
    currentIdx.value = activePageIndex;
  }
}
