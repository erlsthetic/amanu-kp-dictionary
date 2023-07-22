import 'package:amanu/utils/constants/image_strings.dart';
import 'package:get/get.dart';

class FeedbackController extends GetxController {
  static FeedbackController get instance => Get.find();
  RxInt selectedRate = 0.obs;
  List<String> ratesText = ["Very bad", "Bad", "Fair", "Good", "Very Good"];
  List<String> ratesIcon = [
    iRateVeryBad,
    iRateBad,
    iRateFair,
    iRateGood,
    iRateVeryGood
  ];
}
