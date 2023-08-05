import 'package:amanu/screens/details_screen/detail_screen.dart';
import 'package:amanu/utils/auth/helper_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BrowseCard extends StatelessWidget {
  BrowseCard(
      {super.key,
      required this.player,
      required this.wordId,
      required this.word,
      required this.type,
      required this.engTrans,
      required this.filTrans,
      required this.prnLink,
      this.showEngTrans = true,
      required this.onTap});

  final AudioPlayer player;

  Future<void> playFromURL(String url) async {
    try {
      await player.stop();
      await player.play(UrlSource(url));
    } catch (e) {
      Helper.errorSnackBar(title: "Error", message: "Cannot play audio.");
    }
  }

  final String wordId;
  final String word;
  final List<String> type;
  final List<String> engTrans;
  final List<String> filTrans;
  final String prnLink;
  final bool showEngTrans;
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
          height: 80,
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.6),
                          height: 35,
                          child: Text(
                            word.toLowerCase(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.robotoSlab(
                                fontSize: 27,
                                color: primaryOrangeDark,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(bottom: 8),
                            margin: EdgeInsets.only(left: 5),
                            child: Text(
                              "(" + type.join(", ") + ")",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14, color: primaryOrangeLight),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      height: 22.5,
                      child: Text(
                        showEngTrans
                            ? engTrans.length != 0
                                ? engTrans.join(", ")
                                : "No translation."
                            : filTrans.length != 0
                                ? filTrans.join(", ")
                                : "No translation.",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: disabledGrey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
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
                      color: primaryOrangeDark.withOpacity(0.5),
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
                    onTap: () {
                      playFromURL(prnLink);
                    },
                    child: Ink(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: primaryOrangeDark.withAlpha(75),
                        ),
                        child: Container(
                          height: double.infinity,
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: Container(
                            height: 18,
                            width: 18,
                            child: SvgPicture.asset(iListenIcon),
                          ),
                        )),
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
