import 'package:amanu/components/browse_card.dart';
import 'package:amanu/components/search_filter.dart';
import 'package:amanu/components/shimmer_browse_card.dart';
import 'package:amanu/screens/search_screen/controllers/search_controller.dart';
import 'package:amanu/screens/user_tools/controllers/tools_controller.dart';
import 'package:amanu/screens/user_tools/widgets/kulitan_editor.dart';
import 'package:amanu/screens/user_tools/widgets/recording_studio.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/kulitan_preview.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:textfield_tags/textfield_tags.dart';

class AddWordPage extends StatelessWidget {
  AddWordPage({
    super.key,
  });

  final controller = Get.put(ToolsController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          splashColor: primaryOrangeLight,
          focusColor: primaryOrangeLight.withOpacity(0.5),
          onPressed: () {
            controller.submitWord();
          },
          label: Text(
            tAddWord.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: pureWhite,
              letterSpacing: 1.0,
            ),
          ),
          icon: Icon(Icons.add),
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
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: controller.addWordFormKey,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 40, horizontal: 30),
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
                            TextFormField(
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
                            StudioFormField(
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
                            Container(
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
                            ),
                            Obx(() => controller.engTransEmpty.value
                                ? Container(
                                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
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
                              controller: controller.filTransController,
                              width: size.width - (60.0),
                              label: tFilTrans,
                            ),
                            Obx(() => controller.filTransEmpty.value
                                ? Container(
                                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
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
                            WordInfoSection(controller: controller),
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
                                children: [
                                  Expanded(
                                    child: TagsField(
                                      controller: controller.relatedController,
                                      width: size.width - (60.0),
                                      label: tRelated,
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
                                                size: size);
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
                                        borderRadius: BorderRadius.circular(30),
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
                                children: [
                                  Expanded(
                                    child: TagsField(
                                      controller: controller.synonymController,
                                      width: size.width - (60.0),
                                      label: tSynonyms,
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
                                                size: size);
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
                                        borderRadius: BorderRadius.circular(30),
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
                                children: [
                                  Expanded(
                                    child: TagsField(
                                      controller: controller.antonymController,
                                      width: size.width - (60.0),
                                      label: tAntonyms,
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
                                                size: size);
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
                                        borderRadius: BorderRadius.circular(30),
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
              title: tAddWord,
            ),
          ],
        ));
  }
}

class ConnectionSelector extends StatelessWidget {
  ConnectionSelector({
    super.key,
    required this.size,
    required this.title,
    this.onPressed,
  });

  final Size size;
  final String title;
  final VoidCallback? onPressed;
  final searchController = Get.put(SearchWordController());
  final AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: pureWhite, borderRadius: BorderRadius.circular(30.0)),
            margin: EdgeInsets.only(right: 12, top: 12),
            height: size.height - 150,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                      color: primaryOrangeDark,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(30.0))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.robotoSlab(
                            fontSize: 24,
                            color: pureWhite,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 50.0,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 12.5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  color: pureWhite),
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.search,
                                      size: 30.0,
                                      color: primaryOrangeDark,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        child: Container(
                                            height: double.infinity,
                                            width: double.infinity,
                                            alignment: Alignment.center,
                                            child: TextField(
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: muteBlack),
                                              decoration:
                                                  InputDecoration.collapsed(
                                                      hintText: "Search"),
                                            ))),
                                  ]),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          SearchFilter(controller: searchController)
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Obx(
                    () => Container(
                        height: double.infinity,
                        width: double.infinity,
                        padding: EdgeInsets.only(bottom: 2),
                        child: Material(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(30.0)),
                          child: searchController.suggestionMap.length != 0
                              ? ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  padding: EdgeInsets.only(top: 10, bottom: 20),
                                  itemCount:
                                      searchController.suggestionMap.length,
                                  itemBuilder: (context, index) {
                                    String wordID = searchController
                                        .suggestionMap.keys
                                        .elementAt(index);
                                    List<String> type = [];
                                    for (var meaning in searchController
                                        .suggestionMap[wordID]['meanings']) {
                                      type.add(meaning["partOfSpeech"]);
                                    }
                                    return BrowseCard(
                                      onTap: onPressed ?? () {},
                                      wordId: wordID,
                                      word: searchController
                                          .suggestionMap[wordID]["word"],
                                      type: type,
                                      prnLink:
                                          searchController.suggestionMap[wordID]
                                              ["pronunciationAudio"],
                                      engTrans:
                                          searchController.suggestionMap[wordID]
                                                      ["englishTranslations"] ==
                                                  null
                                              ? []
                                              : searchController
                                                      .suggestionMap[wordID]
                                                  ["englishTranslations"],
                                      filTrans: searchController
                                                      .suggestionMap[wordID]
                                                  ["filipinoTranslations"] ==
                                              null
                                          ? []
                                          : searchController
                                                  .suggestionMap[wordID]
                                              ["filipinoTranslations"],
                                      otherRelated:
                                          searchController.suggestionMap[wordID]
                                                      ["otherRelated"] ==
                                                  null
                                              ? []
                                              : searchController
                                                  .suggestionMap[wordID]
                                                      ["otherRelated"]
                                                  .keys
                                                  .toList(),
                                      synonyms: searchController
                                                      .suggestionMap[wordID]
                                                  ["synonyms"] ==
                                              null
                                          ? []
                                          : searchController
                                              .suggestionMap[wordID]["synonyms"]
                                              .keys
                                              .toList(),
                                      antonyms: searchController
                                                      .suggestionMap[wordID]
                                                  ["antonyms"] ==
                                              null
                                          ? []
                                          : searchController
                                              .suggestionMap[wordID]["antonyms"]
                                              .keys
                                              .toList(),
                                      player: player,
                                      foundOn:
                                          searchController.foundOn[wordID] ??
                                              "engTrans",
                                    );
                                  },
                                )
                              : searchController.loading.value
                                  ? ListView.builder(
                                      padding:
                                          EdgeInsets.only(top: 30, bottom: 100),
                                      itemCount: 30,
                                      itemBuilder: (context, index) {
                                        return ShimmerBrowseCard();
                                      },
                                    )
                                  : Center(
                                      child: Text(
                                        "No results found.",
                                        style: TextStyle(
                                            fontSize: 16, color: disabledGrey),
                                      ),
                                    ),
                        )),
                  ),
                ),
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
                  child: Icon(Icons.close, color: primaryOrangeDark),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TagsField extends StatelessWidget {
  const TagsField({
    super.key,
    required this.controller,
    required this.label,
    required this.width,
  });

  final double width;
  final TextfieldTagsController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextFieldTags(
      textfieldTagsController: controller,
      textSeparators: [','],
      letterCase: LetterCase.small,
      validator: (String tag) {
        if (controller.getTags!.contains(tag)) {
          return 'Duplicate tag found.';
        }
        return null;
      },
      inputfieldBuilder: (context, tec, fn, error, onChanged, onSubmitted) {
        return ((context, sc, tags, onTagDelete) {
          return TextField(
            controller: tec,
            focusNode: fn,
            onChanged: onChanged,
            onSubmitted: onSubmitted,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              hintText: label,
              errorText: error,
              prefixIconConstraints: BoxConstraints(
                maxWidth: width * 0.6,
              ),
              prefixIcon: tags.isNotEmpty
                  ? Container(
                      clipBehavior: Clip.antiAlias,
                      margin: EdgeInsets.only(right: 10, left: 1),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(20),
                            left: Radius.circular(5)),
                      ),
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        controller: sc,
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: tags.map((String tag) {
                          return Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20.0),
                              ),
                              color: primaryOrangeDark,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 5.0),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  child: Text(
                                    '$tag',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
                                  ),
                                ),
                                const SizedBox(width: 4.0),
                                InkWell(
                                  child: const Icon(
                                    Icons.cancel,
                                    size: 18.0,
                                    color: Color.fromARGB(255, 233, 233, 233),
                                  ),
                                  onTap: () {
                                    onTagDelete(tag);
                                  },
                                )
                              ],
                            ),
                          );
                        }).toList()),
                      ),
                    )
                  : null,
            ),
          );
        });
      },
    );
  }
}

class StudioSection extends StatelessWidget {
  const StudioSection({
    super.key,
    required this.controller,
  });

  final ToolsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Obx(
              () => Container(
                decoration: BoxDecoration(
                  color: orangeCard,
                  borderRadius: BorderRadius.circular(25),
                  border: controller.audioSubmitError.value
                      ? Border.all(color: Colors.red.shade700)
                      : null,
                ),
                child: Stack(children: [
                  Obx(
                    () => controller.hasFile.value
                        ? new Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Obx(
                              () => new AudioFileWaveforms(
                                size: Size(
                                  MediaQuery.of(context).size.width,
                                  50.0,
                                ),
                                playerController: controller.playerController,
                                enableSeekGesture:
                                    controller.rebuildAudio.value ? true : true,
                                waveformType: WaveformType.long,
                                // ignore: invalid_use_of_protected_member
                                waveformData: [],
                                playerWaveStyle: PlayerWaveStyle(
                                  liveWaveColor: primaryOrangeLight,
                                  spacing: 6.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: orangeCard,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(25, 5, 5, 5),
                            height: double.infinity,
                            width: double.infinity,
                            child: Text(
                              "No data",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: disabledGrey,
                              ),
                            ),
                          ),
                  ),
                  Obx(
                    () => GestureDetector(
                      onTap: () =>
                          controller.playAndStop(controller.playerController),
                      child: Container(
                        height: double.infinity,
                        width: 40,
                        margin: EdgeInsets.all(5.0),
                        child: Icon(
                          controller.isPlaying.value
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: pureWhite,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: controller.hasFile.value
                                ? primaryOrangeDark
                                : disabledGrey),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
          SizedBox(
            width: 5.0,
          ),
          Expanded(
            flex: 5,
            child: GestureDetector(
              onTap: () {
                Get.to(() => RecordingStudioPage());
                controller.playerController.stopPlayer();
              },
              child: Container(
                height: double.infinity,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    tEnterStudio.toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: pureWhite,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: primaryOrangeDark,
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StudioFormField extends FormField {
  StudioFormField(
      {required ToolsController controller,
      required FormFieldSetter onSaved,
      required FormFieldValidator validator,
      AutovalidateMode mode = AutovalidateMode.onUserInteraction})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: controller.audioPath,
            autovalidateMode: mode,
            builder: (FormFieldState state) {
              return Column(
                children: [
                  Container(
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Container(
                            decoration: BoxDecoration(
                              color: orangeCard,
                              borderRadius: BorderRadius.circular(25),
                              border: state.hasError
                                  ? Border.all(color: Colors.red.shade700)
                                  : null,
                            ),
                            child: Stack(children: [
                              Obx(
                                () => controller.hasFile.value
                                    ? new Container(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Obx(
                                          () => new AudioFileWaveforms(
                                            size: Size(
                                              double.infinity,
                                              50.0,
                                            ),
                                            playerController:
                                                controller.playerController,
                                            enableSeekGesture:
                                                controller.rebuildAudio.value
                                                    ? true
                                                    : true,
                                            waveformType: WaveformType.long,
                                            // ignore: invalid_use_of_protected_member
                                            waveformData: [],
                                            playerWaveStyle: PlayerWaveStyle(
                                              liveWaveColor: primaryOrangeLight,
                                              spacing: 6.0,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              color: orangeCard,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        alignment: Alignment.center,
                                        padding:
                                            EdgeInsets.fromLTRB(25, 5, 5, 5),
                                        height: double.infinity,
                                        width: double.infinity,
                                        child: Text(
                                          "No data",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: disabledGrey,
                                          ),
                                        ),
                                      ),
                              ),
                              Obx(
                                () => GestureDetector(
                                  onTap: () => controller
                                      .playAndStop(controller.playerController),
                                  child: Container(
                                    height: double.infinity,
                                    width: 40,
                                    margin: EdgeInsets.all(5.0),
                                    child: Icon(
                                      controller.isPlaying.value
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: pureWhite,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: controller.hasFile.value
                                            ? primaryOrangeDark
                                            : disabledGrey),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => RecordingStudioPage());
                              controller.playerController.stopPlayer();
                              state.reset();
                            },
                            child: Container(
                              height: double.infinity,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  tEnterStudio.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: pureWhite,
                                  ),
                                ),
                              ),
                              decoration: BoxDecoration(
                                color: primaryOrangeDark,
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  state.hasError
                      ? Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          width: double.infinity,
                          child: Text(
                            state.errorText!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Colors.red[700], fontSize: 12),
                          ))
                      : Container()
                ],
              );
            });
}

class KulitanFormField extends FormField {
  KulitanFormField(
      {required ToolsController controller,
      required FormFieldSetter onSaved,
      required FormFieldValidator validator,
      AutovalidateMode mode = AutovalidateMode.onUserInteraction})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: controller.audioPath,
            autovalidateMode: mode,
            builder: (FormFieldState state) {
              return Column(
                children: [
                  Obx(
                    () => Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(30),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          border: state.hasError
                              ? Border.all(color: Colors.red.shade700)
                              : null,
                          color: orangeCard),
                      child: controller.kulitanListEmpty.value
                          ? Container(
                              child: Text(
                                "No data",
                                style: TextStyle(
                                    fontSize: 15, color: disabledGrey),
                              ),
                            )
                          : KulitanPreview(
                              kulitanCharList:
                                  controller.kulitanStringListGetter,
                            ),
                    ),
                  ),
                  state.hasError
                      ? Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          width: double.infinity,
                          child: Text(
                            state.errorText!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Colors.red[700], fontSize: 12),
                          ))
                      : Container(),
                  SizedBox(
                    height: 15.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => KulitanEditorPage());
                      state.reset();
                    },
                    child: Container(
                      height: 50.0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          tEnterKulitanEditor.toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: pureWhite,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: primaryOrangeDark,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ],
              );
            });
}

class WordInfoSection extends StatelessWidget {
  const WordInfoSection({
    super.key,
    required this.controller,
  });

  final ToolsController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      key: controller.typeListKey,
      initialItemCount: controller.typeFields.length,
      itemBuilder: (context, i, animI) {
        return Dismissible(
          key: Key("${i}"),
          child: SizeTransition(
            sizeFactor: animI,
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 120.0,
                          child: DropdownButtonFormField(
                            validator: (value) {
                              if (value != null) {
                                return controller.validateType(value);
                              } else {
                                return "Please select a type";
                              }
                            },
                            items: controller.typeDropItems,
                            onChanged: (String? newValue) {
                              // ignore: invalid_use_of_protected_member
                              if (newValue != "custom") {
                                controller.customTypeController[i].clear();
                              }
                              // ignore: invalid_use_of_protected_member
                              controller.typeFields.value[i] = newValue!;
                              controller.typeFields.refresh();
                            },
                            // ignore: invalid_use_of_protected_member
                            value: controller.typeFields.value[i] == ''
                                ? null
                                // ignore: invalid_use_of_protected_member
                                : controller.typeFields.value[i],
                            decoration: InputDecoration(
                                labelText: tWordType + " *",
                                hintText: tWordType + " *",
                                hintMaxLines: 5,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0))),
                          ),
                        ),
                        // ignore: invalid_use_of_protected_member
                        Obx(() => controller.typeFields.value[i] == "custom"
                            ? Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 5.0),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value != null) {
                                        return controller
                                            .validateCustomType(value);
                                      } else {
                                        return "Please enter custom type";
                                      }
                                    },
                                    controller:
                                        controller.customTypeController[i],
                                    maxLines: 1,
                                    decoration: InputDecoration(
                                        labelText: tCustomWordType + " *",
                                        hintText: tCustomWordType + " *",
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0))),
                                  ),
                                ),
                              )
                            : Container()),
                        SizedBox(
                          width: 5.0,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.addTypeField(i + 1);
                            controller.typeFields.refresh();
                            controller.definitionsFields.refresh();
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            child: Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.add,
                                  color: pureWhite,
                                )),
                            decoration: BoxDecoration(
                              color: primaryOrangeDark,
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 7.5,
                  ),
                  AnimatedList(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    key: controller.definitionListKey[i],
                    initialItemCount: controller.definitionsFields[i].length,
                    itemBuilder: (context, j, animJ) {
                      return Dismissible(
                        key: Key("${i} ${j}"),
                        child: SizeTransition(
                          sizeFactor: animJ,
                          child: Container(
                            child: Column(children: [
                              SizedBox(
                                height: 7.5,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 30),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value != null) {
                                            return controller
                                                .validateDefinition(value);
                                          } else {
                                            return "Please enter word";
                                          }
                                        },
                                        controller: controller
                                            .definitionsFields[i][j][0],
                                        minLines: 1,
                                        maxLines: 4,
                                        decoration: InputDecoration(
                                            labelText: tDefinition + " *",
                                            hintText: tDefinition + " *",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0))),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        controller.addDefinitionField(i, j + 1);
                                        controller.typeFields.refresh();
                                        controller.definitionsFields.refresh();
                                      },
                                      child: Container(
                                        height: 50,
                                        width: 50,
                                        child: Align(
                                            alignment: Alignment.center,
                                            child: Icon(
                                              Icons.add,
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
                                padding: EdgeInsets.only(left: 60),
                                child: TextFormField(
                                  controller: controller.definitionsFields[i][j]
                                      [1],
                                  minLines: 1,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                      labelText: tExample,
                                      hintText: tExample,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 60),
                                child: TextFormField(
                                  controller: controller.definitionsFields[i][j]
                                      [2],
                                  minLines: 1,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                      labelText: tExTrans,
                                      hintText: tExTrans,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 60),
                                child: TextFormField(
                                  controller: controller.definitionsFields[i][j]
                                      [3],
                                  minLines: 1,
                                  maxLines: 1,
                                  decoration: InputDecoration(
                                      labelText: tDialect,
                                      hintText: tDialect,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 60),
                                child: TextFormField(
                                  controller: controller.definitionsFields[i][j]
                                      [4],
                                  minLines: 1,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                      labelText: tOrigin,
                                      hintText: tOrigin,
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0))),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                            ]),
                          ),
                        ),
                        secondaryBackground: Container(
                          padding: EdgeInsets.all(30),
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.delete,
                            color: disabledGrey,
                            size: 50,
                          ),
                        ),
                        background: Container(
                          padding: EdgeInsets.all(30),
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.delete,
                            color: disabledGrey,
                            size: 50,
                          ),
                        ),
                        onDismissed: (direction) {
                          controller.removeDefinitionField(i, j);
                          controller.typeFields.refresh();
                          controller.definitionsFields.refresh();
                        },
                        direction: controller.definitionsFields[i].length > 1
                            ? DismissDirection.horizontal
                            : DismissDirection.none,
                      );
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
          background: Container(
            padding: EdgeInsets.all(30),
            alignment: Alignment.topLeft,
            child: Icon(
              Icons.delete,
              color: disabledGrey,
              size: 60,
            ),
          ),
          secondaryBackground: Container(
            padding: EdgeInsets.all(30),
            alignment: Alignment.topRight,
            child: Icon(
              Icons.delete,
              color: disabledGrey,
              size: 60,
            ),
          ),
          onDismissed: (direction) {
            controller.removeTypeField(i);
            controller.typeFields.refresh();
            controller.definitionsFields.refresh();
          },
          direction: controller.typeFields.length > 1
              ? DismissDirection.horizontal
              : DismissDirection.none,
        );
      },
    );
  }
}
