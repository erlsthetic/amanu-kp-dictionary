import 'package:amanu/components/browse_card.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:amanu/screens/bookmarks_screen/controllers/bookmarks_controller.dart';
import 'package:amanu/screens/details_screen/detail_screen.dart';
import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookmarksScreen extends StatelessWidget {
  BookmarksScreen({
    super.key,
  });

  final controller = Get.put(BookmarksController());
  final drawerController = Get.find<DrawerXController>();
  final appController = Get.find<ApplicationController>();
  final AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.only(bottom: screenPadding.bottom),
      child: Scaffold(
          body: Stack(
        children: [
          Positioned(
            top: screenPadding.top + 50,
            left: 0,
            right: 0,
            child: Obx(
              () => Container(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  height: size.height - screenPadding.top - 50,
                  width: size.width,
                  child: appController.bookmarks.length != 0
                      ? ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(top: 30, bottom: 50),
                          itemCount: appController.bookmarks.length,
                          itemBuilder: (context, index) {
                            String wordID = appController.bookmarks[index];
                            List<String> type = [];
                            for (var meaning in appController
                                .dictionaryContent[wordID]['meanings']) {
                              type.add(meaning["partOfSpeech"]);
                            }
                            return Dismissible(
                              key: Key(wordID),
                              background: Container(
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.all(30),
                                child: Icon(
                                  Icons.bookmark_remove_rounded,
                                  color: disabledGrey.withOpacity(0.75),
                                  size: 40,
                                ),
                              ),
                              secondaryBackground: Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.all(30),
                                child: Icon(
                                  Icons.bookmark_remove_rounded,
                                  color: disabledGrey.withOpacity(0.75),
                                  size: 40,
                                ),
                              ),
                              onDismissed: (_) {
                                controller.removeBookmark(wordID);
                              },
                              child: Material(
                                type: MaterialType.transparency,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 3),
                                  child: BrowseCard(
                                    onTap: () => Get.to(
                                        () => DetailScreen(
                                              wordID: wordID,
                                            ),
                                        duration: Duration(milliseconds: 500),
                                        transition: Transition.rightToLeft,
                                        curve: Curves.easeInOut),
                                    wordId: wordID,
                                    word: appController
                                        .dictionaryContent[wordID]["word"],
                                    type: type,
                                    prnLink:
                                        appController.dictionaryContent[wordID]
                                            ["pronunciationAudio"],
                                    engTrans:
                                        appController.dictionaryContent[wordID]
                                                    ["englishTranslations"] ==
                                                null
                                            ? []
                                            : appController
                                                    .dictionaryContent[wordID]
                                                ["englishTranslations"],
                                    filTrans:
                                        appController.dictionaryContent[wordID]
                                                    ["filipinoTranslations"] ==
                                                null
                                            ? []
                                            : appController
                                                    .dictionaryContent[wordID]
                                                ["filipinoTranslations"],
                                    otherRelated:
                                        appController.dictionaryContent[wordID]
                                                    ["otherRelated"] ==
                                                null
                                            ? []
                                            : appController
                                                .dictionaryContent[wordID]
                                                    ["otherRelated"]
                                                .keys
                                                .toList(),
                                    synonyms:
                                        appController.dictionaryContent[wordID]
                                                    ["synonyms"] ==
                                                null
                                            ? []
                                            : appController
                                                .dictionaryContent[wordID]
                                                    ["synonyms"]
                                                .keys
                                                .toList(),
                                    antonyms:
                                        appController.dictionaryContent[wordID]
                                                    ["antonyms"] ==
                                                null
                                            ? []
                                            : appController
                                                .dictionaryContent[wordID]
                                                    ["antonyms"]
                                                .keys
                                                .toList(),
                                    player: player,
                                  ),
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text(
                            "No bookmarks yet.",
                            style: TextStyle(fontSize: 16, color: disabledGrey),
                          ),
                        )),
            ),
          ),
          ThreePartHeader(
            size: size,
            screenPadding: screenPadding,
            title: tBookmarks,
            firstIcon: Icons.menu_rounded,
            firstOnPressed: () {
              drawerController.drawerToggle(context);
              drawerController.currentItem.value = DrawerItems.bookmarks;
            },
          ),
        ],
      )),
    );
  }
}
