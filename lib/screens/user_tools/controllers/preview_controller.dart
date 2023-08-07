import 'package:amanu/utils/application_controller.dart';
import 'package:get/get.dart';

class PreviewController extends GetxController {
  PreviewController({
    required this.wordID,
    required this.word,
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
  });

  static PreviewController get instance => Get.find();

  final appController = Get.find<ApplicationController>();

  final String wordID;
  final String word;
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

  List<List<Map<String, dynamic>>> definitions = [];
  String kulitanString = '';

  void processForPreview() {
    for (Map<String, dynamic> meaning in meanings) {
      types.add(meaning["partOfSpeech"]);
      List<Map<String, dynamic>> tempDef = [];
      for (Map<String, dynamic> definition in meaning["definitions"]) {
        tempDef.add(definition);
      }
      definitions.add(tempDef);
    }
    for (var line in kulitanChars) {
      for (var syl in line) {
        kulitanString = kulitanString + syl;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
