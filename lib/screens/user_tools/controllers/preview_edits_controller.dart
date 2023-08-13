import 'dart:io';

import 'package:amanu/utils/application_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

class PreviewEditsController extends GetxController {
  PreviewEditsController({
    required this.prevWordID,
    required this.wordID,
    required this.word,
    required this.normalizedWord,
    required this.prn,
    required this.prnPath,
    required this.engTrans,
    required this.filTrans,
    required this.meanings,
    required this.types,
    required this.kulitanChars,
    required this.otherRelated,
    required this.synonyms,
    required this.antonyms,
    required this.sources,
    required this.contributors,
    required this.expert,
    required this.lastModifiedTime,
    required this.definitions,
    required this.kulitanString,
  });

  static PreviewEditsController get instance => Get.find();

  final appController = Get.find<ApplicationController>();

  late TextEditingController notesController;
  var notes = '';

  @override
  void onInit() {
    super.onInit();
    getInformation();
  }

  final String prevWordID;
  final String wordID;
  final String word;
  final String normalizedWord;
  final String prn;
  final String prnPath;
  final List<dynamic> engTrans;
  final List<dynamic> filTrans;
  final List<Map<String, dynamic>> meanings;
  final List<String> types;
  final List<List<dynamic>> kulitanChars;
  final Map<dynamic, dynamic> otherRelated;
  final Map<dynamic, dynamic> synonyms;
  final Map<dynamic, dynamic> antonyms;
  final String sources;
  final Map<dynamic, dynamic> contributors;
  final Map<dynamic, dynamic> expert;
  final String lastModifiedTime;
  final List<List<Map<String, dynamic>>> definitions;
  final String kulitanString;

  final AudioPlayer player = AudioPlayer();

  String prevWord = '';
  String prevPrn = '';
  String prevPrnUrl = '';
  List<dynamic> prevEngTrans = [];
  List<dynamic> prevFilTrans = [];
  List<Map<String, dynamic>> prevMeanings = [];
  List<String> prevTypes = [];
  List<List<Map<String, dynamic>>> prevDefinitions = [];
  var prevKulitanChars = [];
  String prevKulitanString = '';
  Map<dynamic, dynamic> prevOtherRelated = {};
  Map<dynamic, dynamic> prevSynonyms = {};
  Map<dynamic, dynamic> prevAntonyms = {};
  String prevSources = '';
  Map<dynamic, dynamic> prevContributors = {};
  Map<dynamic, dynamic> prevExpert = {};
  String prevLastModifiedTime = '';

  void getInformation() {
    prevWord = appController.dictionaryContent[prevWordID]["word"];
    prevPrn = appController.dictionaryContent[prevWordID]["pronunciation"];
    prevPrnUrl =
        appController.dictionaryContent[prevWordID]["pronunciationAudio"];
    prevEngTrans = appController.dictionaryContent[prevWordID]
                ["englishTranslations"] ==
            null
        ? []
        : appController.dictionaryContent[prevWordID]["englishTranslations"];
    prevFilTrans = appController.dictionaryContent[prevWordID]
                ["filipinoTranslations"] ==
            null
        ? []
        : appController.dictionaryContent[prevWordID]["filipinoTranslations"];
    prevMeanings = appController.dictionaryContent[prevWordID]["meanings"];
    for (Map<String, dynamic> meaning in meanings) {
      prevTypes.add(meaning["partOfSpeech"]);
      List<Map<String, dynamic>> _tempDef = [];
      for (Map<String, dynamic> definition in meaning["definitions"]) {
        _tempDef.add(definition);
      }
      prevDefinitions.add(_tempDef);
    }
    prevKulitanChars =
        appController.dictionaryContent[prevWordID]["kulitan-form"];
    for (var line in kulitanChars) {
      for (var syl in line) {
        prevKulitanString = prevKulitanString + syl;
      }
    }
    prevOtherRelated =
        appController.dictionaryContent[prevWordID]["otherRelated"] == null
            ? {}
            : appController.dictionaryContent[prevWordID]["otherRelated"];
    prevSynonyms =
        appController.dictionaryContent[prevWordID]["synonyms"] == null
            ? {}
            : appController.dictionaryContent[prevWordID]["synonyms"];
    prevAntonyms =
        appController.dictionaryContent[prevWordID]["antonyms"] == null
            ? {}
            : appController.dictionaryContent[prevWordID]["antonyms"];
    prevSources = appController.dictionaryContent[prevWordID]["sources"] == null
        ? ''
        : appController.dictionaryContent[prevWordID]["sources"];
    prevContributors =
        appController.dictionaryContent[prevWordID]["contributors"] == null
            ? {}
            : appController.dictionaryContent[prevWordID]["contributors"];
    prevExpert = appController.dictionaryContent[prevWordID]["expert"] == null
        ? {}
        : appController.dictionaryContent[prevWordID]["expert"];
    prevLastModifiedTime =
        appController.dictionaryContent[prevWordID]["lastModifiedTime"];
  }

  Future<String> uploadAudio(String wordID, String audioPath) async {
    final file = File(audioPath);
    final ext = p.extension(audioPath);
    final path = 'dictionary/${wordID}/audio${ext}';
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    String audioUrl = '';
    await ref.getDownloadURL().then((downloadUrl) {
      audioUrl = downloadUrl;
    });
    return audioUrl;
  }
}
