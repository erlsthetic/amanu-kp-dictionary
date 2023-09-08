import 'package:amanu/components/info_dialog.dart';
import 'package:amanu/models/add_request_model.dart';
import 'package:amanu/models/delete_request_model.dart';
import 'package:amanu/models/edit_request_model.dart';
import 'package:amanu/screens/requests_screen/widgets/request_details_page.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestsController extends GetxController {
  static RequestsController get instance => Get.find();
  late BuildContext context;
  final appController = Get.find<ApplicationController>();
  List<dynamic> requests = [];

  void showRequestNotAvailableDialog() {
    showInfoDialog(
        context,
        "Request unavailable",
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Text(
            "Request is currently being assessed by other experts.",
            textAlign: TextAlign.center,
            style: TextStyle(color: cardText, fontSize: 16),
          ),
        ));
  }

  Future requestSelect(String requestID, int requestType) async {
    if (appController.hasConnection.value) {}
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
          String timestamp = request.timestamp;
          String? prevWordID = null;
          String wordID = request.wordID;
          String word = request.word;
          String normalizedWord = request.normalizedWord;
          String prn = request.prn;
          String prnUrl = request.prnUrl;
          String prnAudioPath = request.prnStoragePath;
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
          if (kulitanChStr[kulitanChStr.length - 1] == '#') {
            kulitanChStr = kulitanChStr.substring(0, kulitanChStr.length - 1);
          }
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
              timestamp: timestamp,
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
              kulitanString: kulitanString,
              prnAudioPath: prnAudioPath));
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
          String timestamp = request.timestamp;
          String? prevWordID = request.prevWordID;
          String wordID = request.wordID;
          String word = request.word;
          String normalizedWord = request.normalizedWord;
          String prn = request.prn;
          String prnUrl = request.prnUrl;
          String prnAudioPath = request.prnStoragePath;
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
          if (kulitanChStr[kulitanChStr.length - 1] == '#') {
            kulitanChStr = kulitanChStr.substring(0, kulitanChStr.length - 1);
          }
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
                timestamp: timestamp,
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
                kulitanString: kulitanString,
                prnAudioPath: prnAudioPath,
              ));
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
          String timestamp = request.timestamp;
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
          String prnAudioPath = '';
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
              appController.dictionaryContent[wordID]["sources"] ?? "";
          Map<dynamic, dynamic> contributors = new Map.from(
              appController.dictionaryContent[wordID]["contributors"] ?? {});
          Map<dynamic, dynamic> expert = new Map.from(
              appController.dictionaryContent[wordID]["expert"] ?? {});
          String lastModifiedTime =
              appController.dictionaryContent[wordID]["lastModifiedTime"] ?? '';
          Get.to(() => RequestDetailsPage(
                wordID: wordID,
                word: word,
                prevWordID: prevWordID,
                requestID: requestId,
                requestType: requestType,
                requesterID: requesterID,
                requesterUserName: requesterUserName,
                notes: notes,
                timestamp: timestamp,
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
                kulitanString: kulitanString,
                prnAudioPath: prnAudioPath,
              ));
        }
      }
    }
  }

  Future getAllRequests() async {
    List<AddRequestModel> addRequests =
        await DatabaseRepository.instance.getAllAddRequests();
    List<EditRequestModel> editRequests =
        await DatabaseRepository.instance.getAllEditRequests();
    List<DeleteRequestModel> deleteRequests =
        await DatabaseRepository.instance.getAllDeleteRequests();
    var tempReq = [];
    tempReq.addAll(addRequests);
    tempReq.addAll(editRequests);
    tempReq.addAll(deleteRequests);
    tempReq.sort(
      (a, b) => a.requestId.compareTo(b.requestId),
    );
    requests = new List.from(tempReq);
  }

  @override
  void onInit() async {
    super.onInit();
    if (appController.hasConnection.value) {
      await getAllRequests();
    } else {
      appController.showConnectionSnackbar();
    }
  }
}
