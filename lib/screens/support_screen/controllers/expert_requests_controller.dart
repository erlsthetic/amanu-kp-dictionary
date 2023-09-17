import 'dart:io';

import 'package:amanu/components/browse_card.dart';
import 'package:amanu/components/info_dialog.dart';
import 'package:amanu/components/loader_dialog.dart';
import 'package:amanu/models/user_model.dart';
import 'package:amanu/screens/details_screen/detail_screen.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:open_file/open_file.dart';
import 'package:shimmer/shimmer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ExpertRequestsController extends GetxController {
  static ExpertRequestsController get instance => Get.find();
  final appController = Get.find<ApplicationController>();
  RxList<UserModel> expertRequests = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (appController.hasConnection.value) {
      getAllRequests();
    } else {
      appController.showConnectionSnackbar();
    }
  }

  Future getAllRequests() async {
    var snapshot = await DatabaseRepository.instance.getAllExpertRequests();
    expertRequests.clear();
    for (UserModel request in snapshot) {
      expertRequests.add(request);
    }
    expertRequests.refresh();
  }

  Future updateUser(BuildContext context, bool accept, UserModel currentDetails,
      bool fromDetails) async {
    showLoaderDialog(context);
    Map<String, dynamic> newDetails = currentDetails.toJson();
    String userID = currentDetails.uid;
    newDetails["expertRequest"] = false;
    if (accept) {
      newDetails["isExpert"] = true;
    } else {
      newDetails["isExpert"] = false;
    }
    await DatabaseRepository.instance
        .updateUserOnDB(newDetails, userID, true)
        .then((value) {
      Navigator.of(context).pop();
      if (fromDetails) {
        Navigator.of(context).pop();
      }
    });
  }

  Future openCV(String url, BuildContext context) async {
    showLoaderDialog(context);
    final file = await downloadFile(url);
    if (file == null) {
      Helper.errorSnackBar(
          title: tOhSnap, message: "Unable to get CV from the internet.");
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pop();
      print(file.path);
      OpenFile.open(file.path);
    }
  }

  Future<File?> downloadFile(String url) async {
    final appStorage = await getTemporaryDirectory();
    String prnExt = url.split("?").first;
    final fileExt = extension(File(prnExt).path);
    final tempFile = File('${appStorage.path}/cv$fileExt');
    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: Duration(seconds: 15),
        ),
      );
      final raf = tempFile.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      return null;
    }
    return tempFile;
  }

  void openRequest(BuildContext context, int index) {
    List<dynamic> contrib = expertRequests[index].contributions ?? [];
    int contribCount = contrib.length;
    final AudioPlayer player = AudioPlayer();
    showInfoDialog(
        context,
        expertRequests[index].userName,
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
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
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        margin: EdgeInsets.only(bottom: 7.5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                width: 2.5, color: primaryOrangeDark)),
                        padding: EdgeInsets.all(2.5),
                        child: expertRequests[index].profileUrl == null ||
                                expertRequests[index].profileUrl == ''
                            ? Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: lightGrey),
                                child: Icon(
                                  Icons.person_rounded,
                                  size: 40,
                                  color: pureWhite.withOpacity(0.5),
                                ))
                            : Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Image.network(
                                  expertRequests[index].profileUrl!,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Shimmer.fromColors(
                                      child: Container(
                                        height: double.infinity,
                                        width: double.infinity,
                                      ),
                                      baseColor: disabledGrey,
                                      highlightColor: lightGrey,
                                    );
                                  },
                                ),
                              ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 1.5),
                                  child: Text(
                                    expertRequests[index].userName,
                                    style: GoogleFonts.robotoSlab(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: primaryOrangeDark,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 1.5),
                                  child: Text(
                                    expertRequests[index].exFullName ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: cardText,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 1.5),
                                  child: Text(
                                    expertRequests[index].email,
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14,
                                      color: cardText,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 1.5),
                                  child: Text(
                                    "+63" +
                                        expertRequests[index]
                                            .phoneNo
                                            .toString(),
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14,
                                      color: cardText,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                expertRequests[index].exBio != null
                                    ? Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 1.5),
                                        child: Text(
                                          expertRequests[index].exBio ?? '',
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
                  ),
                  expertRequests[index].cvUrl == null
                      ? Container()
                      : Container(
                          margin: EdgeInsets.only(top: 10),
                          child: GestureDetector(
                              onTap: Feedback.wrapForTap(() {
                                if (expertRequests[index].cvUrl != null) {
                                  openCV(expertRequests[index].cvUrl!, context);
                                }
                              }, context),
                              child: Container(
                                  width: double.infinity,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: primaryOrangeLight,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.file_open_rounded,
                                        color: pureWhite,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "OPEN CV",
                                        style: TextStyle(
                                            color: pureWhite,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 14),
                                      )
                                    ],
                                  ))),
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
                      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      child: Text(
                        tContributions.toUpperCase() +
                            (contribCount != 0 ? " (${contribCount})" : ""),
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
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: (contribCount == 0)
                      ? Container(
                          child: Text(
                            "No contributions yet.",
                            style: TextStyle(fontSize: 16, color: disabledGrey),
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(contribCount, (index) {
                            String wordID = contrib[index];
                            List<String> type = [];
                            for (var meaning in appController
                                .dictionaryContent[wordID]['meanings']) {
                              type.add(meaning["partOfSpeech"]);
                            }
                            return BrowseCard(
                              onTap: () => Get.to(
                                  () => DetailScreen(
                                        wordID: wordID,
                                      ),
                                  duration: Duration(milliseconds: 500),
                                  transition: Transition.rightToLeft,
                                  curve: Curves.easeInOut),
                              wordId: wordID,
                              word: appController.dictionaryContent[wordID]
                                  ["word"],
                              type: type,
                              prnLink: appController.dictionaryContent[wordID]
                                  ["pronunciationAudio"],
                              engTrans: appController.dictionaryContent[wordID]
                                          ["englishTranslations"] ==
                                      null
                                  ? []
                                  : appController.dictionaryContent[wordID]
                                      ["englishTranslations"],
                              filTrans: appController.dictionaryContent[wordID]
                                          ["filipinoTranslations"] ==
                                      null
                                  ? []
                                  : appController.dictionaryContent[wordID]
                                      ["filipinoTranslations"],
                              otherRelated: appController
                                              .dictionaryContent[wordID]
                                          ["otherRelated"] ==
                                      null
                                  ? []
                                  : appController
                                      .dictionaryContent[wordID]["otherRelated"]
                                      .keys
                                      .toList(),
                              synonyms: appController.dictionaryContent[wordID]
                                          ["synonyms"] ==
                                      null
                                  ? []
                                  : appController
                                      .dictionaryContent[wordID]["synonyms"]
                                      .keys
                                      .toList(),
                              antonyms: appController.dictionaryContent[wordID]
                                          ["antonyms"] ==
                                      null
                                  ? []
                                  : appController
                                      .dictionaryContent[wordID]["antonyms"]
                                      .keys
                                      .toList(),
                              player: player,
                            );
                          }),
                        ))
            ],
          ),
        ),
        Container(
          height: 70,
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Row(
            children: [
              Expanded(
                child: Material(
                  borderRadius: BorderRadius.circular(25),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () async {
                      await updateUser(
                          context, true, expertRequests[index], true);
                      getAllRequests();
                      player.dispose();
                    },
                    splashColor: primaryOrangeLight,
                    highlightColor: primaryOrangeLight.withOpacity(0.5),
                    child: Ink(
                      height: 50.0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "ACCEPT".toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: pureWhite,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: primaryOrangeDark,
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Material(
                  borderRadius: BorderRadius.circular(25),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () async {
                      await updateUser(
                          context, false, expertRequests[index], true);
                      getAllRequests();
                      player.dispose();
                    },
                    splashColor: primaryOrangeLight,
                    highlightColor: primaryOrangeLight.withOpacity(0.5),
                    child: Ink(
                      height: 50.0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          "DECLINE".toUpperCase(),
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: pureWhite,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: darkerOrange.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ), () {
      player.dispose();
    });
  }
}
