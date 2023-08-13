import 'package:amanu/components/dictionary_card.dart';
import 'package:amanu/screens/details_screen/controllers/detail_controller.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class DetailScreen extends StatelessWidget {
  DetailScreen({
    super.key,
    required this.wordID,
  });

  final wordID;

  late final controller =
      Get.put(DetailController(wordID: wordID), tag: "_" + wordID);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Scaffold(
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
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 40, horizontal: 30),
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
                              lastModifiedTime: controller.lastModifiedTime,
                              width: double.infinity),
                        )),
                  )),
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
          ],
        ));
  }
}
