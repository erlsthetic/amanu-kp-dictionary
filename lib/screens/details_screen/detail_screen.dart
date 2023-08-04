import 'package:amanu/components/tag_creator.dart';
import 'package:amanu/screens/details_screen/controllers/detail_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/kulitan_preview.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({
    super.key,
    required this.wordID,
  });

  final wordID;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetailController(wordID: wordID));
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
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: orangeCard),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                      constraints: BoxConstraints(
                                          maxWidth: size.width * 0.6),
                                      child: Text(
                                        controller.word,
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
                                        "(" + controller.types.join(', ') + ")",
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
                                  highlightColor:
                                      primaryOrangeLight.withOpacity(0.5),
                                  onTap: () {
                                    controller.playFromURL();
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
                                                primaryOrangeDark,
                                                BlendMode.srcIn),
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
                            "/" + controller.prn + "/",
                            style: TextStyle(fontSize: 14, color: disabledGrey),
                          ),
                        ),
                        controller.engTrans.length != 0
                            ? Container(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 30.0,
                                      child: Text(
                                        "Eng:",
                                        style: TextStyle(
                                            color: primaryOrangeDark,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Wrap(children: [
                                          for (String trans
                                              in controller.engTrans)
                                            TagCreator(label: trans),
                                        ]),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        controller.filTrans.length != 0
                            ? Container(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 30.0,
                                      child: Text(
                                        "Fil:",
                                        style: TextStyle(
                                            color: darkerOrange, fontSize: 14),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Wrap(children: [
                                          for (String trans
                                              in controller.filTrans)
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
                          height: 5.0,
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
                          child: controller.kulitanString == ''
                              ? Container(
                                  child: Text(
                                    "No data",
                                    style: TextStyle(
                                        fontSize: 15, color: disabledGrey),
                                  ),
                                )
                              : KulitanPreview(
                                  kulitanCharList: controller.kulitanChars),
                        ),
                        SizedBox(
                          height: 5.0,
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
                        controller.synonyms.length != 0
                            ? Container(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 65.0,
                                      child: Text(
                                        "Synonym:",
                                        style: TextStyle(
                                            color: primaryOrangeDark,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Wrap(children: [
                                          for (var syn
                                              in controller.synonyms.entries)
                                            TagCreator(label: syn.key)
                                        ]),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        controller.antonyms.length != 0
                            ? Container(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 65.0,
                                      child: Text(
                                        "Antonym:",
                                        style: TextStyle(
                                            color: primaryOrangeDark,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Wrap(children: [
                                          for (var ant
                                              in controller.antonyms.entries)
                                            TagCreator(label: ant.key)
                                        ]),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(),
                        controller.otherRelated.length != 0
                            ? Container(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 65.0,
                                      child: Text(
                                        "Related:",
                                        style: TextStyle(
                                            color: primaryOrangeDark,
                                            fontSize: 14),
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Wrap(children: [
                                          for (var rel in controller
                                              .otherRelated.entries)
                                            TagCreator(label: rel.key)
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
                          height: 15.0,
                        ),
                      ],
                    ),
                  ),
                ),
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
            },
          ),
        ),
      ],
    ));
  }
}
