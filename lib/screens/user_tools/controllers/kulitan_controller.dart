import 'dart:async';

import 'package:amanu/utils/constants/kulitan_characters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KulitanController extends GetxController {
  static KulitanController get instance => Get.find();

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

  RxList<List<String>> kulitanStringList = <List<String>>[[]].obs;

  bool classifyKulitan(List<List<String>> conditionList, String input) {
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
    if (currentSpace.value < 2) {
      currentSpace.value += 1;
    } else {
      addLine();
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
    if (kulitanStringList[currentLine.value].length <= 3) {
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
        } else if (classifyKulitan(
            [baseVowels], kulitanStringList[currentLine.value][1])) {
          if (classifyKulitan(
              [baseVowels], kulitanStringList[currentLine.value][0])) {
            print("here");
            if (kulitanStringList[currentLine.value][0] ==
                    kulitanStringList[currentLine.value][1] &&
                (classifyKulitan([baseVowels], kulitanChar))) {
              addLine();
              insertCharacter(kulitanChar);
            } else if (kulitanStringList[currentLine.value][0] ==
                    kulitanStringList[currentLine.value][1] &&
                (classifyKulitan([baseConsonants], kulitanChar))) {
              insertCharacter(chopCharacter(kulitanChar));
            }
          } else if (classifyKulitan([
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

  @override
  void onInit() {
    super.onInit();
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
