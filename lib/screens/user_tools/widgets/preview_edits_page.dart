import 'package:amanu/components/dictionary_card.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:amanu/screens/user_tools/controllers/preview_edits_controller.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class PreviewEditsPage extends StatelessWidget {
  final String prevWordID;
  final String wordID;
  final String word;
  final String normalizedWord;
  final String prn;
  final String prnPath;
  final List<dynamic>? engTrans;
  final List<dynamic>? filTrans;
  final List<dynamic> meanings;
  final List<String> types;
  final List<List<dynamic>> kulitanChars;
  final Map<dynamic, dynamic>? otherRelated;
  final Map<dynamic, dynamic>? synonyms;
  final Map<dynamic, dynamic>? antonyms;
  final String? sources;
  final Map<dynamic, dynamic>? contributors;
  final Map<dynamic, dynamic>? expert;
  final String lastModifiedTime;
  final List<List<Map<dynamic, dynamic>>> definitions;
  final String kulitanString;
  final bool fromRequests;
  final String requestID;
  final String requestAudioPath;

  PreviewEditsPage(
      {super.key,
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
      required this.prevWordID,
      this.fromRequests = false,
      this.requestID = '',
      this.requestAudioPath = ''});

  late final controller = Get.put(PreviewEditsController(
      prevWordID: prevWordID,
      wordID: wordID,
      word: word,
      normalizedWord: normalizedWord,
      prn: prn,
      prnPath: prnPath,
      engTrans: engTrans ?? [],
      filTrans: filTrans ?? [],
      meanings: meanings,
      types: types,
      kulitanChars: kulitanChars,
      otherRelated: otherRelated ?? {},
      synonyms: synonyms ?? {},
      antonyms: antonyms ?? {},
      sources: sources ?? '',
      contributors: contributors ?? {},
      expert: expert ?? {},
      lastModifiedTime: lastModifiedTime,
      definitions: definitions,
      kulitanString: kulitanString,
      fromRequests: fromRequests,
      requestID: requestID,
      requestAudioPath: requestAudioPath));

  final appController = Get.find<ApplicationController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.only(bottom: screenPadding.bottom),
      child: Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            splashColor: primaryOrangeLight,
            focusColor: primaryOrangeLight.withOpacity(0.5),
            onPressed: () {
              controller.submitEdits();
            },
            label: Text(
              appController.userIsExpert ?? false
                  ? tConfirmEdits.toUpperCase()
                  : tEditRequest.toUpperCase(),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: pureWhite,
                letterSpacing: 1.0,
              ),
            ),
            icon: Icon(Icons.edit_rounded),
          ),
          body: Stack(
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
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 65, horizontal: 30),
                          child: Column(
                            children: [
                              appController.userIsExpert ?? false
                                  ? Container()
                                  : Container(
                                      width: double.infinity,
                                      margin: EdgeInsets.only(bottom: 10),
                                      child: Form(
                                        key: controller.notesFormKey,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        child: TextFormField(
                                          controller:
                                              controller.notesController,
                                          onSaved: (value) {
                                            controller.notes = value!;
                                          },
                                          validator: (value) {
                                            if (controller
                                                    .notesController.text ==
                                                '') {
                                              return "Please leave some notes describing the edits you made.";
                                            } else {
                                              return null;
                                            }
                                          },
                                          maxLines: 5,
                                          maxLength: 1000,
                                          decoration: InputDecoration(
                                              labelText: tEditNotes,
                                              alignLabelWithHint: true,
                                              hintText: tEditNotesHint,
                                              hintMaxLines: 5,
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0))),
                                        ),
                                      ),
                                    ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: orangeCard,
                                ),
                                child: DictionaryCard(
                                  word: controller.word,
                                  prn: controller.prn,
                                  prnUrl: controller.prnPath,
                                  engTrans: controller.engTrans,
                                  filTrans: controller.filTrans,
                                  meanings: controller.meanings,
                                  types: controller.types,
                                  definitions: controller.definitions,
                                  kulitanChars: controller.kulitanChars,
                                  kulitanString: controller.kulitanString,
                                  otherRelated: controller.otherRelated,
                                  synonyms: controller.synonyms,
                                  antonyms: controller.antonyms,
                                  sources: controller.sources,
                                  contributors: controller.contributors,
                                  expert: controller.expert,
                                  lastModifiedTime: controller.lastModifiedTime,
                                  width: size.width - 60,
                                  isPreview: true,
                                  audioIsOnline: false,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(10),
                                alignment: Alignment.center,
                                child: Text(
                                  "LIVE VERSION:",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: disabledGrey,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: orangeCard,
                                ),
                                child: DictionaryCard(
                                  word: controller.prevWord,
                                  prn: controller.prevPrn,
                                  prnUrl: controller.prevPrnUrl,
                                  engTrans: controller.prevEngTrans,
                                  filTrans: controller.prevFilTrans,
                                  meanings: controller.prevMeanings,
                                  types: controller.prevTypes,
                                  definitions: controller.prevDefinitions,
                                  kulitanChars: controller.prevKulitanChars,
                                  kulitanString: controller.prevKulitanString,
                                  otherRelated: controller.prevOtherRelated,
                                  synonyms: controller.prevSynonyms,
                                  antonyms: controller.prevAntonyms,
                                  sources: controller.prevSources,
                                  contributors: controller.prevContributors,
                                  expert: controller.prevExpert,
                                  lastModifiedTime:
                                      controller.prevLastModifiedTime,
                                  width: size.width - 60,
                                  isPreview: true,
                                ),
                              ),
                            ],
                          )),
                    )),
              ),
              Positioned(
                  top: screenPadding.top + 80,
                  left: 30,
                  right: 30,
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: disabledGrey.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Text(
                      tThisIsAPreview,
                      style: TextStyle(
                          fontWeight: FontWeight.w400, color: cardText),
                    ),
                  )),
              IsProcessingWithHeader(
                  condition: controller.isProcessing,
                  size: size,
                  screenPadding: screenPadding),
              ThreePartHeader(
                size: size,
                screenPadding: screenPadding,
                title: controller.word,
                secondIcon: Icons.bookmark_outline_rounded,
                secondIconDisabled: true,
              ),
            ],
          )),
    );
  }
}
