import 'package:amanu/components/browse_card.dart';
import 'package:amanu/components/shimmer_browse_card.dart';
import 'package:amanu/screens/details_screen/detail_screen.dart';
import 'package:amanu/screens/search_screen/controllers/search_controller.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({
    super.key,
  });

  final AudioPlayer player = AudioPlayer();
  final appController = Get.find<ApplicationController>();
  final controller = Get.put(SearchWordController());

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
          child: Obx(
            () => Container(
                height: size.height - 110,
                width: size.width,
                child: controller.suggestionMap.length != 0
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: 30, bottom: 100),
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
                            onTap: () => Get.to(() => DetailScreen(
                                  wordID: wordID,
                                )),
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
                            synonyms: controller.suggestionMap[wordID]
                                        ["synonyms"] ==
                                    null
                                ? []
                                : controller
                                    .suggestionMap[wordID]["synonyms"].keys
                                    .toList(),
                            antonyms: controller.suggestionMap[wordID]
                                        ["antonyms"] ==
                                    null
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
                              style:
                                  TextStyle(fontSize: 16, color: disabledGrey),
                            ),
                          )),
          ),
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
                          onTap: Feedback.wrapForTap(() {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    backgroundColor: Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0)),
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: pureWhite,
                                              borderRadius:
                                                  BorderRadius.circular(30.0)),
                                          margin: EdgeInsets.only(
                                              right: 12, top: 12),
                                          height: size.height * 0.5,
                                          width: double.infinity,
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                width: double.infinity,
                                                height: 70,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 15),
                                                decoration: BoxDecoration(
                                                    color: primaryOrangeDark,
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    30.0))),
                                                child: Text(
                                                  "Search options",
                                                  style: GoogleFonts.robotoSlab(
                                                      fontSize: 24,
                                                      color: pureWhite,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(20.0),
                                                      child:
                                                          Column(children: []),
                                                    )),
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
                          }, context),
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
                        onChanged: (value) => controller.searchWord(value),
                      )))
            ]),
          ),
        ),
      ],
    ));
  }
}
