import 'package:amanu/utils/application_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchWordController extends GetxController {
  static SearchWordController get instance => Get.find();

  SearchWordController({this.fromKulitan = false, this.kulitanQuery = ''});

  final bool fromKulitan;
  final String kulitanQuery;

  final appController = Get.find<ApplicationController>();

  late TextEditingController searchBoxController;

  RxBool searchInWord = true.obs;
  RxBool searchInEngTrans = true.obs;
  RxBool searchInFilTrans = true.obs;
  RxBool searchInKulitan = true.obs;
  RxBool searchInDefinition = false.obs;
  RxBool searchInRelated = false.obs;
  RxBool searchInSynonyms = false.obs;
  RxBool searchInAntonyms = false.obs;
  RxBool isAscending = true.obs;
  RxBool loading = false.obs;

  RxMap<dynamic, dynamic> suggestionMap = <dynamic, dynamic>{}.obs;
  Map<dynamic, dynamic> foundOn = {};

  @override
  void onInit() {
    super.onInit();
    suggestionMap.value = appController.dictionaryContent;
    if (fromKulitan) {
      searchWord(kulitanQuery);
      searchBoxController = TextEditingController(text: kulitanQuery);
    } else {
      searchBoxController = TextEditingController();
    }
  }

  void searchWord(String input) {
    loading.value = true;
    Map<dynamic, dynamic> tempMap = {};
    Map<dynamic, dynamic> tempFoundOn = {};
    String query = appController.normalizeWord(input);
    for (var entry in appController.dictionaryContent.entries) {
      if (searchInWord.value) {
        if (entry.value["word"] != null) {
          String word = entry.value["word"].toLowerCase();
          if (word.contains(query)) {
            tempMap[entry.key] = entry.value;
            tempFoundOn[entry.key] = "engTrans";
            continue;
          }
        }
      }
      if (searchInEngTrans.value) {
        if (entry.value["englishTranslations"] != null) {
          bool _found = false;
          List<dynamic> engTransList = entry.value["englishTranslations"];
          for (var trans in engTransList) {
            if (trans.toLowerCase().contains(query)) {
              tempMap[entry.key] = entry.value;
              tempFoundOn[entry.key] = "engTrans";
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
          List<dynamic> filTransList = entry.value["filipinoTranslations"];
          for (var trans in filTransList) {
            if (trans.toLowerCase().contains(query)) {
              tempMap[entry.key] = entry.value;
              tempFoundOn[entry.key] = "filTrans";
              _found = true;
              break;
            }
          }
          if (_found) {
            continue;
          }
        }
      }
      if (searchInKulitan.value) {
        if (entry.value["kulitan-form"] != null) {
          var kulitanList = entry.value["kulitan-form"];
          String kulitanString = '';
          for (var line in kulitanList) {
            if (line != null) {
              for (var syl in line) {
                kulitanString = kulitanString + syl;
              }
            }
          }
          if (kulitanString.contains(query)) {
            tempMap[entry.key] = entry.value;
            tempFoundOn[entry.key] = "engTrans";
            continue;
          }
        }
      }
      if (searchInDefinition.value) {
        if (entry.value["meanings"] != null) {
          bool _found = false;
          List<dynamic> meanings = entry.value["meanings"];
          for (var meaning in meanings) {
            bool _foundInDef = false;
            List<Map<dynamic, dynamic>> definitions = meaning["definitions"];
            for (var definition in definitions) {
              if (definition["definition"].toLowerCase().contains(query)) {
                tempMap[entry.key] = entry.value;
                tempFoundOn[entry.key] = "engTrans";
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
              tempMap[entry.key] = entry.value;
              tempFoundOn[entry.key] = "otherRelated";
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
              tempMap[entry.key] = entry.value;
              tempFoundOn[entry.key] = "synonyms";
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
              tempMap[entry.key] = entry.value;
              tempFoundOn[entry.key] = "antonyms";
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
    suggestionMap.value = tempMap;
    foundOn = tempFoundOn;
    if (suggestionMap.length == 0) {
      Future.delayed(Duration(seconds: 3), () {
        loading.value = false;
      });
    }
  }
}
