import 'package:amanu/components/browse_card.dart';
import 'package:amanu/components/shimmer_browse_card.dart';
import 'package:amanu/screens/details_screen/detail_screen.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({
    super.key,
  });

  final AudioPlayer player = AudioPlayer();
  final appController = Get.find<ApplicationController>();
  final controller = Get.put(SearchController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: screenPadding.top + 50,
          left: 0,
          right: 0,
          child: Container(
              height: size.height - 110,
              width: size.width,
              child: appController.dictionaryContent.length != 0
                  ? ListView.builder(
                      padding: EdgeInsets.only(top: 30, bottom: 100),
                      itemCount: appController.dictionaryContent.length,
                      itemBuilder: (context, index) {
                        String wordID = appController.dictionaryContent.keys
                            .elementAt(index);
                        List<String> type = [];
                        for (var meaning in appController
                            .dictionaryContent[wordID]['meanings']) {
                          type.add(meaning["partOfSpeech"]);
                        }
                        return BrowseCard(
                          onTap: () => Get.to(() => DetailScreen(
                                wordID: wordID,
                              )),
                          wordId: wordID,
                          word: appController.dictionaryContent[wordID]["word"],
                          type: type,
                          prnLink: appController.dictionaryContent[wordID]
                              ["pronunciationAudio"],
                          engTrans: appController.dictionaryContent[wordID]
                                      ["englishTranslations"] ==
                                  null
                              ? []
                              : appController.dictionaryContent[wordID]
                                  ["englishTranslations"],
                          filTrans: appController.dictionaryContent[wordID]
                                      ["filipinoTranslations"] ==
                                  null
                              ? []
                              : appController.dictionaryContent[wordID]
                                  ["filipinoTranslations"],
                          player: player,
                        );
                      },
                    )
                  : ListView.builder(
                      padding: EdgeInsets.only(top: 30, bottom: 100),
                      itemCount: 30,
                      itemBuilder: (context, index) {
                        return ShimmerBrowseCard();
                      },
                    )),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Hero(
            tag: "AppBar",
            child: Container(
              width: size.width,
              height: screenPadding.top + 70,
              decoration: BoxDecoration(
                  gradient: orangeGradient,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30.0))),
            ),
          ),
        ),
        Positioned(
            top: screenPadding.top,
            left: 0,
            child: Container(
              height: 70,
              width: size.width,
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Hero(
                      tag: 'firstButton',
                      child: Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: Feedback.wrapForTap(() {
                            Get.back();
                          }, context),
                          child: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            weight: 10,
                            color: pureWhite,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                    Hero(
                      tag: 'secondButton',
                      child: Container(
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: Feedback.wrapForTap(() {}, context),
                          child: Icon(
                            Icons.manage_search_rounded,
                            size: 30,
                            color: pureWhite,
                          ),
                        ),
                      ),
                    ),
                  ]),
            )),
        Positioned(
          top: screenPadding.top + 10,
          left: 0,
          child: Container(
            alignment: Alignment.centerLeft,
            height: 50.0,
            width: size.width - 110,
            margin: EdgeInsets.symmetric(horizontal: 55.0),
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: pureWhite),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Hero(
                tag: "SearchIcon",
                child: Icon(
                  Icons.search,
                  size: 30.0,
                  color: primaryOrangeDark,
                ),
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
                        style: TextStyle(fontSize: 18, color: muteBlack),
                        decoration:
                            InputDecoration.collapsed(hintText: "Search"),
                      )))
            ]),
          ),
        ),
      ],
    ));
  }
}
