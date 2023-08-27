import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<dynamic> showConfirmDialog(
    BuildContext context,
    String title,
    String content,
    String option1Text,
    String option2Text,
    VoidCallback option1Tap,
    VoidCallback option2Tap) {
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: pureWhite,
                    borderRadius: BorderRadius.circular(30.0)),
                margin: EdgeInsets.only(right: 12, top: 12),
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      constraints: BoxConstraints(minHeight: 70),
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          color: primaryOrangeDark,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30.0))),
                      child: Text(
                        title,
                        style: GoogleFonts.robotoSlab(
                            fontSize: 24,
                            color: pureWhite,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Text(
                                content,
                                textAlign: TextAlign.center,
                                style: TextStyle(color: cardText, fontSize: 16),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Material(
                                    borderRadius: BorderRadius.circular(25),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(25),
                                      onTap: option1Tap,
                                      splashColor: primaryOrangeLight,
                                      highlightColor:
                                          primaryOrangeLight.withOpacity(0.5),
                                      child: Ink(
                                        height: 50.0,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            option1Text.toUpperCase(),
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: pureWhite,
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryOrangeDark,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Material(
                                    borderRadius: BorderRadius.circular(25),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(25),
                                      onTap: option2Tap,
                                      splashColor: primaryOrangeDarkShine,
                                      highlightColor: primaryOrangeDarkShine
                                          .withOpacity(0.5),
                                      child: Ink(
                                        height: 50.0,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            option2Text.toUpperCase(),
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: pureWhite,
                                            ),
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: primaryOrangeLight,
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    )
                  ],
                ),
              ),
              Positioned(
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 18.0,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.close, color: primaryOrangeDark),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}
