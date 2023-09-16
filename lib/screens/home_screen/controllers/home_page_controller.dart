import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:coast/coast.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  static HomePageController get instance => Get.find();
  HomePageController({required this.wordOfTheDay});

  final appController = Get.find<ApplicationController>();

  final RxInt currentIdx = 0.obs;

  CoastController coastController = CoastController(initialPage: 0);
  CrabController crabController = CrabController();

  onPageChangedCallback(int activePageIndex) {
    currentIdx.value = activePageIndex;
  }

  final String wordOfTheDay;

  String word = '';
  String prn = '';
  String prnUrl = '';
  List<dynamic> engTrans = [];
  List<dynamic> filTrans = [];
  List<dynamic> meanings = [];
  List<String> types = [];
  List<List<Map<String, dynamic>>> definitions = [];
  var kulitanChars = [];
  String kulitanString = '';
  Map<dynamic, dynamic> otherRelated = {};
  Map<dynamic, dynamic> synonyms = {};
  Map<dynamic, dynamic> antonyms = {};
  String sources = '';
  Map<dynamic, dynamic> contributors = {};
  Map<dynamic, dynamic> expert = {};
  String lastModifiedTime = '';

  late bool wotdFound;

  void getInformation() {
    if (wordOfTheDay != "" && wotdFound) {
      String wordID = wordOfTheDay;
      word = appController.dictionaryContent[wordID]["word"];
      prn = appController.dictionaryContent[wordID]["pronunciation"];
      prnUrl = appController.dictionaryContent[wordID]["pronunciationAudio"];
      engTrans =
          appController.dictionaryContent[wordID]["englishTranslations"] == null
              ? []
              : appController.dictionaryContent[wordID]["englishTranslations"];
      filTrans = appController.dictionaryContent[wordID]
                  ["filipinoTranslations"] ==
              null
          ? []
          : appController.dictionaryContent[wordID]["filipinoTranslations"];
      meanings =
          appController.dictionaryContent[wordID]["meanings"] as List<dynamic>;
      for (Map<String, dynamic> meaning in meanings) {
        types.add(meaning["partOfSpeech"]);
        List<Map<String, dynamic>> tempDef = [];
        for (Map<String, dynamic> definition in meaning["definitions"]) {
          tempDef.add(definition);
        }
        definitions.add(tempDef);
      }
      kulitanChars = new List.from(
          appController.dictionaryContent[wordID]["kulitan-form"]);
      for (var line in kulitanChars) {
        for (var syl in line) {
          kulitanString = kulitanString + syl;
        }
      }
      otherRelated =
          appController.dictionaryContent[wordID]["otherRelated"] == null
              ? {}
              : appController.dictionaryContent[wordID]["otherRelated"];
      synonyms = appController.dictionaryContent[wordID]["synonyms"] == null
          ? {}
          : appController.dictionaryContent[wordID]["synonyms"];
      antonyms = appController.dictionaryContent[wordID]["antonyms"] == null
          ? {}
          : appController.dictionaryContent[wordID]["antonyms"];
      sources = appController.dictionaryContent[wordID]["sources"] == null
          ? ''
          : appController.dictionaryContent[wordID]["sources"];
      contributors =
          appController.dictionaryContent[wordID]["contributors"] == null
              ? {}
              : appController.dictionaryContent[wordID]["contributors"];
      expert = appController.dictionaryContent[wordID]["expert"] == null
          ? {}
          : appController.dictionaryContent[wordID]["expert"];
      lastModifiedTime =
          appController.dictionaryContent[wordID]["lastModifiedTime"];
    }
  }

  @override
  void onInit() {
    super.onInit();
    print("wordOfTheDay: " + wordOfTheDay);
    wotdFound = appController.dictionaryContent.containsKey(wordOfTheDay);
    getInformation();
    if (appController.noData.value) {
      Helper.errorSnackBar(
          title: "Dictionary currently has no data",
          message:
              "Please connect to the internet to sync dictionary's data to local device.");
    }
  }
}
