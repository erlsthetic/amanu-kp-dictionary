import 'package:amanu/components/loader_dialog.dart';
import 'package:amanu/screens/requests_screen/controllers/requests_controller.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestDetailsController extends GetxController {
  RequestDetailsController({
    required this.requestID,
    required this.requestType,
    required this.requesterID,
    required this.requesterUserName,
    required this.notes,
    required this.timestamp,
    required this.prevWordID,
    required this.wordID,
    required this.word,
    required this.normalizedWord,
    required this.prn,
    required this.prnUrl,
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

  static RequestDetailsController get instance => Get.find();
  final appController = Get.find<ApplicationController>();

  RxBool isProcessing = false.obs;

  final String requestID;
  final int requestType;
  final String requesterID;
  final String requesterUserName;
  final String notes;
  final String timestamp;

  final String? prevWordID;
  final String wordID;
  final String word;
  final String normalizedWord;
  final String prn;
  final String prnUrl;
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

  void getPrevInformation() {
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

  Future deleteRequest(context) async {
    showLoaderDialog(context);
    if (appController.hasConnection.value) {
      DatabaseRepository.instance
          .removeRequest(requestID)
          .whenComplete(() async {
        final requestController = Get.find<RequestsController>();
        if (appController.hasConnection.value) {
          await requestController.getAllRequests();
        } else {
          appController.showConnectionSnackbar();
        }
        Navigator.of(context).pop();
        Get.back();
      });
    } else {
      Navigator.of(context).pop();
      appController.showConnectionSnackbar();
    }
  }

  Future editRequest() async {
    if (appController.hasConnection.value) {
    } else {
      appController.showConnectionSnackbar();
    }
  }

  Future approveRequest() async {
    if (appController.hasConnection.value) {
    } else {
      appController.showConnectionSnackbar();
    }
  }

  @override
  void onInit() async {
    super.onInit();
    if (requestType == 1) {
      getPrevInformation();
    }
  }
}
