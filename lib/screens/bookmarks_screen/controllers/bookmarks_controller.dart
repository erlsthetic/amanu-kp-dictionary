import 'package:amanu/utils/application_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarksController extends GetxController {
  static BookmarksController get instance => Get.find();

  final appController = Get.find<ApplicationController>();

  void removeBookmark(String wordID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("bookmarks")) {
      appController.bookmarks.value = prefs.getStringList("bookmarks")!;
      if (appController.bookmarks.contains(wordID)) {
        appController.bookmarks.remove(wordID);
        prefs.setStringList("bookmarks", appController.bookmarks);
      }
    }
  }
}
