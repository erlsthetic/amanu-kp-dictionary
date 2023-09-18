import 'dart:ui';

import 'package:amanu/components/confirm_dialog.dart';
import 'package:amanu/screens/user_tools/controllers/modify_word_controller.dart';
import 'package:amanu/screens/user_tools/widgets/connection_selector.dart';
import 'package:amanu/screens/user_tools/widgets/kulitan_formfield.dart';
import 'package:amanu/screens/user_tools/widgets/studio_formfield.dart';
import 'package:amanu/screens/user_tools/widgets/tags_field.dart';
import 'package:amanu/screens/user_tools/widgets/word_info_section.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ModifyWordPage extends StatefulWidget {
  ModifyWordPage(
      {super.key,
      this.editMode = false,
      this.editWordID,
      this.editWord = '',
      this.requestMode = false,
      this.requestID,
      this.requestType});

  final bool? editMode;
  final bool? requestMode;
  final String? editWord;
  final String? editWordID;
  final String? requestID;
  final int? requestType;

  @override
  State<ModifyWordPage> createState() => _ModifyWordPageState();
}

class _ModifyWordPageState extends State<ModifyWordPage> {
  late final controller = Get.put(ModifyController(
      editMode: widget.editMode ?? false,
      editWordID: widget.editWordID,
      requestMode: widget.requestMode ?? false,
      requestID: widget.requestID,
      requestType: widget.requestType));

  final appController = Get.find<ApplicationController>();
  TutorialCoachMark? tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    showTutorial();
  }

  void showTutorial() {
    if (appController.isFirstTimeBookmarks) {
      Future.delayed(Duration(seconds: 1), () {
        tutorialCoachMark = TutorialCoachMark(
            pulseEnable: false,
            targets: controller.initTarget(),
            imageFilter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
            onClickTarget: (target) {
              if (target.identify == "modify-key") {
                Scrollable.ensureVisible(controller.modifyKey.currentContext!,
                    alignment: 0.5,
                    alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                    duration: Duration(milliseconds: 800));
              } else if (target.identify == "modify-word-key") {
                Scrollable.ensureVisible(
                    controller.modifyPrnKey.currentContext!,
                    alignment: 0.5,
                    alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                    duration: Duration(milliseconds: 800));
              } else if (target.identify == "modify-prn-key") {
                Scrollable.ensureVisible(
                    controller.modifyStudioKey.currentContext!,
                    alignment: 0.5,
                    alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                    duration: Duration(milliseconds: 800));
              } else if (target.identify == "modify-studio-key") {
                Scrollable.ensureVisible(
                    controller.modifyEngTransKey.currentContext!,
                    alignment: 1.0,
                    alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                    duration: Duration(milliseconds: 800));
              } else if (target.identify == "modify-engtrans-key") {
                Scrollable.ensureVisible(
                    controller.modifyFilTransKey.currentContext!,
                    alignment: 0.5,
                    alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                    duration: Duration(milliseconds: 800));
              } else if (target.identify == "modify-filtrans-key") {
                Scrollable.ensureVisible(
                    controller.modifyInformationKey.currentContext!,
                    alignment: 1.5,
                    alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                    duration: Duration(milliseconds: 800));
              } else if (target.identify == "modify-info-next-key") {
                Scrollable.ensureVisible(
                    controller.modifyInformationKey.currentContext!,
                    alignment: 0.5,
                    alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                    duration: Duration(milliseconds: 800));
              } else if (target.identify == "modify-info-bnext-key") {
                Scrollable.ensureVisible(
                    controller.modifyKulitanKey.currentContext!,
                    alignment: 0.5,
                    alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                    duration: Duration(milliseconds: 800));
              } else if (target.identify == "modify-kulitan-key") {
                Scrollable.ensureVisible(
                    controller.modifyOtherRelatedKey.currentContext!,
                    alignment: 0.5,
                    alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                    duration: Duration(milliseconds: 800));
              } else if (target.identify == "modify-related-key") {
                Scrollable.ensureVisible(
                    controller.modifySynonymKey.currentContext!,
                    alignment: 0.5,
                    alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                    duration: Duration(milliseconds: 800));
              } else if (target.identify == "modify-synonym-key") {
                Scrollable.ensureVisible(
                    controller.modifyAntonymKey.currentContext!,
                    alignment: 0.5,
                    alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                    duration: Duration(milliseconds: 800));
              } else if (target.identify == "modify-antonym-key") {
                Scrollable.ensureVisible(
                    controller.modifySourcesKey.currentContext!,
                    alignment: 0.5,
                    alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
                    duration: Duration(milliseconds: 800));
              }
            },
            onFinish: () async {
              // SharedPreferences prefs = await SharedPreferences.getInstance();
              // prefs.setBool("isFirstTimeModify", false);
              // appController.isFirstTimeModify = false;
            },
            hideSkip: true)
          ..show(context: context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.only(bottom: screenPadding.bottom),
      child: Scaffold(
        key: controller.modifyKey,
        floatingActionButton: FloatingActionButton.extended(
          key: controller.modifyProceedKey,
          splashColor: primaryOrangeLight,
          focusColor: primaryOrangeLight.withOpacity(0.5),
          onPressed: () {
            controller.submitWord();
          },
          label: Text(
            tProceed.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: pureWhite,
              letterSpacing: 1.0,
            ),
          ),
          icon: Icon(Icons.keyboard_double_arrow_right),
        ),
        body: WillPopScope(
            onWillPop: () async {
              final shouldPop = await showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: pureWhite,
                                borderRadius: BorderRadius.circular(30.0)),
                            margin: EdgeInsets.only(right: 12, top: 12),
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  constraints: BoxConstraints(minHeight: 70),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  decoration: BoxDecoration(
                                      color: primaryOrangeDark,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(30.0))),
                                  child: Text(
                                    "Cancel editing",
                                    style: GoogleFonts.robotoSlab(
                                        fontSize: 24,
                                        color: pureWhite,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(20.0),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          width: double.infinity,
                                          alignment: Alignment.center,
                                          child: Text(
                                            "Are you sure you want to go back? All your edits will be discarded.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: cardText, fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  onTap: () {
                                                    if ((widget.requestMode ??
                                                            false) &&
                                                        widget.requestID !=
                                                            null)
                                                      DatabaseRepository
                                                          .instance
                                                          .changeRequestState(
                                                              widget.requestID!,
                                                              true);
                                                    Navigator.pop(
                                                        context, true);
                                                  },
                                                  splashColor:
                                                      primaryOrangeLight,
                                                  highlightColor:
                                                      primaryOrangeLight
                                                          .withOpacity(0.5),
                                                  child: Ink(
                                                    height: 50.0,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "Go back".toUpperCase(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                          color: pureWhite,
                                                        ),
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: primaryOrangeDark,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Material(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                child: InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(25),
                                                  onTap: () {
                                                    Navigator.pop(
                                                        context, false);
                                                  },
                                                  splashColor:
                                                      primaryOrangeDarkShine,
                                                  highlightColor:
                                                      primaryOrangeDarkShine
                                                          .withOpacity(0.5),
                                                  child: Ink(
                                                    height: 50.0,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "Cancel".toUpperCase(),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 16,
                                                          color: pureWhite,
                                                        ),
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: primaryOrangeLight,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                )
                              ],
                            ),
                          ),
                          Positioned(
                            right: 0.0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Align(
                                alignment: Alignment.topRight,
                                child: CircleAvatar(
                                  radius: 18.0,
                                  backgroundColor: Colors.white,
                                  child: Icon(Icons.close,
                                      color: primaryOrangeDark),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
              return shouldPop;
            },
            child: Stack(
              children: [
                Positioned(
                  top: screenPadding.top + 50,
                  left: 0,
                  right: 0,
                  child: Container(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      height: size.height - screenPadding.top - 50,
                      width: size.width,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: controller.modifyWordFormKey,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 40, horizontal: 30),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    tAddInstructions,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                      color: darkGrey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                TextFormField(
                                  key: controller.modifyWordKey,
                                  controller: controller.wordController,
                                  validator: (value) {
                                    if (value != null) {
                                      return controller.validateWord(value);
                                    } else {
                                      return "Please enter word";
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: tWord + " *",
                                      hintText: tWord + " *",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    tPronunciation + " *",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                      color: disabledGrey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                TextFormField(
                                  key: controller.modifyPrnKey,
                                  controller: controller.phoneticController,
                                  validator: (value) {
                                    if (value != null) {
                                      return controller.validatePhonetic(value);
                                    } else {
                                      return "Please enter word phonetics";
                                    }
                                  },
                                  decoration: InputDecoration(
                                      labelText: tPhonetic + " *",
                                      hintText: tPhonetic + " *",
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                StudioFormField(
                                    key: controller.modifyStudioKey,
                                    controller: controller,
                                    onSaved: (value) {
                                      value = controller.audioPath;
                                    },
                                    validator: (value) {
                                      if (controller.audioPath == '') {
                                        return "Please provide audio pronunciation";
                                      } else {
                                        return null;
                                      }
                                    }),
                                SizedBox(
                                  height: 20.0,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    tEngTrans,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                      color: disabledGrey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                TagsField(
                                  key: controller.modifyEngTransKey,
                                  controller: controller.engTransController,
                                  width: size.width - (60.0 + 55),
                                  label: tEngTrans,
                                  category: 'engTrans',
                                ),
                                /*Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: TagsField(
                                        controller: controller.engTransController,
                                        width: size.width - (60.0 + 55),
                                        label: tEngTrans,
                                      )),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      Container(
                                        height: 50,
                                        width: 50,
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.keyboard_arrow_up,
                                              color: pureWhite,
                                            )),
                                        decoration: BoxDecoration(
                                          color: primaryOrangeDark,
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),*/
                                Obx(() => controller.engTransEmpty.value
                                    ? Container(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 10, 15, 0),
                                        width: double.infinity,
                                        child: Text(
                                          'You may want to provide a translation',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.yellow[700],
                                              fontSize: 12),
                                        ))
                                    : Container()),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    tFilTrans,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                      color: disabledGrey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                TagsField(
                                  key: controller.modifyFilTransKey,
                                  controller: controller.filTransController,
                                  width: size.width - (60.0),
                                  label: tFilTrans,
                                  category: "filTrans",
                                ),
                                Obx(() => controller.filTransEmpty.value
                                    ? Container(
                                        padding:
                                            EdgeInsets.fromLTRB(15, 10, 15, 0),
                                        width: double.infinity,
                                        child: Text(
                                          'You may want to provide a translation',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: Colors.yellow[700],
                                              fontSize: 12),
                                        ))
                                    : Container()),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    tInfoSec.toUpperCase(),
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.poppins(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600,
                                      color: muteBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                WordInfoSection(
                                    key: controller.modifyInformationKey,
                                    controller: controller),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    tKulitanSec.toUpperCase() + " *",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.poppins(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600,
                                      color: muteBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                KulitanFormField(
                                    key: controller.modifyKulitanKey,
                                    controller: controller,
                                    onSaved: (value) {},
                                    validator: (value) {
                                      if (controller.kulitanListEmpty.value) {
                                        return "Please provide Kulitan information for the word.";
                                      } else {
                                        return null;
                                      }
                                    }),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    tConnectionSec.toUpperCase(),
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.poppins(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600,
                                      color: muteBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    tRelated,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                      color: disabledGrey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    key: controller.modifyOtherRelatedKey,
                                    children: [
                                      Expanded(
                                        child: TagsField(
                                          controller:
                                              controller.relatedController,
                                          width: size.width - (60.0),
                                          label: tRelated,
                                          category: 'related',
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      GestureDetector(
                                        onTap: Feedback.wrapForTap(() {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ConnectionSelector(
                                                  title: "Select related word",
                                                  size: size,
                                                  category: "related",
                                                );
                                              });
                                        }, context),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.eject,
                                                color: pureWhite,
                                              )),
                                          decoration: BoxDecoration(
                                            color: primaryOrangeDark,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    tSynonyms,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                      color: disabledGrey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    key: controller.modifySynonymKey,
                                    children: [
                                      Expanded(
                                        child: TagsField(
                                          controller:
                                              controller.synonymController,
                                          width: size.width - (60.0),
                                          label: tSynonyms,
                                          category: "synonyms",
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      GestureDetector(
                                        onTap: Feedback.wrapForTap(() {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ConnectionSelector(
                                                  title: "Select synonym",
                                                  size: size,
                                                  category: "synonyms",
                                                );
                                              });
                                        }, context),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.eject,
                                                color: pureWhite,
                                              )),
                                          decoration: BoxDecoration(
                                            color: primaryOrangeDark,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    tAntonyms,
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.poppins(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.normal,
                                      color: disabledGrey,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8.0,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    key: controller.modifyAntonymKey,
                                    children: [
                                      Expanded(
                                        child: TagsField(
                                          controller:
                                              controller.antonymController,
                                          width: size.width - (60.0),
                                          label: tAntonyms,
                                          category: "antonyms",
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      GestureDetector(
                                        onTap: Feedback.wrapForTap(() {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ConnectionSelector(
                                                  title: "Select antonym",
                                                  size: size,
                                                  category: "antonyms",
                                                );
                                              });
                                        }, context),
                                        child: Container(
                                          height: 50,
                                          width: 50,
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.eject,
                                                color: pureWhite,
                                              )),
                                          decoration: BoxDecoration(
                                            color: primaryOrangeDark,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    tReferences.toUpperCase(),
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.poppins(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600,
                                      color: muteBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                TextFormField(
                                  key: controller.modifySourcesKey,
                                  controller: controller.referencesController,
                                  minLines: 1,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                      labelText: tSources,
                                      hintText: tSources,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                ),
                                SizedBox(
                                  height: 40.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )),
                ),
                IsProcessingWithHeader(
                    condition: controller.isProcessing,
                    size: size,
                    screenPadding: screenPadding),
                ThreePartHeader(
                  size: size,
                  screenPadding: screenPadding,
                  title: widget.editMode ?? false
                      ? appController.userIsExpert ?? false
                          ? tEdit + ' "' + (widget.editWord ?? '') + '"'
                          : tEdit +
                              ' "' +
                              (widget.editWord ?? '') +
                              '"' +
                              tEditWordRequest
                      : appController.userIsExpert ?? false
                          ? tAddWord
                          : tAddWordRequest,
                  firstOnPressed: () {
                    showConfirmDialog(
                        context,
                        "Cancel editing",
                        "Are you sure you want to exit? Your edits will be discarded",
                        "Exit",
                        "Cancel", () {
                      if ((widget.requestMode ?? false) &&
                          widget.requestID != null) {
                        DatabaseRepository.instance
                            .changeRequestState(widget.requestID!, true);
                      }
                      Navigator.of(context).pop();
                      Get.back();
                    }, () {
                      Navigator.of(context).pop();
                    });
                  },
                ),
              ],
            )),
      ),
    );
  }
}
