import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/constants/app_colors.dart';

class HeaderSubheader extends StatelessWidget {
  const HeaderSubheader({
    super.key,
    required this.size,
    required this.header,
    required this.subHeader,
  });

  final Size size;
  final String header;
  final String subHeader;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 40,
        ),
        Text(
          header,
          style: GoogleFonts.poppins(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
            color: muteBlack,
            height: 1,
          ),
        ),
        Text(
          subHeader,
          style: GoogleFonts.poppins(
            fontSize: 16.0,
            fontWeight: FontWeight.w600,
            color: muteBlack,
          ),
        ),
      ],
    );
  }
}
