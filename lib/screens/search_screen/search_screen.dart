import 'package:amanu/components/browse_card.dart';
import 'package:amanu/components/search_field.dart';
import 'package:amanu/components/search_filter.dart';
import 'package:amanu/components/shimmer_browse_card.dart';
import 'package:amanu/screens/details_screen/detail_screen.dart';
import 'package:amanu/screens/search_screen/controllers/search_controller.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchScreen extends StatelessWidget {
  SearchScreen({super.key, this.fromKulitanScanner = false, this.input = ''});

  final bool fromKulitanScanner;
  final String input;

  final AudioPlayer player = AudioPlayer();
  final appController = Get.find<ApplicationController>();
  late final controller = Get.put(SearchWordController(
      fromKulitan: fromKulitanScanner, kulitanQuery: input));

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
                  height: size.height - 110,
                  width: size.width,
                  child: controller.suggestionMap.length != 0
                      ? ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(top: 30, bottom: 50),
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
                              onTap: () => Get.to(
                                  () => DetailScreen(
                                        wordID: wordID,
                                      ),
                                  duration: Duration(milliseconds: 500),
                                  transition: Transition.rightToLeft,
                                  curve: Curves.easeInOut),
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
                                      .suggestionMap[wordID]["otherRelated"]
                                      .keys
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
                              padding: EdgeInsets.only(top: 30, bottom: 50),
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
                        child: SearchFilter(controller: controller),
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
                Icon(
                  Icons.search,
                  size: 30.0,
                  color: primaryOrangeDark,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(child: SearchField(controller: controller))
              ]),
            ),
          ),
        ],
      )),
    );
  }
}
