import 'package:amanu/components/coachmark_desc.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomePageController extends GetxController {
  static HomePageController get instance => Get.find();
  HomePageController({required this.wordOfTheDay});

  final appController = Get.find<ApplicationController>();
  final RxInt currentIdx = 0.obs;
  CoastController coastController = CoastController(initialPage: 0);
  CrabController crabController = CrabController();

  @override
  void onInit() async {
    super.onInit();
    print("wordOfTheDay: " + wordOfTheDay);
    wotdFound = appController.dictionaryContent.containsKey(wordOfTheDay);
    await getInformation();
    if (appController.noData.value) {
      Helper.errorSnackBar(
          title: "Dictionary currently has no data",
          message:
              "Please connect to the internet to sync dictionary's data to local device.");
    }
  }

  GlobalKey navigationKey = GlobalKey();
  GlobalKey homeScreenKey = GlobalKey();
  GlobalKey wotdKey = GlobalKey();
  GlobalKey scannerKey = GlobalKey();
  GlobalKey searchKey = GlobalKey();
  GlobalKey drawerKey = GlobalKey();
  GlobalKey requestsKey = GlobalKey();
  GlobalKey browseKey = GlobalKey();
  GlobalKey amanuKey = GlobalKey();

  List<TargetFocus> initTarget() {
    String greeting = '';
    var hour = DateTime.now().hour;
    if (hour < 12) {
      greeting = '<i><b>Mayap á ábac!</b></i>\n';
    } else if (hour >= 12 && hour < 18) {
      greeting = '<i><b>Mayap á gatpanápun!</b></i>\n';
    } else {
      greeting = '<i><b>Mayap á bénği!</b></i>\n';
    }
    return [
      TargetFocus(
          identify: "start-key",
          keyTarget: amanuKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Amánu Walkthrough",
                  text: greeting +
                      "In order to get the most out of your <b>Amánu</b> experience, <i>let's take a tour!</i>",
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
          identify: "home-screen-key",
          keyTarget: homeScreenKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Home Screen",
                  text:
                      "This is the <b>Amánu Home screen</b>. This will always be the start of your <i>venture to the Kapampangan language</i>.",
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
          identify: "wotd-key",
          keyTarget: wotdKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(top: 70),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Word of the Day",
                  text:
                      "Presented in the Home screen is our <b>Word of the Day</b>, that allows you to <i>learn a new Kapampangan word each day!</i>",
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
          identify: "search-key",
          keyTarget: searchKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Search the Dictionary",
                  text:
                      "From the Home screen, you can also start searching for your dictionary queries using the <b>Search button</b>. <i>Easy!</i>",
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
          identify: "request-key",
          keyTarget: requestsKey,
          shape: ShapeLightFocus.Circle,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Quick Access",
                  text:
                      "<b>Want to join Amánu?</b> Click this button and we'll redirect you to our <i>onboarding page</i>.\n\n <b>Already signed in?</b> This will show your profile or the requests coming in for <i>quick access</i>.",
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
          identify: "scanner-key",
          keyTarget: scannerKey,
          shape: ShapeLightFocus.Circle,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "The Kulitan Reader",
                  text:
                      "One of our main features, the <b>Kulitan Reader</b>, can be easily accessed here. This allows you to <i><b>transliterate Kulitan scripts</b> quickly and on the fly</i>.",
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
          identify: "navigation-key",
          keyTarget: navigationKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "The Home Navigation",
                  text:
                      "Navigate between the <b>Home and Browse screen</b> using these navigation buttons, or simply, swipe the screen <b>horizontally</b>.\n <i>It's that simple</i>.",
                  onNext: () async {
                    await coastController.animateTo(beach: 1);
                    currentIdx.value = 1;
                    this.update();
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
          identify: "browse-screen-key",
          keyTarget: homeScreenKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Browse Screen",
                  text:
                      "<i>Now this is the real thing</i>.\nThis is the <b>Browse page</b>. It allows you to <i>browse through the dictionary entries</i> we have here in Amánu.",
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
          identify: "browse-card-key",
          keyTarget: browseKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                top: 10,
              ),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Browsing the dictionary",
                  text:
                      "To browse a particular entry, you can click these <b>dictionary cards</b> and we'll redirect you to its <b>detail page</b>.",
                  onNext: () async {
                    await coastController.animateTo(beach: 0);
                    currentIdx.value = 0;
                    this.update();
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
          identify: "drawer-key",
          keyTarget: drawerKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "The Amánu Drawer",
                  text:
                      "<i>And Amánu doesn't stop there</i>. The <b>Amánu drawer</b> is packed with other features and pages that you might want to explore.",
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
          identify: "ready-key",
          keyTarget: homeScreenKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "You are now ready!",
                  text:
                      "<i>Welcome to <b>Amánu</b>, your Kapampangan Dictionary and Kulitan Script reader.</i>",
                  next: "Let's go!",
                  skip: "",
                  onNext: () {
                    ctl.next();
                  },
                  onSkip: () {},
                  withSkip: false,
                );
              },
            ),
          ]),
    ];
  }

  late BuildContext context;

  onPageChangedCallback(int activePageIndex) {
    currentIdx.value = activePageIndex;
  }

  final String wordOfTheDay;

  String word = '';
  String prn = '';
  String prnUrl = '';
  List<dynamic> engTrans = [];
  List<dynamic> filTrans = [];
  List<dynamic> meanings = [];
  List<String> types = [];
  List<List<Map<dynamic, dynamic>>> definitions = [];
  var kulitanChars = [];
  String kulitanString = '';
  Map<dynamic, dynamic> otherRelated = {};
  Map<dynamic, dynamic> synonyms = {};
  Map<dynamic, dynamic> antonyms = {};
  String sources = '';
  Map<dynamic, dynamic> contributors = {};
  Map<dynamic, dynamic> expert = {};
  String lastModifiedTime = '';

  late bool wotdFound;

  Future getInformation() async {
    if (wordOfTheDay != "" && wotdFound) {
      String wordID = wordOfTheDay;
      word = appController.dictionaryContent[wordID]["word"];
      prn = appController.dictionaryContent[wordID]["pronunciation"];
      prnUrl = appController.dictionaryContent[wordID]["pronunciationAudio"];
      engTrans =
          appController.dictionaryContent[wordID]["englishTranslations"] == null
              ? []
              : appController.dictionaryContent[wordID]["englishTranslations"];
      filTrans = appController.dictionaryContent[wordID]
                  ["filipinoTranslations"] ==
              null
          ? []
          : appController.dictionaryContent[wordID]["filipinoTranslations"];
      meanings =
          appController.dictionaryContent[wordID]["meanings"] as List<dynamic>;
      for (Map<dynamic, dynamic> meaning in meanings) {
        types.add(meaning["partOfSpeech"]);
        List<Map<dynamic, dynamic>> tempDef = [];
        for (Map<dynamic, dynamic> definition in meaning["definitions"]) {
          tempDef.add(definition);
        }
        definitions.add(tempDef);
      }
      kulitanChars = new List.from(
          appController.dictionaryContent[wordID]["kulitan-form"]);
      for (var line in kulitanChars) {
        for (var syl in line) {
          kulitanString = kulitanString + syl;
        }
      }
      otherRelated =
          appController.dictionaryContent[wordID]["otherRelated"] == null
              ? {}
              : appController.dictionaryContent[wordID]["otherRelated"];
      synonyms = appController.dictionaryContent[wordID]["synonyms"] == null
          ? {}
          : appController.dictionaryContent[wordID]["synonyms"];
      antonyms = appController.dictionaryContent[wordID]["antonyms"] == null
          ? {}
          : appController.dictionaryContent[wordID]["antonyms"];
      sources = appController.dictionaryContent[wordID]["sources"] == null
          ? ''
          : appController.dictionaryContent[wordID]["sources"];
      contributors =
          appController.dictionaryContent[wordID]["contributors"] == null
              ? {}
              : appController.dictionaryContent[wordID]["contributors"];
      expert = appController.dictionaryContent[wordID]["expert"] == null
          ? {}
          : appController.dictionaryContent[wordID]["expert"];
      lastModifiedTime =
          appController.dictionaryContent[wordID]["lastModifiedTime"];
    }
  }
}
