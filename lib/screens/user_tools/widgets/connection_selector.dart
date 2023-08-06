import 'package:amanu/components/browse_card.dart';
import 'package:amanu/components/search_filter.dart';
import 'package:amanu/components/shimmer_browse_card.dart';
import 'package:amanu/screens/search_screen/controllers/search_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
