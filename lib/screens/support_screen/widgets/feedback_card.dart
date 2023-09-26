import 'package:amanu/screens/support_screen/controllers/feedbacks_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackCard extends StatelessWidget {
  FeedbackCard(
      {super.key,
      required this.timestamp,
      required this.rating,
      required this.additionalNotes,
      required this.onTap,
      required this.controller});

  final String timestamp;
  final int rating;
  final String? additionalNotes;
  final VoidCallback onTap;
  final FeedbacksController controller;

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
              children: [
                Container(
                  padding: EdgeInsets.only(right: 10),
                  alignment: Alignment.center,
                  height: double.infinity,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    height: 45,
                    width: 45,
                    child: Container(
                      child: Center(
                          child: SvgPicture.asset(
                        controller.ratesIcon[rating - 1],
                        colorFilter: ColorFilter.mode(
                            primaryOrangeDark, BlendMode.srcIn),
                      )),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 20,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Rating:",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  color: cardText,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            for (int i = 0; i < 5; i++)
                              Icon(Icons.star_rate_rounded,
                                  size: 20,
                                  color: rating > i
                                      ? primaryOrangeDark
                                      : disabledGrey),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Text(
                                (rating == 1
                                    ? "(Very Bad)"
                                    : rating == 2
                                        ? "(Bad)"
                                        : rating == 3
                                            ? "(Fair)"
                                            : rating == 4
                                                ? "(Good)"
                                                : "(Very Good)"),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: cardText,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 18,
                        child: Text(
                          additionalNotes ?? "No additional comments.",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: disabledGrey,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
