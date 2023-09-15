import 'package:amanu/utils/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpertRequestCard extends StatelessWidget {
  ExpertRequestCard(
      {super.key,
      required this.userID,
      required this.phoneNo,
      required this.bio,
      required this.userName,
      required this.userFullName,
      required this.onTap,
      required this.profileUrl});

  final String userID;
  final int phoneNo;
  final String userName;
  final String userFullName;
  final String? bio;
  final String? profileUrl;
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
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: disabledGrey,
                          image: (profileUrl == null || profileUrl == '')
                              ? null
                              : DecorationImage(
                                  image: NetworkImage(profileUrl ?? ''))),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 35,
                        child: AutoSizeText(
                          userName,
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
                          userFullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: disabledGrey,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        alignment: Alignment.topLeft,
                        height: 35,
                        child: Text(
                          "+63" + phoneNo.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: disabledGrey,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      bio != null || bio != ''
                          ? Container(
                              alignment: Alignment.topLeft,
                              height: 35,
                              child: Text(
                                bio ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: disabledGrey,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: Feedback.wrapForTap(() {}, context),
                        child: Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: primaryOrangeLight,
                              borderRadius: BorderRadius.circular(15)),
                          child: Icon(
                            Icons.check_rounded,
                            color: pureWhite,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      GestureDetector(
                        onTap: Feedback.wrapForTap(() {}, context),
                        child: Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: primaryOrangeLight,
                              borderRadius: BorderRadius.circular(15)),
                          child: Icon(
                            Icons.close_rounded,
                            color: pureWhite,
                            size: 20,
                          ),
                        ),
                      ),
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
