import 'package:amanu/models/feedback_model.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FeedbackController extends GetxController {
  static FeedbackController get instance => Get.find();
  final databaseRepo = Get.put(DatabaseRepository());

  RxBool isProcessing = false.obs;
  RxBool noSelection = false.obs;

  var additionalNotes = '';

  final GlobalKey<FormState> feedbackFormKey = GlobalKey<FormState>();

  late TextEditingController notesController;

  @override
  void onInit() {
    super.onInit();
    notesController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    notesController.dispose();
    additionalNotes = '';
  }

  RxInt selectedRate = 0.obs;
  List<String> ratesText = ["Very bad", "Bad", "Fair", "Good", "Very Good"];
  List<String> ratesIcon = [
    iRateVeryBad,
    iRateBad,
    iRateFair,
    iRateGood,
    iRateVeryGood
  ];

  Future<void> sendFeedback() async {
    selectedRate.value == 0 ? noSelection.value = true : null;
    final String timestamp =
        DateFormat('yyyy-MM-dd(HH:mm:ss)').format(DateTime.now());
    final feedbackFormValid = feedbackFormKey.currentState!.validate();
    if (!feedbackFormValid || selectedRate.value == 0 || noSelection == true) {
      return;
    }
    feedbackFormKey.currentState!.save();
    isProcessing.value = true;

    final feedbackInfo = FeedbackModel(
        rating: selectedRate.value,
        additionalNotes: additionalNotes != '' ? additionalNotes : null,
        timestamp: timestamp);

    await databaseRepo.createFeedbackOnDB(feedbackInfo, timestamp);
  }
}
