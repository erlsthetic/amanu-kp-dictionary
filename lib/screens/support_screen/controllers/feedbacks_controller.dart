import 'package:amanu/components/info_dialog.dart';
import 'package:amanu/models/feedback_model.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbacksController extends GetxController {
  static FeedbacksController get instance => Get.find();
  final appController = Get.find<ApplicationController>();
  List<FeedbackModel> feedbacks = [];
  List<String> ratesIcon = [
    iRateVeryBad,
    iRateBad,
    iRateFair,
    iRateGood,
    iRateVeryGood
  ];

  @override
  void onInit() {
    super.onInit();
    if (appController.hasConnection.value) {
      getFeedbacks();
    } else {
      appController.showConnectionSnackbar();
    }
  }

  Future getFeedbacks() async {
    var snapshot = await DatabaseRepository.instance.getAllFeedbacks();
    feedbacks = new List.from(snapshot);
  }

  void openFeedback(BuildContext context, String title, int rating,
      String? additionalNotes, String timestamp) {
    showInfoDialog(
        context,
        title,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                height: 20,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: [
                    Text(
                      "Rating:",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: cardText,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    for (int i = 0; i < 5; i++)
                      Icon(Icons.star_rate_rounded,
                          size: 18,
                          color: rating > i ? primaryOrangeDark : disabledGrey),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
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
                          fontSize: 12,
                          color: cardText,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: Container(
                  child: Text(
                    additionalNotes ?? "No additional comments.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 16,
                        color: cardText,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
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
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
        null,
        null);
  }
}
