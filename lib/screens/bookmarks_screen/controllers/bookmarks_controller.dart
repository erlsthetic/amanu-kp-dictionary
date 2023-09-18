import 'package:amanu/components/coachmark_desc.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class BookmarksController extends GetxController {
  static BookmarksController get instance => Get.find();
  final appController = Get.find<ApplicationController>();

  GlobalKey bookmarksKey = GlobalKey();
  GlobalKey bookmarksListKey = GlobalKey();

  late BuildContext context;

  List<TargetFocus> initTarget() {
    return [
      TargetFocus(
          identify: "bookmarks-key",
          keyTarget: bookmarksKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Bookmarks Screen",
                  text:
                      "This is your <b>Bookmarks screen</b>. This is where all your <i>local bookmarks</i> will be stored.",
                  onNext: () {
                    ctl.next();
                  },
                  onSkip: () {
                    ctl.skip();
                  },
                );
              },
            ),
          ]),
      TargetFocus(
          identify: "bookmarks-list-key",
          keyTarget: bookmarksListKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                bottom: 10,
              ),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Bookmarks Screen",
                  text:
                      "This list will contain all your <b>Bookmark entries</b>. <i>Tap to open</i> the word's details, and <i>swipe horizontally to remove</i> it from the bookmarks.",
                  onNext: () {
                    ctl.next();
                  },
                  next: "Got it!",
                  skip: "",
                  withSkip: false,
                  onSkip: () {},
                );
              },
            ),
          ]),
    ];
  }

  void removeBookmark(String wordID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("bookmarks")) {
      appController.bookmarks.value = prefs.getStringList("bookmarks")!;
      if (appController.bookmarks.contains(wordID)) {
        appController.bookmarks.remove(wordID);
        prefs.setStringList("bookmarks", appController.bookmarks);
      }
    }
  }
}
