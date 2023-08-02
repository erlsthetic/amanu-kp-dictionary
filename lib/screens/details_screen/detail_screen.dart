import 'package:amanu/screens/details_screen/controllers/detail_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/kulitan_preview.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({
    super.key,
  });

  final controller = Get.put(DetailController());

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
                              child: Container(
                                  child: Text(
                                "abcdefg",
                                style: GoogleFonts.robotoSlab(
                                    fontSize: 30,
                                    color: primaryOrangeDark,
                                    fontWeight: FontWeight.bold),
                              )),
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
                                  onTap: () {},
                                  child: Ink(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: pureWhite,
                                    ),
                                    child: Icon(
                                      Icons.play_arrow,
                                      color: primaryOrangeDark,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          width: double.infinity,
                          child: Text(
                            "/a'manu/",
                            style: TextStyle(fontSize: 14, color: disabledGrey),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          padding: EdgeInsets.only(left: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 30.0,
                                child: Text(
                                  "Eng:",
                                  style: TextStyle(
                                      color: primaryOrangeDark, fontSize: 14),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  child: Wrap(children: [
                                    for (String trans in controller.engTrans)
                                      TagCreator(label: trans),
                                  ]),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5.0),
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
                                    for (String trans in controller.filTrans)
                                      TagCreator(label: trans)
                                  ]),
                                ),
                              )
                            ],
                          ),
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
                          padding: EdgeInsets.fromLTRB(30, 10, 30, 20),
                          width: double.infinity,
                          child: controller.kulitanChars.isEmpty
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
                          height: 15.0,
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          padding: EdgeInsets.only(left: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
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
                                    for (String syn in controller.synonym)
                                      TagCreator(label: syn)
                                  ]),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          padding: EdgeInsets.only(left: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
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
                                    for (String ant in controller.antonym)
                                      TagCreator(label: ant)
                                  ]),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 5.0),
                          padding: EdgeInsets.only(left: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
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
                                    for (String rel in controller.related)
                                      TagCreator(label: rel)
                                  ]),
                                ),
                              )
                            ],
                          ),
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
        ThreePartHeader(
          size: size,
          screenPadding: screenPadding,
          title: "abcdefg",
        ),
      ],
    ));
  }
}

class TagCreator extends StatelessWidget {
  const TagCreator({
    super.key,
    required this.label,
    this.color = pureWhite,
    this.textColor = disabledGrey,
  });

  final String label;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(2.5, 0, 2.5, 5.0),
      height: 22,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(20), color: color),
      padding: EdgeInsets.fromLTRB(5, 3, 5, 3),
      child: Text(label,
          style: TextStyle(
              fontSize: 12, color: textColor, fontStyle: FontStyle.italic)),
    );
  }
}
