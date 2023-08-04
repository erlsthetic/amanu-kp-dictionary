import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/components/browse_card.dart';
import 'package:amanu/components/search_button.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BrowseScreenPage extends StatelessWidget {
  BrowseScreenPage({
    super.key,
    required this.size,
    required this.topPadding,
  });

  final AudioPlayer player = AudioPlayer();

  final Size size;
  final double topPadding;

  final drawerController = Get.find<DrawerXController>();
  final appController = Get.find<ApplicationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: topPadding + 50,
          left: 0,
          right: 0,
          child: Container(
              height: size.height - 110,
              width: size.width,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 30, bottom: 100),
                itemCount: appController.dictionaryContent.length,
                itemBuilder: (context, index) {
                  String wordID =
                      appController.dictionaryContent.keys.elementAt(index);
                  List<String> type = [];
                  for (var meaning in appController.dictionaryContent[wordID]
                      ['meanings']) {
                    type.add(meaning["partOfSpeech"]);
                  }
                  return BrowseCard(
                    wordId: wordID,
                    word: appController.dictionaryContent[wordID]["word"],
                    type: type,
                    prnLink: appController.dictionaryContent[wordID]
                        ["pronunciationAudio"],
                    engTrans: appController
                                .dictionaryContent[wordID]
                                    ["englishTranslations"]
                                .length ==
                            0
                        ? []
                        : appController.dictionaryContent[wordID]
                            ["englishTranslations"],
                    filTrans: appController
                                .dictionaryContent[wordID]
                                    ["filipinoTranslations"]
                                .length ==
                            0
                        ? []
                        : appController.dictionaryContent[wordID]
                            ["filipinoTranslations"],
                    player: player,
                  );
                },
              )),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Crab(
            tag: "AppBar",
            child: Container(
              width: size.width,
              height: topPadding + 70,
              decoration: BoxDecoration(
                  gradient: orangeGradient,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30.0))),
            ),
          ),
        ),
        Positioned(
          top: topPadding,
          child: Crab(
            tag: "AmanuLogo",
            child: Container(
              height: 0,
              width: size.width,
              child: FittedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 130,
                      width: 130,
                      child: SvgPicture.asset(iAmanuWhiteLogoWithLabel),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      height: 150,
                      width: 75,
                      child: SvgPicture.asset(
                          iAmanuWhiteScriptVerticalWithSeparator),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: topPadding + 10,
          child: SearchButton(
            shrinkFactor: 1.0,
          ),
          left: 16,
          right: 16,
        ),
        Positioned(
            top: topPadding,
            left: 0,
            child: Container(
              height: 70,
              width: size.width,
              padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Crab(
                      tag: 'HamburgerMenu',
                      child: IconButton(
                        onPressed: () {
                          drawerController.drawerToggle(context);
                          drawerController.currentItem.value =
                              DrawerItems.browse;
                        },
                        icon: Icon(Icons.menu_rounded),
                        color: pureWhite,
                        iconSize: 30,
                      ),
                    ),
                    Crab(
                      tag: "Requests",
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          splashColor: primaryOrangeLight,
                          highlightColor: primaryOrangeLight.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                          child: Ink(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: primaryOrangeLight.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Icon(
                              Icons.person_rounded,
                              color: pureWhite,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            )),
      ],
    ));
  }
}
