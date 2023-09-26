import 'dart:async';

import 'package:amanu/components/coachmark_desc.dart';
import 'package:amanu/screens/user_tools/controllers/modify_word_controller.dart';
import 'package:amanu/utils/constants/kulitan_characters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class KulitanController extends GetxController {
  static KulitanController get instance => Get.find();

  final addPageController = Get.find<ModifyController>();

  GlobalKey kulitanScreenKey = GlobalKey();
  GlobalKey kulitanKeyboardKey = GlobalKey();
  GlobalKey kulitanViewerKey = GlobalKey();
  GlobalKey kulitanSaveKey = GlobalKey();

  late BuildContext context;

  List<TargetFocus> initTarget() {
    return [
      TargetFocus(
          identify: "kulitan-screen-key",
          keyTarget: kulitanScreenKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Kulitan Editor",
                  text:
                      "This is the <b>Kulitan Editor</b>, your tool in writing Kulitan scripts. It's like a notepad, but using <i>Kulitan characters</i>.",
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
          identify: "kulitan-keyboard-key",
          keyTarget: kulitanScreenKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height / 5),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Kulitan Keyboard",
                  text:
                      'This is the <b>Kulitan Keyboard</b>. Use it to type <i>Kulitan characters</i> by <i>tapping</i> for an "<i>-a</i>" character, <i>hold-swiping up</i> for "<i>-i</i>" character, and <i>hold-swiping down</i> for "<i>-u</i>" characters.',
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
          identify: "kulitan-viewer-key",
          keyTarget: kulitanViewerKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Kulitan Viewer",
                  text:
                      'This is the <b>Kulitan Viewer</b> where all your typed characters will be displayed. You can <i>scroll through the viewer</i> if your Kulitan script is too long for the viewer.',
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
          identify: "kulitan-save-key",
          keyTarget: kulitanSaveKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Save your changes",
                  text:
                      "Save your changes using the save button on the upper left.",
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

  List<List<List<String>>> keyboardData = [
    [
      ["ga", "ga", "gi", "gi", "gu", "gu"],
      ["ka", "ka", "ki", "ki", "ku", "ku"],
      ["nga", "nga", "ngi", "ngi", "ngu", "ngu"],
      ["a", "a", "a", "a", "a", "a"]
    ],
    [
      ["ba", "ba", "bi", "bi", "bu", "bu"],
      ["ta", "ta", "ti", "ti", "tu", "tu"],
      ["da", "da", "di", "di", "du", "du"],
      ["i", "i", "yi", "yi", "yu", "yu"]
    ],
    [
      ["na", "na", "ni", "ni", "nu", "nu"],
      ["la", "la", "li", "li", "lu", "lu"],
      ["sa", "sa", "si", "si", "su", "su"],
      ["u", "u", "wi", "wi", "wu", "wu"]
    ],
    [
      ["ma", "ma", "mi", "mi", "mu", "mu"],
      ["pa", "pa", "pi", "pi", "pu", "pu"],
    ]
  ];

  RxInt currentLine = 0.obs;
  RxInt currentSpace = 0.obs;

  RxList<List<dynamic>> kulitanStringList = <List<dynamic>>[[]].obs;

  bool classifyKulitan(List<List<dynamic>> conditionList, String input) {
    for (final condition in conditionList) {
      for (final x in condition) {
        if (x == input) return true;
      }
    }
    return false;
  }

  void addLine() {
    // ignore: invalid_use_of_protected_member
    kulitanStringList.value.add([]);
    kulitanStringList.refresh();
    currentLine.value += 1;
    currentSpace.value = 0;
  }

  void insertCharacter(String kulitanChar) {
    kulitanStringList[currentLine.value]
        .insert(currentSpace.value, kulitanChar);
    kulitanStringList.refresh();
    if (currentSpace.value < 3) {
      currentSpace.value += 1;
    }
  }

  String chopCharacter(String kulitanChar) {
    String newString = kulitanChar.replaceAll("a", "");
    return newString;
  }

  void addCharacter(String kulitanChar) async {
    blinkerTyping.value = true;
    print("Cursor: Line " +
        currentLine.value.toString() +
        ", Space " +
        currentSpace.value.toString());
    print("Adding: " + kulitanChar);
    if (kulitanStringList[currentLine.value].length < 3) {
      if (currentSpace.value == 0) {
        insertCharacter(kulitanChar);
      } else if (currentSpace.value == 1) {
        if (classifyKulitan([
          garlitUpperVowels,
          garlitUpperConsonants,
          garlitLowerVowels,
          garlitLowerConsonants
        ], kulitanChar)) {
          addLine();
          insertCharacter(kulitanChar);
        } else if (classifyKulitan([baseConsonants], kulitanChar)) {
          insertCharacter(chopCharacter(kulitanChar));
        } else if (classifyKulitan([baseVowels], kulitanChar)) {
          insertCharacter(kulitanChar);
        }
      } else if (currentSpace.value == 2) {
        if (classifyKulitan([
          garlitUpperVowels,
          garlitUpperConsonants,
          garlitLowerVowels,
          garlitLowerConsonants
        ], kulitanChar)) {
          addLine();
          insertCharacter(kulitanChar);
        } else if (classifyKulitan(//2nd char is vowel
            [baseVowels], kulitanStringList[currentLine.value][1])) {
          if (classifyKulitan(// 1st char is vowel
              [baseVowels], kulitanStringList[currentLine.value][0])) {
            if (kulitanStringList[currentLine.value]
                        [0] == // 1st and 2nd are same, and entry is vowel
                    kulitanStringList[currentLine.value][1] &&
                (classifyKulitan([baseVowels], kulitanChar))) {
              addLine();
              insertCharacter(kulitanChar);
            } else if (kulitanStringList[currentLine.value][
                        0] == // 1st and 2nd are same, and entry is base consonant
                    kulitanStringList[currentLine.value][1] &&
                (classifyKulitan([baseConsonants], kulitanChar))) {
              insertCharacter(chopCharacter(kulitanChar));
            } else if (classifyKulitan([
              // 1st and 2nd are vowels !=, and input is BC or BV
              baseConsonants,
              baseVowels
            ], kulitanChar)) {
              if (classifyKulitan([baseConsonants], kulitanChar)) {
                insertCharacter(chopCharacter(kulitanChar));
              } else if (classifyKulitan([baseVowels], kulitanChar)) {
                insertCharacter(kulitanChar);
              }
            }
          } else if (classifyKulitan([
            // 2nd is vowels and 1st are BC GUC GLC GUV GLV
            baseConsonants,
            garlitUpperConsonants,
            garlitLowerConsonants,
            garlitUpperVowels,
            garlitLowerVowels
          ], kulitanStringList[currentLine.value][0])) {
            if (classifyKulitan([baseConsonants], kulitanChar)) {
              insertCharacter(chopCharacter(kulitanChar));
            } else if (classifyKulitan([baseVowels], kulitanChar)) {
              insertCharacter(kulitanChar);
            }
          }
        } else if (classifyKulitan([baseConsonants, baseConsonantsChopped],
            kulitanStringList[currentLine.value][1])) {
          addLine();
          insertCharacter(kulitanChar);
        }
      } else {}
    } else {
      addLine();
      await Future.delayed(Duration(milliseconds: 200));
      insertCharacter(kulitanChar);
    }
    // ignore: invalid_use_of_protected_member
    print(kulitanStringList.value);
    print("Current: Line " +
        currentLine.value.toString() +
        ", Space " +
        currentSpace.value.toString());
    kulitanStringList.refresh();
    blinkerTyping.value = false;
  }

  void deleteCharacter() {
    blinkerTyping.value = true;
    if (kulitanStringList.length >= 1) {
      if (kulitanStringList.length > 1) {
        if (currentSpace.value == 0) {
          kulitanStringList.removeAt(currentLine.value);
          print("Removed line " + currentLine.value.toString());
          currentLine.value -= 1;
          if (kulitanStringList[currentLine.value].length != 0) {
            currentSpace.value =
                kulitanStringList[currentLine.value].length - 1;
            print("Removed L" +
                currentLine.value.toString() +
                "S" +
                currentSpace.value.toString() +
                " : " +
                kulitanStringList[currentLine.value][currentSpace.value]);
            kulitanStringList[currentLine.value].removeAt(currentSpace.value);
          } else {
            currentSpace.value = 0;
          }
        } else {
          print("Removed L" +
              currentLine.value.toString() +
              "S" +
              currentSpace.value.toString() +
              " : " +
              kulitanStringList[currentLine.value][currentSpace.value - 1]);
          kulitanStringList[currentLine.value].removeAt(currentSpace.value - 1);
          currentSpace.value -= 1;
        }
      } else {
        if (currentSpace.value != 0) {
          print("Removed L" +
              currentLine.value.toString() +
              "S" +
              currentSpace.value.toString() +
              " : " +
              kulitanStringList[currentLine.value][currentSpace.value - 1]);
          kulitanStringList[currentLine.value].removeAt(currentSpace.value - 1);
          currentSpace.value -= 1;
        }
      }
    }
    kulitanStringList.refresh();
    blinkerTyping.value = false;
  }

  void enterNewLine() {
    addLine();
    print("Add line on L" + currentLine.value.toString());
    // ignore: invalid_use_of_protected_member
    print(kulitanStringList.value);
    print("Current: Line " +
        currentLine.value.toString() +
        ", Space " +
        currentSpace.value.toString());
    kulitanStringList.refresh();
  }

  void clearList() {
    kulitanStringList.clear();
    kulitanStringList.insert(0, []);
    currentSpace.value = 0;
    currentLine.value = 0;
    kulitanStringList.refresh();
  }

  RxBool blinkerShow = true.obs;
  RxBool blinkerTyping = false.obs;
  int blinkDuration = 1200;
  int showDuration = 600;

  Timer? _showTimer;
  Timer? _hideTimer;

  void initializeTimers() async {
    _showTimer = Timer.periodic(Duration(milliseconds: blinkDuration), (_) {
      if (!blinkerTyping.value) blinkerShow.value = true;
    });
    await Future.delayed(Duration(milliseconds: showDuration));
    if (blinkerShow.value)
      _hideTimer = Timer.periodic(Duration(milliseconds: blinkDuration), (_) {
        if (!blinkerTyping.value) {
          if (blinkerShow.value) {
            blinkerShow.value = false;
          }
        }
      });
  }

  void checkIfEmpty() {
    String kulitanString = '';
    for (var line in kulitanStringList) {
      for (String i in line) {
        kulitanString += i;
      }
    }
    if (kulitanString == '') {
      addPageController.kulitanListEmpty.value = true;
    } else {
      addPageController.kulitanListEmpty.value = false;
    }
  }

  void saveKulitan() {
    addPageController.kulitanStringListGetter.clear();
    for (var i in kulitanStringList) {
      addPageController.kulitanStringListGetter.add(i);
    }
    addPageController.kulitanStringListGetter.refresh();
    addPageController.currentLine = currentLine.value;
    addPageController.currentSpace = currentSpace.value;
  }

  void getFromAddPage() {
    kulitanStringList.clear();
    for (var i in addPageController.kulitanStringListGetter) {
      kulitanStringList.add(i);
    }
    kulitanStringList.refresh();
    currentLine.value = addPageController.currentLine;
    currentSpace.value = addPageController.currentSpace;
  }

  @override
  void onInit() {
    super.onInit();
    getFromAddPage();
    initializeTimers();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      blinkerShow.value = true;
    });
  }

  @override
  void onClose() {
    _showTimer!.cancel();
    _hideTimer!.cancel();
  }
}
