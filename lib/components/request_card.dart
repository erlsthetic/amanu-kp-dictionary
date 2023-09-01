import 'package:amanu/components/tag_creator.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RequestCard extends StatelessWidget {
  RequestCard(
      {super.key,
      required this.timestamp,
      required this.requestType,
      required this.word,
      required this.userName,
      required this.onTap,
      this.notes = ''});

  final String timestamp;
  final int requestType;
  final String word;
  final String userName;
  final String notes;
  final VoidCallback onTap;

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
          height: 120,
          width: double.infinity,
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
              Container(
                height: double.infinity,
                width: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(20)),
                    color: requestType == 0
                        ? primaryOrangeDark
                        : requestType == 1
                            ? primaryOrangeLight
                            : darkerOrange.withOpacity(0.8)),
                child: Icon(
                  requestType == 0
                      ? Icons.add
                      : requestType == 1
                          ? Icons.edit
                          : Icons.delete,
                  size: 20,
                  color: pureWhite,
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 35,
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
                        height: 35,
                        child: Text(
                          notes,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: disabledGrey,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            height: 22,
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
                              alignment: Alignment.topLeft,
                              height: 22,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
