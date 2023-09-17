import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBrowseCard extends StatelessWidget {
  ShimmerBrowseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: Container(
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
                        child: Shimmer.fromColors(
                          baseColor: primaryOrangeDark.withOpacity(0.8),
                          highlightColor: primaryOrangeDarkShine,
                          child: Container(
                            height: 27.5,
                            width: 100,
                            color: primaryOrangeDark.withOpacity(0.8),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Shimmer.fromColors(
                          baseColor: primaryOrangeLight.withOpacity(0.8),
                          highlightColor: primaryOrangeLightShine,
                          child: Container(
                            margin: EdgeInsets.only(left: 5),
                            height: 27.5,
                            width: 75,
                            color: primaryOrangeLight.withOpacity(0.8),
                          ),
                        ),
                      )
                    ],
                  ),
                  Shimmer.fromColors(
                    baseColor: orangeCard,
                    highlightColor: orangeCardShine,
                    child: Container(
                      height: 27.5,
                      color: orangeCard,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Shimmer.fromColors(
              baseColor: primaryOrangeLight.withOpacity(0.8),
              highlightColor: primaryOrangeLightShine,
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: primaryOrangeLight.withOpacity(0.8)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
