import 'package:amanu/models/add_request_model.dart';
import 'package:amanu/models/delete_request_model.dart';
import 'package:amanu/models/edit_request_model.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:get/get.dart';

class RequestDetailsController extends GetxController {
  RequestDetailsController({
    required this.requestID,
    required this.requestType,
    required this.requesterID,
    required this.requesterUserName,
    required this.notes,
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

/*
  Future getAddDetails(AddRequestModel request) async {
    notes = request.requestNotes ?? '';
    prn = request.prn;
    prnUrl = request.prnUrl;
    engTrans = new List.from(request.engTrans);
    filTrans = new List.from(request.filTrans);
    meanings = new List.from(request.meanings);
    for (Map<String, dynamic> meaning in meanings) {
      types.add(meaning["partOfSpeech"]);
      List<Map<String, dynamic>> _tempDef = [];
      for (Map<String, dynamic> definition in meaning["definitions"]) {
        _tempDef.add(definition);
      }
      definitions.add(_tempDef);
    }
    String kulitanChStr = request.kulitanChars;
    List<dynamic> kulitanLines = kulitanChStr.split("#");
    for (String line in kulitanLines) {
      List<dynamic> chars = line.split(",");
      kulitanChars.add(chars);
    }
    for (var line in kulitanChars) {
      for (var syl in line) {
        kulitanString = kulitanString + syl;
      }
    }
    otherRelated = new Map.from(request.otherRelated);
    synonyms = new Map.from(request.synonyms);
    antonyms = new Map.from(request.antonyms);
    sources = request.sources;
    contributors = new Map.from(request.contributors);
    expert = new Map.from(request.expert);
    lastModifiedTime = request.lastModifiedTime;
  }

  Future getEditDetails(EditRequestModel request) async {
    notes = request.requestNotes ?? '';
    prn = request.prn;
    prnUrl = request.prnUrl;
    engTrans = new List.from(request.engTrans);
    filTrans = new List.from(request.filTrans);
    meanings = new List.from(request.meanings);
    for (Map<String, dynamic> meaning in meanings) {
      types.add(meaning["partOfSpeech"]);
      List<Map<String, dynamic>> _tempDef = [];
      for (Map<String, dynamic> definition in meaning["definitions"]) {
        _tempDef.add(definition);
      }
      definitions.add(_tempDef);
    }
    String kulitanChStr = request.kulitanChars;
    List<dynamic> kulitanLines = kulitanChStr.split("#");
    for (String line in kulitanLines) {
      List<dynamic> chars = line.split(",");
      kulitanChars.add(chars);
    }
    for (var line in kulitanChars) {
      for (var syl in line) {
        kulitanString = kulitanString + syl;
      }
    }
    otherRelated = new Map.from(request.otherRelated);
    synonyms = new Map.from(request.synonyms);
    antonyms = new Map.from(request.antonyms);
    sources = request.sources;
    contributors = new Map.from(request.contributors);
    expert = new Map.from(request.expert);
    lastModifiedTime = request.lastModifiedTime;
  }

  Future getDeleteDetails(DeleteRequestModel request) async {
    notes = request.requestNotes ?? '';
    prn = appController.dictionaryContent[wordID]["pronunciation"];
    prnUrl = appController.dictionaryContent[wordID]["pronunciationAudio"];
    engTrans =
        appController.dictionaryContent[wordID]["englishTranslations"] == null
            ? []
            : appController.dictionaryContent[wordID]["englishTranslations"];
    filTrans =
        appController.dictionaryContent[wordID]["filipinoTranslations"] == null
            ? []
            : appController.dictionaryContent[wordID]["filipinoTranslations"];
    meanings = appController.dictionaryContent[wordID]["meanings"];
    for (Map<String, dynamic> meaning in meanings) {
      types.add(meaning["partOfSpeech"]);
      List<Map<String, dynamic>> _tempDef = [];
      for (Map<String, dynamic> definition in meaning["definitions"]) {
        _tempDef.add(definition);
      }
      definitions.add(_tempDef);
    }
    kulitanChars =
        new List.from(appController.dictionaryContent[wordID]["kulitan-form"]);
    for (var line in kulitanChars) {
      for (var syl in line) {
        kulitanString = kulitanString + syl;
      }
    }
    otherRelated =
        appController.dictionaryContent[wordID]["otherRelated"] == null
            ? {}
            : appController.dictionaryContent[wordID]["otherRelated"];
    synonyms = appController.dictionaryContent[wordID]["synonyms"] == null
        ? {}
        : appController.dictionaryContent[wordID]["synonyms"];
    antonyms = appController.dictionaryContent[wordID]["antonyms"] == null
        ? {}
        : appController.dictionaryContent[wordID]["antonyms"];
    sources = appController.dictionaryContent[wordID]["sources"] == null
        ? ''
        : appController.dictionaryContent[wordID]["sources"];
    contributors =
        appController.dictionaryContent[wordID]["contributors"] == null
            ? {}
            : appController.dictionaryContent[wordID]["contributors"];
    expert = appController.dictionaryContent[wordID]["expert"] == null
        ? {}
        : appController.dictionaryContent[wordID]["expert"];
    lastModifiedTime =
        appController.dictionaryContent[wordID]["lastModifiedTime"];
  }
*/
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

  @override
  void onInit() async {
    super.onInit();
    if (requestType == 2) {
      getPrevInformation();
    }
  }
}
