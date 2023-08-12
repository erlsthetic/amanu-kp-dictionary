import 'package:amanu/components/browse_card.dart';
import 'package:amanu/components/shimmer_browse_card.dart';
import 'package:amanu/screens/search_screen/controllers/search_controller.dart';
import 'package:amanu/screens/user_tools/controllers/tools_controller.dart';
import 'package:amanu/screens/user_tools/modify_word_page.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/application_controller.dart';

class SearchResultList extends StatelessWidget {
  SearchResultList({
    super.key,
    required this.size,
    required this.controller,
    required this.player,
    required this.height,
    required this.width,
    this.borderRadius,
    this.padding,
    this.onTap,
    this.contentPadding,
    required this.category,
  });

  final Size size;
  final SearchWordController controller;
  final AudioPlayer player;
  final double height;
  final double width;
  final EdgeInsets? padding;
  final EdgeInsets? contentPadding;
  final BorderRadiusGeometry? borderRadius;
  final VoidCallback? onTap;
  final String category;
  final appController = Get.find<ApplicationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
          height: height,
          width: width,
          padding: padding ?? EdgeInsets.zero,
          child: Material(
            type: MaterialType.transparency,
            borderRadius: borderRadius ?? BorderRadius.zero,
            child: controller.suggestionMap.length != 0
                ? ListView.builder(
                    physics: BouncingScrollPhysics(),
                    padding:
                        contentPadding ?? EdgeInsets.only(top: 30, bottom: 100),
                    itemCount: controller.suggestionMap.length,
                    itemBuilder: (context, index) {
                      String wordID =
                          controller.suggestionMap.keys.elementAt(index);
                      List<String> type = [];
                      for (var meaning in controller.suggestionMap[wordID]
                          ['meanings']) {
                        type.add(meaning["partOfSpeech"]);
                      }
                      return BrowseCard(
                        onTap: () {
                          if (category == "edit") {
                            Get.to(() => ModifyWordPage(
                                  editMode: true,
                                  editWordID: wordID,
                                  editWord: controller.suggestionMap[wordID]
                                      ["word"],
                                ));
                          } else if (category == "delete") {
                            showDeleteDialog(context, wordID);
                          } else if (category == "related") {
                            final modifyController =
                                Get.find<ModifyController>();
                            modifyController.addAsImported(
                                modifyController.importedRelated,
                                modifyController.relatedController,
                                controller.suggestionMap[wordID]["word"],
                                wordID);
                            Navigator.of(context).pop();
                          } else if (category == "synonyms") {
                            final modifyController =
                                Get.find<ModifyController>();
                            modifyController.addAsImported(
                                modifyController.importedSynonyms,
                                modifyController.synonymController,
                                controller.suggestionMap[wordID]["word"],
                                wordID);
                            Navigator.of(context).pop();
                          } else if (category == "antonyms") {
                            final modifyController =
                                Get.find<ModifyController>();
                            modifyController.addAsImported(
                                modifyController.importedRelated,
                                modifyController.relatedController,
                                controller.suggestionMap[wordID]["word"],
                                wordID);
                            Navigator.of(context).pop();
                          }
                        },
                        wordId: wordID,
                        word: controller.suggestionMap[wordID]["word"],
                        type: type,
                        prnLink: controller.suggestionMap[wordID]
                            ["pronunciationAudio"],
                        engTrans: controller.suggestionMap[wordID]
                                    ["englishTranslations"] ==
                                null
                            ? []
                            : controller.suggestionMap[wordID]
                                ["englishTranslations"],
                        filTrans: controller.suggestionMap[wordID]
                                    ["filipinoTranslations"] ==
                                null
                            ? []
                            : controller.suggestionMap[wordID]
                                ["filipinoTranslations"],
                        otherRelated: controller.suggestionMap[wordID]
                                    ["otherRelated"] ==
                                null
                            ? []
                            : controller
                                .suggestionMap[wordID]["otherRelated"].keys
                                .toList(),
                        synonyms:
                            controller.suggestionMap[wordID]["synonyms"] == null
                                ? []
                                : controller
                                    .suggestionMap[wordID]["synonyms"].keys
                                    .toList(),
                        antonyms:
                            controller.suggestionMap[wordID]["antonyms"] == null
                                ? []
                                : controller
                                    .suggestionMap[wordID]["antonyms"].keys
                                    .toList(),
                        player: player,
                        foundOn: controller.foundOn[wordID] ?? "engTrans",
                      );
                    },
                  )
                : controller.loading.value
                    ? ListView.builder(
                        padding: EdgeInsets.only(top: 30, bottom: 100),
                        itemCount: 30,
                        itemBuilder: (context, index) {
                          return ShimmerBrowseCard();
                        },
                      )
                    : Center(
                        child: Text(
                          "No results found.",
                          style: TextStyle(fontSize: 16, color: disabledGrey),
                        ),
                      ),
          )),
    );
  }

  Future<dynamic> showDeleteDialog(BuildContext context, String wordID) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
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
                        height: 70,
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                            color: primaryOrangeDark,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30.0))),
                        child: Text(
                          tDeleteYes,
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
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                  appController.userIsExpert!
                                      ? (tDeletePrompt1 +
                                          controller.suggestionMap[wordID]
                                              ["word"] +
                                          tDeletePrompt2)
                                      : (tDeleteRequestPrompt1 +
                                          controller.suggestionMap[wordID]
                                              ["word"] +
                                          tDeleteRequestPrompt2),
                                  textAlign: TextAlign.center,
                                  style:
                                      TextStyle(color: cardText, fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Material(
                                      borderRadius: BorderRadius.circular(25),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(25),
                                        onTap: () {},
                                        splashColor: primaryOrangeLight,
                                        highlightColor:
                                            primaryOrangeLight.withOpacity(0.5),
                                        child: Ink(
                                          height: 50.0,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              tDeleteYes.toUpperCase(),
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
                                            borderRadius:
                                                BorderRadius.circular(25),
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
                                      borderRadius: BorderRadius.circular(25),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(25),
                                        onTap: () {},
                                        splashColor: primaryOrangeDarkShine,
                                        highlightColor: primaryOrangeDarkShine
                                            .withOpacity(0.5),
                                        child: Ink(
                                          height: 50.0,
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              tCancel.toUpperCase(),
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                color: pureWhite,
                                              ),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            color: primaryOrangeLight,
                                            borderRadius:
                                                BorderRadius.circular(25),
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
                        child: Icon(Icons.close, color: primaryOrangeDark),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}
