import 'dart:io';
import 'dart:math';

import 'package:amanu/components/dictionary_card.dart';
import 'package:amanu/components/join_dialog.dart';
import 'package:amanu/screens/home_screen/controllers/home_page_controller.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/screens/profile_screen/profile_screen.dart';
import 'package:amanu/screens/requests_screen/requests_screen.dart';
import 'package:amanu/utils/application_controller.dart';
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
    final screenPadding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.only(bottom: screenPadding.bottom),
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            delegate: SliverSearchAppBar(
                screenSize: size,
                topPadding: topPadding,
                drawerController: drawerController,
                homeController: controller),
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
                      child: controller.wotdFound
                          ? DictionaryCard(
                              key: controller.wotdKey,
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
                              width: double.infinity)
                          : Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 100,
                              child: Text(
                                "No data",
                                style: TextStyle(color: cardText),
                              ),
                            ),
                    ),
                  ],
                )),
          ])),
        ],
      ),
    );
  }
}

class SliverSearchAppBar extends SliverPersistentHeaderDelegate {
  SliverSearchAppBar(
      {required this.screenSize,
      required this.topPadding,
      required this.drawerController,
      required this.homeController});
  final Size screenSize;
  final double topPadding;
  final DrawerXController drawerController;
  final HomePageController homeController;
  final appController = Get.find<ApplicationController>();

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
            child: Hero(
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
                (topPadding + 40) * (1 - shrinkFactor) +
                    (shrinkFactor * (topPadding + 10)),
                topPadding + 10),
            child: Crab(
              tag: "AmanuLogo",
              child: Container(
                height: ((screenSize.height * 0.35) - 30 - (topPadding + 45)) *
                    (1 - shrinkFactor),
                width: (screenSize.width),
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Row(
                    key: homeController.amanuKey,
                    mainAxisSize: MainAxisSize.min,
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
              key: homeController.searchKey,
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
                        key: homeController.drawerKey,
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
                        key: homeController.requestsKey,
                        tag: "Requests",
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              if (appController.isLoggedIn) {
                                if (appController.userIsExpert ?? false) {
                                  Get.to(
                                      () => RequestsScreen(
                                            fromDrawer: false,
                                          ),
                                      duration: Duration(milliseconds: 500),
                                      transition: Transition.upToDown,
                                      curve: Curves.easeInOut);
                                } else {
                                  Get.to(
                                      () => ProfileScreen(
                                            fromDrawer: false,
                                          ),
                                      duration: Duration(milliseconds: 500),
                                      transition: Transition.upToDown,
                                      curve: Curves.easeInOut);
                                }
                              } else {
                                showJoinDialog(context);
                              }
                            },
                            splashColor: primaryOrangeLight,
                            highlightColor: primaryOrangeLight.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                            child: Ink(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: appController.isLoggedIn &&
                                        !(appController.userIsExpert ?? false)
                                    ? Colors.transparent
                                    : primaryOrangeLight.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(20.0),
                                border: appController.isLoggedIn &&
                                        !(appController.userIsExpert ?? false)
                                    ? Border.all(width: 2, color: pureWhite)
                                    : null,
                              ),
                              child: appController.isLoggedIn
                                  ? (appController.userIsExpert ?? false)
                                      ? Icon(
                                          Icons.book,
                                          color: pureWhite,
                                          size: 25,
                                        )
                                      : appController.userPicLocal == null
                                          ? Icon(
                                              Icons.person_rounded,
                                              color: pureWhite,
                                              size: 25,
                                            )
                                          : FittedBox(
                                              fit: BoxFit.cover,
                                              child: Container(
                                                margin: EdgeInsets.all(3),
                                                height: 50,
                                                width: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            60),
                                                    image: DecorationImage(
                                                        image: FileImage(File(
                                                            appController
                                                                .userPicLocal!)),
                                                        fit: BoxFit.cover)),
                                              ),
                                            )
                                  : Icon(
                                      Icons.people_alt_rounded,
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