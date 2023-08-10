import 'dart:io';

import 'package:amanu/screens/user_tools/widgets/preview_page.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/helper_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ModifyController extends GetxController {
  ModifyController({this.editMode = false, this.editWordID});
  final bool editMode;
  final String? editWordID;
  static ModifyController get instance => Get.find();
  bool importError = false;

  final appController = Get.find<ApplicationController>();
  RxBool isProcessing = false.obs;

  void populateFields() async {
    isProcessing.value = true;
    // reload dictionary
    wordController.text = appController.dictionaryContent[editWordID]["word"];
    phoneticController.text =
        appController.dictionaryContent[editWordID]["pronunciation"];
    String prnUrl =
        appController.dictionaryContent[editWordID]["pronunciationAudio"];
    String prnUrlExt = appController.dictionaryContent[editWordID]
            ["pronunciationAudio"]
        .split("?")
        .first!;
    final appStorage = await getApplicationDocumentsDirectory();
    final fileExt = extension(File(prnUrlExt).path);
    final tempAudioFile = File('${appStorage.path}/audio$fileExt');
    try {
      final response = await Dio().get(
        prnUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: Duration(seconds: 15),
        ),
      );
      final raf = tempAudioFile.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      importError = false;
      await raf.close();
    } catch (e) {
      Get.back();
      Helper.errorSnackBar(
          title: tOhSnap,
          message: "Unable to get audio pronunciation from the internet.");
      return;
    }
    audioPath = tempAudioFile.path;
    playerController.stopPlayer();
    playerController.preparePlayer(path: audioPath);
    playerController.seekTo(0);
    hasFile.value = true;
    if (appController.dictionaryContent[editWordID]["englishTranslations"] !=
        null) {
      for (var trans in appController.dictionaryContent[editWordID]
          ["englishTranslations"]) {
        engTransController..addTag = trans;
      }
    }
    if (appController.dictionaryContent[editWordID]["filipinoTranslations"] !=
        null) {
      for (var trans in appController.dictionaryContent[editWordID]
          ["filipinoTranslations"]) {
        filTransController..addTag = trans;
      }
    }
    List<Map<String, dynamic>> meanings =
        appController.dictionaryContent[editWordID]["meanings"];
    List<String> _types = [];
    List<List<Map<String, dynamic>>> _definitions = [];
    for (Map<String, dynamic> meaning in meanings) {
      _types.add(meaning["partOfSpeech"]);
      List<Map<String, dynamic>> tempDef = [];
      for (Map<String, dynamic> definition in meaning["definitions"]) {
        tempDef.add(definition);
      }
      _definitions.add(tempDef);
    }
    for (var i = 0; i < _types.length; i++) {
      addTypeField(i);
      if (_types[i] == "noun" ||
          _types[i] == "verb" ||
          _types[i] == "adjective" ||
          _types[i] == "adverb" ||
          _types[i] == "particle") {
        typeFields[i] = _types[i];
      } else {
        typeFields[i] = "custom";
        customTypeController[i].text = _types[i];
      }
      for (var j = 0; j < _definitions[i].length; j++) {
        if (j != 0) addDefinitionField(i, j);
        if (_definitions[i][j]["definition"] != null) {
          definitionsFields[i][j][0].text = _definitions[i][j]["definition"];
        }
        if (_definitions[i][j]["example"] != null) {
          definitionsFields[i][j][1].text = _definitions[i][j]["example"];
        }
        if (_definitions[i][j]["exampleTranslation"] != null) {
          definitionsFields[i][j][2].text =
              _definitions[i][j]["exampleTranslation"];
        }
        if (_definitions[i][j]["dialect"] != null) {
          definitionsFields[i][j][3].text = _definitions[i][j]["dialect"];
        }
        if (_definitions[i][j]["origin"] != null) {
          definitionsFields[i][j][4].text = _definitions[i][j]["origin"];
        }
      }
    }
    if (appController.dictionaryContent[editWordID]["kulitan-form"].length !=
        0) {
      kulitanStringListGetter.value =
          appController.dictionaryContent[editWordID]["kulitan-form"];
    }
    currentLine = kulitanStringListGetter.length - 1;
    currentSpace = kulitanStringListGetter[currentLine].length;
    String kulitanString = '';
    for (var line in kulitanStringListGetter) {
      for (var syl in line) {
        kulitanString = kulitanString + syl;
      }
    }
    if (kulitanString == '') {
      kulitanListEmpty.value = true;
    } else {
      kulitanListEmpty.value = false;
    }
    if (appController.dictionaryContent[editWordID]["otherRelated"] != null) {
      for (var rel in appController
          .dictionaryContent[editWordID]["otherRelated"].entries) {
        relatedController..addTag = rel.key;
        if (rel.value != null) {
          importedRelated[rel.key] = rel.value;
        }
      }
    }
    if (appController.dictionaryContent[editWordID]["synonyms"] != null) {
      for (var syn
          in appController.dictionaryContent[editWordID]["synonyms"].entries) {
        synonymController..addTag = syn.key;
        if (syn.value != null) {
          importedSynonyms[syn.key] = syn.value;
        }
      }
    }
    if (appController.dictionaryContent[editWordID]["antonyms"] != null) {
      for (var ant
          in appController.dictionaryContent[editWordID]["antonyms"].entries) {
        antonymController..addTag = ant.key;
        if (ant.value != null) {
          importedAntonyms[ant.key] = ant.value;
        }
      }
    }
    if (appController.dictionaryContent[editWordID]["sources"] != null) {
      referencesController.text =
          appController.dictionaryContent[editWordID]["sources"];
    }
    if (appController.dictionaryContent[editWordID]["contributors"] != null) {
      contributors =
          appController.dictionaryContent[editWordID]["contributors"];
    }
    if (appController.dictionaryContent[editWordID]["expert"] != null) {
      expert = appController.dictionaryContent[editWordID]["expert"];
    }
    rebuildAudio.value = !rebuildAudio.value;
    isProcessing.value = false;
    Helper.successSnackBar(
        title: "Form ready!",
        message:
            "Form has been filled with information. You can now edit using the form.");
  }

  Map<String, String> contributors = {};
  Map<String, String> expert = {};

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

  late PlayerController playerController;
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

  List<dynamic> engTransList = [];

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

  List<dynamic> filTransList = [];

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

  RxList<List<dynamic>> kulitanStringListGetter = <List<dynamic>>[[]].obs;
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

  final Map<String, String> importedSynonyms = {};
  final Map<String, dynamic> synonymsMap = {};
  final Map<String, String> importedAntonyms = {};
  final Map<String, dynamic> antonymsMap = {};
  final Map<String, String> importedRelated = {};
  final Map<String, dynamic> relatedMap = {};

  void addAsImported(Map<String, String> importedMap,
      TextfieldTagsController controller, String word, String wordID) {
    controller..addTag = word;
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
    if (!editMode) addTypeField(0);
    relatedController = TextfieldTagsController();
    synonymController = TextfieldTagsController();
    antonymController = TextfieldTagsController();
    referencesController = TextEditingController();
    if (editMode) {
      populateFields();
    }
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
          contributors: contributors.length == 0 ? null : contributors,
          expert: expert.length == 0 ? null : expert,
          lastModifiedTime: timestamp,
          definitions: definitions,
          kulitanString: kulitanString,
        ));
  }
}
