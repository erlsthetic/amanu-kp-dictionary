import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/helper_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailController extends GetxController {
  static DetailController get instance => Get.find();
  DetailController({required this.wordID});

  final wordID;
  final appController = Get.find<ApplicationController>();
  final AudioPlayer player = AudioPlayer();

  String word = '';
  String prn = '';
  String prnUrl = '';
  List<dynamic> engTrans = [];
  List<dynamic> filTrans = [];
  List<Map<String, dynamic>> meanings = [];
  List<String> types = [];
  List<List<Map<String, dynamic>>> definitions = [];
  var kulitanChars = [];
  String kulitanString = '';
  Map<dynamic, dynamic> synonyms = {};
  Map<dynamic, dynamic> antonyms = {};
  Map<dynamic, dynamic> otherRelated = {};
  String references = '';
  List<Map<String, dynamic>> contributors = [];
  Map<String, dynamic> expert = {};
  String lastModified = '';

  void getInformation() {
    word = appController.dictionaryContent[wordID]["word"];
    prn = appController.dictionaryContent[wordID]["pronunciation"];
    prnUrl = appController.dictionaryContent[wordID]["pronunciationAudio"];
    engTrans = appController.dictionaryContent[wordID]["englishTranslations"];
    filTrans = appController.dictionaryContent[wordID]["filipinoTranslations"];
    meanings = appController.dictionaryContent[wordID]["meanings"];
    for (Map<String, dynamic> meaning in meanings) {
      types.add(meaning["partOfSpeech"]);
      List<Map<String, dynamic>> tempDef = [];
      for (Map<String, dynamic> definition in meaning["definitions"]) {
        tempDef.add(definition);
      }
      definitions.add(tempDef);
    }
    kulitanChars = appController.dictionaryContent[wordID]["kulitan-form"];
    for (var line in kulitanChars) {
      for (var syl in line) {
        kulitanString = kulitanString + syl;
      }
    }
    synonyms = appController.dictionaryContent[wordID]["synonyms"];
    antonyms = appController.dictionaryContent[wordID]["antonyms"];
    otherRelated = appController.dictionaryContent[wordID]["otherRelated"];
    references = appController.dictionaryContent[wordID]["sources"];
  }

  RxBool onBookmarks = false.obs;

  Future<void> playFromURL() async {
    try {
      await player.stop();
      await player.play(UrlSource(prnUrl));
    } catch (e) {
      Helper.errorSnackBar(title: "Error", message: "Cannot play audio.");
    }
  }

  Future bookmarkToggle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("bookmarks")) {
      appController.bookmarks = prefs.getStringList("bookmarks")!;
      if (appController.bookmarks.contains(wordID)) {
        appController.bookmarks.remove(wordID);
        prefs.setStringList("bookmarks", appController.bookmarks);
        onBookmarks.value = false;
      } else {
        appController.bookmarks.add(wordID);
        prefs.setStringList("bookmarks", appController.bookmarks);
        onBookmarks.value = true;
      }
    } else {
      if (appController.bookmarks.contains(wordID)) {
        appController.bookmarks.remove(wordID);
        prefs.setStringList("bookmarks", appController.bookmarks);
        onBookmarks.value = false;
      } else {
        appController.bookmarks.add(wordID);
        prefs.setStringList("bookmarks", appController.bookmarks);
        onBookmarks.value = true;
      }
    }
  }

  void checkIfInBookmarks() {
    if (appController.bookmarks.contains(wordID)) {
      onBookmarks.value = true;
    } else {
      onBookmarks.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    getInformation();
    checkIfInBookmarks();
  }

  @override
  void onClose() {
    super.onClose();
    player.dispose();
  }
}
