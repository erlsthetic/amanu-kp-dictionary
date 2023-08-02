import 'package:amanu/screens/details_screen/detail_screen.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrowseCard extends StatelessWidget {
  BrowseCard({super.key});

  final String word = "Sample";
  final String type = "noun";
  final List<String> engTran = ["examlple", "example", "example", "example"];
  final String prnLink = "https://something";

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: InkWell(
        onTap: () => Get.to(() => DetailScreen()),
        splashColor: primaryOrangeLight,
        highlightColor: primaryOrangeLight.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          height: 80,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 10, 10, 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: pureWhite,
              boxShadow: [
                BoxShadow(
                  color: primaryOrangeDark.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: -8,
                ),
              ]),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            height: 27.5,
                            width: 75,
                            color: primaryOrangeDark,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
                            height: 27.5,
                            width: 100,
                            color: primaryOrangeLight,
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 27.5,
                      color: orangeCard,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primaryOrangeDark.withOpacity(0.4),
                      blurRadius: 12,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    splashColor: primaryOrangeLight,
                    highlightColor: primaryOrangeLight.withOpacity(0.5),
                    onTap: () {},
                    child: Ink(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: primaryOrangeDark.withAlpha(50),
                      ),
                      child: Icon(
                        Icons.play_arrow,
                        color: pureWhite,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
