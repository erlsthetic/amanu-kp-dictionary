import 'dart:io';

import 'package:amanu/components/confirm_dialog.dart';
import 'package:amanu/components/info_dialog.dart';
import 'package:amanu/components/loader_dialog.dart';
import 'package:amanu/screens/requests_screen/controllers/requests_controller.dart';
import 'package:amanu/screens/user_tools/modify_word_page.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

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
    required this.prnAudioPath,
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
  final String prnAudioPath;
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

  void showRequestNotAvailableDialog(BuildContext context) {
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
        ),
        null,
        null);
  }

  Future deleteRequest(BuildContext context, String prnPath) async {
    showLoaderDialog(context);
    if (appController.hasConnection.value) {
      bool isAvailable = false;

      if (requestType == 0) {
        final req = await DatabaseRepository.instance.getAddRequest(requestID);
        if (req != null) {
          isAvailable = req.isAvailable;
        }
      } else if (requestType == 1) {
        final req = await DatabaseRepository.instance.getEditRequest(requestID);
        if (req != null) {
          isAvailable = req.isAvailable;
        }
      } else {
        final req =
            await DatabaseRepository.instance.getDeleteRequest(requestID);
        if (req != null) {
          isAvailable = req.isAvailable;
        }
      }

      if (!isAvailable) {
        Navigator.of(context).pop();
        showRequestNotAvailableDialog(context);
      } else {
        showConfirmDialog(
            context,
            "Delete confirmation",
            "Are you sure you want to delete this request?",
            "Delete",
            "Cancel", () {
          DatabaseRepository.instance
              .removeRequest(requestID, prnPath)
              .then((value) async {
            final requestController = Get.find<RequestsController>();
            if (appController.hasConnection.value) {
              requestController.requests.clear();
              await requestController.getAllRequests();
            } else {
              appController.showConnectionSnackbar();
            }
          });
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Get.back();
        }, () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      }
    } else {
      Navigator.of(context).pop();
      appController.showConnectionSnackbar();
    }
  }

  Future editRequest(BuildContext context) async {
    showLoaderDialog(context);
    if (appController.hasConnection.value) {
      bool isAvailable = false;

      if (requestType == 0) {
        final req = await DatabaseRepository.instance.getAddRequest(requestID);
        if (req != null) {
          isAvailable = req.isAvailable;
        }
      } else if (requestType == 1) {
        final req = await DatabaseRepository.instance.getEditRequest(requestID);
        if (req != null) {
          isAvailable = req.isAvailable;
        }
      } else {
        final req =
            await DatabaseRepository.instance.getDeleteRequest(requestID);
        if (req != null) {
          isAvailable = req.isAvailable;
        }
      }

      if (!isAvailable) {
        Navigator.of(context).pop();
        showRequestNotAvailableDialog(context);
      } else {
        Navigator.of(context).pop();
        Get.to(() => ModifyWordPage(
              requestMode: true,
              requestID: requestID,
              requestType: requestType,
            ));
      }
    } else {
      Navigator.of(context).pop();
      appController.showConnectionSnackbar();
    }
  }

  Future approveDeleteWord(BuildContext context) async {
    showLoaderDialog(context);
    if (appController.hasConnection.value) {
      bool isAvailable = false;

      if (requestType == 0) {
        final req = await DatabaseRepository.instance.getAddRequest(requestID);
        if (req != null) {
          isAvailable = req.isAvailable;
        }
      } else if (requestType == 1) {
        final req = await DatabaseRepository.instance.getEditRequest(requestID);
        if (req != null) {
          isAvailable = req.isAvailable;
        }
      } else {
        final req =
            await DatabaseRepository.instance.getDeleteRequest(requestID);
        if (req != null) {
          isAvailable = req.isAvailable;
        }
      }

      if (!isAvailable) {
        showRequestNotAvailableDialog(context);
      } else {
        showConfirmDialog(
            context,
            "Approval confirmation",
            "Are you sure you want to approve this request?",
            "Approve",
            "Cancel", () async {
          await DatabaseRepository.instance
              .removeWordOnDB(wordID, word)
              .then((value) async {
            DatabaseRepository.instance
                .removeRequest(requestID, prnAudioPath)
                .then((value) async {
              final requestController = Get.find<RequestsController>();
              if (appController.hasConnection.value) {
                requestController.requests.clear();
                await requestController.getAllRequests();
              } else {
                appController.showConnectionSnackbar();
              }
            });
          });
          Navigator.of(context).pop();
          Navigator.of(context).pop();
          Get.back();
        }, () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      }
    } else {
      Navigator.of(context).pop();
      appController.showConnectionSnackbar();
    }
  }

  Future approveRequest(BuildContext context) async {
    showLoaderDialog(context);
    if (appController.hasConnection.value) {
      bool isAvailable = false;

      if (requestType == 0) {
        final req = await DatabaseRepository.instance.getAddRequest(requestID);
        if (req != null) {
          isAvailable = req.isAvailable;
        }
      } else if (requestType == 1) {
        final req = await DatabaseRepository.instance.getEditRequest(requestID);
        if (req != null) {
          isAvailable = req.isAvailable;
        }
      } else {
        final req =
            await DatabaseRepository.instance.getDeleteRequest(requestID);
        if (req != null) {
          isAvailable = req.isAvailable;
        }
      }

      if (!isAvailable) {
        showRequestNotAvailableDialog(context);
      } else {
        showConfirmDialog(
            context,
            "Approval confirmation",
            "Are you sure you want to approve this request?",
            "Approve",
            "Cancel", () async {
          String wordKey =
              await DatabaseRepository.instance.getAvailableWordKey(wordID);
          final appStorage = await getApplicationDocumentsDirectory();
          final fileExt = extension(File(prnAudioPath).path);
          final tempAudioFile = File('${appStorage.path}/audio$fileExt');
          await FirebaseStorage.instance
              .ref()
              .child(prnAudioPath)
              .writeToFile(tempAudioFile)
              .then((taskSnapshot) async {
            if (taskSnapshot.state == TaskState.error) {
              Helper.errorSnackBar(
                  title: tOhSnap, message: tSomethingWentWrong);
            }
          });
          List<String> audioPaths = await DatabaseRepository.instance
              .uploadAudio(wordID, tempAudioFile.path, 'dictionary');
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
            if (requestType == 0) {
              await DatabaseRepository.instance
                  .addWordOnDB(wordKey, details)
                  .then((value) async {
                await DatabaseRepository.instance
                    .removeRequest(requestID, prnAudioPath);
              });
            } else {
              await DatabaseRepository.instance
                  .updateWordOnDB(wordKey, prevWordID ?? '', details)
                  .then((value) async {
                await DatabaseRepository.instance
                    .removeRequest(requestID, prnAudioPath);
              });
            }
            final requestController = Get.find<RequestsController>();
            if (appController.hasConnection.value) {
              requestController.requests.clear();
              await requestController.getAllRequests();
            } else {
              appController.showConnectionSnackbar();
            }
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            Get.back();
          } else {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
            appController.showConnectionSnackbar();
          }
        }, () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        });
      }
    } else {
      Navigator.of(context).pop();
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
