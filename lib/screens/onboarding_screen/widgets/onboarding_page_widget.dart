import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/onboarding_model.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key, required this.model});

  final OnBoardingModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Image(
              image: AssetImage(model.image),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Text(
                    model.header,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                        color: model.headColor,
                        height: 1),
                  ),
                ),
                Expanded(
                  child: Text(
                    model.subheading,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      color: model.subHeadColor,
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 40.0,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          )
        ],
      ),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment(-0.9, -1),
              end: Alignment(0.9, 1),
              stops: [0.0, 0.75],
              colors: model.colors)),
    );
  }
}
