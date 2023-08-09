import 'package:amanu/components/browse_card.dart';
import 'package:amanu/components/shimmer_browse_card.dart';
import 'package:amanu/screens/search_screen/controllers/search_controller.dart';
import 'package:amanu/screens/user_tools/controllers/tools_controller.dart';
import 'package:amanu/screens/user_tools/modify_word_page.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchResultList extends StatelessWidget {
  const SearchResultList({
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
                                ));
                          } else if (category == "delete") {
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
}
