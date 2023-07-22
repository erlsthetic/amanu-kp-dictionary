import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/widgets/components/browse_card.dart';
import 'package:amanu/widgets/components/search_button.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';

class BrowseScreenPage extends StatelessWidget {
  const BrowseScreenPage({
    super.key,
    required this.size,
    required this.topPadding,
  });

  final Size size;
  final double topPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: topPadding + 50,
          left: 0,
          right: 0,
          child: Container(
              height: size.height - 110,
              width: size.width,
              child: ListView.builder(
                padding: EdgeInsets.only(top: 30, bottom: 100),
                itemCount: 20,
                itemBuilder: (context, index) {
                  return BrowseCard();
                },
              )),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Crab(
            tag: "AppBar",
            child: Container(
              width: size.width,
              height: topPadding + 70,
              decoration: BoxDecoration(
                  gradient: orangeGradient,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30.0))),
            ),
          ),
        ),
        Positioned(
          top: topPadding + 10,
          child: SearchButton(
            shrinkFactor: 1.0,
          ),
          left: 16,
          right: 16,
        ),
        Positioned(
            top: topPadding,
            left: 0,
            child: Container(
              height: 70,
              width: size.width,
              padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Crab(
                      tag: 'HamburgerMenu',
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.menu_rounded),
                        color: pureWhite,
                        iconSize: 30,
                      ),
                    ),
                    Crab(
                      tag: "Requests",
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {},
                          splashColor: primaryOrangeLight,
                          highlightColor: primaryOrangeLight.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                          child: Ink(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                color: primaryOrangeLight.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Icon(
                              Icons.person_rounded,
                              color: pureWhite,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
            )),
      ],
    ));
  }
}
