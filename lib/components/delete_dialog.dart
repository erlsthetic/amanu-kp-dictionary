import 'package:amanu/screens/search_screen/controllers/search_controller.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future<dynamic> showDeleteDialog(BuildContext context, String wordID,
    SearchWordController? controller, bool isFromModifySearch) {
  final appController = Get.find<ApplicationController>();
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
                      height: 70,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                          color: primaryOrangeDark,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30.0))),
                      child: Text(
                        tDeleteWord,
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
                                appController.userIsExpert ?? false
                                    ? (tDeletePrompt1 +
                                        (isFromModifySearch
                                            ? controller!.suggestionMap[wordID]
                                                ["word"]
                                            : appController
                                                    .dictionaryContent[wordID]
                                                ["word"]) +
                                        tDeletePrompt2)
                                    : (tDeleteRequestPrompt1 +
                                        (isFromModifySearch
                                            ? controller!.suggestionMap[wordID]
                                                ["word"]
                                            : appController
                                                    .dictionaryContent[wordID]
                                                ["word"]) +
                                        tDeleteRequestPrompt2),
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
                                      onTap: () {},
                                      splashColor: primaryOrangeLight,
                                      highlightColor:
                                          primaryOrangeLight.withOpacity(0.5),
                                      child: Ink(
                                        height: 50.0,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            tDeleteYes.toUpperCase(),
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
                                      onTap: () {},
                                      splashColor: primaryOrangeDarkShine,
                                      highlightColor: primaryOrangeDarkShine
                                          .withOpacity(0.5),
                                      child: Ink(
                                        height: 50.0,
                                        child: Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            tCancel.toUpperCase(),
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
