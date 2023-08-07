import 'package:amanu/components/tag_creator.dart';
import 'package:amanu/screens/details_screen/detail_screen.dart';
import 'package:amanu/utils/auth/helper_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/kulitan_preview.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DictionaryCard extends StatelessWidget {
  DictionaryCard({
    super.key,
    required this.word,
    required this.prn,
    required this.prnUrl,
    required this.engTrans,
    required this.filTrans,
    required this.meanings,
    required this.types,
    required this.definitions,
    required this.kulitanChars,
    required this.kulitanString,
    required this.otherRelated,
    required this.synonyms,
    required this.antonyms,
    required this.sources,
    required this.contributors,
    required this.expert,
    required this.lastModifiedTime,
    this.isPreview = false,
    required this.width,
    this.audioIsOnline = true,
  });

  final double width;
  final bool isPreview;
  final String word;
  final String prn;
  final String prnUrl;
  final List<dynamic> engTrans;
  final List<dynamic> filTrans;
  final List<Map<String, dynamic>> meanings;
  final List<String> types;
  final List<List<Map<String, dynamic>>> definitions;
  final List<dynamic> kulitanChars;
  final String kulitanString;
  final Map<dynamic, dynamic> otherRelated;
  final Map<dynamic, dynamic> synonyms;
  final Map<dynamic, dynamic> antonyms;
  final String sources;
  final Map<dynamic, dynamic> contributors;
  final Map<dynamic, dynamic> expert;
  final String lastModifiedTime;
  final bool audioIsOnline;

  final AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                        constraints: BoxConstraints(maxWidth: width * 0.7),
                        child: Text(
                          word,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.robotoSlab(
                              fontSize: 30,
                              color: primaryOrangeDark,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                        margin: EdgeInsets.only(left: 10),
                        child: Text(
                          "(" + types.join(', ') + ")",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              fontSize: 15,
                              color: primaryOrangeDark,
                              fontWeight: FontWeight.w300),
                        )),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primaryOrangeDark.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    splashColor: primaryOrangeLight,
                    highlightColor: primaryOrangeLight.withOpacity(0.5),
                    onTap: () async {
                      if (audioIsOnline) {
                        try {
                          await player.stop();
                          await player.play(UrlSource(prnUrl));
                        } catch (e) {
                          Helper.errorSnackBar(
                              title: "Error", message: "Cannot play audio.");
                        }
                      } else {
                        try {
                          await player.stop();
                          await player.play(DeviceFileSource(prnUrl));
                        } catch (e) {
                          Helper.errorSnackBar(
                              title: "Error", message: "Cannot play audio.");
                        }
                      }
                    },
                    child: Ink(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: pureWhite,
                        ),
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Container(
                            height: 18,
                            width: 18,
                            child: SvgPicture.asset(
                              iListenIcon,
                              colorFilter: ColorFilter.mode(
                                  primaryOrangeDark, BlendMode.srcIn),
                            ),
                          ),
                        )),
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10.0),
            width: double.infinity,
            child: Text(
              "/" + prn + "/",
              style: TextStyle(fontSize: 14, color: cardText),
            ),
          ),
          engTrans.length != 0
              ? Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 2),
                        width: 30.0,
                        child: Text(
                          "Eng:",
                          style:
                              TextStyle(color: primaryOrangeDark, fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Wrap(children: [
                            for (String trans in engTrans)
                              TagCreator(label: trans),
                          ]),
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
          filTrans.length != 0
              ? Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 2),
                        width: 30.0,
                        child: Text(
                          "Fil:",
                          style: TextStyle(color: darkerOrange, fontSize: 14),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: Wrap(children: [
                            for (String trans in filTrans)
                              TagCreator(label: trans)
                          ]),
                        ),
                      )
                    ],
                  ),
                )
              : Container(),
          SizedBox(
            height: 5.0,
          ),
          Divider(
            color: disabledGrey,
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              for (MapEntry type in types.asMap().entries)
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TagCreator(
                        label: type.value,
                        color: primaryOrangeDark,
                        textColor: pureWhite,
                        fontSize: 13,
                        height: 24,
                        padding: EdgeInsets.fromLTRB(6, 4, 6, 4),
                      ),
                      for (MapEntry definition
                          in definitions[type.key].asMap().entries)
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        (definition.key + 1).toString() +
                                            ".   ",
                                        style: TextStyle(
                                            fontSize: 15, color: cardText),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          child: Text.rich(
                                            TextSpan(
                                              text: definition
                                                      .value["definition"] +
                                                  (definition.value[
                                                                  "definition"][
                                                              definition
                                                                      .value[
                                                                          "definition"]
                                                                      .length -
                                                                  1] ==
                                                          "."
                                                      ? ""
                                                      : "."),
                                              children: [
                                                definition.value["dialect"] !=
                                                            null ||
                                                        definition.value[
                                                                "origin"] !=
                                                            null
                                                    ? TextSpan(text: " (from ")
                                                    : TextSpan(text: ""),
                                                definition.value["dialect"] !=
                                                        null
                                                    ? TextSpan(
                                                        text: definition
                                                            .value["dialect"],
                                                        style: TextStyle(
                                                            fontStyle: FontStyle
                                                                .italic))
                                                    : TextSpan(text: ""),
                                                definition.value["dialect"] !=
                                                            null &&
                                                        definition.value[
                                                                "origin"] !=
                                                            null
                                                    ? TextSpan(text: " ")
                                                    : TextSpan(text: ""),
                                                definition.value["origin"] !=
                                                        null
                                                    ? TextSpan(
                                                        text: '"' +
                                                            definition.value[
                                                                "origin"] +
                                                            '"')
                                                    : TextSpan(text: ""),
                                                definition.value["dialect"] !=
                                                            null ||
                                                        definition.value[
                                                                "origin"] !=
                                                            null
                                                    ? TextSpan(text: ")")
                                                    : TextSpan(text: ""),
                                              ],
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: cardText),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                definition.value["example"] != null
                                    ? Container(
                                        padding: EdgeInsets.only(
                                          left: 40,
                                        ),
                                        margin: EdgeInsets.only(top: 2.5),
                                        child: Text(
                                          '"' +
                                              definition.value["example"] +
                                              '"',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontStyle: FontStyle.italic,
                                              color: primaryOrangeDark),
                                        ),
                                      )
                                    : Container(),
                                definition.value["exampleTranslation"] != null
                                    ? Container(
                                        padding: EdgeInsets.only(
                                          left: 40,
                                        ),
                                        margin: EdgeInsets.only(top: 2.5),
                                        child: Text(
                                          '"' +
                                              definition
                                                  .value["exampleTranslation"] +
                                              '"',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontStyle: FontStyle.italic,
                                              color: darkerOrange),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(
                                  height: 10,
                                )
                              ]),
                        ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )
            ]),
          ),
          Divider(
            color: disabledGrey,
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            width: double.infinity,
            child: Text(
              tKulitanSec.toUpperCase(),
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                color: darkerOrange,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
            width: double.infinity,
            child: kulitanString == ''
                ? Container(
                    child: Text(
                      "No data",
                      style: TextStyle(fontSize: 15, color: cardText),
                    ),
                  )
                : KulitanPreview(kulitanCharList: kulitanChars),
          ),
          SizedBox(
            height: 5.0,
          ),
          otherRelated.length == 0 &&
                  synonyms.length == 0 &&
                  antonyms.length == 0
              ? Container()
              : Column(
                  children: [
                    Divider(
                      color: disabledGrey,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        tConnectionSec.toUpperCase(),
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: darkerOrange,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    otherRelated.length != 0
                        ? Container(
                            padding: EdgeInsets.only(left: 10.0, bottom: 5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 2),
                                  width: 65.0,
                                  child: Text(
                                    "Related:",
                                    style: TextStyle(
                                        color: primaryOrangeDark, fontSize: 14),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Wrap(children: [
                                      for (var rel in otherRelated.entries)
                                        GestureDetector(
                                          child: TagCreator(
                                            label: rel.key,
                                            isBadge: rel.value != null
                                                ? true
                                                : false,
                                            isLink: rel.value != null
                                                ? true
                                                : false,
                                          ),
                                          onTap: rel.value != null
                                              ? isPreview
                                                  ? () {}
                                                  : Feedback.wrapForTap(() {
                                                      Get.to(
                                                          () =>
                                                              new DetailScreen(
                                                                  wordID: rel
                                                                      .value),
                                                          preventDuplicates:
                                                              false);
                                                    }, context)
                                              : () {},
                                        )
                                    ]),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    synonyms.length != 0
                        ? Container(
                            padding: EdgeInsets.only(left: 10.0, bottom: 5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 2),
                                  width: 65.0,
                                  child: Text(
                                    "Synonym:",
                                    style: TextStyle(
                                        color: primaryOrangeDark, fontSize: 14),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Wrap(children: [
                                      for (var syn in synonyms.entries)
                                        GestureDetector(
                                          child: TagCreator(
                                            label: syn.key,
                                            isBadge: syn.value != null
                                                ? true
                                                : false,
                                            isLink: syn.value != null
                                                ? true
                                                : false,
                                          ),
                                          onTap: syn.value != null
                                              ? isPreview
                                                  ? () {}
                                                  : Feedback.wrapForTap(() {
                                                      () => Get.to(
                                                          () =>
                                                              new DetailScreen(
                                                                  wordID: syn
                                                                      .value),
                                                          preventDuplicates:
                                                              false);
                                                    }, context)
                                              : () {},
                                        )
                                    ]),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    antonyms.length != 0
                        ? Container(
                            padding: EdgeInsets.only(left: 10.0, bottom: 5.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 2),
                                  width: 65.0,
                                  child: Text(
                                    "Antonym:",
                                    style: TextStyle(
                                        color: primaryOrangeDark, fontSize: 14),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Wrap(children: [
                                      for (var ant in antonyms.entries)
                                        GestureDetector(
                                          child: TagCreator(
                                            label: ant.key,
                                            isBadge: ant.value != null
                                                ? true
                                                : false,
                                            isLink: ant.value != null
                                                ? true
                                                : false,
                                          ),
                                          onTap: ant.value != null
                                              ? isPreview
                                                  ? () {}
                                                  : Feedback.wrapForTap(() {
                                                      () => Get.to(
                                                          () =>
                                                              new DetailScreen(
                                                                  wordID: ant
                                                                      .value),
                                                          preventDuplicates:
                                                              false);
                                                    }, context)
                                              : () {},
                                        )
                                    ]),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: 5.0,
                    ),
                  ],
                ),
          sources == '' && contributors.length == 0 && expert.length == 0
              ? Container()
              : Column(
                  children: [
                    Divider(
                      color: disabledGrey,
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        tReferences.toUpperCase(),
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: darkerOrange,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    sources != ''
                        ? Container(
                            margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
                            padding: EdgeInsets.only(left: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 65.0,
                                  child: Text(
                                    "Sources:",
                                    style: TextStyle(
                                        color: primaryOrangeDark, fontSize: 14),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                      child: Text(
                                    sources,
                                    style: TextStyle(
                                        color: cardText, fontSize: 13),
                                  )),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    contributors.length != 0
                        ? Container(
                            padding: EdgeInsets.only(left: 10.0, bottom: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 2),
                                  width: 90.0,
                                  child: Text(
                                    "Contributors:",
                                    style: TextStyle(
                                        color: primaryOrangeDark, fontSize: 14),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Wrap(children: [
                                      for (var contributor
                                          in contributors.entries)
                                        GestureDetector(
                                          child: TagCreator(
                                              isBadge: true,
                                              label: contributor.key),
                                          onTap: contributor.value != null
                                              ? isPreview
                                                  ? () {}
                                                  : Feedback.wrapForTap(() {
                                                      () => Get.to(DetailScreen(
                                                          wordID: contributor
                                                              .value));
                                                    }, context)
                                              : () {},
                                        )
                                    ]),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                    expert.length != 0
                        ? Container(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 2),
                                  width: 90.0,
                                  child: Text(
                                    "Approved by:",
                                    style: TextStyle(
                                        color: primaryOrangeDark, fontSize: 14),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    child: Wrap(children: [
                                      for (var expert in expert.entries)
                                        GestureDetector(
                                          child: TagCreator(
                                            color: expertBadge,
                                            label: expert.key,
                                            isBadge: true,
                                            isExpert: true,
                                          ),
                                          onTap: expert.value != null
                                              ? isPreview
                                                  ? () {}
                                                  : Feedback.wrapForTap(() {
                                                      () => Get.to(DetailScreen(
                                                          wordID:
                                                              expert.value));
                                                    }, context)
                                              : () {},
                                        )
                                    ]),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(),
                  ],
                ),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}
