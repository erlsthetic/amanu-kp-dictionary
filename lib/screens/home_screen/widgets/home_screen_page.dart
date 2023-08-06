import 'dart:math';

import 'package:amanu/components/dictionary_card.dart';
import 'package:amanu/screens/home_screen/controllers/home_page_controller.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/search_button.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/drawerx_controller.dart';

class HomeScreenPage extends StatelessWidget {
  HomeScreenPage({
    super.key,
    required this.size,
    required this.topPadding,
  });

  final Size size;
  final double topPadding;

  final drawerController = Get.find<DrawerXController>();

  final controller = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: SliverSearchAppBar(
              screenSize: size,
              topPadding: topPadding,
              drawerController: drawerController),
          pinned: true,
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(30, 0, 30, 100),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Text(
                      tWordOfTheDay.toUpperCase(),
                      style: GoogleFonts.roboto(
                        color: disabledGrey,
                        fontSize: 15,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: orangeCard,
                    ),
                    child: DictionaryCard(
                        word: controller.word,
                        prn: controller.prn,
                        prnUrl: controller.prnUrl,
                        engTrans: controller.engTrans,
                        filTrans: controller.filTrans,
                        meanings: controller.meanings,
                        types: controller.types,
                        definitions: controller.definitions,
                        kulitanChars: controller.kulitanChars,
                        kulitanString: controller.kulitanString,
                        otherRelated: controller.otherRelated,
                        synonyms: controller.synonyms,
                        antonyms: controller.antonyms,
                        sources: controller.sources,
                        contributors: controller.contributors,
                        expert: controller.expert,
                        lastModifiedTime: controller.lastModifiedTime,
                        width: double.infinity),
                  ),
                ],
              )),
        ])),
      ],
    );
  }
}

class SliverSearchAppBar extends SliverPersistentHeaderDelegate {
  SliverSearchAppBar(
      {required this.screenSize,
      required this.topPadding,
      required this.drawerController});
  final Size screenSize;
  final double topPadding;
  final DrawerXController drawerController;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    var adjustedShrinkOffset = shrinkOffset > (maxExtent - minExtent)
        ? (maxExtent - minExtent)
        : shrinkOffset;
    double shrinkFactor = adjustedShrinkOffset / (maxExtent - minExtent);
    //double offset = ((maxExtent - minExtent) - adjustedShrinkOffset) - (15 * (1 - shrinkFactor));

    return Container(
      height: max((maxExtent - shrinkOffset), minExtent),
      child: Stack(
        children: [
          Crab(
            tag: "AppBar",
            child: Container(
              width: double.infinity,
              height: screenSize.height * 0.35,
              decoration: BoxDecoration(
                  gradient: orangeGradient,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(30.0))),
            ),
          ),
          /*_BackgroundWave(
            height: screenSize.height * 0.40,
          ),*/
          /*Positioned(
              left: 0,
              child: Text(
                offset.truncate().toString() +
                    " " +
                    shrinkOffset.truncate().toString() +
                    " " +
                    shrinkFactor.toStringAsFixed(3),
              )),*/
          Positioned(
            top: max(
                (topPadding + 60) * (1 - shrinkFactor) +
                    (shrinkFactor * (topPadding + 10)),
                topPadding + 10),
            child: Crab(
              tag: "AmanuLogo",
              child: Container(
                height: (screenSize.height * 0.20) * (1 - shrinkFactor),
                width: (screenSize.width),
                child: FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 130,
                        width: 130,
                        child: SvgPicture.asset(iAmanuWhiteLogoWithLabel),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 150,
                        width: 75,
                        child: SvgPicture.asset(
                            iAmanuWhiteScriptVerticalWithSeparator),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: max(
                ((screenSize.height * 0.35) - 30) * (1 - shrinkFactor) +
                    (shrinkFactor * (topPadding + 10)),
                topPadding + 10),
            child: SearchButton(
              shrinkFactor: shrinkFactor,
            ),
            left: 16,
            right: 16,
          ),
          Positioned(
              top: topPadding,
              left: 0,
              child: Container(
                height: 70,
                width: screenSize.width,
                padding: EdgeInsets.fromLTRB(
                    10 - (5 * shrinkFactor), 0, 20 - (10 * shrinkFactor), 0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Crab(
                        tag: 'HamburgerMenu',
                        child: IconButton(
                          onPressed: () {
                            drawerController.drawerToggle(context);
                            drawerController.currentItem.value =
                                DrawerItems.home;
                          },
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
      ),
    );
  }

  @override
  double get maxExtent => screenSize.height * 0.4;

  @override
  double get minExtent => topPadding + 70; //70 or 130

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      oldDelegate.maxExtent != maxExtent || oldDelegate.minExtent != minExtent;
}
/*
class _BackgroundWave extends StatelessWidget {
  final double height;

  const _BackgroundWave({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipPath(
          clipper: _BackgroundWaveClipper(),
          child: Crab(
            tag: "AppBar",
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: height,
              decoration: const BoxDecoration(gradient: orangeGradient),
            ),
          )),
    );
  }
}

class _BackgroundWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    const minSize = 130.0;

    final p1Diff = ((minSize - size.height) * 0.5).truncate().abs();
    path.lineTo(0.0, size.height - p1Diff);

    final controlPoint = Offset(size.width * 0.4, size.height * 1.2);
    final endPoint = Offset(size.width, minSize + (p1Diff * 0.4));

    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(_BackgroundWaveClipper oldClipper) => oldClipper != this;
}
*/