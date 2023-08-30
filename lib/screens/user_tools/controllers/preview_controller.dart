import 'dart:io';

import 'package:amanu/models/add_request_model.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

class PreviewController extends GetxController {
  PreviewController({
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

  static PreviewController get instance => Get.find();

  final appController = Get.find<ApplicationController>();
  final GlobalKey<FormState> notesFormKey = GlobalKey<FormState>();
  late TextEditingController notesController;
  var notes = '';

  @override
  void onInit() {
    super.onInit();
  }

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

  Future<List<String>> uploadAudio(
      String wordID, String audioPath, String storagePath) async {
    final file = File(audioPath);
    final ext = p.extension(audioPath);
    final path = '${storagePath}/${wordID}/audio${ext}';
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    String audioUrl = '';
    await ref.getDownloadURL().then((downloadUrl) {
      audioUrl = downloadUrl;
    });
    return [path, audioUrl];
  }

  Future submitWord() async {
    if (appController.userIsExpert ?? false) {
      List<String> audioPaths =
          await uploadAudio(wordID, prnPath, 'dictionary');
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
        "lastModifiedTime": lastModifiedTime
      };
      if (appController.hasConnection.value) {
        DatabaseRepository.instance.addWordOnDB(word, details);
      } else {
        appController.showConnectionSnackbar();
      }
    } else {
      final notesValid = notesFormKey.currentState!.validate();
      if (!notesValid) {
        return;
      }
      notesFormKey.currentState!.save();
      List<String> audioPaths = await uploadAudio(wordID, prnPath,
          'requests/${lastModifiedTime + "-" + (appController.userID ?? '')}');
      AddRequestModel request = AddRequestModel(
          uid: appController.userID ?? '',
          timestamp: lastModifiedTime,
          requestType: 1,
          isAvailable: true,
          wordID: wordID,
          word: word,
          normalizedWord: normalizedWord,
          prn: prn,
          prnUrl: audioPaths[1],
          prnStoragePath: audioPaths[0],
          engTrans: engTrans,
          filTrans: filTrans,
          meanings: meanings,
          kulitanChars: kulitanChars,
          otherRelated: otherRelated,
          synonyms: synonyms,
          antonyms: antonyms,
          sources: sources,
          contributors: contributors,
          expert: expert,
          lastModifiedTime: lastModifiedTime);
      if (appController.hasConnection.value) {
        DatabaseRepository.instance.createAddRequestOnDB(
            request, lastModifiedTime, appController.userID ?? '');
      } else {
        appController.showConnectionSnackbar();
      }
    }
  }
}
