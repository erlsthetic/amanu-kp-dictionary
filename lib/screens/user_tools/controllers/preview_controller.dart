import 'dart:io';

import 'package:amanu/utils/application_controller.dart';
import 'package:firebase_storage/firebase_storage.dart';
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

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
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
