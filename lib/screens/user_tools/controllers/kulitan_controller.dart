import 'package:get/get.dart';

class KulitanController extends GetxController {
  static KulitanController get instance => Get.find();

  RxInt currentLine = 0.obs;
  RxInt currentSpace = 0.obs;

  RxList<List<String>> kulitanStringList = <List<String>>[].obs;

  void addLine() {
    kulitanStringList.value.add([]);
  }

  void addCharacter(line) {
    if (kulitanStringList[line].length <= 3) {
      //add
    } else {
      addLine();
      //insertCharacter
    }
  }
}
