import 'package:amanu/components/tag_creator.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ProblemReportCard extends StatelessWidget {
  ProblemReportCard(
      {super.key,
      required this.timestamp,
      required this.subject,
      required this.details,
      required this.problemType,
      required this.email,
      required this.onTap,
      required this.imgUrl});

  final String timestamp;
  final String problemType;
  final String? email;
  final String subject;
  final String details;
  final String? imgUrl;
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
          child: Container(
            padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: double.infinity,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: primaryOrangeDark, width: 1.5)),
                    padding: EdgeInsets.all(2.5),
                    child: Container(),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        height: 20,
                        child: Text(
                          problemType.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              fontSize: 11,
                              color: disabledGrey,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 35,
                        child: Text(
                          subject,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: disabledGrey,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 35,
                        child: Text(
                          details,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: disabledGrey,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      imgUrl != null || imgUrl != ''
                          ? Container(
                              alignment: Alignment.topLeft,
                              height: 25,
                              child: TagCreator(
                                label: "with Image",
                                color: primaryOrangeLight,
                                textColor: pureWhite,
                              ))
                          : Container(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
