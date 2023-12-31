import 'package:amanu/models/add_request_model.dart';
import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/controllers/home_page_controller.dart';
import 'package:amanu/screens/home_screen/drawer_launcher.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PreviewController extends GetxController {
  PreviewController(
      {required this.wordID,
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

  static PreviewController get instance => Get.find();

  final appController = Get.find<ApplicationController>();
  final GlobalKey<FormState> notesFormKey = GlobalKey<FormState>();
  late TextEditingController notesController;
  var notes = '';
  RxBool isProcessing = false.obs;

  @override
  void onInit() {
    super.onInit();
    notesController = new TextEditingController();
  }

  final String wordID;
  final String word;
  final String normalizedWord;
  final String prn;
  final String prnPath;
  final List<dynamic> engTrans;
  final List<dynamic> filTrans;
  final List<dynamic> meanings;
  final List<String> types;
  final List<List<dynamic>> kulitanChars;
  final Map<dynamic, dynamic> otherRelated;
  final Map<dynamic, dynamic> synonyms;
  final Map<dynamic, dynamic> antonyms;
  final String sources;
  final Map<dynamic, dynamic> contributors;
  final Map<dynamic, dynamic> expert;
  final String lastModifiedTime;
  final List<List<Map<dynamic, dynamic>>> definitions;
  final String kulitanString;
  final bool fromRequests;
  final String requestID;
  final String requestAudioPath;

  Future submitWord() async {
    if (appController.hasConnection.value) {
      if (appController.userIsExpert ?? false) {
        isProcessing.value = true;
        String wordKey =
            await DatabaseRepository.instance.getAvailableWordKey(wordID);
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
          await DatabaseRepository.instance.addWordOnDB(wordKey, details);
          await appController.checkDictionary();
          appController.update();
          final homeController = Get.find<HomePageController>();
          await homeController.getInformation();
          if (fromRequests) {
            await DatabaseRepository.instance
                .removeRequest(requestID, requestAudioPath);
          }
          isProcessing.value = false;
          final drawerController = Get.find<DrawerXController>();
          drawerController.currentItem.value = DrawerItems.home;
          Get.offAll(() => DrawerLauncher(),
              duration: Duration(milliseconds: 500),
              transition: Transition.downToUp,
              curve: Curves.easeInOut);
        } else {
          appController.showConnectionSnackbar();
          isProcessing.value = false;
        }
      } else {
        isProcessing.value = true;
        final notesValid = notesFormKey.currentState!.validate();
        if (!notesValid) {
          isProcessing.value = false;
          return;
        }
        notesFormKey.currentState!.save();

        String wordKey =
            await DatabaseRepository.instance.getAvailableWordKey(wordID);
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
        AddRequestModel request = AddRequestModel(
            requestId: timestampForPath + "-" + (appController.userID ?? ''),
            uid: appController.userID ?? '',
            userName: appController.userName ?? '',
            timestamp: timestampForPath,
            requestType: 0,
            isAvailable: true,
            requestNotes: notes == '' ? null : notes,
            wordID: wordKey,
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
          await DatabaseRepository.instance.createAddRequestOnDB(
              request, timestampForPath, appController.userID ?? '');
          isProcessing.value = false;
          final drawerController = Get.find<DrawerXController>();
          drawerController.currentItem.value = DrawerItems.home;
          Get.offAll(() => DrawerLauncher(),
              duration: Duration(milliseconds: 500),
              transition: Transition.downToUp,
              curve: Curves.easeInOut);
        } else {
          appController.showConnectionSnackbar();
          isProcessing.value = false;
        }
      }
    } else {
      appController.showConnectionSnackbar();
    }
  }
}
