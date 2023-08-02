import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/constants/app_colors.dart';

class HeaderSubheaderWithImage extends StatelessWidget {
  const HeaderSubheaderWithImage({
    super.key,
    required this.size,
    required this.header,
    required this.subHeader,
    required this.imgString,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.imageHeight = 0.2,
    this.heightBetween = 20,
  });

  final Size size;
  final String header;
  final String subHeader;
  final String imgString;
  final CrossAxisAlignment crossAxisAlignment;
  final double imageHeight;
  final double? heightBetween;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        SizedBox(
          height: 20,
        ),
        Image(
          image: AssetImage(imgString),
          height: size.height * imageHeight,
        ),
        SizedBox(
          height: heightBetween,
        ),
        Text(
          header,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: muteBlack,
            height: 1,
          ),
        ),
        Text(
          subHeader,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            color: muteBlack,
          ),
        ),
      ],
    );
  }
}
