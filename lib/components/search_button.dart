import 'package:amanu/screens/search_screen/search_screen.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchButton extends StatelessWidget {
  final double shrinkFactor;
  SearchButton({Key? key, required this.shrinkFactor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
          20 + (15 * shrinkFactor), 0, 20 + (20 * shrinkFactor), 0),
      child: Crab(
        tag: "SearchButton",
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color:
                      primaryOrangeDark.withOpacity(0.6 - (0.6 * shrinkFactor)),
                  blurRadius: 15,
                  spreadRadius: -5,
                )
              ]),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              splashColor: primaryOrangeLight,
              highlightColor: primaryOrangeLight.withOpacity(0.5),
              onTap: () {
                Get.to(() => SearchScreen());
              },
              child: Ink(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20.0, 15 - (5 * shrinkFactor),
                    15.0, 15 - (5 * shrinkFactor)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: pureWhite,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Search',
                      style: GoogleFonts.poppins(
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        color: primaryOrangeDark,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Hero(
                      tag: "SearchIcon",
                      child: Icon(
                        Icons.search,
                        color: primaryOrangeDark,
                        size: 30.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
