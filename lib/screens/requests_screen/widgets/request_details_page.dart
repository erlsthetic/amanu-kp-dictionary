import 'package:amanu/components/dictionary_card.dart';
import 'package:amanu/components/floating_button.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:amanu/screens/requests_screen/controllers/request_details_controller.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PreviewEditsPage extends StatelessWidget {
  final String? prevWordID;
  final String wordID;
  final String word;
  final String requestID;
  final String requesterID;
  final int requestType;
  final String requesterUserName;

  PreviewEditsPage(
      {super.key,
      required this.wordID,
      required this.word,
      required this.prevWordID,
      required this.requestID,
      required this.requestType,
      required this.requesterID,
      required this.requesterUserName});

  late final controller = Get.put(RequestDetailsController(
      prevWordID: prevWordID,
      wordID: wordID,
      word: word,
      requestID: requestID,
      requestType: requestType,
      requesterID: requesterID,
      requesterUserName: requesterUserName));

  final appController = Get.find<ApplicationController>();

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
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              height: size.height - screenPadding.top - 50,
              width: size.width,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 65, horizontal: 30),
                    child: Column(
                      children: [
                        Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(bottom: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: orangeCard),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    width: double.infinity,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      "Notes:",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    )),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    "Notes",
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                )
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text(
                            (requestType == 0 || requestType == 1)
                                ? "REQUEST:"
                                : "DETAILS:",
                            style: TextStyle(
                                fontSize: 15,
                                color: disabledGrey,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.only(bottom: 10),
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
                            lastModifiedTime: controller.lastModifiedTime,
                            width: size.width - 60,
                            isPreview: true,
                          ),
                        ),
                        requestType == 1
                            ? Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    alignment: Alignment.center,
                                    child: Text(
                                      "ORIGINAL:",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: disabledGrey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(bottom: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: orangeCard,
                                    ),
                                    child: DictionaryCard(
                                      word: controller.prevWord,
                                      prn: controller.prevPrn,
                                      prnUrl: controller.prevPrnUrl,
                                      engTrans: controller.prevEngTrans,
                                      filTrans: controller.prevFilTrans,
                                      meanings: controller.prevMeanings,
                                      types: controller.prevTypes,
                                      definitions: controller.prevDefinitions,
                                      kulitanChars: controller.prevKulitanChars,
                                      kulitanString:
                                          controller.prevKulitanString,
                                      otherRelated: controller.prevOtherRelated,
                                      synonyms: controller.prevSynonyms,
                                      antonyms: controller.prevAntonyms,
                                      sources: controller.prevSources,
                                      contributors: controller.prevContributors,
                                      expert: controller.prevExpert,
                                      lastModifiedTime:
                                          controller.prevLastModifiedTime,
                                      width: size.width - 60,
                                      isPreview: true,
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                      ],
                    )),
              )),
        ),
        IsProcessingWithHeader(
            condition: controller.isProcessing,
            size: size,
            screenPadding: screenPadding),
        ThreePartHeader(
          size: size,
          screenPadding: screenPadding,
          title: word,
          secondIcon: Icons.bookmark_outline_rounded,
          secondIconDisabled: true,
        ),
        CustomFloatingPanel(
          onPressed: (index) {
            print("Clicked $index");
            if (index == 0) {
            } else if (index == 1) {}
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
          iconBGColors: [primaryOrangeLight, darkerOrange.withOpacity(0.8)],
          iconBGSize: 60,
          mainIconColor: primaryOrangeDark,
          shadowColor: primaryOrangeDark,
        )
      ],
    ));
  }
}
