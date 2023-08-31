import 'package:amanu/models/add_request_model.dart';
import 'package:amanu/models/delete_request_model.dart';
import 'package:amanu/models/edit_request_model.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:get/get.dart';

class RequestDetailsController extends GetxController {
  RequestDetailsController(
      {required this.prevWordID,
      required this.wordID,
      required this.word,
      required this.requestID,
      required this.requestType,
      required this.requesterID,
      required this.requesterUserName});

  static RequestDetailsController get instance => Get.find();
  final appController = Get.find<ApplicationController>();

  final String? prevWordID;
  final String wordID;
  final String word;
  final String requestID;
  final int requestType;
  final String requesterID;
  final String requesterUserName;
  RxBool isProcessing = false.obs;

  String prn = '';
  String prnUrl = '';
  List<dynamic> engTrans = [];
  List<dynamic> filTrans = [];
  List<Map<String, dynamic>> meanings = [];
  List<String> types = [];
  List<List<Map<String, dynamic>>> definitions = [];
  var kulitanChars = [];
  String kulitanString = '';
  Map<dynamic, dynamic> otherRelated = {};
  Map<dynamic, dynamic> synonyms = {};
  Map<dynamic, dynamic> antonyms = {};
  String sources = '';
  Map<dynamic, dynamic> contributors = {};
  Map<dynamic, dynamic> expert = {};
  String lastModifiedTime = '';

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

  String notes = '';

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
    if (requestType == 0) {
      AddRequestModel? request =
          await DatabaseRepository.instance.getAddRequest(requestID);
      if (request == null) {
        Get.back();
        Helper.errorSnackBar(
            title: tOhSnap,
            message: "Unable to get request. PLease try again.");
      }
    } else if (requestType == 1) {
      EditRequestModel? request =
          await DatabaseRepository.instance.getEditRequest(requestID);
      if (request == null) {
        Get.back();
        Helper.errorSnackBar(
            title: tOhSnap,
            message: "Unable to get request. PLease try again.");
      }
    } else if (requestType == 2) {
      DeleteRequestModel? request =
          await DatabaseRepository.instance.getDeleteRequest(requestID);
      if (request == null) {
        Get.back();
        Helper.errorSnackBar(
            title: tOhSnap,
            message: "Unable to get request. PLease try again.");
      }
    }
  }
}
