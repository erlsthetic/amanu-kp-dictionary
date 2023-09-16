import 'dart:io';

import 'package:amanu/models/add_request_model.dart';
import 'package:amanu/models/edit_request_model.dart';
import 'package:amanu/screens/user_tools/widgets/preview_edits_page.dart';
import 'package:amanu/screens/user_tools/widgets/preview_page.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ModifyController extends GetxController {
  ModifyController(
      {this.editMode = false,
      this.editWordID,
      this.requestMode = false,
      this.requestID,
      this.requestType});
  final bool editMode;
  final String? editWordID;
  final bool requestMode;
  final String? requestID;
  final int? requestType;
  static ModifyController get instance => Get.find();
  bool importError = false;
  final appController = Get.find<ApplicationController>();
  RxBool isProcessing = false.obs;
  String? prnStoragePath = '';
  String? requestEditID = '';

  @override
  void onInit() {
    super.onInit();
    wordController = TextEditingController();
    phoneticController = TextEditingController();
    engTransController = TextfieldTagsController();
    filTransController = TextfieldTagsController();
    playerController = PlayerController();
    if (!editMode && !requestMode) addTypeField(0);
    relatedController = TextfieldTagsController();
    synonymController = TextfieldTagsController();
    antonymController = TextfieldTagsController();
    referencesController = TextEditingController();
    if (editMode) {
      getEditDetails();
    } else if (requestMode) {
      getRequestDetails();
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

  Future populateFields(
    String word,
    String prn,
    String prnAudioUrl,
    List<dynamic>? engTrans,
    List<dynamic>? filTrans,
    List<dynamic> meaningsList,
    List<List<dynamic>> kulitanChars,
    Map<dynamic, dynamic>? otherRelated,
    Map<dynamic, dynamic>? synonyms,
    Map<dynamic, dynamic>? antonyms,
    String? sources,
    Map<dynamic, dynamic>? contributorsList,
    Map<dynamic, dynamic>? expertList,
  ) async {
    isProcessing.value = true;
    wordController.text = word;
    phoneticController.text = prn;
    String prnExt = prnAudioUrl.split("?").first;
    final appStorage = await getApplicationDocumentsDirectory();
    final fileExt = extension(File(prnExt).path);
    final tempAudioFile = File('${appStorage.path}/audio$fileExt');
    try {
      final response = await Dio().get(
        prnAudioUrl,
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
    List<dynamic> meaningsGetList = List.from(meaningsList);
    List<String> _types = [];
    List<List<Map<String, dynamic>>> _definitions = [];
    for (Map<String, dynamic> meaning in meaningsGetList) {
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
    if (kulitanChars != 0) {
      kulitanStringListGetter.clear();
      for (var i in kulitanChars) {
        var newList = [];
        for (var j in i) {
          newList.add(j);
        }
        kulitanStringListGetter.add(newList);
      }
      kulitanStringListGetter.refresh();
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
    if (otherRelated != null) {
      for (var rel in otherRelated.entries) {
        relatedController..addTag = rel.key;
        if (rel.value != null) {
          importedRelated[rel.key] = rel.value;
        }
      }
    }
    if (synonyms != null) {
      for (var syn in synonyms.entries) {
        synonymController..addTag = syn.key;
        if (syn.value != null) {
          importedSynonyms[syn.key] = syn.value;
        }
      }
    }
    if (antonyms != null) {
      for (var ant in antonyms.entries) {
        antonymController..addTag = ant.key;
        if (ant.value != null) {
          importedAntonyms[ant.key] = ant.value;
        }
      }
    }
    if (sources != null) {
      referencesController.text = sources;
    }
    if (contributorsList != null) {
      contributors = new Map.from(contributorsList);
    }
    if (expertList != null) {
      expert = new Map.from(expertList);
    }
    rebuildAudio.value = !rebuildAudio.value;
    isProcessing.value = false;
    Helper.successSnackBar(
        title: "Form ready!",
        message:
            "Form has been filled with information. You can now edit using the form.");
  }

  Future getEditDetails() async {
    await appController.checkDictionary();
    appController.update();
    await populateFields(
        appController.dictionaryContent[editWordID]["word"],
        appController.dictionaryContent[editWordID]["pronunciation"],
        appController.dictionaryContent[editWordID]["pronunciationAudio"],
        appController.dictionaryContent[editWordID]["englishTranslations"] !=
                null
            ? new List.from(appController.dictionaryContent[editWordID]
                ["englishTranslations"])
            : null,
        appController.dictionaryContent[editWordID]["filipinoTranslations"] !=
                null
            ? new List.from(appController.dictionaryContent[editWordID]
                ["filipinoTranslations"])
            : null,
        appController.dictionaryContent[editWordID]["meanings"] != null
            ? new List.from(
                appController.dictionaryContent[editWordID]["meanings"])
            : [],
        appController.dictionaryContent[editWordID]["kulitan-form"] != null
            ? new List.from(
                appController.dictionaryContent[editWordID]["kulitan-form"])
            : [],
        appController.dictionaryContent[editWordID]["otherRelated"] != null
            ? new Map.from(
                appController.dictionaryContent[editWordID]["otherRelated"])
            : null,
        appController.dictionaryContent[editWordID]["synonyms"] != null
            ? new Map.from(
                appController.dictionaryContent[editWordID]["synonyms"])
            : null,
        appController.dictionaryContent[editWordID]["antonyms"] != null
            ? new Map.from(
                appController.dictionaryContent[editWordID]["antonyms"])
            : null,
        appController.dictionaryContent[editWordID]["sources"],
        appController.dictionaryContent[editWordID]["contributors"] != null
            ? new Map.from(
                appController.dictionaryContent[editWordID]["contributors"])
            : null,
        appController.dictionaryContent[editWordID]["expert"] != null
            ? new Map.from(appController.dictionaryContent[editWordID]["expert"])
            : null);
  }

  Future getRequestDetails() async {
    if (requestType == 0) {
      AddRequestModel? request =
          await DatabaseRepository.instance.getAddRequest(requestID ?? '');
      if (request == null) {
        Get.back();
        Helper.errorSnackBar(
            title: tOhSnap,
            message: "Unable to get request. PLease try again.");
      } else {
        await DatabaseRepository.instance.changeRequestState(requestID!, false);
        List<List<dynamic>> kulitanCharsList = [];
        String kulitanChStr = request.kulitanChars;
        if (kulitanChStr[kulitanChStr.length - 1] == '#') {
          kulitanChStr = kulitanChStr.substring(0, kulitanChStr.length - 1);
        }
        List<dynamic> kulitanLines = kulitanChStr.split("#");
        for (String line in kulitanLines) {
          List<dynamic> chars = line.split(",");
          kulitanCharsList.add(chars);
        }
        populateFields(
            request.word,
            request.prn,
            request.prnUrl,
            new List.from(request.engTrans),
            new List.from(request.filTrans),
            new List.from(request.meanings),
            kulitanCharsList,
            new Map.from(request.otherRelated),
            new Map.from(request.synonyms),
            new Map.from(request.antonyms),
            request.sources,
            new Map.from(request.contributors),
            new Map.from(request.expert));
        prnStoragePath = request.prnStoragePath;
      }
    } else {
      EditRequestModel? request =
          await DatabaseRepository.instance.getEditRequest(requestID ?? '');
      if (request == null) {
        Get.back();
        Helper.errorSnackBar(
            title: tOhSnap,
            message: "Unable to get request. PLease try again.");
      } else {
        await DatabaseRepository.instance.changeRequestState(requestID!, false);
        List<List<dynamic>> kulitanCharsList = [];
        String kulitanChStr = request.kulitanChars;
        if (kulitanChStr[kulitanChStr.length - 1] == '#') {
          kulitanChStr = kulitanChStr.substring(0, kulitanChStr.length - 1);
        }
        List<dynamic> kulitanLines = kulitanChStr.split("#");
        for (String line in kulitanLines) {
          List<dynamic> chars = line.split(",");
          kulitanCharsList.add(chars);
        }
        populateFields(
            request.word,
            request.prn,
            request.prnUrl,
            new List.from(request.engTrans),
            new List.from(request.filTrans),
            new List.from(request.meanings),
            kulitanCharsList,
            new Map.from(request.otherRelated),
            new Map.from(request.synonyms),
            new Map.from(request.antonyms),
            request.sources,
            new Map.from(request.contributors),
            new Map.from(request.expert));
        requestEditID = request.prevWordID;
      }
    }
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

  final GlobalKey<FormState> modifyWordFormKey = GlobalKey<FormState>();

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
  final List<FocusNode> typeFieldFocusNode = [];
  final List<List<FocusNode>> definitionFieldFocusNode = [];
  final RxList<List<List<TextEditingController>>> definitionsFields =
      <List<List<TextEditingController>>>[].obs;
  // TD is              D                  TD
  //[[[TE, TE, TE, TE], [TE, TE, TE, TE]], [[TE, TE, TE, TE]]]
  Future addTypeField(int i) async {
    typeListKey.currentState?.insertItem(i);
    customTypeController.insert(i, TextEditingController());
    typeFieldFocusNode.insert(i, FocusNode());
    definitionListKey.insert(i, GlobalKey());
    typeFields.insert(i, '');
    definitionsFields.insert(i, []);
    definitionFieldFocusNode.insert(i, []);
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
    definitionFieldFocusNode[i].insert(j, FocusNode());
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

    final informationValid = modifyWordFormKey.currentState!.validate();
    if (!informationValid ||
        wordController.text.isEmpty ||
        phoneticController.text.isEmpty ||
        audioSubmitError.value ||
        kulitanError.value) {
      return;
    }
    modifyWordFormKey.currentState!.save();

    String normalizedWord =
        appController.normalizeWord(wordController.text.trim());
    String wordKey = normalizedWord;

    List<dynamic> meanings = [];

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

    if (editMode) {
      if (expert.length != 0) {
        String pastUsername = expert.keys.toList().first;
        String pastUID = expert[pastUsername] ?? "";
        contributors[pastUsername] = pastUID;
      }
      if (appController.userIsExpert ?? false) {
        expert.clear();
        expert[appController.userName ?? "User"] = appController.userID ?? "";
      } else {
        expert.clear();
        if (contributors.containsValue(appController.userID ?? "")) {
          contributors.removeWhere(
              (key, value) => value == (appController.userID ?? ""));
        }
        contributors[appController.userName ?? "User"] =
            appController.userID ?? "";
      }
      Get.to(() => PreviewEditsPage(
            prevWordID: requestMode ? requestEditID! : editWordID!,
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
            fromRequests: requestMode,
            requestID: requestID ?? '',
            requestAudioPath: prnStoragePath ?? '',
          ));
    } else {
      if (appController.userIsExpert ?? false) {
        expert.clear();
        contributors.clear();
        expert[appController.userName ?? "User"] = appController.userID ?? "";
      } else {
        expert.clear();
        contributors.clear();
        contributors[appController.userName ?? "User"] =
            appController.userID ?? "";
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
            fromRequests: requestMode,
            requestID: requestID ?? '',
            requestAudioPath: prnStoragePath ?? '',
          ));
    }
  }
}
