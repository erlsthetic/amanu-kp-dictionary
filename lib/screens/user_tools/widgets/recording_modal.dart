import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';

class RecordingStudioModal {
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tForgetPasswordTitle,
              style: GoogleFonts.poppins(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: muteBlack,
                height: 1,
              ),
            ),
            Text(
              tForgetPasswordSubtitle,
              style: GoogleFonts.poppins(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
                color: muteBlack,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
