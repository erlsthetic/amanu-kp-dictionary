import 'package:amanu/components/coachmark_desc.dart';
import 'package:amanu/components/text_span_builder.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class DetailController extends GetxController {
  static DetailController get instance => Get.find();
  DetailController({required this.wordID});

  GlobalKey detailsKey = GlobalKey();
  GlobalKey detailBookmarkKey = GlobalKey();

  late BuildContext context;

  List<TargetFocus> initTarget() {
    return [
      TargetFocus(
          identify: "details-key",
          keyTarget: detailsKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Details Page",
                  text:
                      "This is the <b>Details screen</b>. This is where <i>all the information</i> about a word is presented.",
                  onNext: () {
                    ctl.next();
                  },
                  onSkip: () {
                    ctl.skip();
                  },
                );
              },
            ),
          ]),
      TargetFocus(
          identify: "detail-bookmark-key",
          keyTarget: detailBookmarkKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Bookmark the word",
                  text:
                      "Use the <b>bookmark toggle</b> in the upper right to bookmark and un-bookmark a word.",
                  onNext: () {
                    ctl.next();
                  },
                  next: "Got it!",
                  skip: "",
                  withSkip: false,
                  onSkip: () {},
                );
              },
            ),
          ]),
    ];
  }

  RxBool inDictionary = false.obs;

  final wordID;
  final appController = Get.find<ApplicationController>();
  final AudioPlayer player = AudioPlayer();

  String word = '';
  String prn = '';
  String prnUrl = '';
  List<dynamic> engTrans = [];
  List<dynamic> filTrans = [];
  List<dynamic> meanings = [];
  List<String> types = [];
  List<List<Map<dynamic, dynamic>>> definitions = [];
  var kulitanChars = [];
  String kulitanString = '';
  Map<dynamic, dynamic> otherRelated = {};
  Map<dynamic, dynamic> synonyms = {};
  Map<dynamic, dynamic> antonyms = {};
  String sources = '';
  Map<dynamic, dynamic> contributors = {};
  Map<dynamic, dynamic> expert = {};
  String lastModifiedTime = '';

  void getInformation() {
    word = appController.dictionaryContent[wordID]["word"];
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
    for (Map<dynamic, dynamic> meaning in meanings) {
      types.add(meaning["partOfSpeech"]);
      List<Map<dynamic, dynamic>> tempDef = [];
      for (Map<dynamic, dynamic> definition in meaning["definitions"]) {
        tempDef.add(definition);
      }
      definitions.add(tempDef);
    }
    kulitanChars =
        new List.from(appController.dictionaryContent[wordID]["kulitan-form"]);
    for (var line in kulitanChars) {
      if (line != null) {
        for (var syl in line) {
          kulitanString = kulitanString + syl;
        }
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

  RxBool onBookmarks = false.obs;

  Future<void> playFromURL() async {
    try {
      await player.stop();
      await player.play(UrlSource(prnUrl));
    } catch (e) {
      Helper.errorSnackBar(title: "Error", message: "Cannot play audio.");
    }
  }

  Future bookmarkToggle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("bookmarks")) {
      appController.bookmarks.value = prefs.getStringList("bookmarks")!;
      if (appController.bookmarks.contains(wordID)) {
        appController.bookmarks.remove(wordID);
        prefs.setStringList("bookmarks", appController.bookmarks);
        onBookmarks.value = false;
      } else {
        appController.bookmarks.add(wordID);
        prefs.setStringList("bookmarks", appController.bookmarks);
        onBookmarks.value = true;
      }
    } else {
      if (appController.bookmarks.contains(wordID)) {
        appController.bookmarks.remove(wordID);
        prefs.setStringList("bookmarks", appController.bookmarks);
        onBookmarks.value = false;
      } else {
        appController.bookmarks.add(wordID);
        prefs.setStringList("bookmarks", appController.bookmarks);
        onBookmarks.value = true;
      }
    }
  }

  void checkIfInBookmarks() {
    if (appController.bookmarks.contains(wordID)) {
      onBookmarks.value = true;
    } else {
      onBookmarks.value = false;
    }
  }

  Future<dynamic> showInfoDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        builder: (BuildContext contextDialog) {
          Future.delayed(Duration(seconds: 1))
              .then((value) => Navigator.pop(contextDialog));
          return Dialog(
            backgroundColor: disabledGrey.withOpacity(0.75),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
                padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        style: TextStyle(color: pureWhite, fontSize: 15),
                        children: [
                          WidgetSpan(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: Icon(
                                onBookmarks.value
                                    ? Icons.bookmark_rounded
                                    : Icons.bookmark_outline_rounded,
                                color: pureWhite,
                                size: 20,
                              ),
                            ),
                          ),
                          buildTextSpan(
                              text: onBookmarks.value
                                  ? word + " was added to your bookmarks."
                                  : word + " was removed from your bookmarks.",
                              style: TextStyle(color: pureWhite, fontSize: 15),
                              boldWeight: FontWeight.bold)
                        ]))),
          );
        });
  }

  @override
  void onInit() {
    super.onInit();
    if (appController.dictionaryContent.containsKey(wordID)) {
      inDictionary.value = true;
      getInformation();
      checkIfInBookmarks();
    } else {
      inDictionary.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
    player.dispose();
  }
}
