import 'dart:io';

import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/profile_screen/controllers/profile_screen_controller.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({
    super.key,
    this.fromDrawer = true,
    this.ownProfile = true,
    this.userID = null,
  });

  final bool fromDrawer;
  final bool ownProfile;
  final String? userID;

  final drawerController = Get.find<DrawerXController>();
  final appController = Get.find<ApplicationController>();
  late final controller =
      Get.put(ProfileController(isOtherProfile: !ownProfile, userID: userID));

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: screenPadding.top + 50,
          left: 0,
          right: 0,
          child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              height: size.height - screenPadding.top - 50,
              width: size.width,
              child: Column(
                children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 15),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: pureWhite,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryOrangeDark.withOpacity(0.65),
                                    blurRadius: 15,
                                    spreadRadius: -8,
                                  ),
                                ]),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            height: 120,
                                            width: 120,
                                            margin:
                                                EdgeInsets.only(bottom: 7.5),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(60),
                                                border: Border.all(
                                                    width: 4,
                                                    color: primaryOrangeDark)),
                                            padding: EdgeInsets.all(5),
                                            child: controller.userPic == null
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(60),
                                                        color: lightGrey),
                                                    child: Icon(
                                                      Icons.person_rounded,
                                                      size: 60,
                                                      color: pureWhite
                                                          .withOpacity(0.5),
                                                    ))
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              60),
                                                      image: ownProfile
                                                          ? DecorationImage(
                                                              image: FileImage(
                                                                  File(controller
                                                                      .userPic!)),
                                                              fit: BoxFit.cover)
                                                          : DecorationImage(
                                                              image: NetworkImage(
                                                                  controller
                                                                      .userPic!),
                                                              fit:
                                                                  BoxFit.cover),
                                                    ),
                                                  ),
                                          ),
                                          Positioned(
                                            bottom: 0,
                                            child: controller.userIsExpert ??
                                                    false
                                                ? Container(
                                                    height: 23,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 7.5,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: expertBadge,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: expertBadge
                                                                .withOpacity(
                                                                    0.65),
                                                            blurRadius: 10,
                                                            spreadRadius: -4,
                                                          ),
                                                        ]),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .verified_rounded,
                                                          size: 15,
                                                          color: muteBlack
                                                              .withOpacity(0.5),
                                                        ),
                                                        SizedBox(
                                                          width: 2.5,
                                                        ),
                                                        Text(
                                                          tExpert,
                                                          style: TextStyle(
                                                              color: muteBlack
                                                                  .withOpacity(
                                                                      0.5),
                                                              fontSize: 11.5,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                : !(controller.userIsExpert ??
                                                            true) &&
                                                        (controller
                                                                .userExpertRequest ??
                                                            false)
                                                    ? Container(
                                                        height: 23,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 7.5,
                                                        ),
                                                        decoration: BoxDecoration(
                                                            color: darkGrey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: darkGrey
                                                                    .withOpacity(
                                                                        0.65),
                                                                blurRadius: 10,
                                                                spreadRadius:
                                                                    -4,
                                                              ),
                                                            ]),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .pending_actions_rounded,
                                                              size: 15,
                                                              color: pureWhite
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            SizedBox(
                                                              width: 2.5,
                                                            ),
                                                            Text(
                                                              tExpert,
                                                              style: TextStyle(
                                                                  color: pureWhite
                                                                      .withOpacity(
                                                                          0.5),
                                                                  fontSize:
                                                                      11.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    : Container(
                                                        height: 23,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 7.5,
                                                        ),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                contributorBadge,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: contributorBadge
                                                                    .withOpacity(
                                                                        0.65),
                                                                blurRadius: 10,
                                                                spreadRadius:
                                                                    -4,
                                                              ),
                                                            ]),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .person_add_rounded,
                                                              size: 15,
                                                              color: pureWhite
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            SizedBox(
                                                              width: 2.5,
                                                            ),
                                                            Text(
                                                              tExpert,
                                                              style: TextStyle(
                                                                  color: pureWhite
                                                                      .withOpacity(
                                                                          0.5),
                                                                  fontSize:
                                                                      11.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                          ),
                                          ownProfile
                                              ? Positioned(
                                                  right: 0,
                                                  top: 2.5,
                                                  child: GestureDetector(
                                                    onTap: Feedback.wrapForTap(
                                                        () {}, context),
                                                    child: Container(
                                                      height: 32,
                                                      width: 32,
                                                      decoration: BoxDecoration(
                                                          color: pureWhite,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: primaryOrangeDark
                                                                  .withOpacity(
                                                                      0.65),
                                                              blurRadius: 10,
                                                              spreadRadius: -4,
                                                            ),
                                                          ]),
                                                      child: Icon(
                                                        Icons.edit,
                                                        size: 18,
                                                        color:
                                                            primaryOrangeDark,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.topLeft,
                                          child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 1.5),
                                                  child: Text(
                                                    controller.userName ??
                                                        "User",
                                                    style:
                                                        GoogleFonts.robotoSlab(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 22,
                                                      color: primaryOrangeDark,
                                                    ),
                                                  ),
                                                ),
                                                (controller.userIsExpert ??
                                                            false) &&
                                                        controller
                                                                .userFullName !=
                                                            null
                                                    ? Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 1.5),
                                                        child: Text(
                                                          controller
                                                              .userFullName!,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: cardText,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 1.5),
                                                  child: Text(
                                                    controller.userEmail ??
                                                        "user@email.com",
                                                    style: TextStyle(
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontSize: 14,
                                                      color: cardText,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                (controller.userIsExpert ??
                                                            false) &&
                                                        controller.userBio !=
                                                            null
                                                    ? Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 1.5),
                                                        child: Text(
                                                          controller.userBio!,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: cardText,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(),
                                              ]),
                                        ),
                                      )
                                    ],
                                  )
                                ]),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 2,
                                    color: primaryOrangeDark,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    tContributions.toUpperCase() +
                                        (controller.contributionCount != null
                                            ? "(${controller.contributionCount})"
                                            : ""),
                                    style: GoogleFonts.robotoSlab(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: primaryOrangeDark,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 2,
                                    color: primaryOrangeDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),
        ThreePartHeader(
          size: size,
          screenPadding: screenPadding,
          title: controller.userName ?? "User",
          firstIcon: fromDrawer
              ? Icons.menu_rounded
              : Icons.arrow_back_ios_new_rounded,
          firstOnPressed: () {
            fromDrawer ? drawerController.drawerToggle(context) : Get.back();
          },
        ),
      ],
    ));
  }
}
