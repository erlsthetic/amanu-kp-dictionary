import 'package:amanu/components/tag_creator.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestCard extends StatelessWidget {
  RequestCard(
      {super.key,
      required this.timestamp,
      required this.word,
      required this.userName,
      required this.onTap,
      required this.onTapButton1,
      required this.onTapButton2,
      this.notes = ''});

  final String timestamp;
  final String word;
  final String userName;
  final String notes;
  final VoidCallback onTap;
  final VoidCallback onTapButton1;
  final VoidCallback onTapButton2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: InkWell(
        onTap: onTap,
        splashColor: primaryOrangeLight,
        highlightColor: primaryOrangeLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          height: 100,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: pureWhite,
              boxShadow: [
                BoxShadow(
                  color: primaryOrangeDark.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: -8,
                ),
              ]),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 40,
                      child: AutoSizeText(
                        word.toLowerCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.robotoSlab(
                            color: primaryOrangeDark,
                            fontWeight: FontWeight.w800),
                        presetFontSizes: [30, 29, 28, 27, 26, 25, 24, 23, 22],
                      ),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      height: 22.5,
                      child: Text(
                        notes,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: disabledGrey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          alignment: Alignment.centerLeft,
                          height: 22.5,
                          child: Text(
                            "by:",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: disabledGrey,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        TagCreator(
                          label: userName,
                          color: contributorBadge,
                          textColor: pureWhite.withOpacity(0.75),
                          isBadge: true,
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(left: 10),
                            child: Text(
                              timestamp,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: disabledGrey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primaryOrangeDark.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Material(
                  color: pureWhite,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    splashColor: primaryOrangeLight,
                    highlightColor: primaryOrangeLight.withOpacity(0.5),
                    onTap: onTapButton1,
                    child: Ink(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryOrangeDark.withAlpha(75),
                        ),
                        child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.edit,
                              color: primaryOrangeDark,
                              size: 30,
                            ))),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primaryOrangeDark.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Material(
                  color: pureWhite,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    splashColor: primaryOrangeLight,
                    highlightColor: primaryOrangeLight.withOpacity(0.5),
                    onTap: onTapButton2,
                    child: Ink(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryOrangeDark.withAlpha(75),
                        ),
                        child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.delete,
                              color: primaryOrangeDark,
                              size: 30,
                            ))),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
