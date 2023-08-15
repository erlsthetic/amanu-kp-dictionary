import 'dart:ui';

class OnBoardingModel {
  final String image;
  final String header;
  final String subheading;
  final List<Color> colors;
  final Color headColor;
  final Color subHeadColor;
  final bool hasSkip;
  final bool hasButton;
  final int pageNo;

  OnBoardingModel(
      {required this.image,
      required this.header,
      required this.subheading,
      required this.colors,
      required this.headColor,
      required this.subHeadColor,
      required this.hasSkip,
      required this.hasButton,
      required this.pageNo});
}
