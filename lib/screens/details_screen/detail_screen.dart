import 'package:amanu/components/delete_dialog.dart';
import 'package:amanu/components/dictionary_card.dart';
import 'package:amanu/components/floating_button.dart';
import 'package:amanu/screens/details_screen/controllers/detail_controller.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:amanu/screens/user_tools/modify_word_page.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({
    super.key,
    required this.wordID,
  });

  final wordID;
  final appController = Get.find<ApplicationController>();
  late final controller =
      Get.put(DetailController(wordID: wordID), tag: "_" + wordID);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.only(bottom: screenPadding.bottom),
      child: Scaffold(
          key: _scaffoldKey,
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
                  child: controller.inDictionary.value
                      ? SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 40, horizontal: 30),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: orangeCard,
                                ),
                                child: DictionaryCard(
                                    word: controller.word,
                                    prn: controller.prn,
                                    prnUrl: controller.prnUrl,
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
                                    lastModifiedTime:
                                        controller.lastModifiedTime,
                                    width: double.infinity),
                              )),
                        )
                      : Center(
                          child: Text(
                            "Entry not found.",
                            style: TextStyle(fontSize: 16, color: disabledGrey),
                          ),
                        ),
                ),
              ),
              Obx(
                () => ThreePartHeader(
                  size: size,
                  screenPadding: screenPadding,
                  title: controller.word,
                  secondIcon: controller.onBookmarks.value
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_outline_rounded,
                  secondOnPressed: () {
                    controller.bookmarkToggle();
                    controller.showInfoDialog(_scaffoldKey.currentContext!);
                  },
                ),
              ),
              appController.isLoggedIn && controller.inDictionary.value
                  ? CustomFloatingPanel(
                      onPressed: (index) {
                        print("Clicked $index");
                        if (index == 0) {
                          if (appController.hasConnection.value) {
                            Get.to(
                                () => ModifyWordPage(
                                      editMode: true,
                                      editWordID: wordID,
                                      editWord: appController
                                          .dictionaryContent[wordID]["word"],
                                    ),
                                duration: Duration(milliseconds: 500),
                                transition: Transition.rightToLeft,
                                curve: Curves.easeInOut);
                          } else {
                            appController.showConnectionSnackbar();
                          }
                        } else if (index == 1) {
                          if (appController.hasConnection.value) {
                            showDeleteDialog(context, wordID, null, false);
                          } else {
                            appController.showConnectionSnackbar();
                          }
                        }
                      },
                      positionBottom: size.height * 0.05,
                      positionLeft: size.width - 85,
                      size: 70,
                      iconSize: 30,
                      panelIcon: iToolBox,
                      dockType: DockType.inside,
                      dockOffset: 15,
                      backgroundColor: pureWhite,
                      contentColor: pureWhite,
                      panelShape: PanelShape.rounded,
                      borderRadius: BorderRadius.circular(40),
                      borderColor: primaryOrangeDark,
                      buttons: [
                        iToolsEdit,
                        iToolsDelete,
                      ],
                      iconBGColors: [
                        primaryOrangeLight,
                        darkerOrange.withOpacity(0.8)
                      ],
                      iconBGSize: 60,
                      mainIconColor: primaryOrangeDark,
                      shadowColor: primaryOrangeDark,
                    )
                  : Container()
            ],
          )),
    );
  }
}
