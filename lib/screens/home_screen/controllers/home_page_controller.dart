import 'package:coast/coast.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  final RxInt currentIdx = 0.obs;
  late final coastController =
      new CoastController(initialPage: currentIdx.value);

  onPageChangedCallback(int activePageIndex) {
    currentIdx.value = activePageIndex;
  }
}
