import 'dart:io';

import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/controllers/home_page_controller.dart';
import 'package:amanu/models/drawer_item_model.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerItems {
  static const home = DrawerItem('Home', iHomeIcon);
  static const browse = DrawerItem('Browse', iDictionaryIcon);
  static const bookmarks = DrawerItem('Bookmarks', iBookmarksIcon);
  static const kulitan = DrawerItem('Kulitan Reader', iAmanuScannerIcon);
  static const join = DrawerItem('Join Amanu', iJoinAmanuIcon);
  static const support = DrawerItem('Support', iSupportIcon);
  static const profile = DrawerItem('Profile', iProfileIcon);
  static const requests = DrawerItem('Requests', iRequestsIcon);

  static const regular = <DrawerItem>[
    home,
    browse,
    bookmarks,
    kulitan,
    join,
    support
  ];

  static const withUser = <DrawerItem>[
    home,
    browse,
    bookmarks,
    kulitan,
    profile,
    support
  ];

  static const withExpert = <DrawerItem>[
    home,
    browse,
    bookmarks,
    kulitan,
    profile,
    requests,
    support
  ];
}

class AppDrawer extends StatelessWidget {
  AppDrawer(
      {super.key,
      required this.currentItem,
      required this.onSelectedItem,
      required this.controller});
  final DrawerItem currentItem;
  final ValueChanged<DrawerItem> onSelectedItem;
  final DrawerXController controller;

  final appController = Get.find<ApplicationController>();

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: primaryOrangeDark,
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !appController.isLoggedIn
                ? Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Container(
                          height: 150,
                          width: 150,
                          child: SvgPicture.asset(iAmanuWhiteLogoWithLabel)),
                    ),
                  )
                : Expanded(
                    flex: appController.userIsExpert ?? false ? 3 : 1,
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 100.0,
                            width: 100.0,
                            padding: EdgeInsets.all(7.5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: pureWhite),
                            child: appController.userPicLocal == null
                                ? Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        color: primaryOrangeLight),
                                    child: Icon(
                                      Icons.person_rounded,
                                      size: 60,
                                      color: pureWhite.withOpacity(0.5),
                                    ))
                                : Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        image: DecorationImage(
                                            image: FileImage(File(
                                                appController.userPicLocal!)),
                                            fit: BoxFit.cover)),
                                  ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Text(
                              'Hello, ' + appController.userName!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                  color: pureWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          appController.isLoggedIn &&
                                  (appController.userIsExpert ?? false)
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: expertBadge),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.verified_rounded,
                                          size: 14,
                                          color: muteBlack.withOpacity(0.5)),
                                      SizedBox(
                                        width: 3.0,
                                      ),
                                      Text(
                                        'Expert',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                            color: muteBlack.withOpacity(0.5),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12),
                                      ),
                                    ],
                                  ),
                                )
                              : appController.userExpertRequest ?? false
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: darkGrey),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.pending_actions_rounded,
                                              size: 14,
                                              color:
                                                  pureWhite.withOpacity(0.5)),
                                          SizedBox(
                                            width: 3.0,
                                          ),
                                          Text(
                                            'Pending Expert',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                color:
                                                    pureWhite.withOpacity(0.5),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: contributorBadge),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(Icons.person_add_rounded,
                                              size: 14,
                                              color:
                                                  pureWhite.withOpacity(0.5)),
                                          SizedBox(
                                            width: 3.0,
                                          ),
                                          Text(
                                            'Contributor',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                                color:
                                                    pureWhite.withOpacity(0.5),
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    )
                        ],
                      ),
                    ),
                  ),
            ...appController.isLoggedIn
                ? (appController.userIsExpert ?? false)
                    ? DrawerItems.withExpert.map(buildDrawerItem).toList()
                    : DrawerItems.withUser.map(buildDrawerItem).toList()
                : DrawerItems.regular.map(buildDrawerItem).toList(),
            appController.isLoggedIn
                ? Expanded(
                    flex: appController.userIsExpert ?? false ? 2 : 1,
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: GestureDetector(
                        onTap: Feedback.wrapForTap(() {
                          appController.isLoggedIn
                              ? controller.logoutUser()
                              : null;
                        }, context),
                        child: Container(
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: pureWhite,
                                  width: 3.0,
                                )),
                            height: 50,
                            width: 100,
                            child: Text(
                              "LOGOUT",
                              style: GoogleFonts.poppins(
                                  color: pureWhite,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15),
                            )),
                      ),
                    ),
                  )
                : Expanded(flex: 1, child: Container()),
          ],
        )),
      );

  Widget buildDrawerItem(DrawerItem item) {
    return ListTileTheme(
      selectedColor: primaryOrangeDark,
      iconColor: primaryOrangeDark,
      child: ListTile(
        textColor: pureWhite,
        selectedTileColor: pureWhite,
        selected: currentItem == item,
        minLeadingWidth: 30,
        iconColor: pureWhite,
        leading: Container(
          width: 28,
          height: 28,
          child: SvgPicture.asset(
            item.icon,
            colorFilter: ColorFilter.mode(
                currentItem == item ? primaryOrangeDark : pureWhite,
                BlendMode.srcIn),
          ),
        ),
        title: Text(
          item.title,
          style:
              GoogleFonts.robotoSlab(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        onTap: () {
          onSelectedItem(item);
          if (Get.isRegistered<HomePageController>()) {
            final homeController = Get.find<HomePageController>();
            if (currentItem == DrawerItems.home ||
                currentItem == DrawerItems.browse) {
              homeController.coastController.animateTo(
                  beach: item == DrawerItems.home ? 0 : 1,
                  duration: Duration(milliseconds: 50));
            }
          }
        },
      ),
    );
  }
}
