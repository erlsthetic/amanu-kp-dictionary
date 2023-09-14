import 'dart:io';

import 'package:amanu/components/confirm_dialog.dart';
import 'package:amanu/components/processing_loader.dart';
import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/controllers/home_page_controller.dart';
import 'package:amanu/models/drawer_item_model.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
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
      required this.controller,
      required this.ctx});
  final DrawerItem currentItem;
  final ValueChanged<DrawerItem> onSelectedItem;
  final DrawerXController controller;
  final BuildContext ctx;

  final appController = Get.find<ApplicationController>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.only(bottom: screenPadding.bottom),
      child: Scaffold(
        backgroundColor: primaryOrangeDark,
        body: Stack(
          children: [
            SafeArea(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GetBuilder<ApplicationController>(
                  builder: (ctl) {
                    return !ctl.isLoggedIn
                        ? Expanded(
                            flex: 3,
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width / 2,
                              child: Container(
                                  height: 130,
                                  width: 130,
                                  child: SvgPicture.asset(
                                      iAmanuWhiteLogoWithLabel)),
                            ),
                          )
                        : Expanded(
                            flex: 4,
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: FittedBox(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 100.0,
                                      width: 100.0,
                                      padding: EdgeInsets.all(7.5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: pureWhite),
                                      child: ctl.userPicLocal == null
                                          ? Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  color: primaryOrangeLight),
                                              child: Icon(
                                                Icons.person_rounded,
                                                size: 60,
                                                color:
                                                    pureWhite.withOpacity(0.5),
                                              ))
                                          : Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(60),
                                                  image: DecorationImage(
                                                      image: FileImage(File(
                                                          ctl.userPicLocal!)),
                                                      fit: BoxFit.cover)),
                                            ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      width: (size.width * 0.5) - 20,
                                      child: Text(
                                        'Hello, ' + ctl.userName!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                            height: 1.2,
                                            color: pureWhite,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    ctl.isLoggedIn && (ctl.userIsAdmin ?? false)
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 4, horizontal: 8),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: adminBadge),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                    Icons
                                                        .admin_panel_settings_rounded,
                                                    size: 14,
                                                    color: pureWhite
                                                        .withOpacity(0.5)),
                                                SizedBox(
                                                  width: 3.0,
                                                ),
                                                Text(
                                                  tAdmin,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                      color: pureWhite
                                                          .withOpacity(0.5),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          )
                                        : ctl.isLoggedIn &&
                                                (ctl.userIsExpert ?? false)
                                            ? Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 4, horizontal: 8),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: expertBadge),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.verified_rounded,
                                                        size: 14,
                                                        color: muteBlack
                                                            .withOpacity(0.5)),
                                                    SizedBox(
                                                      width: 3.0,
                                                    ),
                                                    Text(
                                                      tExpert,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: muteBlack
                                                                  .withOpacity(
                                                                      0.5),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : ctl.userExpertRequest ?? false
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 8),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color: darkGrey),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .pending_actions_rounded,
                                                            size: 14,
                                                            color: pureWhite
                                                                .withOpacity(
                                                                    0.5)),
                                                        SizedBox(
                                                          width: 3.0,
                                                        ),
                                                        Text(
                                                          tPending,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts.poppins(
                                                              color: pureWhite
                                                                  .withOpacity(
                                                                      0.5),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                : Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 4,
                                                            horizontal: 8),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        color:
                                                            contributorBadge),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                            Icons
                                                                .person_add_rounded,
                                                            size: 14,
                                                            color: pureWhite
                                                                .withOpacity(
                                                                    0.5)),
                                                        SizedBox(
                                                          width: 3.0,
                                                        ),
                                                        Text(
                                                          tContributor,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: GoogleFonts.poppins(
                                                              color: pureWhite
                                                                  .withOpacity(
                                                                      0.5),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                  ],
                                ),
                              ),
                            ),
                          );
                  },
                ),
                ...appController.isLoggedIn
                    ? (appController.userIsExpert ?? false)
                        ? DrawerItems.withExpert.map(buildDrawerItem).toList()
                        : DrawerItems.withUser.map(buildDrawerItem).toList()
                    : DrawerItems.regular.map(buildDrawerItem).toList(),
                appController.isLoggedIn
                    ? Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: GestureDetector(
                            onTap: Feedback.wrapForTap(() {
                              appController.isLoggedIn
                                  ? showConfirmDialog(
                                      context,
                                      "Logout",
                                      "Are you sure you want to log out?",
                                      "Logout",
                                      "Cancel", () {
                                      controller.logoutUser(context);
                                    }, () {
                                      Navigator.of(context).pop();
                                    })
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
                    : Expanded(flex: 2, child: Container()),
              ],
            )),
            Obx(() => controller.isProcessing.value
                ? IsProcessingLoader(size: size)
                : Container())
          ],
        ),
      ),
    );
  }

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
          final homeController = Get.find<HomePageController>();
          if ((currentItem == DrawerItems.home && item == DrawerItems.browse) ||
              (currentItem == DrawerItems.browse && item == DrawerItems.home)) {
            ZoomDrawer.of(ctx)!.toggle();
            homeController.coastController.animateTo(
                beach: item == DrawerItems.home ? 0 : 1,
                duration: Duration(milliseconds: 300));
          } else {
            onSelectedItem(item);
          }
        },
      ),
    );
  }
}
