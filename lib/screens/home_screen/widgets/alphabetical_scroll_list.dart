import 'package:amanu/components/browse_card.dart';
import 'package:amanu/screens/details_screen/detail_screen.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class _AZItem extends ISuspensionBean {
  final String word;
  final String wordID;
  final String tag;

  _AZItem({required this.word, required this.wordID, required this.tag});

  @override
  String getSuspensionTag() => tag;
}

class AlphabeticalListView extends StatefulWidget {
  AlphabeticalListView({super.key});

  @override
  State<AlphabeticalListView> createState() => _AlphabeticalListViewState();
}

class _AlphabeticalListViewState extends State<AlphabeticalListView> {
  List<_AZItem> items = [];

  @override
  void initState() {
    super.initState();
    convertList(appController.dictionaryContent);
  }

  void convertList(Map<dynamic, dynamic> dictionaryContent) {
    this.items = dictionaryContent.entries
        .map((entry) => _AZItem(
            word: appController.dictionaryContent[entry.key]["word"]
                .replaceAll("<i>", "")
                .replaceAll("</i>", "")
                .replaceAll("<b>", "")
                .replaceAll("</b>", "")
                .replaceAll("<u>", "")
                .replaceAll("</u>", ""),
            wordID: entry.key,
            tag: appController.dictionaryContent[entry.key]["word"]
                .replaceAll("<i>", "")
                .replaceAll("</i>", "")
                .replaceAll("<b>", "")
                .replaceAll("</b>", "")
                .replaceAll("<u>", "")
                .replaceAll("</u>", "")
        .replaceAll(RegExp(r'[àáâäæãåā]'), 'a')
        .replaceAll(RegExp(r'[îïíīįì]'), 'i')
        .replaceAll(RegExp(r'[ûüùúū]'), 'u')
        .replaceAll(RegExp(r'[èéêëēėę]'), 'e')
        .replaceAll(RegExp(r'[ôöòóœøōõ]'), 'o')[0]
                .toUpperCase()))
        .toList();
    SuspensionUtil.sortListBySuspensionTag(this.items);
    SuspensionUtil.setShowSuspensionStatus(this.items);
  }

  final AudioPlayer player = AudioPlayer();
  final appController = Get.find<ApplicationController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return AzListView(
      data: items,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildListItem(item, player);
      },
      padding: EdgeInsets.only(top: 30, bottom: size.width * 0.2),
      physics: BouncingScrollPhysics(),
      indexBarItemHeight: (size.height - 70 - 20 - (size.width * 0.2)) / 27,
      indexBarMargin: EdgeInsets.only(right: 5, top: 10),
      indexHintBuilder: (context, hint) {
        return Container(
          height: 60,
          width: 85,
          alignment: Alignment.center,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  height: 60,
                  width: 85,
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: SvgPicture.asset(iScrollHint),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  height: 60,
                  width: 60,
                  alignment: Alignment.center,
                  child: Text(hint,
                      style: GoogleFonts.robotoSlab(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: pureWhite,
                      )),
                ),
              ),
            ],
          ),
        );
      },
      indexBarOptions: IndexBarOptions(
          indexHintOffset: Offset(8, 5),
          textStyle: TextStyle(color: lightGrey, fontSize: 11.5),
          needRebuild: true,
          indexHintAlignment: Alignment.centerRight,
          selectTextStyle:
              TextStyle(color: pureWhite, fontWeight: FontWeight.bold),
          selectItemDecoration:
              BoxDecoration(shape: BoxShape.circle, color: primaryOrangeDark)),
    );
  }

  Widget _buildListItem(_AZItem item, AudioPlayer player) {
    final tag = item.getSuspensionTag();
    final offstage = !item.isShowSuspension;
    String wordID = item.wordID;
    List<String> type = [];
    for (var meaning in appController.dictionaryContent[wordID]['meanings']) {
      type.add(meaning["partOfSpeech"]);
    }
    return Column(
      children: [
        Offstage(offstage: offstage, child: buildHeader(tag)),
        Padding(
          padding: EdgeInsets.only(right: 15),
          child: BrowseCard(
            onTap: () => Get.to(
                () => DetailScreen(
                      wordID: wordID,
                    ),
                duration: Duration(milliseconds: 500),
                transition: Transition.rightToLeft,
                curve: Curves.easeInOut),
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
            otherRelated:
                appController.dictionaryContent[wordID]["otherRelated"] == null
                    ? []
                    : appController
                        .dictionaryContent[wordID]["otherRelated"].keys
                        .toList(),
            synonyms:
                appController.dictionaryContent[wordID]["synonyms"] == null
                    ? []
                    : appController.dictionaryContent[wordID]["synonyms"].keys
                        .toList(),
            antonyms:
                appController.dictionaryContent[wordID]["antonyms"] == null
                    ? []
                    : appController.dictionaryContent[wordID]["antonyms"].keys
                        .toList(),
            player: player,
          ),
        ),
      ],
    );
  }

  Widget buildHeader(String tag) {
    return Container(
      height: 65,
      padding: EdgeInsets.fromLTRB(35, 5, 15, 5),
      alignment: Alignment.centerLeft,
      child: Text(tag,
          style: GoogleFonts.robotoSlab(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            color: disabledGrey,
          )),
    );
  }
}
