import 'dart:io';

import 'package:amanu/components/browse_card.dart';
import 'package:amanu/components/loader_dialog.dart';
import 'package:amanu/screens/details_screen/detail_screen.dart';
import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/profile_screen/controllers/profile_screen_controller.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

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

  final AudioPlayer player = AudioPlayer();

  final drawerController = Get.find<DrawerXController>();
  final appController = Get.find<ApplicationController>();
  late final controller =
      Get.put(ProfileController(isOtherProfile: !ownProfile, userID: userID));

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.only(bottom: screenPadding.bottom),
      child: Scaffold(
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
                child: Obx(
                  () => controller.userNotFound.value
                      ? controller.isProcessing.value
                          ? Container()
                          : Center(
                              child: Text(
                                "User not found",
                                style: TextStyle(
                                    fontSize: 16, color: disabledGrey),
                              ),
                            )
                      : SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Obx(
                                  () => Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: pureWhite,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: primaryOrangeDark
                                                .withOpacity(0.65),
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    height: 120,
                                                    width: 120,
                                                    margin: EdgeInsets.only(
                                                        bottom: 7.5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(60),
                                                        border: Border.all(
                                                            width: 4,
                                                            color:
                                                                primaryOrangeDark)),
                                                    padding: EdgeInsets.all(5),
                                                    child: controller.userPic
                                                                .value ==
                                                            ''
                                                        ? Container(
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            60),
                                                                color:
                                                                    lightGrey),
                                                            child: Icon(
                                                              Icons
                                                                  .person_rounded,
                                                              size: 60,
                                                              color: pureWhite
                                                                  .withOpacity(
                                                                      0.5),
                                                            ))
                                                        : Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          60),
                                                              image: ownProfile
                                                                  ? DecorationImage(
                                                                      image: FileImage(File(controller
                                                                          .userPic
                                                                          .value)),
                                                                      fit: BoxFit
                                                                          .cover)
                                                                  : DecorationImage(
                                                                      image: NetworkImage(controller
                                                                          .userPic
                                                                          .value),
                                                                      fit: BoxFit
                                                                          .cover),
                                                            ),
                                                          ),
                                                  ),
                                                  Positioned(
                                                    bottom: 0,
                                                    child: controller
                                                            .userIsAdmin.value
                                                        ? Container(
                                                            height: 23,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 7.5,
                                                            ),
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    expertBadge,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: adminBadge
                                                                        .withOpacity(
                                                                            0.65),
                                                                    blurRadius:
                                                                        10,
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
                                                                      .admin_panel_settings_rounded,
                                                                  size: 15,
                                                                  color: pureWhite
                                                                      .withOpacity(
                                                                          0.5),
                                                                ),
                                                                SizedBox(
                                                                  width: 2.5,
                                                                ),
                                                                Text(
                                                                  tAdmin,
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
                                                        : controller
                                                                .userIsExpert
                                                                .value
                                                            ? Container(
                                                                height: 23,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                  horizontal:
                                                                      7.5,
                                                                ),
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        expertBadge,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: expertBadge
                                                                            .withOpacity(0.65),
                                                                        blurRadius:
                                                                            10,
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
                                                                          .verified_rounded,
                                                                      size: 15,
                                                                      color: muteBlack
                                                                          .withOpacity(
                                                                              0.5),
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          2.5,
                                                                    ),
                                                                    Text(
                                                                      tExpert,
                                                                      style: TextStyle(
                                                                          color: muteBlack.withOpacity(
                                                                              0.5),
                                                                          fontSize:
                                                                              11.5,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    )
                                                                  ],
                                                                ),
                                                              )
                                                            : (!controller
                                                                        .userIsExpert
                                                                        .value &&
                                                                    controller
                                                                        .userExpertRequest
                                                                        .value)
                                                                ? Container(
                                                                    height: 23,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          7.5,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        color:
                                                                            darkGrey,
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                darkGrey.withOpacity(0.65),
                                                                            blurRadius:
                                                                                10,
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
                                                                          size:
                                                                              15,
                                                                          color:
                                                                              pureWhite.withOpacity(0.5),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2.5,
                                                                        ),
                                                                        Text(
                                                                          tPending,
                                                                          style: TextStyle(
                                                                              color: pureWhite.withOpacity(0.5),
                                                                              fontSize: 11.5,
                                                                              fontWeight: FontWeight.w600),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  )
                                                                : Container(
                                                                    height: 23,
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          7.5,
                                                                    ),
                                                                    decoration: BoxDecoration(
                                                                        color:
                                                                            contributorBadge,
                                                                        borderRadius:
                                                                            BorderRadius.circular(20),
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                contributorBadge.withOpacity(0.65),
                                                                            blurRadius:
                                                                                10,
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
                                                                          size:
                                                                              15,
                                                                          color:
                                                                              pureWhite.withOpacity(0.5),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              2.5,
                                                                        ),
                                                                        Text(
                                                                          tContributor,
                                                                          style: TextStyle(
                                                                              color: pureWhite.withOpacity(0.5),
                                                                              fontSize: 11.5,
                                                                              fontWeight: FontWeight.w600),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                  ),
                                                  ownProfile
                                                      ? Positioned(
                                                          right: 0,
                                                          top: 2.5,
                                                          child:
                                                              GestureDetector(
                                                            onTap: Feedback
                                                                .wrapForTap(() {
                                                              controller
                                                                  .populateFields();
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Dialog(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(30.0)),
                                                                      child:
                                                                          Stack(
                                                                        children: [
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(color: pureWhite, borderRadius: BorderRadius.circular(30.0)),
                                                                            margin:
                                                                                EdgeInsets.only(right: 12, top: 12),
                                                                            width:
                                                                                double.infinity,
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Container(
                                                                                  alignment: Alignment.center,
                                                                                  width: double.infinity,
                                                                                  height: 60,
                                                                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                                                                  decoration: BoxDecoration(color: primaryOrangeDark, borderRadius: BorderRadius.vertical(top: Radius.circular(30.0))),
                                                                                  child: Text(
                                                                                    "Edit profile",
                                                                                    style: GoogleFonts.robotoSlab(fontSize: 24, color: pureWhite, fontWeight: FontWeight.bold),
                                                                                  ),
                                                                                ),
                                                                                Flexible(
                                                                                  child: Container(
                                                                                    constraints: BoxConstraints(
                                                                                      maxHeight: size.height * 0.6,
                                                                                    ),
                                                                                    width: double.infinity,
                                                                                    padding: EdgeInsets.fromLTRB(20, 20, 10, 20),
                                                                                    child: Scrollbar(
                                                                                      child: SingleChildScrollView(
                                                                                        physics: BouncingScrollPhysics(),
                                                                                        child: Form(
                                                                                          key: controller.editAccountFormKey,
                                                                                          autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                                          child: Container(
                                                                                            padding: EdgeInsets.only(right: 10),
                                                                                            child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                                                              Container(
                                                                                                  height: 105,
                                                                                                  child: Stack(
                                                                                                    alignment: Alignment.center,
                                                                                                    children: [
                                                                                                      Positioned(
                                                                                                        top: 0,
                                                                                                        child: Container(
                                                                                                          margin: EdgeInsets.only(bottom: 10),
                                                                                                          child: Obx(
                                                                                                            () => Container(
                                                                                                              height: 100,
                                                                                                              width: 100,
                                                                                                              margin: EdgeInsets.only(bottom: 7.5),
                                                                                                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(60), border: Border.all(width: 4, color: primaryOrangeDark)),
                                                                                                              padding: EdgeInsets.all(5),
                                                                                                              child: controller.newProfilePath.value == '' && controller.userPic == ''
                                                                                                                  ? Container(
                                                                                                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(60), color: lightGrey),
                                                                                                                      child: Icon(
                                                                                                                        Icons.person_rounded,
                                                                                                                        size: 60,
                                                                                                                        color: pureWhite.withOpacity(0.5),
                                                                                                                      ))
                                                                                                                  : Container(
                                                                                                                      decoration: BoxDecoration(
                                                                                                                        borderRadius: BorderRadius.circular(60),
                                                                                                                        image: controller.newProfilePath.value != '' ? DecorationImage(image: FileImage(controller.newProfile), fit: BoxFit.cover) : DecorationImage(image: FileImage(File(controller.userPic.value)), fit: BoxFit.cover),
                                                                                                                      ),
                                                                                                                    ),
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      ),
                                                                                                      Positioned(
                                                                                                        bottom: 0,
                                                                                                        child: GestureDetector(
                                                                                                          onTap: Feedback.wrapForTap(() {
                                                                                                            showDialog(
                                                                                                                context: context,
                                                                                                                builder: (BuildContext context) {
                                                                                                                  return Dialog(
                                                                                                                    backgroundColor: Colors.transparent,
                                                                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                                                                                                                    child: Stack(
                                                                                                                      children: [
                                                                                                                        Container(
                                                                                                                          decoration: BoxDecoration(color: pureWhite, borderRadius: BorderRadius.circular(30.0)),
                                                                                                                          margin: EdgeInsets.only(right: 12, top: 12),
                                                                                                                          width: double.infinity,
                                                                                                                          child: Column(
                                                                                                                            mainAxisSize: MainAxisSize.min,
                                                                                                                            children: [
                                                                                                                              Container(
                                                                                                                                alignment: Alignment.center,
                                                                                                                                width: double.infinity,
                                                                                                                                height: 60,
                                                                                                                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                                                                                                                decoration: BoxDecoration(color: primaryOrangeDark, borderRadius: BorderRadius.vertical(top: Radius.circular(30.0))),
                                                                                                                                child: Text(
                                                                                                                                  "Change options",
                                                                                                                                  style: GoogleFonts.robotoSlab(fontSize: 24, color: pureWhite, fontWeight: FontWeight.bold),
                                                                                                                                ),
                                                                                                                              ),
                                                                                                                              Container(
                                                                                                                                width: double.infinity,
                                                                                                                                padding: EdgeInsets.all(15.0),
                                                                                                                                child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                                                                                                  Container(
                                                                                                                                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                                                                                                                    width: double.infinity,
                                                                                                                                    child: ElevatedButton(
                                                                                                                                        onPressed: () async {
                                                                                                                                          await controller.getUserPhoto(ImageSource.camera);
                                                                                                                                          Navigator.of(context).pop();
                                                                                                                                        },
                                                                                                                                        style: ElevatedButton.styleFrom(
                                                                                                                                          elevation: 10,
                                                                                                                                          shadowColor: primaryOrangeDark.withOpacity(0.5),
                                                                                                                                          backgroundColor: pureWhite,
                                                                                                                                          alignment: Alignment.center,
                                                                                                                                          minimumSize: Size(100, 40),
                                                                                                                                          shape: RoundedRectangleBorder(
                                                                                                                                            borderRadius: BorderRadius.circular(20),
                                                                                                                                          ),
                                                                                                                                        ),
                                                                                                                                        child: Row(
                                                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                                          children: [
                                                                                                                                            Icon(
                                                                                                                                              Icons.photo_camera_rounded,
                                                                                                                                              size: 20,
                                                                                                                                              color: primaryOrangeDark,
                                                                                                                                            ),
                                                                                                                                            SizedBox(
                                                                                                                                              width: 5,
                                                                                                                                            ),
                                                                                                                                            Text(
                                                                                                                                              "Take a picture",
                                                                                                                                              textAlign: TextAlign.center,
                                                                                                                                              style: GoogleFonts.poppins(
                                                                                                                                                fontSize: 14.0,
                                                                                                                                                fontWeight: FontWeight.w600,
                                                                                                                                                color: primaryOrangeDark,
                                                                                                                                                letterSpacing: 1.0,
                                                                                                                                              ),
                                                                                                                                            ),
                                                                                                                                          ],
                                                                                                                                        )),
                                                                                                                                  ),
                                                                                                                                  SizedBox(
                                                                                                                                    height: 5,
                                                                                                                                  ),
                                                                                                                                  Container(
                                                                                                                                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                                                                                                                    width: double.infinity,
                                                                                                                                    child: ElevatedButton(
                                                                                                                                        onPressed: () async {
                                                                                                                                          await controller.getUserPhoto(ImageSource.gallery);
                                                                                                                                          Navigator.of(context).pop();
                                                                                                                                        },
                                                                                                                                        style: ElevatedButton.styleFrom(
                                                                                                                                          elevation: 10,
                                                                                                                                          shadowColor: primaryOrangeDark.withOpacity(0.5),
                                                                                                                                          backgroundColor: pureWhite,
                                                                                                                                          alignment: Alignment.center,
                                                                                                                                          minimumSize: Size(100, 40),
                                                                                                                                          shape: RoundedRectangleBorder(
                                                                                                                                            borderRadius: BorderRadius.circular(20),
                                                                                                                                          ),
                                                                                                                                        ),
                                                                                                                                        child: Row(
                                                                                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                                                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                                                          children: [
                                                                                                                                            Icon(
                                                                                                                                              Icons.photo_library_rounded,
                                                                                                                                              size: 20,
                                                                                                                                              color: primaryOrangeDark,
                                                                                                                                            ),
                                                                                                                                            SizedBox(
                                                                                                                                              width: 5,
                                                                                                                                            ),
                                                                                                                                            Text(
                                                                                                                                              "Select from gallery",
                                                                                                                                              textAlign: TextAlign.center,
                                                                                                                                              style: GoogleFonts.poppins(
                                                                                                                                                fontSize: 14.0,
                                                                                                                                                fontWeight: FontWeight.w600,
                                                                                                                                                color: primaryOrangeDark,
                                                                                                                                                letterSpacing: 1.0,
                                                                                                                                              ),
                                                                                                                                            ),
                                                                                                                                          ],
                                                                                                                                        )),
                                                                                                                                  ),
                                                                                                                                ]),
                                                                                                                              ),
                                                                                                                            ],
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                        Positioned(
                                                                                                                          right: 0.0,
                                                                                                                          child: GestureDetector(
                                                                                                                            onTap: () {
                                                                                                                              Navigator.of(context).pop();
                                                                                                                            },
                                                                                                                            child: Align(
                                                                                                                              alignment: Alignment.topRight,
                                                                                                                              child: CircleAvatar(
                                                                                                                                radius: 18.0,
                                                                                                                                backgroundColor: Colors.white,
                                                                                                                                child: Icon(Icons.close, color: primaryOrangeDark),
                                                                                                                              ),
                                                                                                                            ),
                                                                                                                          ),
                                                                                                                        ),
                                                                                                                      ],
                                                                                                                    ),
                                                                                                                  );
                                                                                                                });
                                                                                                          }, context),
                                                                                                          child: Container(
                                                                                                            height: 20,
                                                                                                            padding: EdgeInsets.symmetric(
                                                                                                              horizontal: 7.5,
                                                                                                            ),
                                                                                                            decoration: BoxDecoration(color: primaryOrangeDark, borderRadius: BorderRadius.circular(20), boxShadow: [
                                                                                                              BoxShadow(
                                                                                                                color: primaryOrangeDark.withOpacity(0.65),
                                                                                                                blurRadius: 10,
                                                                                                                spreadRadius: -4,
                                                                                                              ),
                                                                                                            ]),
                                                                                                            child: Row(
                                                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                                                              children: [
                                                                                                                Icon(Icons.image, size: 15, color: pureWhite),
                                                                                                                SizedBox(
                                                                                                                  width: 2.5,
                                                                                                                ),
                                                                                                                Text(
                                                                                                                  "CHANGE",
                                                                                                                  style: TextStyle(color: pureWhite, fontSize: 11, fontWeight: FontWeight.w600),
                                                                                                                )
                                                                                                              ],
                                                                                                            ),
                                                                                                          ),
                                                                                                        ),
                                                                                                      )
                                                                                                    ],
                                                                                                  )),
                                                                                              SizedBox(
                                                                                                height: 20,
                                                                                              ),
                                                                                              TextFormField(
                                                                                                controller: controller.userNameController,
                                                                                                maxLength: 30,
                                                                                                onChanged: (value) {
                                                                                                  controller.checkUserName();
                                                                                                },
                                                                                                onSaved: (value) {
                                                                                                  controller.newUserName = value!;
                                                                                                },
                                                                                                validator: (value) {
                                                                                                  if (value != null) {
                                                                                                    return controller.validateUserName(value);
                                                                                                  } else {
                                                                                                    return "Enter a valid username";
                                                                                                  }
                                                                                                },
                                                                                                decoration: InputDecoration(prefixIcon: Icon(Icons.person_outline_outlined), labelText: tUsername, hintText: tUsername, border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 10.0,
                                                                                              ),
                                                                                              TextFormField(
                                                                                                controller: controller.phoneNoController,
                                                                                                onSaved: (value) {
                                                                                                  controller.newPhoneNo = value!;
                                                                                                },
                                                                                                keyboardType: TextInputType.phone,
                                                                                                validator: (value) {
                                                                                                  if (value != null) {
                                                                                                    return controller.validatePhone(value);
                                                                                                  } else {
                                                                                                    return "Enter a valid 10-digit number";
                                                                                                  }
                                                                                                },
                                                                                                decoration: InputDecoration(prefixIcon: Icon(Icons.phone_outlined), prefixText: "+63 ", labelText: tContact, hintText: "xxxxxxxxxx", border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
                                                                                              ),
                                                                                              controller.userIsExpert.value
                                                                                                  ? Column(
                                                                                                      mainAxisSize: MainAxisSize.min,
                                                                                                      children: [
                                                                                                        SizedBox(
                                                                                                          height: 10.0,
                                                                                                        ),
                                                                                                        TextFormField(
                                                                                                          controller: controller.exFullNameController,
                                                                                                          onSaved: (value) {
                                                                                                            controller.newExFullName = value!;
                                                                                                          },
                                                                                                          validator: (value) {
                                                                                                            if (value != null) {
                                                                                                              return controller.validateExFullName(value);
                                                                                                            } else {
                                                                                                              return "Enter a valid name";
                                                                                                            }
                                                                                                          },
                                                                                                          decoration: InputDecoration(prefixIcon: Icon(Icons.person_outline_outlined), labelText: tName, hintText: tName, border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
                                                                                                        ),
                                                                                                        SizedBox(
                                                                                                          height: 10.0,
                                                                                                        ),
                                                                                                        TextFormField(
                                                                                                          controller: controller.exBioController,
                                                                                                          onSaved: (value) {
                                                                                                            controller.newExBio = value!;
                                                                                                          },
                                                                                                          validator: (value) {
                                                                                                            if (value != null) {
                                                                                                              return controller.validateBio(value);
                                                                                                            } else {
                                                                                                              return "Please describe your self and profession.";
                                                                                                            }
                                                                                                          },
                                                                                                          maxLines: 5,
                                                                                                          maxLength: 200,
                                                                                                          decoration: InputDecoration(labelText: tBio, alignLabelWithHint: true, hintText: tEnterBio, hintMaxLines: 5, border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
                                                                                                        ),
                                                                                                      ],
                                                                                                    )
                                                                                                  : Container(),
                                                                                              SizedBox(
                                                                                                height: 10.0,
                                                                                              ),
                                                                                              Container(
                                                                                                  width: double.infinity,
                                                                                                  alignment: Alignment.center,
                                                                                                  child: Text(
                                                                                                    "PRIVACY SETTINGS",
                                                                                                    style: GoogleFonts.robotoSlab(fontSize: 20, color: primaryOrangeDark, fontWeight: FontWeight.w600),
                                                                                                  )),
                                                                                              SizedBox(
                                                                                                height: 10.0,
                                                                                              ),
                                                                                              Container(
                                                                                                padding: EdgeInsets.symmetric(vertical: 5),
                                                                                                width: double.infinity,
                                                                                                alignment: Alignment.center,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      margin: EdgeInsets.only(right: 10),
                                                                                                      child: Text(
                                                                                                        "Publicize Email:",
                                                                                                        style: TextStyle(fontSize: 14, color: disabledGrey),
                                                                                                      ),
                                                                                                    ),
                                                                                                    Container(
                                                                                                      child: Obx(
                                                                                                        () => FlutterSwitch(
                                                                                                          padding: 2,
                                                                                                          width: 55,
                                                                                                          height: 30,
                                                                                                          valueFontSize: 12,
                                                                                                          toggleSize: 26,
                                                                                                          value: controller.newEmailPublic.value,
                                                                                                          borderRadius: 30,
                                                                                                          showOnOff: true,
                                                                                                          onToggle: (value) {
                                                                                                            controller.newEmailPublic.value = value;
                                                                                                          },
                                                                                                          activeColor: primaryOrangeDark,
                                                                                                        ),
                                                                                                      ),
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              Container(
                                                                                                padding: EdgeInsets.symmetric(vertical: 5),
                                                                                                width: double.infinity,
                                                                                                alignment: Alignment.center,
                                                                                                child: Row(
                                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                    Container(
                                                                                                      margin: EdgeInsets.only(right: 10),
                                                                                                      child: Text(
                                                                                                        "Publicize Phone:",
                                                                                                        style: TextStyle(fontSize: 14, color: disabledGrey),
                                                                                                      ),
                                                                                                    ),
                                                                                                    Container(
                                                                                                      child: Obx(
                                                                                                        () => FlutterSwitch(
                                                                                                          padding: 2,
                                                                                                          width: 55,
                                                                                                          height: 30,
                                                                                                          valueFontSize: 12,
                                                                                                          toggleSize: 26,
                                                                                                          value: controller.newPhonePublic.value,
                                                                                                          borderRadius: 30,
                                                                                                          showOnOff: true,
                                                                                                          onToggle: (value) {
                                                                                                            controller.newPhonePublic.value = value;
                                                                                                          },
                                                                                                          activeColor: primaryOrangeDark,
                                                                                                        ),
                                                                                                      ),
                                                                                                    )
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                              SizedBox(
                                                                                                height: 10.0,
                                                                                              ),
                                                                                              !controller.userIsExpert.value
                                                                                                  ? Container(
                                                                                                      padding: EdgeInsets.only(
                                                                                                        left: 10,
                                                                                                        right: 10,
                                                                                                      ),
                                                                                                      width: double.infinity,
                                                                                                      child: ElevatedButton(
                                                                                                          onPressed: () async {
                                                                                                            if (appController.hasConnection.value) {
                                                                                                              if (controller.userExpertRequest.value) {
                                                                                                                controller.newExpertRequest = false;
                                                                                                                showLoaderDialog(context);
                                                                                                                await controller.updateUserDetails().whenComplete(() {
                                                                                                                  Navigator.of(context).pop();
                                                                                                                });
                                                                                                              } else {
                                                                                                                controller.newExpertRequest = true;
                                                                                                                showLoaderDialog(context);
                                                                                                                await controller.updateUserDetails().whenComplete(() {
                                                                                                                  Navigator.of(context).pop();
                                                                                                                });
                                                                                                              }
                                                                                                            } else {
                                                                                                              appController.showConnectionSnackbar();
                                                                                                            }
                                                                                                          },
                                                                                                          style: ElevatedButton.styleFrom(
                                                                                                            backgroundColor: primaryOrangeLight,
                                                                                                            alignment: Alignment.center,
                                                                                                            minimumSize: Size(100, 45),
                                                                                                            shape: RoundedRectangleBorder(
                                                                                                              borderRadius: BorderRadius.circular(20),
                                                                                                            ),
                                                                                                          ),
                                                                                                          child: Text(
                                                                                                            controller.userExpertRequest.value ? tCancelExpertRequest : tUpgradeExpert,
                                                                                                            textAlign: TextAlign.center,
                                                                                                            style: GoogleFonts.poppins(
                                                                                                              fontSize: 16.0,
                                                                                                              fontWeight: FontWeight.w600,
                                                                                                              color: pureWhite,
                                                                                                              height: 1,
                                                                                                              letterSpacing: 1.0,
                                                                                                            ),
                                                                                                          )),
                                                                                                    )
                                                                                                  : Container(),
                                                                                            ]),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                                                                  width: double.infinity,
                                                                                  child: ElevatedButton(
                                                                                      onPressed: () async {
                                                                                        if (appController.hasConnection.value) {
                                                                                          showLoaderDialog(context);
                                                                                          await controller.updateUserDetails().whenComplete(() {
                                                                                            Navigator.of(context).pop();
                                                                                          });
                                                                                        }
                                                                                      },
                                                                                      style: ElevatedButton.styleFrom(
                                                                                        alignment: Alignment.center,
                                                                                        minimumSize: Size(100, 45),
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(20),
                                                                                        ),
                                                                                      ),
                                                                                      child: Text(
                                                                                        tSaveChanges.toUpperCase(),
                                                                                        textAlign: TextAlign.center,
                                                                                        style: GoogleFonts.poppins(
                                                                                          fontSize: 16.0,
                                                                                          fontWeight: FontWeight.w600,
                                                                                          color: pureWhite,
                                                                                          letterSpacing: 1.0,
                                                                                        ),
                                                                                      )),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Positioned(
                                                                            right:
                                                                                0.0,
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                Navigator.of(context).pop();
                                                                              },
                                                                              child: Align(
                                                                                alignment: Alignment.topRight,
                                                                                child: CircleAvatar(
                                                                                  radius: 18.0,
                                                                                  backgroundColor: Colors.white,
                                                                                  child: Icon(Icons.close, color: primaryOrangeDark),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  });
                                                            }, context),
                                                            child: Container(
                                                              height: 32,
                                                              width: 32,
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      pureWhite,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: primaryOrangeDark
                                                                          .withOpacity(
                                                                              0.65),
                                                                      blurRadius:
                                                                          10,
                                                                      spreadRadius:
                                                                          -4,
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
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      1.5),
                                                          child: Text(
                                                            controller
                                                                .userName.value,
                                                            style: GoogleFonts
                                                                .robotoSlab(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 22,
                                                              color:
                                                                  primaryOrangeDark,
                                                            ),
                                                          ),
                                                        ),
                                                        controller.userIsExpert
                                                                    .value &&
                                                                controller
                                                                        .userFullName
                                                                        .value !=
                                                                    ''
                                                            ? Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            1.5),
                                                                child: Text(
                                                                  controller
                                                                      .userFullName
                                                                      .value,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        cardText,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                        controller
                                                                .userEmailPublic
                                                                .value
                                                            ? Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            1.5),
                                                                child: Text(
                                                                  controller
                                                                      .userEmail
                                                                      .value,
                                                                  style:
                                                                      TextStyle(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        cardText,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                        controller
                                                                .userPhonePublic
                                                                .value
                                                            ? Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            1.5),
                                                                child: Text(
                                                                  "+63" +
                                                                      controller
                                                                          .userPhoneNo
                                                                          .value
                                                                          .toString(),
                                                                  style:
                                                                      TextStyle(
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .italic,
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        cardText,
                                                                  ),
                                                                ),
                                                              )
                                                            : Container(),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        controller.userIsExpert
                                                                    .value &&
                                                                controller
                                                                        .userBio
                                                                        .value !=
                                                                    ''
                                                            ? Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        vertical:
                                                                            1.5),
                                                                child: Text(
                                                                  controller
                                                                      .userBio
                                                                      .value,
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    color:
                                                                        cardText,
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
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                              (controller.contributionCount !=
                                                      ''
                                                  ? " (${controller.contributionCount})"
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
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: (controller
                                                .userContributions.length ==
                                            0)
                                        ? Container(
                                            child: Text(
                                              "No contributions yet.",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: disabledGrey),
                                            ),
                                          )
                                        : Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: List.generate(
                                                controller.userContributions
                                                    .length, (index) {
                                              String wordID = controller
                                                  .userContributions[index];
                                              List<String> type = [];
                                              for (var meaning in appController
                                                      .dictionaryContent[wordID]
                                                  ['meanings']) {
                                                type.add(
                                                    meaning["partOfSpeech"]);
                                              }
                                              return BrowseCard(
                                                onTap: () =>
                                                    Get.to(() => DetailScreen(
                                                          wordID: wordID,
                                                        )),
                                                wordId: wordID,
                                                word: appController
                                                        .dictionaryContent[
                                                    wordID]["word"],
                                                type: type,
                                                prnLink: appController
                                                            .dictionaryContent[
                                                        wordID]
                                                    ["pronunciationAudio"],
                                                engTrans: appController
                                                                    .dictionaryContent[
                                                                wordID][
                                                            "englishTranslations"] ==
                                                        null
                                                    ? []
                                                    : appController
                                                                .dictionaryContent[
                                                            wordID]
                                                        ["englishTranslations"],
                                                filTrans: appController
                                                                    .dictionaryContent[
                                                                wordID][
                                                            "filipinoTranslations"] ==
                                                        null
                                                    ? []
                                                    : appController
                                                                .dictionaryContent[
                                                            wordID][
                                                        "filipinoTranslations"],
                                                otherRelated:
                                                    appController.dictionaryContent[
                                                                    wordID][
                                                                "otherRelated"] ==
                                                            null
                                                        ? []
                                                        : appController
                                                            .dictionaryContent[
                                                                wordID]
                                                                ["otherRelated"]
                                                            .keys
                                                            .toList(),
                                                synonyms:
                                                    appController.dictionaryContent[
                                                                    wordID]
                                                                ["synonyms"] ==
                                                            null
                                                        ? []
                                                        : appController
                                                            .dictionaryContent[
                                                                wordID]
                                                                ["synonyms"]
                                                            .keys
                                                            .toList(),
                                                antonyms:
                                                    appController.dictionaryContent[
                                                                    wordID]
                                                                ["antonyms"] ==
                                                            null
                                                        ? []
                                                        : appController
                                                            .dictionaryContent[
                                                                wordID]
                                                                ["antonyms"]
                                                            .keys
                                                            .toList(),
                                                player: player,
                                              );
                                            }),
                                          ))
                              ],
                            ),
                          ),
                        ),
                )),
          ),
          IsProcessingWithHeader(
              condition: controller.isProcessing,
              size: size,
              screenPadding: screenPadding),
          Obx(
            () => ThreePartHeader(
              size: size,
              screenPadding: screenPadding,
              title: controller.userName.value,
              firstIcon: fromDrawer
                  ? Icons.menu_rounded
                  : Icons.arrow_back_ios_new_rounded,
              firstOnPressed: () {
                fromDrawer
                    ? drawerController.drawerToggle(context)
                    : Get.back();
              },
            ),
          ),
        ],
      )),
    );
  }
}
