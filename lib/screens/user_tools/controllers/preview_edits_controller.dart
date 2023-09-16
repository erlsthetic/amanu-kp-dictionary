import 'package:amanu/models/edit_request_model.dart';
import 'package:amanu/screens/home_screen/home_screen.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PreviewEditsController extends GetxController {
  PreviewEditsController(
      {required this.prevWordID,
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
      required this.fromRequests,
      required this.requestID,
      required this.requestAudioPath});

  static PreviewEditsController get instance => Get.find();

  final appController = Get.find<ApplicationController>();
  final GlobalKey<FormState> notesFormKey = GlobalKey<FormState>();
  late TextEditingController notesController;
  var notes = '';
  RxBool isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    getInformation();
    notesController = TextEditingController();
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
  final bool fromRequests;
  final String requestID;
  final String requestAudioPath;

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
    for (Map<String, dynamic> meaning in prevMeanings) {
      prevTypes.add(meaning["partOfSpeech"]);
      List<Map<String, dynamic>> _tempDef = [];
      for (Map<String, dynamic> definition in meaning["definitions"]) {
        _tempDef.add(definition);
      }
      prevDefinitions.add(_tempDef);
    }
    prevKulitanChars = new List.from(
        appController.dictionaryContent[prevWordID]["kulitan-form"]);
    for (var line in prevKulitanChars) {
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

  Future submitEdits() async {
    if (appController.hasConnection.value) {
      if (appController.userIsExpert ?? false) {
        isProcessing.value = true;
        List<String> audioPaths = await DatabaseRepository.instance
            .uploadAudio(wordID, prnPath, 'dictionary');
        String timestamp =
            DateFormat('yyyy-MM-dd (HH:mm:ss)').format(DateTime.now());
        var details = {
          "word": word,
          "normalizedWord": normalizedWord,
          "pronunciation": prn,
          "pronunciationAudio": audioPaths[1],
          "englishTranslations": new List.from(engTrans),
          "filipinoTranslations": new List.from(filTrans),
          "meanings": new List.from(meanings),
          "kulitan-form": new List.from(kulitanChars),
          "otherRelated": new Map.from(otherRelated),
          "synonyms": new Map.from(synonyms),
          "antonyms": new Map.from(antonyms),
          "sources": sources,
          "contributors": new Map.from(contributors),
          "expert": new Map.from(expert),
          "lastModifiedTime": timestamp
        };
        if (appController.hasConnection.value) {
          await DatabaseRepository.instance
              .updateWordOnDB(wordID, prevWordID, details);
          if (fromRequests) {
            await DatabaseRepository.instance
                .removeRequest(requestID, requestAudioPath);
          }
          isProcessing.value = false;
          Get.off(() => HomeScreen());
        } else {
          isProcessing.value = false;
          appController.showConnectionSnackbar();
        }
        isProcessing.value = false;
      } else {
        isProcessing.value = true;
        final notesValid = notesFormKey.currentState!.validate();
        if (!notesValid) {
          return;
        }
        notesFormKey.currentState!.save();
        String timestamp =
            DateFormat('yyyy-MM-dd (HH:mm:ss)').format(DateTime.now());
        String timestampForPath = timestamp.replaceAll(" ", "");
        List<String> audioPaths = await DatabaseRepository.instance.uploadAudio(
            wordID,
            prnPath,
            'requests/${timestampForPath + "-" + (appController.userID ?? '')}');
        String kulitanStr = '';
        for (var line in kulitanChars) {
          String lineStr = '';
          for (var ch in line) {
            if (ch != null) {
              lineStr += (ch + ",");
            }
          }
          if (lineStr.length > 0) {
            lineStr = lineStr.substring(0, lineStr.length - 1);
          }
          kulitanStr += (lineStr + "#");
        }
        EditRequestModel request = EditRequestModel(
            requestId: timestampForPath + "-" + (appController.userID ?? ''),
            uid: appController.userID ?? '',
            userName: appController.userName ?? '',
            timestamp: timestampForPath,
            requestType: 1,
            isAvailable: true,
            requestNotes: notes == '' ? null : notes,
            prevWordID: prevWordID,
            wordID: wordID,
            word: word,
            normalizedWord: normalizedWord,
            prn: prn,
            prnUrl: audioPaths[1],
            prnStoragePath: audioPaths[0],
            engTrans: engTrans,
            filTrans: filTrans,
            meanings: meanings,
            kulitanChars: kulitanStr,
            otherRelated: otherRelated,
            synonyms: synonyms,
            antonyms: antonyms,
            sources: sources,
            contributors: contributors,
            expert: expert,
            lastModifiedTime: timestamp);
        if (appController.hasConnection.value) {
          await DatabaseRepository.instance.createEditRequestOnDB(
              request, timestampForPath, appController.userID ?? '');
          isProcessing.value = false;
        } else {
          isProcessing.value = false;
          appController.showConnectionSnackbar();
        }
      }
    } else {
      appController.showConnectionSnackbar();
    }
  }
}
