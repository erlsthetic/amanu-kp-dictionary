import 'package:amanu/utils/constants/kulitan_characters.dart';
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

  RxList<List<String>> kulitanStringList = <List<String>>[].obs;

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
    if (currentSpace.value < 3) {
      currentSpace.value += 1;
    }
  }

  String chopCharacter(String kulitanChar) {
    String newString = kulitanChar.replaceAll("a", "");
    return newString;
  }

  void addCharacter(String kulitanChar) {
    if (kulitanStringList[currentLine.value].length <= 3) {
      if (currentLine.value == 0) {
        insertCharacter(kulitanChar);
      } else if (currentLine.value == 1) {
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
      } else if (currentLine.value == 2) {
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
              insertCharacter(chopCharacter(kulitanChar));
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
    }
  }
}
