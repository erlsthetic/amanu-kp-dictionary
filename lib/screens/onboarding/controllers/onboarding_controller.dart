import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import '../models/onboarding_model.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/text_strings.dart';
import '../widgets/onboarding_page_widget.dart';

class OnBoardingController extends GetxController {
  final controller = LiquidController();
  RxInt currentPage = 0.obs;

  final onBoardingPages = [
    OnBoardingPage(
        model: OnBoardingModel(
            image: iOnBoardingAnim1,
            header: tOnBoardingHead1,
            subheading: tOnBoardingSubHead1,
            colors: [pureWhite, pureWhite],
            headColor: primaryOrangeDark,
            subHeadColor: darkGrey)),
    OnBoardingPage(
        model: OnBoardingModel(
            image: iOnBoardingAnim2,
            header: tOnBoardingHead2,
            subheading: tOnBoardingSubHead2,
            colors: [primaryOrangeLight, primaryOrangeDark],
            headColor: darkGrey,
            subHeadColor: pureWhite)),
    OnBoardingPage(
        model: OnBoardingModel(
            image: iOnBoardingAnim3,
            header: tOnBoardingHead3,
            subheading: tOnBoardingSubHead3,
            colors: [pureWhite, pureWhite],
            headColor: primaryOrangeDark,
            subHeadColor: darkGrey)),
  ];

  onPageChangedCallback(int activePageIndex) {
    currentPage.value = activePageIndex;
  }

  skip() => controller.jumpToPage(page: 2);
}
