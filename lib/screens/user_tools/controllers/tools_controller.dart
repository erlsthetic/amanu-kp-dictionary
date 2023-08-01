import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textfield_tags/textfield_tags.dart';

class ToolsController extends GetxController {
  static ToolsController get instance => Get.find();

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

  List<String> synonymsList = [];

  void getSynonyms() {
    synonymsList.clear();
    for (String word in synonymController.getTags!) {
      synonymsList.add(word);
    }
  }

  List<String> antonymsList = [];

  void getAntonyms() {
    antonymsList.clear();
    for (String word in antonymController.getTags!) {
      antonymsList.add(word);
    }
  }

  List<String> relatedList = [];

  void getRelated() {
    relatedList.clear();
    for (String word in relatedController.getTags!) {
      relatedList.add(word);
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

  void submitWord() {
    validateAudio();
    getEnglishTranslations();
    validateEngTrans();
    getFilipinoTranslations();
    validateFilTrans();
    validateKulitan();
    getAntonyms();
    getRelated();
    getSynonyms();

    final informationValid = addWordFormKey.currentState!.validate();

    if (!informationValid ||
        wordController.text.isEmpty ||
        phoneticController.text.isEmpty ||
        audioSubmitError.value ||
        kulitanError.value) {
      return;
    }
    print("PASSED");
  }
}
