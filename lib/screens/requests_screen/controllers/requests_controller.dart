import 'package:amanu/components/info_dialog.dart';
import 'package:amanu/models/add_request_model.dart';
import 'package:amanu/models/delete_request_model.dart';
import 'package:amanu/models/edit_request_model.dart';
import 'package:amanu/screens/requests_screen/widgets/request_details_page.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestsController extends GetxController {
  static RequestsController get instance => Get.find();
  late final BuildContext context;
  final appController = Get.find<ApplicationController>();
  List<dynamic> requests = [];

  void showRequestNotAvailableDialog() {
    showInfoDialog(context, "Request unavailable",
        "Request is currently being assessed by other experts.");
  }

  Future requestSelect(String requestID, int requestType) async {
    if (requestType == 0) {
      AddRequestModel? request =
          await DatabaseRepository.instance.getAddRequest(requestID);
      if (request == null) {
        Get.back();
        Helper.errorSnackBar(
            title: tOhSnap,
            message: "Unable to get request. PLease try again.");
      } else {
        if (request.isAvailable == false) {
          showRequestNotAvailableDialog();
        } else {
          String requestId = request.requestId;
          int requestType = request.requestType;
          String requesterID = request.uid;
          String requesterUserName = request.userName;
          String notes = request.requestNotes ?? '';
          String? prevWordID = null;
          String wordID = request.wordID;
          String word = request.word;
          String normalizedWord = request.normalizedWord;
          String prn = request.prn;
          String prnUrl = request.prnUrl;
          List<dynamic> engTrans = new List.from(request.engTrans);
          List<dynamic> filTrans = new List.from(request.filTrans);
          List<Map<String, dynamic>> meanings = new List.from(request.meanings);
          List<String> types = [];
          List<List<Map<String, dynamic>>> definitions = [];
          List<List<dynamic>> kulitanChars = [];
          String kulitanString = '';
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
          Map<dynamic, dynamic> otherRelated =
              new Map.from(request.otherRelated);
          Map<dynamic, dynamic> synonyms = new Map.from(request.synonyms);
          Map<dynamic, dynamic> antonyms = new Map.from(request.antonyms);
          String sources = request.sources;
          Map<dynamic, dynamic> contributors =
              new Map.from(request.contributors);
          Map<dynamic, dynamic> expert = new Map.from(request.expert);
          String lastModifiedTime = request.lastModifiedTime;
          Get.to(() => RequestDetailsPage(
              wordID: wordID,
              word: word,
              prevWordID: prevWordID,
              requestID: requestId,
              requestType: requestType,
              requesterID: requesterID,
              requesterUserName: requesterUserName,
              notes: notes,
              normalizedWord: normalizedWord,
              prn: prn,
              prnUrl: prnUrl,
              engTrans: engTrans,
              filTrans: filTrans,
              meanings: meanings,
              types: types,
              kulitanChars: kulitanChars,
              otherRelated: otherRelated,
              synonyms: synonyms,
              antonyms: antonyms,
              sources: sources,
              contributors: contributors,
              expert: expert,
              lastModifiedTime: lastModifiedTime,
              definitions: definitions,
              kulitanString: kulitanString));
        }
      }
    } else if (requestType == 1) {
      EditRequestModel? request =
          await DatabaseRepository.instance.getEditRequest(requestID);
      if (request == null) {
        Get.back();
        Helper.errorSnackBar(
            title: tOhSnap,
            message: "Unable to get request. PLease try again.");
      } else {
        if (request.isAvailable == false) {
          showRequestNotAvailableDialog();
        } else {
          String requestId = request.requestId;
          int requestType = request.requestType;
          String requesterID = request.uid;
          String requesterUserName = request.userName;
          String notes = request.requestNotes ?? '';
          String? prevWordID = request.prevWordID;
          String wordID = request.wordID;
          String word = request.word;
          String normalizedWord = request.normalizedWord;
          String prn = request.prn;
          String prnUrl = request.prnUrl;
          List<dynamic> engTrans = new List.from(request.engTrans);
          List<dynamic> filTrans = new List.from(request.filTrans);
          List<Map<String, dynamic>> meanings = new List.from(request.meanings);
          List<String> types = [];
          List<List<Map<String, dynamic>>> definitions = [];
          List<List<dynamic>> kulitanChars = [];
          String kulitanString = '';
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
          Map<dynamic, dynamic> otherRelated =
              new Map.from(request.otherRelated);
          Map<dynamic, dynamic> synonyms = new Map.from(request.synonyms);
          Map<dynamic, dynamic> antonyms = new Map.from(request.antonyms);
          String sources = request.sources;
          Map<dynamic, dynamic> contributors =
              new Map.from(request.contributors);
          Map<dynamic, dynamic> expert = new Map.from(request.expert);
          String lastModifiedTime = request.lastModifiedTime;
          Get.to(() => RequestDetailsPage(
              wordID: wordID,
              word: word,
              prevWordID: prevWordID,
              requestID: requestId,
              requestType: requestType,
              requesterID: requesterID,
              requesterUserName: requesterUserName,
              notes: notes,
              normalizedWord: normalizedWord,
              prn: prn,
              prnUrl: prnUrl,
              engTrans: engTrans,
              filTrans: filTrans,
              meanings: meanings,
              types: types,
              kulitanChars: kulitanChars,
              otherRelated: otherRelated,
              synonyms: synonyms,
              antonyms: antonyms,
              sources: sources,
              contributors: contributors,
              expert: expert,
              lastModifiedTime: lastModifiedTime,
              definitions: definitions,
              kulitanString: kulitanString));
        }
      }
    } else if (requestType == 2) {
      DeleteRequestModel? request =
          await DatabaseRepository.instance.getDeleteRequest(requestID);
      if (request == null) {
        Get.back();
        Helper.errorSnackBar(
            title: tOhSnap,
            message: "Unable to get request. PLease try again.");
      } else {
        if (request.isAvailable == false) {
          showRequestNotAvailableDialog();
        } else {
          String requestId = request.requestId;
          int requestType = request.requestType;
          String requesterID = request.uid;
          String requesterUserName = request.userName;
          String notes = request.requestNotes ?? '';
          String? prevWordID = null;
          String wordID = request.wordID;
          String word = request.word;
          String normalizedWord =
              appController.dictionaryContent[wordID]["normalizedWord"] ?? '';
          String prn =
              appController.dictionaryContent[wordID]["pronunciation"] ?? '';
          String prnUrl = appController.dictionaryContent[wordID]
                  ["pronunciationAudio"] ??
              '';
          List<dynamic> engTrans = new List.from(
              appController.dictionaryContent[wordID]["englishTranslations"] ??
                  []);
          List<dynamic> filTrans = new List.from(
              appController.dictionaryContent[wordID]["filipinoTranslations"] ??
                  []);
          List<Map<String, dynamic>> meanings = new List.from(
              appController.dictionaryContent[wordID]["meanings"] ?? []);
          List<String> types = [];
          List<List<Map<String, dynamic>>> definitions = [];
          List<List<dynamic>> kulitanChars = new List.from(
              appController.dictionaryContent[wordID]["kulitan-form"]);
          String kulitanString = '';
          for (Map<String, dynamic> meaning in meanings) {
            types.add(meaning["partOfSpeech"]);
            List<Map<String, dynamic>> _tempDef = [];
            for (Map<String, dynamic> definition in meaning["definitions"]) {
              _tempDef.add(definition);
            }
            definitions.add(_tempDef);
          }
          for (var line in kulitanChars) {
            for (var syl in line) {
              kulitanString = kulitanString + syl;
            }
          }
          Map<dynamic, dynamic> otherRelated = new Map.from(
              appController.dictionaryContent[wordID]["otherRelated"] ?? {});
          Map<dynamic, dynamic> synonyms = new Map.from(
              appController.dictionaryContent[wordID]["synonyms"] ?? {});
          Map<dynamic, dynamic> antonyms = new Map.from(
              appController.dictionaryContent[wordID]["antonyms"] ?? {});
          String sources =
              appController.dictionaryContent[prevWordID]["sources"];
          Map<dynamic, dynamic> contributors = new Map.from(
              appController.dictionaryContent[wordID]["contributors"] ?? {});
          Map<dynamic, dynamic> expert = new Map.from(
              appController.dictionaryContent[wordID]["expert"] ?? {});
          String lastModifiedTime = appController.dictionaryContent[prevWordID]
                  ["lastModifiedTime"] ??
              '';
          Get.to(() => RequestDetailsPage(
              wordID: wordID,
              word: word,
              prevWordID: prevWordID,
              requestID: requestId,
              requestType: requestType,
              requesterID: requesterID,
              requesterUserName: requesterUserName,
              notes: notes,
              normalizedWord: normalizedWord,
              prn: prn,
              prnUrl: prnUrl,
              engTrans: engTrans,
              filTrans: filTrans,
              meanings: meanings,
              types: types,
              kulitanChars: kulitanChars,
              otherRelated: otherRelated,
              synonyms: synonyms,
              antonyms: antonyms,
              sources: sources,
              contributors: contributors,
              expert: expert,
              lastModifiedTime: lastModifiedTime,
              definitions: definitions,
              kulitanString: kulitanString));
        }
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();
    List<AddRequestModel> addRequests =
        await DatabaseRepository.instance.getAllAddRequests();
    List<EditRequestModel> editRequests =
        await DatabaseRepository.instance.getAllEditRequests();
    List<DeleteRequestModel> deleteRequests =
        await DatabaseRepository.instance.getAllDeleteRequests();
    requests.addAll(addRequests);
    requests.addAll(editRequests);
    requests.addAll(deleteRequests);
    requests.sort(
      (a, b) => a.requestId.compareTo(b.requestId),
    );
  }
}
