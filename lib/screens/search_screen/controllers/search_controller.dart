import 'package:amanu/components/coachmark_desc.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class SearchWordController extends GetxController {
  static SearchWordController get instance => Get.find();

  SearchWordController({this.fromKulitan = false, this.kulitanQuery = ''});

  GlobalKey searchKey = GlobalKey();
  GlobalKey searchBoxKey = GlobalKey();
  GlobalKey searchListKey = GlobalKey();
  GlobalKey searchFilterKey = GlobalKey();

  late BuildContext context;

  List<TargetFocus> initTarget() {
    return [
      TargetFocus(
          identify: "search-key",
          keyTarget: searchKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Search Screen",
                  text:
                      "This is the <b>Search screen</b>, where you can look up your <i>word queries</i>.",
                  onNext: () {
                    ctl.next();
                  },
                  onSkip: () {
                    ctl.skip();
                  },
                );
              },
            ),
          ]),
      TargetFocus(
          identify: "search-box-key",
          keyTarget: searchBoxKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Search Box",
                  text:
                      "Type your queries using this <b>Search box</b>, and we'll automatically look for your <i>word query</i>.",
                  onNext: () {
                    ctl.next();
                  },
                  onSkip: () {
                    ctl.skip();
                  },
                );
              },
            ),
          ]),
      TargetFocus(
          identify: "search-results-key",
          keyTarget: searchListKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(bottom: 10),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Search Results",
                  text:
                      "<b>Search results</b> will be listed here, in which, you can open the details page of a particular word by <i>tapping on its browse card</i>.",
                  onNext: () {
                    ctl.next();
                  },
                  onSkip: () {
                    ctl.skip();
                  },
                );
              },
            ),
          ]),
      TargetFocus(
          identify: "search-filter-key",
          keyTarget: searchFilterKey,
          shape: ShapeLightFocus.Circle,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Search Filter",
                  text:
                      "You may use the <b>Search filter</b> button to refine your searches. Just enable which parts of a word we should run your search query.",
                  onNext: () {
                    ctl.next();
                  },
                  next: "Got it!",
                  skip: "",
                  withSkip: false,
                  onSkip: () {},
                );
              },
            ),
          ]),
    ];
  }

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
          String word = entry.value["word"]
              .toLowerCase()
              .replaceAll("<i>", "")
              .replaceAll("</i>", "")
              .replaceAll("<b>", "")
              .replaceAll("</b>", "")
              .replaceAll("<u>", "")
              .replaceAll("</u>", "");
          String normalized = appController.normalizeWord(word);
          if (normalized.contains(query)) {
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
            var normalized = appController.normalizeWord(trans);
            if (normalized.toLowerCase().contains(query)) {
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
            var normalized = appController.normalizeWord(trans);
            if (normalized.toLowerCase().contains(query)) {
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
          String normalized = appController.normalizeWord(kulitanString);
          if (normalized.toLowerCase().contains(query)) {
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
            //TODO
            if (meaning["definitions"] != null) {
              List<dynamic> definitions = meaning["definitions"];
              for (var definition in definitions) {
                var defNoTags = definition["definition"]
                    .toLowerCase()
                    .replaceAll("<i>", "")
                    .replaceAll("</i>", "")
                    .replaceAll("<b>", "")
                    .replaceAll("</b>", "")
                    .replaceAll("<u>", "")
                    .replaceAll("</u>", "");
                var normalized = appController.normalizeWord(defNoTags);
                if (normalized.toLowerCase().contains(query)) {
                  tempMap[entry.key] = entry.value;
                  tempFoundOn[entry.key] = "engTrans";
                  _foundInDef = true;
                  break;
                }
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
            var relWord = appController.normalizeWord(rel.key);
            if (relWord.toLowerCase().contains(query)) {
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
            var synWord = appController.normalizeWord(syn.key);
            if (synWord.toLowerCase().contains(query)) {
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
            var antWord = appController.normalizeWord(ant.key);
            if (antWord.toLowerCase().contains(query)) {
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
