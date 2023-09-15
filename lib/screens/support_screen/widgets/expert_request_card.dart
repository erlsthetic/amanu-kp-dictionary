import 'package:amanu/components/tag_creator.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class ExpertRequestCard extends StatelessWidget {
  ExpertRequestCard(
      {super.key,
      required this.userID,
      required this.phoneNo,
      required this.bio,
      required this.userName,
      required this.userFullName,
      required this.onTap,
      required this.profileUrl,
      required this.cvUrl,
      required this.onTapOpt1,
      required this.onTapOpt2});

  final String userID;
  final int phoneNo;
  final String userName;
  final String? userFullName;
  final String? bio;
  final String? profileUrl;
  final String? cvUrl;
  final VoidCallback onTap;
  final VoidCallback onTapOpt1;
  final VoidCallback onTapOpt2;

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
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border:
                            Border.all(color: primaryOrangeDark, width: 2.5)),
                    padding: EdgeInsets.all(2.5),
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: disabledGrey),
                      child: profileUrl != null || profileUrl != ''
                          ? Image.network(
                              profileUrl ?? '',
                              errorBuilder: (context, error, stackTrace) {
                                return Shimmer.fromColors(
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                  ),
                                  baseColor: disabledGrey,
                                  highlightColor: lightGrey,
                                );
                              },
                            )
                          : Icon(
                              Icons.person_rounded,
                              size: 40,
                              color: darkGrey,
                            ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: 25,
                          child: AutoSizeText(
                            userName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.robotoSlab(
                                color: primaryOrangeDark,
                                fontWeight: FontWeight.w800),
                            presetFontSizes: [28, 27, 26, 25, 24, 23, 22],
                          ),
                        ),
                        userFullName != null || userFullName != ''
                            ? Container(
                                alignment: Alignment.topLeft,
                                height: 16,
                                child: Text(
                                  userFullName ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.roboto(
                                      fontSize: 15,
                                      color: disabledGrey,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            : Container(),
                        Container(
                          alignment: Alignment.topLeft,
                          height: 15,
                          child: Row(
                            children: [
                              Text(
                                "+63" + phoneNo.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: disabledGrey,
                                    fontWeight: FontWeight.w600),
                              ),
                              cvUrl != null || cvUrl != ''
                                  ? Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: TagCreator(
                                        label: "with CV",
                                        color: primaryOrangeLight,
                                        textColor: pureWhite,
                                        height: 15,
                                        padding:
                                            EdgeInsets.fromLTRB(4, 1, 4, 1),
                                        margin: EdgeInsets.all(0),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        bio != null || bio != ''
                            ? Container(
                                alignment: Alignment.topLeft,
                                height: 15,
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
                ),
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: Feedback.wrapForTap(onTapOpt1, context),
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: primaryOrangeDark,
                              borderRadius: BorderRadius.circular(20)),
                          child: Icon(
                            Icons.check_rounded,
                            color: pureWhite,
                            size: 20,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: Feedback.wrapForTap(onTapOpt2, context),
                        child: Container(
                          height: 40,
                          width: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: darkerOrange.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20)),
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
