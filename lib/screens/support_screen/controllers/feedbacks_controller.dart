import 'package:amanu/models/feedback_model.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:get/get.dart';

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
}
