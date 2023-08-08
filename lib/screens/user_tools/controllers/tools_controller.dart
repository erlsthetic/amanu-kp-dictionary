import 'package:amanu/screens/user_tools/widgets/preview_page.dart';
import 'package:intl/intl.dart';

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textfield_tags/textfield_tags.dart';

class ModifyController extends GetxController {
  static ModifyController get instance => Get.find();

  RxBool isProcessing = false.obs;

  late TextEditingController wordController,
      phoneticController,
      referencesController;

  String? validateWord(String value) {
    if (value.isEmpty) {
      return "Please enter word";
    }
    return null;
  }

  String? validatePhonetic(String value) {
    if (value.isEmpty) {
      return "Please enter word phonetics";
    }
    return null;
  }

  final GlobalKey<FormState> addWordFormKey = GlobalKey<FormState>();

  late final PlayerController playerController;
  RxBool rebuildAudio = true.obs;
  String audioPath = "";
  RxBool isPlaying = false.obs;
  RxBool hasFile = false.obs;
  RxBool audioSubmitError = false.obs;

  void playAndStop(PlayerController controller) async {
    if (controller.playerState == PlayerState.playing) {
      await controller.pausePlayer();
    } else {
      await controller.startPlayer(finishMode: FinishMode.loop);
    }

    playerController.playerState == PlayerState.playing
        ? isPlaying.value = true
        : isPlaying.value = false;
  }

  void validateAudio() {
    if (hasFile.value) {
      audioSubmitError.value = false;
    } else {
      audioSubmitError.value = true;
    }
  }

  late TextfieldTagsController engTransController,
      filTransController,
      relatedController,
      synonymController,
      antonymController;

  List<String> engTransList = [];

  void getEnglishTranslations() {
    engTransList.clear();
    for (String word in engTransController.getTags!) {
      engTransList.add(word);
    }
  }

  RxBool engTransEmpty = false.obs;

  void validateEngTrans() {
    if (engTransList.length == 0) {
      engTransEmpty.value = true;
    } else {
      engTransEmpty.value = false;
    }
  }

  List<String> filTransList = [];

  void getFilipinoTranslations() {
    filTransList.clear();
    for (String word in filTransController.getTags!) {
      filTransList.add(word);
    }
  }

  RxBool filTransEmpty = false.obs;

  void validateFilTrans() {
    if (filTransList.length == 0) {
      filTransEmpty.value = true;
    } else {
      filTransEmpty.value = false;
    }
  }

  RxList<List<String>> kulitanStringListGetter = <List<String>>[[]].obs;
  int currentLine = 0;
  int currentSpace = 0;
  RxBool kulitanListEmpty = true.obs;
  RxBool kulitanError = false.obs;

  void validateKulitan() {
    if (kulitanListEmpty.value) {
      kulitanError.value = true;
    } else {
      kulitanError.value = false;
    }
  }

  final GlobalKey<AnimatedListState> typeListKey = GlobalKey();
  final List<GlobalKey<AnimatedListState>> definitionListKey = [];

  List<DropdownMenuItem<String>> get typeDropItems {
    List<DropdownMenuItem<String>> wordTypes = [
      DropdownMenuItem(child: Text("noun"), value: "noun"),
      DropdownMenuItem(child: Text("verb"), value: "verb"),
      DropdownMenuItem(child: Text("adjective"), value: "adjective"),
      DropdownMenuItem(child: Text("adverb"), value: "adverb"),
      DropdownMenuItem(child: Text("particle"), value: "particle"),
      DropdownMenuItem(child: Text("custom"), value: "custom"),
    ];
    return wordTypes;
  }

  final RxList<String> typeFields = <String>[].obs;
  final List<TextEditingController> customTypeController = [];
  final RxList<List<List<TextEditingController>>> definitionsFields =
      <List<List<TextEditingController>>>[].obs;
  // TD is              D                  TD
  //[[[TE, TE, TE, TE], [TE, TE, TE, TE]], [[TE, TE, TE, TE]]]
  void addTypeField(int i) {
    typeListKey.currentState?.insertItem(i);
    customTypeController.insert(i, TextEditingController());
    definitionListKey.insert(i, GlobalKey());
    typeFields.insert(i, '');
    definitionsFields.insert(i, []);
    addDefinitionField(i, 0);
  }

  void removeTypeField(int i) {
    typeFields.removeAt(i);
    customTypeController.removeAt(i);
    typeListKey.currentState!.removeItem(i, (_, __) => Container());
  }

  void addDefinitionField(int i, int j) {
    definitionsFields[i].insert(j, [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ]);
    definitionListKey[i].currentState?.insertItem(j);
  }

  void removeDefinitionField(int i, int j) {
    definitionsFields[i].removeAt(j);
    definitionListKey[i].currentState!.removeItem(j, (_, __) => Container());
  }

  String? validateType(String value) {
    if (value.isEmpty) {
      return "Please select a type";
    }
    return null;
  }

  String? validateCustomType(String value) {
    if (value.isEmpty) {
      return "Please enter custom type";
    }
    return null;
  }

  String? validateDefinition(String value) {
    if (value.isEmpty) {
      return "Please enter a definition";
    }
    return null;
  }

  Map<String, String> importedSynonyms = {};
  Map<String, dynamic> synonymsMap = {};
  Map<String, String> importedAntonyms = {};
  Map<String, dynamic> antonymsMap = {};
  Map<String, String> importedRelated = {};
  Map<String, dynamic> relatedMap = {};

  void addAsImported(Map<String, String> importedMap,
      TextfieldTagsController controller, String word, String wordID) {
    controller.onChanged(word);
    importedMap[word] = wordID;
    print(importedMap);
    List<String> currentTags = controller.getTags!;
    print(currentTags);
  }

  void getTextFieldTagsData(TextfieldTagsController controller,
      Map<String, String> importedMap, Map<String, dynamic> saveMap) {
    saveMap.clear();
    for (String word in controller.getTags!) {
      if (importedMap.containsKey(word)) {
        saveMap[word] = importedMap[word]!;
      } else {
        saveMap[word] = null;
      }
    }
  }

  String normalizeWord(String word) {
    String normalWord = word
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[àáâäæãåā]'), 'a')
        .replaceAll(RegExp(r'[îïíīįì]'), 'i')
        .replaceAll(RegExp(r'[ûüùúū]'), 'u')
        .replaceAll(RegExp(r'[èéêëēėę]'), 'e')
        .replaceAll(RegExp(r'[ôöòóœøōõ]'), 'o')
        .replaceAll(RegExp(r'[!-,\.-@\[-`{-¿]'), '');
    return normalWord;
  }

  Future<String> availableKey(String key) async {
    final _realtimeDB = FirebaseDatabase.instance.ref();
    int modifier = 0;
    String currentString = key;
    bool notAvailable;
    var snapshot = await _realtimeDB.child("dictionary").child(key).get();
    if (snapshot.exists) {
      notAvailable = true;
      while (notAvailable) {
        currentString = key + modifier.toString();
        snapshot =
            await _realtimeDB.child("dictionary").child(currentString).get();
        if (snapshot.exists) {
          modifier += 1;
        } else {
          return currentString;
        }
      }
    } else {
      return currentString;
    }
  }

  @override
  void onInit() {
    super.onInit();
    wordController = TextEditingController();
    phoneticController = TextEditingController();
    engTransController = TextfieldTagsController();
    filTransController = TextfieldTagsController();
    playerController = PlayerController();
    addTypeField(0);
    relatedController = TextfieldTagsController();
    synonymController = TextfieldTagsController();
    antonymController = TextfieldTagsController();
    referencesController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    wordController.dispose();
    phoneticController.dispose();
    engTransController.dispose();
    filTransController.dispose();
    playerController.dispose();
    relatedController.dispose();
    synonymController.dispose();
    antonymController.dispose();
    referencesController.dispose();
  }

  void submitWord() async {
    validateAudio();
    getEnglishTranslations();
    validateEngTrans();
    getFilipinoTranslations();
    validateFilTrans();
    validateKulitan();
    getTextFieldTagsData(relatedController, importedRelated, relatedMap);
    getTextFieldTagsData(synonymController, importedSynonyms, synonymsMap);
    getTextFieldTagsData(antonymController, importedAntonyms, antonymsMap);

    final informationValid = addWordFormKey.currentState!.validate();
    if (!informationValid ||
        wordController.text.isEmpty ||
        phoneticController.text.isEmpty ||
        audioSubmitError.value ||
        kulitanError.value) {
      return;
    }
    addWordFormKey.currentState!.save();

    String normalizedWord = normalizeWord(wordController.text.trim());
    //String wordKey = await availableKey(normalizedWord);
    String wordKey = normalizedWord;

    List<Map<String, dynamic>> meanings = [];

    for (MapEntry type in typeFields.asMap().entries) {
      Map<String, dynamic> tempMeaning = {};

      tempMeaning["partOfSpeech"] = type.value == "custom"
          ? customTypeController[type.key].text
          : type.value;

      List<Map<String, dynamic>> tempDefinitions = [];

      for (var definition in definitionsFields[type.key]) {
        Map<String, dynamic> tempDef = {};
        tempDef["definition"] = definition[0].text;
        tempDef["example"] =
            definition[1].text.isEmpty || definition[2].text.trim() == ""
                ? null
                : definition[1].text;
        tempDef["exampleTranslation"] =
            definition[2].text.isEmpty || definition[3].text.trim() == ""
                ? null
                : definition[2].text;
        tempDef["dialect"] =
            definition[3].text.isEmpty || definition[1].text.trim() == ""
                ? null
                : definition[3].text;
        tempDef["origin"] =
            definition[4].text.isEmpty || definition[1].text.trim() == ""
                ? null
                : definition[4].text;
        tempDefinitions.add(tempDef);
      }
      tempMeaning["definitions"] = tempDefinitions;
      meanings.add(tempMeaning);
    }

    final String timestamp =
        DateFormat('yyyy-MM-dd (HH:mm:ss)').format(DateTime.now());

    /*
    Map<String, dynamic> details = {
      "word": wordController.text.trim(),
      "normalizedWord": normalizedWord,
      "pronunciation": phoneticController.text.trim(),
      "pronunciationAudio": audioPath,
      "englishTranslations": engTransEmpty.value ? null : engTransList,
      "filipinoTranslations": filTransEmpty.value ? null : filTransList,
      "meanings": meanings,
      "kulitan-form": kulitanStringListGetter,
      "otherRelated": relatedMap.length == 0 ? null : relatedMap,
      "synonyms": synonymsMap.length == 0 ? null : synonymsMap,
      "antonyms": antonymsMap.length == 0 ? null : antonymsMap,
      "sources": referencesController.text.isEmpty ||
              referencesController.text.trim() == ''
          ? null
          : referencesController.text.trim(),
      "contributors": null,
      "expert": null,
      "lastModifiedTime": timestamp
    };
    */

    List<String> types = [];
    List<List<Map<String, dynamic>>> definitions = [];

    for (Map<String, dynamic> meaning in meanings) {
      types.add(meaning["partOfSpeech"]);
      List<Map<String, dynamic>> tempDef = [];
      for (Map<String, dynamic> definition in meaning["definitions"]) {
        tempDef.add(definition);
      }
      definitions.add(tempDef);
    }
    String kulitanString = '';
    for (var line in kulitanStringListGetter) {
      for (var syl in line) {
        kulitanString = kulitanString + syl;
      }
    }

    Get.to(() => PreviewPage(
          wordID: wordKey,
          word: wordController.text.trim(),
          normalizedWord: normalizedWord,
          prn: phoneticController.text.trim(),
          prnPath: audioPath,
          engTrans: engTransEmpty.value ? null : engTransList,
          filTrans: filTransEmpty.value ? null : filTransList,
          meanings: meanings,
          types: typeFields,
          kulitanChars: kulitanStringListGetter,
          otherRelated: relatedMap.length == 0 ? null : relatedMap,
          synonyms: synonymsMap.length == 0 ? null : synonymsMap,
          antonyms: antonymsMap.length == 0 ? null : antonymsMap,
          sources: referencesController.text.isEmpty ||
                  referencesController.text.trim() == ''
              ? null
              : referencesController.text.trim(),
          contributors: null,
          expert: null,
          lastModifiedTime: timestamp,
          definitions: definitions,
          kulitanString: kulitanString,
        ));
  }
}
