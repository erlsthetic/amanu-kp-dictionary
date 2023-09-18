import 'dart:io';

import 'package:amanu/components/coachmark_desc.dart';
import 'package:amanu/models/add_request_model.dart';
import 'package:amanu/models/edit_request_model.dart';
import 'package:amanu/screens/user_tools/widgets/preview_edits_page.dart';
import 'package:amanu/screens/user_tools/widgets/preview_page.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ModifyController extends GetxController {
  ModifyController(
      {this.editMode = false,
      this.editWordID,
      this.requestMode = false,
      this.requestID,
      this.requestType});
  final bool editMode;
  final String? editWordID;
  final bool requestMode;
  final String? requestID;
  final int? requestType;
  static ModifyController get instance => Get.find();
  bool importError = false;
  final appController = Get.find<ApplicationController>();
  RxBool isProcessing = false.obs;
  String? prnStoragePath = '';
  String? requestEditID = '';
  late BuildContext context;

  GlobalKey modifyKey = GlobalKey();
  GlobalKey modifyWordKey = GlobalKey();
  GlobalKey modifyPrnKey = GlobalKey();
  GlobalKey modifyStudioKey = GlobalKey();

  GlobalKey modifyEngTransKey = GlobalKey();
  GlobalKey modifyFilTransKey = GlobalKey();

  GlobalKey modifyInformationKey = GlobalKey();

  GlobalKey modifyKulitanKey = GlobalKey();
  GlobalKey modifyOtherRelatedKey = GlobalKey();
  GlobalKey modifySynonymKey = GlobalKey();
  GlobalKey modifyAntonymKey = GlobalKey();

  GlobalKey modifySourcesKey = GlobalKey();

  GlobalKey modifyProceedKey = GlobalKey();

  List<TargetFocus> initTarget() {
    return [
      TargetFocus(
          identify: "modify-key",
          keyTarget: modifyKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Modify Word Screen",
                  text:
                      "As a logged in user, one of your tools is the <b>Add/Modify Word screen</b>. Here, you can <i>add</i> or <i>modify a word</i> and send it to Amanu to update the dictionary (<i>or as an update request if you are a Contributor</i>).",
                  onNext: () {
                    Scrollable.ensureVisible(modifyKey.currentContext!,
                        alignment: 0.5,
                        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                        duration: Duration(milliseconds: 800));
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
          identify: "modify-word-key",
          keyTarget: modifyWordKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Word field",
                  text:
                      "Use this field to enter the <b>word</b> you desire to add or edit. You may use characters with diacritic marks, <b>bold</b>, <i>italic</i>, and <u>underline</u> tags if needed. Tap the help button for more information about <i>tags</i>.",
                  onNext: () {
                    Scrollable.ensureVisible(modifyPrnKey.currentContext!,
                        alignment: 0.5,
                        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                        duration: Duration(milliseconds: 800));
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
          identify: "modify-prn-key",
          keyTarget: modifyPrnKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Phonetics field",
                  text:
                      "Use this field to enter the <b>phonetics</b> or <b>pronunciation</b> of your word. You may also use <i>diacritic characters</i> and <i>tags</i> in this field.",
                  onNext: () {
                    Scrollable.ensureVisible(modifyStudioKey.currentContext!,
                        alignment: 0.5,
                        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                        duration: Duration(milliseconds: 800));
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
          identify: "modify-studio-key",
          keyTarget: modifyStudioKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "The Recording Studio",
                  text:
                      'The <b>Recording Studio</b> is your tool to record or upload audio pronunciations of your word. Tap the <i>"Open Studio"</i> button to launch the studio and you may use the <i>player</i> to playback your recorded audio.',
                  onNext: () {
                    Scrollable.ensureVisible(modifyEngTransKey.currentContext!,
                        alignment: 1.0,
                        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                        duration: Duration(milliseconds: 800));
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
          identify: "modify-engtrans-key",
          keyTarget: modifyEngTransKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "English Translations field",
                  text:
                      'The <b>English Translations</b> field allows you to enter the English translations of your word. To add, simply <i>type your word and end it with a "," (comma)</i> to separate it with other translations.',
                  onNext: () {
                    Scrollable.ensureVisible(modifyFilTransKey.currentContext!,
                        alignment: 0.5,
                        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                        duration: Duration(milliseconds: 800));
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
          identify: "modify-filtrans-key",
          keyTarget: modifyFilTransKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Filipino Translations field",
                  text:
                      'The <b>Filipino Translations</b> field, on the other hand, allows you to enter the Filipino translations of your word, with the same rules as mentioned in the previous field.',
                  onNext: () {
                    Scrollable.ensureVisible(
                        modifyInformationKey.currentContext!,
                        alignment: 1.5,
                        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                        duration: Duration(milliseconds: 800));
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
          identify: "modify-info-key",
          keyTarget: modifyInformationKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(top: 5),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "The Information section",
                  text:
                      "The <b>Information</b> section allows you to enter the details about your word. This includes its <i>definition</i>, <i>example</i> (in Kapampangan), <i>example's translation</i>, its <i>dialect</i> (if applicable), and its <i>origin</i>.",
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
          identify: "modify-info-key",
          keyTarget: modifyInformationKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(top: 5),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "The Type field",
                  text:
                      "The <b>Type</b> field is dedicated to supply what part of speech your word is used. A word can have multiple parts of speech depending on usage, to add, simply <i>press the add button</i> on the right of the field. If the type isn't listed in the dropdown, you may use the <i>custom type</i> and <i>fill the custom field</i> that will appear beside the dropdown.",
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
          identify: "modify-info-key",
          keyTarget: modifyInformationKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(top: 5),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "The Definition field",
                  text:
                      "The <b>Definition</b> field is dedicated to supply the meaning of your word. You may also use <i>diacritic characters</i> and <i>tags</i> in this field.",
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
          identify: "modify-info-next-key",
          keyTarget: modifyInformationKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(top: 5),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "The Example field",
                  text:
                      "The <b>Example</b> field is dedicated to supply an example Kapampangan phrase or sentence using your word. You may also use <i>diacritic characters</i> and <i>tags</i> in this field.",
                  onNext: () {
                    Scrollable.ensureVisible(
                        modifyInformationKey.currentContext!,
                        alignment: 0.5,
                        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                        duration: Duration(milliseconds: 800));
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
          identify: "modify-info-key",
          keyTarget: modifyInformationKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(top: 5),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "The Example Translation field",
                  text:
                      "The <b>Example Translation</b> field is dedicated to supply the English translation of the example you provided in the previous field. You may also use <i>diacritic characters</i> and <i>tags</i> in this field.",
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
          identify: "modify-info-key",
          keyTarget: modifyInformationKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(top: 5),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "The Dialect field",
                  text:
                      'The <b>Dialect</b> field is dedicated to supply the Kapampangan dialect you word follows. This will be displayed as "(from Dialect "Origin")" in the detail page.',
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
          identify: "modify-info-bnext-key",
          keyTarget: modifyInformationKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(top: 5),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "The Origin field",
                  text:
                      'The <b>Origin</b> field is dedicated to supply the origin of your word. This will be displayed as "(from Dialect "Origin")" in the detail page.',
                  onNext: () {
                    Scrollable.ensureVisible(modifyKulitanKey.currentContext!,
                        alignment: 0.5,
                        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                        duration: Duration(milliseconds: 800));
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
          identify: "modify-kulitan-key",
          keyTarget: modifyKulitanKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "The Kulitan Editor",
                  text:
                      'The <b>Kulitan Editor</b> is your tool to supply how your word will be written in Kulitan. Tap "<i>Open Kulitan Editor</i>" button to launch the editor.',
                  onNext: () {
                    Scrollable.ensureVisible(
                        modifyOtherRelatedKey.currentContext!,
                        alignment: 0.5,
                        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                        duration: Duration(milliseconds: 800));
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
          identify: "modify-related-key",
          keyTarget: modifyOtherRelatedKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "The Other Related field",
                  text:
                      'The <b>Other Related</b> field is dedicated to supply other words related to your word. If related word exists within the dictionary, you may use the <i>import button</i> on the right. If not you may <i>manually type the word and end it with a "," (comma)</i>.',
                  onNext: () {
                    Scrollable.ensureVisible(modifySynonymKey.currentContext!,
                        alignment: 0.5,
                        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                        duration: Duration(milliseconds: 800));
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
          identify: "modify-synonym-key",
          keyTarget: modifySynonymKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "The Synonym field",
                  text:
                      'The <b>Synonym</b> field is dedicated to supply synonyms of your word. Similar rules from the <i>Other related field</i> are applied on this field.',
                  onNext: () {
                    Scrollable.ensureVisible(modifyAntonymKey.currentContext!,
                        alignment: 0.5,
                        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                        duration: Duration(milliseconds: 800));
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
          identify: "modify-antonym-key",
          keyTarget: modifyAntonymKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "The Antonym field",
                  text:
                      'The <b>Antonym</b> field is dedicated to supply antonyms of your word. Similar rules from the <i>Other related field and Synonyms field</i> are applied on this field.',
                  onNext: () {
                    Scrollable.ensureVisible(modifySourcesKey.currentContext!,
                        alignment: 0.5,
                        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                        duration: Duration(milliseconds: 800));
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
          identify: "modify-sources-key",
          keyTarget: modifySourcesKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "The Sources field",
                  text:
                      "The <b>Sources</b> field is dedicated to supply all the  references you used in creating or editing the word entry. You may also use <i>diacritic characters</i> and <i>tags</i> in this field.",
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
          identify: "modify-proceed-key",
          keyTarget: modifyProceedKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              customPosition: CustomTargetContentPosition(
                bottom: 80,
              ),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Proceed to Preview",
                  text:
                      "The <b>Proceed</b> button redirects you to a preview of the dictionary entry you just created or modified. You may always go back to this page to edit some details from the preview.",
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

  @override
  void onInit() {
    super.onInit();
    wordController = TextEditingController();
    phoneticController = TextEditingController();
    engTransController = TextfieldTagsController();
    filTransController = TextfieldTagsController();
    playerController = PlayerController();
    if (!editMode && !requestMode) addTypeField(0);
    relatedController = TextfieldTagsController();
    synonymController = TextfieldTagsController();
    antonymController = TextfieldTagsController();
    referencesController = TextEditingController();
    if (editMode) {
      getEditDetails();
    } else if (requestMode) {
      getRequestDetails();
    }
  }

  @override
  void onClose() {
    super.onClose();
    wordController.dispose();
    phoneticController.dispose();
    engTransController.dispose();
    filTransController.dispose();
    playerController.dispose();
    relatedController.dispose();
    synonymController.dispose();
    antonymController.dispose();
    referencesController.dispose();
  }

  Future populateFields(
    String word,
    String prn,
    String prnAudioUrl,
    List<dynamic>? engTrans,
    List<dynamic>? filTrans,
    List<dynamic> meaningsList,
    List<List<dynamic>> kulitanChars,
    Map<dynamic, dynamic>? otherRelated,
    Map<dynamic, dynamic>? synonyms,
    Map<dynamic, dynamic>? antonyms,
    String? sources,
    Map<dynamic, dynamic>? contributorsList,
    Map<dynamic, dynamic>? expertList,
  ) async {
    isProcessing.value = true;
    wordController.text = word;
    phoneticController.text = prn;
    String prnExt = prnAudioUrl.split("?").first;
    final appStorage = await getApplicationDocumentsDirectory();
    final fileExt = p.extension(File(prnExt).path);
    final tempAudioFile = File('${appStorage.path}/audio$fileExt');
    try {
      final response = await Dio().get(
        prnAudioUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: Duration(seconds: 15),
        ),
      );
      final raf = tempAudioFile.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      importError = false;
      await raf.close();
    } catch (e) {
      Get.back();
      Helper.errorSnackBar(
          title: tOhSnap,
          message: "Unable to get audio pronunciation from the internet.");
      return;
    }
    audioPath = tempAudioFile.path;
    playerController.stopPlayer();
    playerController.preparePlayer(path: audioPath);
    playerController.seekTo(0);
    hasFile.value = true;
    List<dynamic> meaningsGetList = List.from(meaningsList);
    List<String> _types = [];
    List<List<Map<dynamic, dynamic>>> _definitions = [];
    for (Map<dynamic, dynamic> meaning in meaningsGetList) {
      _types.add(meaning["partOfSpeech"]);
      List<Map<dynamic, dynamic>> tempDef = [];
      for (Map<dynamic, dynamic> definition in meaning["definitions"]) {
        tempDef.add(definition);
      }
      _definitions.add(tempDef);
    }
    for (var i = 0; i < _types.length; i++) {
      addTypeField(i);
      if (_types[i] == "noun" ||
          _types[i] == "verb" ||
          _types[i] == "adjective" ||
          _types[i] == "adverb" ||
          _types[i] == "particle") {
        typeFields[i] = _types[i];
      } else {
        typeFields[i] = "custom";
        customTypeController[i].text = _types[i];
      }
      for (var j = 0; j < _definitions[i].length; j++) {
        if (j != 0) addDefinitionField(i, j);
        if (_definitions[i][j]["definition"] != null) {
          definitionsFields[i][j][0].text = _definitions[i][j]["definition"];
        }
        if (_definitions[i][j]["example"] != null) {
          definitionsFields[i][j][1].text = _definitions[i][j]["example"];
        }
        if (_definitions[i][j]["exampleTranslation"] != null) {
          definitionsFields[i][j][2].text =
              _definitions[i][j]["exampleTranslation"];
        }
        if (_definitions[i][j]["dialect"] != null) {
          definitionsFields[i][j][3].text = _definitions[i][j]["dialect"];
        }
        if (_definitions[i][j]["origin"] != null) {
          definitionsFields[i][j][4].text = _definitions[i][j]["origin"];
        }
      }
    }
    if (kulitanChars != 0) {
      kulitanStringListGetter.clear();
      for (var i in kulitanChars) {
        var newList = [];
        for (var j in i) {
          newList.add(j);
        }
        kulitanStringListGetter.add(newList);
      }
      kulitanStringListGetter.refresh();
    }
    currentLine = kulitanStringListGetter.length - 1;
    currentSpace = kulitanStringListGetter[currentLine].length;
    String kulitanString = '';
    for (var line in kulitanStringListGetter) {
      for (var syl in line) {
        kulitanString = kulitanString + syl;
      }
    }
    if (kulitanString == '') {
      kulitanListEmpty.value = true;
    } else {
      kulitanListEmpty.value = false;
    }
    if (otherRelated != null) {
      for (var rel in otherRelated.entries) {
        relatedController..addTag = rel.key;
        if (rel.value != null) {
          importedRelated[rel.key] = rel.value;
        }
      }
    }
    if (synonyms != null) {
      for (var syn in synonyms.entries) {
        synonymController..addTag = syn.key;
        if (syn.value != null) {
          importedSynonyms[syn.key] = syn.value;
        }
      }
    }
    if (antonyms != null) {
      for (var ant in antonyms.entries) {
        antonymController..addTag = ant.key;
        if (ant.value != null) {
          importedAntonyms[ant.key] = ant.value;
        }
      }
    }
    if (sources != null) {
      referencesController.text = sources;
    }
    if (contributorsList != null) {
      contributors = new Map.from(contributorsList);
    }
    if (expertList != null) {
      expert = new Map.from(expertList);
    }
    rebuildAudio.value = !rebuildAudio.value;
    isProcessing.value = false;
    Helper.successSnackBar(
        title: "Form ready!",
        message:
            "Form has been filled with information. You can now edit using the form.");
  }

  Future getEditDetails() async {
    await appController.checkDictionary();
    appController.update();
    await populateFields(
        appController.dictionaryContent[editWordID]["word"],
        appController.dictionaryContent[editWordID]["pronunciation"],
        appController.dictionaryContent[editWordID]["pronunciationAudio"],
        appController.dictionaryContent[editWordID]["englishTranslations"] !=
                null
            ? new List.from(appController.dictionaryContent[editWordID]
                ["englishTranslations"])
            : null,
        appController.dictionaryContent[editWordID]["filipinoTranslations"] !=
                null
            ? new List.from(appController.dictionaryContent[editWordID]
                ["filipinoTranslations"])
            : null,
        appController.dictionaryContent[editWordID]["meanings"] != null
            ? new List.from(
                appController.dictionaryContent[editWordID]["meanings"])
            : [],
        appController.dictionaryContent[editWordID]["kulitan-form"] != null
            ? new List.from(
                appController.dictionaryContent[editWordID]["kulitan-form"])
            : [],
        appController.dictionaryContent[editWordID]["otherRelated"] != null
            ? new Map.from(
                appController.dictionaryContent[editWordID]["otherRelated"])
            : null,
        appController.dictionaryContent[editWordID]["synonyms"] != null
            ? new Map.from(
                appController.dictionaryContent[editWordID]["synonyms"])
            : null,
        appController.dictionaryContent[editWordID]["antonyms"] != null
            ? new Map.from(
                appController.dictionaryContent[editWordID]["antonyms"])
            : null,
        appController.dictionaryContent[editWordID]["sources"],
        appController.dictionaryContent[editWordID]["contributors"] != null
            ? new Map.from(
                appController.dictionaryContent[editWordID]["contributors"])
            : null,
        appController.dictionaryContent[editWordID]["expert"] != null
            ? new Map.from(appController.dictionaryContent[editWordID]["expert"])
            : null);
  }

  Future getRequestDetails() async {
    if (requestType == 0) {
      AddRequestModel? request =
          await DatabaseRepository.instance.getAddRequest(requestID ?? '');
      if (request == null) {
        Get.back();
        Helper.errorSnackBar(
            title: tOhSnap,
            message: "Unable to get request. PLease try again.");
      } else {
        await DatabaseRepository.instance.changeRequestState(requestID!, false);
        List<List<dynamic>> kulitanCharsList = [];
        String kulitanChStr = request.kulitanChars;
        if (kulitanChStr[kulitanChStr.length - 1] == '#') {
          kulitanChStr = kulitanChStr.substring(0, kulitanChStr.length - 1);
        }
        List<dynamic> kulitanLines = kulitanChStr.split("#");
        for (String line in kulitanLines) {
          List<dynamic> chars = line.split(",");
          kulitanCharsList.add(chars);
        }
        populateFields(
            request.word,
            request.prn,
            request.prnUrl,
            new List.from(request.engTrans),
            new List.from(request.filTrans),
            new List.from(request.meanings),
            kulitanCharsList,
            new Map.from(request.otherRelated),
            new Map.from(request.synonyms),
            new Map.from(request.antonyms),
            request.sources,
            new Map.from(request.contributors),
            new Map.from(request.expert));
        prnStoragePath = request.prnStoragePath;
      }
    } else {
      EditRequestModel? request =
          await DatabaseRepository.instance.getEditRequest(requestID ?? '');
      if (request == null) {
        Get.back();
        Helper.errorSnackBar(
            title: tOhSnap,
            message: "Unable to get request. PLease try again.");
      } else {
        await DatabaseRepository.instance.changeRequestState(requestID!, false);
        List<List<dynamic>> kulitanCharsList = [];
        String kulitanChStr = request.kulitanChars;
        if (kulitanChStr[kulitanChStr.length - 1] == '#') {
          kulitanChStr = kulitanChStr.substring(0, kulitanChStr.length - 1);
        }
        List<dynamic> kulitanLines = kulitanChStr.split("#");
        for (String line in kulitanLines) {
          List<dynamic> chars = line.split(",");
          kulitanCharsList.add(chars);
        }
        populateFields(
            request.word,
            request.prn,
            request.prnUrl,
            new List.from(request.engTrans),
            new List.from(request.filTrans),
            new List.from(request.meanings),
            kulitanCharsList,
            new Map.from(request.otherRelated),
            new Map.from(request.synonyms),
            new Map.from(request.antonyms),
            request.sources,
            new Map.from(request.contributors),
            new Map.from(request.expert));
        requestEditID = request.prevWordID;
      }
    }
  }

  Map<dynamic, dynamic> contributors = {};
  Map<dynamic, dynamic> expert = {};

  late TextEditingController wordController,
      phoneticController,
      referencesController;

  String? validateWord(String value) {
    if (value.isEmpty) {
      return "Please enter word";
    }
    return null;
  }

  String? validatePhonetic(String value) {
    if (value.isEmpty) {
      return "Please enter word phonetics";
    }
    return null;
  }

  final GlobalKey<FormState> modifyWordFormKey = GlobalKey<FormState>();

  late PlayerController playerController;
  RxBool rebuildAudio = true.obs;
  String audioPath = "";
  RxBool isPlaying = false.obs;
  RxBool hasFile = false.obs;
  RxBool audioSubmitError = false.obs;

  void playAndStop(PlayerController controller) async {
    if (controller.playerState == PlayerState.playing) {
      await controller.pausePlayer();
    } else {
      await controller.startPlayer(finishMode: FinishMode.loop);
    }

    playerController.playerState == PlayerState.playing
        ? isPlaying.value = true
        : isPlaying.value = false;
  }

  void validateAudio() {
    if (hasFile.value) {
      audioSubmitError.value = false;
    } else {
      audioSubmitError.value = true;
    }
  }

  late TextfieldTagsController engTransController,
      filTransController,
      relatedController,
      synonymController,
      antonymController;

  List<dynamic> engTransList = [];

  void getEnglishTranslations() {
    engTransList.clear();
    for (String word in engTransController.getTags!) {
      engTransList.add(word);
    }
  }

  RxBool engTransEmpty = false.obs;

  void validateEngTrans() {
    if (engTransList.length == 0) {
      engTransEmpty.value = true;
    } else {
      engTransEmpty.value = false;
    }
  }

  List<dynamic> filTransList = [];

  void getFilipinoTranslations() {
    filTransList.clear();
    for (String word in filTransController.getTags!) {
      filTransList.add(word);
    }
  }

  RxBool filTransEmpty = false.obs;

  void validateFilTrans() {
    if (filTransList.length == 0) {
      filTransEmpty.value = true;
    } else {
      filTransEmpty.value = false;
    }
  }

  RxList<List<dynamic>> kulitanStringListGetter = <List<dynamic>>[[]].obs;
  int currentLine = 0;
  int currentSpace = 0;
  RxBool kulitanListEmpty = true.obs;
  RxBool kulitanError = false.obs;

  void validateKulitan() {
    if (kulitanListEmpty.value) {
      kulitanError.value = true;
    } else {
      kulitanError.value = false;
    }
  }

  final GlobalKey<AnimatedListState> typeListKey = GlobalKey();
  final List<GlobalKey<AnimatedListState>> definitionListKey = [];

  List<DropdownMenuItem<String>> get typeDropItems {
    List<DropdownMenuItem<String>> wordTypes = [
      DropdownMenuItem(child: Text("noun"), value: "noun"),
      DropdownMenuItem(child: Text("verb"), value: "verb"),
      DropdownMenuItem(child: Text("adjective"), value: "adjective"),
      DropdownMenuItem(child: Text("adverb"), value: "adverb"),
      DropdownMenuItem(child: Text("particle"), value: "particle"),
      DropdownMenuItem(child: Text("custom"), value: "custom"),
    ];
    return wordTypes;
  }

  final RxList<String> typeFields = <String>[].obs;
  final List<TextEditingController> customTypeController = [];
  final List<FocusNode> typeFieldFocusNode = [];
  final List<List<FocusNode>> definitionFieldFocusNode = [];
  final RxList<List<List<TextEditingController>>> definitionsFields =
      <List<List<TextEditingController>>>[].obs;
  // TD is              D                  TD
  //[[[TE, TE, TE, TE], [TE, TE, TE, TE]], [[TE, TE, TE, TE]]]
  Future addTypeField(int i) async {
    typeListKey.currentState?.insertItem(i);
    customTypeController.insert(i, TextEditingController());
    typeFieldFocusNode.insert(i, FocusNode());
    definitionListKey.insert(i, GlobalKey());
    typeFields.insert(i, '');
    definitionsFields.insert(i, []);
    definitionFieldFocusNode.insert(i, []);
    addDefinitionField(i, 0);
  }

  void removeTypeField(int i) {
    typeFields.removeAt(i);
    customTypeController.removeAt(i);
    typeListKey.currentState!.removeItem(i, (_, __) => Container());
  }

  void addDefinitionField(int i, int j) {
    definitionsFields[i].insert(j, [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ]);
    definitionListKey[i].currentState?.insertItem(j);
    definitionFieldFocusNode[i].insert(j, FocusNode());
  }

  void removeDefinitionField(int i, int j) {
    definitionsFields[i].removeAt(j);
    definitionListKey[i].currentState!.removeItem(j, (_, __) => Container());
  }

  String? validateType(String value) {
    if (value.isEmpty) {
      return "Please select a type";
    }
    return null;
  }

  String? validateCustomType(String value) {
    if (value.isEmpty) {
      return "Please enter custom type";
    }
    return null;
  }

  String? validateDefinition(String value) {
    if (value.isEmpty) {
      return "Please enter a definition";
    }
    return null;
  }

  final Map<dynamic, dynamic> importedSynonyms = {};
  final Map<dynamic, dynamic> synonymsMap = {};
  final Map<dynamic, dynamic> importedAntonyms = {};
  final Map<dynamic, dynamic> antonymsMap = {};
  final Map<dynamic, dynamic> importedRelated = {};
  final Map<dynamic, dynamic> relatedMap = {};

  void addAsImported(Map<dynamic, dynamic> importedMap,
      TextfieldTagsController controller, String word, String wordID) {
    controller..addTag = word;
    importedMap[word] = wordID;
    print(importedMap);
    List<String> currentTags = controller.getTags!;
    print(currentTags);
  }

  void getTextFieldTagsData(TextfieldTagsController controller,
      Map<dynamic, dynamic> importedMap, Map<dynamic, dynamic> saveMap) {
    saveMap.clear();
    for (String word in controller.getTags!) {
      if (importedMap.containsKey(word)) {
        saveMap[word] = importedMap[word]!;
      } else {
        saveMap[word] = null;
      }
    }
  }

  void submitWord() async {
    validateAudio();
    getEnglishTranslations();
    validateEngTrans();
    getFilipinoTranslations();
    validateFilTrans();
    validateKulitan();
    getTextFieldTagsData(relatedController, importedRelated, relatedMap);
    getTextFieldTagsData(synonymController, importedSynonyms, synonymsMap);
    getTextFieldTagsData(antonymController, importedAntonyms, antonymsMap);

    final informationValid = modifyWordFormKey.currentState!.validate();
    if (!informationValid ||
        wordController.text.isEmpty ||
        phoneticController.text.isEmpty ||
        audioSubmitError.value ||
        kulitanError.value) {
      return;
    }
    modifyWordFormKey.currentState!.save();

    String wordNoTag = wordController.text
        .replaceAll("<i>", "")
        .replaceAll("</i>", "")
        .replaceAll("<b>", "")
        .replaceAll("</b>", "")
        .replaceAll("<u>", "")
        .replaceAll("</u>", "");

    String normalizedWord = appController.normalizeWord(wordNoTag.trim());
    String wordKey = normalizedWord;

    List<dynamic> meanings = [];

    for (MapEntry type in typeFields.asMap().entries) {
      Map<dynamic, dynamic> tempMeaning = {};

      tempMeaning["partOfSpeech"] = type.value == "custom"
          ? customTypeController[type.key].text
          : type.value;

      List<Map<dynamic, dynamic>> tempDefinitions = [];

      for (var definition in definitionsFields[type.key]) {
        Map<dynamic, dynamic> tempDef = {};
        tempDef["definition"] = definition[0].text;
        tempDef["example"] =
            definition[1].text.isEmpty || definition[2].text.trim() == ""
                ? null
                : definition[1].text;
        tempDef["exampleTranslation"] =
            definition[2].text.isEmpty || definition[3].text.trim() == ""
                ? null
                : definition[2].text;
        tempDef["dialect"] =
            definition[3].text.isEmpty || definition[1].text.trim() == ""
                ? null
                : definition[3].text;
        tempDef["origin"] =
            definition[4].text.isEmpty || definition[1].text.trim() == ""
                ? null
                : definition[4].text;
        tempDefinitions.add(tempDef);
      }
      tempMeaning["definitions"] = tempDefinitions;
      meanings.add(tempMeaning);
    }

    final String timestamp =
        DateFormat('yyyy-MM-dd (HH:mm:ss)').format(DateTime.now());

    List<String> types = [];
    List<List<Map<dynamic, dynamic>>> definitions = [];

    for (Map<dynamic, dynamic> meaning in meanings) {
      types.add(meaning["partOfSpeech"]);
      List<Map<dynamic, dynamic>> tempDef = [];
      for (Map<dynamic, dynamic> definition in meaning["definitions"]) {
        tempDef.add(definition);
      }
      definitions.add(tempDef);
    }
    String kulitanString = '';
    for (var line in kulitanStringListGetter) {
      for (var syl in line) {
        kulitanString = kulitanString + syl;
      }
    }

    if (editMode) {
      if (expert.length != 0) {
        String pastUsername = expert.keys.toList().first;
        String pastUID = expert[pastUsername] ?? "";
        contributors[pastUsername] = pastUID;
      }
      if (appController.userIsExpert ?? false) {
        expert.clear();
        expert[appController.userName ?? "User"] = appController.userID ?? "";
      } else {
        expert.clear();
        if (contributors.containsValue(appController.userID ?? "")) {
          contributors.removeWhere(
              (key, value) => value == (appController.userID ?? ""));
        }
        contributors[appController.userName ?? "User"] =
            appController.userID ?? "";
      }
      Get.to(
          () => PreviewEditsPage(
                prevWordID: requestMode ? requestEditID! : editWordID!,
                wordID: wordKey,
                word: wordController.text.trim(),
                normalizedWord: normalizedWord,
                prn: phoneticController.text.trim(),
                prnPath: audioPath,
                engTrans: engTransEmpty.value ? null : engTransList,
                filTrans: filTransEmpty.value ? null : filTransList,
                meanings: meanings,
                types: typeFields,
                kulitanChars: kulitanStringListGetter,
                otherRelated: relatedMap.length == 0 ? null : relatedMap,
                synonyms: synonymsMap.length == 0 ? null : synonymsMap,
                antonyms: antonymsMap.length == 0 ? null : antonymsMap,
                sources: referencesController.text.isEmpty ||
                        referencesController.text.trim() == ''
                    ? null
                    : referencesController.text.trim(),
                contributors: contributors.length == 0 ? null : contributors,
                expert: expert.length == 0 ? null : expert,
                lastModifiedTime: timestamp,
                definitions: definitions,
                kulitanString: kulitanString,
                fromRequests: requestMode,
                requestID: requestID ?? '',
                requestAudioPath: prnStoragePath ?? '',
              ),
          duration: Duration(milliseconds: 500),
          transition: Transition.rightToLeft,
          curve: Curves.easeInOut);
    } else {
      if (appController.userIsExpert ?? false) {
        expert.clear();
        contributors.clear();
        expert[appController.userName ?? "User"] = appController.userID ?? "";
      } else {
        expert.clear();
        contributors.clear();
        contributors[appController.userName ?? "User"] =
            appController.userID ?? "";
      }
      Get.to(
          () => PreviewPage(
                wordID: wordKey,
                word: wordController.text.trim(),
                normalizedWord: normalizedWord,
                prn: phoneticController.text.trim(),
                prnPath: audioPath,
                engTrans: engTransEmpty.value ? null : engTransList,
                filTrans: filTransEmpty.value ? null : filTransList,
                meanings: meanings,
                types: typeFields,
                kulitanChars: kulitanStringListGetter,
                otherRelated: relatedMap.length == 0 ? null : relatedMap,
                synonyms: synonymsMap.length == 0 ? null : synonymsMap,
                antonyms: antonymsMap.length == 0 ? null : antonymsMap,
                sources: referencesController.text.isEmpty ||
                        referencesController.text.trim() == ''
                    ? null
                    : referencesController.text.trim(),
                contributors: contributors.length == 0 ? null : contributors,
                expert: expert.length == 0 ? null : expert,
                lastModifiedTime: timestamp,
                definitions: definitions,
                kulitanString: kulitanString,
                fromRequests: requestMode,
                requestID: requestID ?? '',
                requestAudioPath: prnStoragePath ?? '',
              ),
          duration: Duration(milliseconds: 500),
          transition: Transition.rightToLeft,
          curve: Curves.easeInOut);
    }
  }
}
