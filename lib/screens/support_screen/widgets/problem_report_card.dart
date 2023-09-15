import 'package:amanu/components/tag_creator.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
            width: double.infinity,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: double.infinity,
                  width: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(20)),
                    color: problemType.toLowerCase() ==
                            "account related problem"
                        ? primaryOrangeDark
                        : problemType.toLowerCase() == "content related problem"
                            ? primaryOrangeLight
                            : problemType.toLowerCase() == "Bugs and crashes"
                                ? darkerOrange.withOpacity(0.8)
                                : orangeCard,
                  ),
                  child: Icon(
                    problemType.toLowerCase() == "account related problem"
                        ? Icons.account_circle_rounded
                        : problemType.toLowerCase() == "content related problem"
                            ? Icons.library_books_rounded
                            : problemType.toLowerCase() == "Bugs and crashes"
                                ? Icons.bug_report_rounded
                                : Icons.app_shortcut_rounded,
                    size: 25,
                    color: pureWhite,
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          height: 14,
                          child: Text(
                            problemType.toUpperCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: disabledGrey,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 18,
                          child: Text(
                            subject,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: cardText,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          height: 18,
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
                        Row(
                          children: [
                            imgUrl != null
                                ? Container(
                                    padding: EdgeInsets.only(right: 10),
                                    alignment: Alignment.topLeft,
                                    height: 25,
                                    child: TagCreator(
                                      label: "with Image",
                                      color: primaryOrangeLight,
                                      textColor: pureWhite,
                                    ))
                                : Container(),
                            Container(
                              alignment: Alignment.topLeft,
                              height: 22,
                              child: Text(
                                timestamp,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: disabledGrey,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
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
      ),
    );
  }
}
