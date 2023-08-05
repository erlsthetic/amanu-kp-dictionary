import 'package:amanu/utils/application_controller.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  static SearchController get instance => Get.find();

  final appController = Get.find<ApplicationController>();

  RxBool searchInWord = true.obs;
  RxBool searchInEngTrans = true.obs;
  RxBool searchInFilTrans = true.obs;
  RxBool searchInDefinition = false.obs;
  RxBool searchInRelated = false.obs;
  RxBool searchInSynonyms = false.obs;
  RxBool searchInAntonyms = true.obs;

  RxMap<dynamic, dynamic> suggestionMap = <dynamic, dynamic>{}.obs;

  void searchWord(String input) {
    String query = input.toLowerCase();
    suggestionMap.clear();
    for (var entry in appController.dictionaryContent.entries) {
      if (searchInWord.value) {
        if (entry.value["word"] != null) {
          String word = entry.value["word"].toLowerCase();
          if (word.contains(query)) {
            suggestionMap[entry.key] = entry.value;
            continue;
          }
        }
      }
      if (searchInEngTrans.value) {
        if (entry.value["englishTranslations"] != null) {
          bool _found = false;
          List<String> engTransList = entry.value["englishTranslations"];
          for (var trans in engTransList) {
            if (trans.toLowerCase().contains(query)) {
              suggestionMap[entry.key] = entry.value;
              _found = true;
              break;
            }
          }
          if (_found) {
            continue;
          }
        }
      }
      if (searchInFilTrans.value) {
        if (entry.value["filipinoTranslations"] != null) {
          bool _found = false;
          List<String> filTransList = entry.value["filipinoTranslations"];
          for (var trans in filTransList) {
            if (trans.toLowerCase().contains(query)) {
              suggestionMap[entry.key] = entry.value;
              _found = true;
              break;
            }
          }
          if (_found) {
            continue;
          }
        }
      }
      if (searchInDefinition.value) {
        if (entry.value["meanings"] != null) {
          bool _found = false;
          List<Map<dynamic, dynamic>> meanings =
              entry.value["filipinoTranslations"];
          for (var meaning in meanings) {
            bool _foundInDef = false;
            List<Map<dynamic, dynamic>> definitions = meaning["definitions"];
            for (var definition in definitions) {
              if (definition["definition"].toLowerCase().contains(query)) {
                suggestionMap[entry.key] = entry.value;
                _foundInDef = true;
                break;
              }
            }
            if (_foundInDef) {
              _found = true;
              break;
            }
          }
          if (_found) {
            continue;
          }
        }
      }
      if (searchInRelated.value) {
        if (entry.value["otherRelated"] != null) {
          bool _found = false;
          Map<dynamic, dynamic> related = entry.value["otherRelated"];
          for (var rel in related.entries) {
            if (rel.key.toLowerCase().contains(query)) {
              suggestionMap[entry.key] = entry.value;
              _found = true;
              break;
            }
          }
          if (_found) {
            continue;
          }
        }
      }
      if (searchInSynonyms.value) {
        if (entry.value["synonyms"] != null) {
          bool _found = false;
          Map<dynamic, dynamic> synonyms = entry.value["synonyms"];
          for (var syn in synonyms.entries) {
            if (syn.key.toLowerCase().contains(query)) {
              suggestionMap[entry.key] = entry.value;
              _found = true;
              break;
            }
          }
          if (_found) {
            continue;
          }
        }
      }
      if (searchInAntonyms.value) {
        if (entry.value["antonyms"] != null) {
          bool _found = false;
          Map<dynamic, dynamic> antonyms = entry.value["antonyms"];
          for (var ant in antonyms.entries) {
            if (ant.key.toLowerCase().contains(query)) {
              suggestionMap[entry.key] = entry.value;
              _found = true;
              break;
            }
          }
          if (_found) {
            continue;
          }
        }
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    suggestionMap.value = appController.dictionaryContent;
  }
}
