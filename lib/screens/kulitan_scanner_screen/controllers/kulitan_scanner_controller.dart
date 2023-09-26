import 'dart:io';

import 'package:amanu/components/coachmark_desc.dart';
import 'package:amanu/components/coachmark_with_image.dart';
import 'package:amanu/components/info_dialog.dart';
import 'package:amanu/components/loader_dialog.dart';
import 'package:amanu/screens/search_screen/search_screen.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'dart:convert';

import '../../../utils/constants/app_colors.dart';

class KulitanScannerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static KulitanScannerController get instance => Get.find();
  final appController = Get.find<ApplicationController>();
  Image? predictionImage = null;
  TransformationController? transController;
  late AnimationController zoomAnimController;
  Animation<Matrix4>? anim;
  RxBool isVisible = true.obs;

  @override
  void onClose() {
    super.onClose();
    if (transController != null) transController!.dispose();
    zoomAnimController.dispose();
  }

  @override
  void onInit() async {
    super.onInit();
    transController = TransformationController();
    zoomAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            if (transController == null)
              transController = TransformationController();
            transController!.value = anim!.value;
          });
  }

  GlobalKey scannerAllKey = GlobalKey();
  GlobalKey scannerButtonKey = GlobalKey();
  GlobalKey scannerZoomKey = GlobalKey();
  GlobalKey scannerExposureKey = GlobalKey();
  GlobalKey scannerFlashKey = GlobalKey();
  GlobalKey scannerUploadKey = GlobalKey();
  GlobalKey scannerSwitchKey = GlobalKey();

  late BuildContext context;

  List<TargetFocus> initTarget() {
    return [
      TargetFocus(
          identify: "scanner-start-key",
          keyTarget: scannerAllKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Kulitan Reader",
                  text:
                      "This is the <b>Kulitan Reader</b>. Here you can transliterate you written Kulitan scripts to the Latin alphabet.",
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
          identify: "scanner-beta-key",
          keyTarget: scannerAllKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: (MediaQuery.of(context).size.height / 2) -
                      100 -
                      (MediaQuery.of(context).size.width / 2)),
              builder: (context, ctl) {
                return CoachmarkDescWithImage(
                  title: "Kulitan Reader Guide",
                  image: iKulitanReaderGuide,
                  text:
                      "As the <b>Kulitan Reader</b> is still on its beta stages, there are still <i>limitations</i> to its functionality. Please <i>follow these pointers</i> to correctly capture and read your Kulitan scripts.",
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
          identify: "scanner-guide1-key",
          keyTarget: scannerAllKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: (MediaQuery.of(context).size.height / 2) -
                      50 -
                      (MediaQuery.of(context).size.width / 2)),
              builder: (context, ctl) {
                return CoachmarkDescWithImage(
                  title: "Kulitan Reader Guide",
                  image: iKulitanGuide1,
                  text:
                      "Ensure the captured image <b>only contains characters belonging to the Kulitan script</b>, as we will try to read any characters or objects that are caught within the image.",
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
          identify: "scanner-guide2-key",
          keyTarget: scannerAllKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: (MediaQuery.of(context).size.height / 2) -
                      50 -
                      (MediaQuery.of(context).size.width / 2)),
              builder: (context, ctl) {
                return CoachmarkDescWithImage(
                  title: "Kulitan Reader Guide",
                  image: iKulitanGuide2,
                  text:
                      "The text in the captured image should be <b>darker</b> than its background. Preferably, <b>black characters over a white background</b> as this will create a significant contrast helping us to identify your characters.",
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
          identify: "scanner-guide3-key",
          keyTarget: scannerAllKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: (MediaQuery.of(context).size.height / 2) -
                      50 -
                      (MediaQuery.of(context).size.width / 2)),
              builder: (context, ctl) {
                return CoachmarkDescWithImage(
                  title: "Kulitan Reader Guide",
                  image: iKulitanGuide3,
                  text:
                      "The <b>main body of the character should be larger than its diacritic/garlit</b>. Of course, accents are meant to be smaller.",
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
          identify: "scanner-guide4-key",
          keyTarget: scannerAllKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: (MediaQuery.of(context).size.height / 2) -
                      50 -
                      (MediaQuery.of(context).size.width / 2)),
              builder: (context, ctl) {
                return CoachmarkDescWithImage(
                  title: "Kulitan Reader Guide",
                  image: iKulitanGuide4,
                  text:
                      "The <b>diacritic should not be touching</b> and is <b>placed within the width of the main body of the character</b>. This separation helps us distinguish if a character has diacritics or not.",
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
          identify: "scanner-guide5-key",
          keyTarget: scannerAllKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: (MediaQuery.of(context).size.height / 2) -
                      100 -
                      (MediaQuery.of(context).size.width / 2)),
              builder: (context, ctl) {
                return CoachmarkDescWithImage(
                  title: "Kulitan Reader Guide",
                  image: iKulitanGuide5,
                  text:
                      "Characters including its diacritic mark <b>should not be touching other characters</b>, and has a bearable amount of space in between. Characters <b>should not be entering the box space</b> of another. This help us separate characters from other characters.",
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
          identify: "scanner-guide6-key",
          keyTarget: scannerAllKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: (MediaQuery.of(context).size.height / 2) -
                      50 -
                      (MediaQuery.of(context).size.width / 2)),
              builder: (context, ctl) {
                return CoachmarkDescWithImage(
                  title: "Kulitan Reader Guide",
                  image: iKulitanGuide6,
                  text:
                      "<b>Capture upright</b>, with the Kulitan written on a <b>top-to-down</b> manner.",
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
          identify: "scanner-button-key",
          keyTarget: scannerButtonKey,
          shape: ShapeLightFocus.Circle,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Kulitan Reader Guide",
                  text:
                      "Use this button as a <b>shutter or capture button</b>.",
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
          identify: "scanner-flash-key",
          keyTarget: scannerFlashKey,
          shape: ShapeLightFocus.Circle,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Kulitan Reader Guide",
                  text:
                      "Use this button to cycle through different <b>flash options</b>.",
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
          identify: "scanner-switch-key",
          keyTarget: scannerSwitchKey,
          shape: ShapeLightFocus.Circle,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Kulitan Reader Guide",
                  text:
                      "Use this button to cycle from <b>front and back cameras</b>.",
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
          identify: "scanner-zoom-key",
          keyTarget: scannerZoomKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.top,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Kulitan Reader Guide",
                  text: "Use this zoom slider to <b>zoom the camera</b>.",
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
          identify: "scanner-exposure-key",
          keyTarget: scannerExposureKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Kulitan Reader Guide",
                  text:
                      "Use this exposure slider to <b>adjust the camera's exposure</b>.",
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
          identify: "scanner-focus-key",
          keyTarget: scannerAllKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Kulitan Reader Guide",
                  text:
                      "Click anywhere on the camera preview to <b>set focal point</b>.",
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
          identify: "scanner-upload-key",
          keyTarget: scannerUploadKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.bottom,
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Kulitan Reader Guide",
                  text:
                      "You may also use existing photos using this <b>upload button</b>.",
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
          identify: "scanner-help-key",
          keyTarget: scannerAllKey,
          shape: ShapeLightFocus.Circle,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "Kulitan Reader Guide",
                  text:
                      "You may always go back to this walkthrough using the <b>help button</b> on the top right.",
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
          identify: "scanner-final-key",
          keyTarget: scannerAllKey,
          shape: ShapeLightFocus.RRect,
          radius: 30,
          contents: [
            TargetContent(
              align: ContentAlign.custom,
              customPosition: CustomTargetContentPosition(
                  top: MediaQuery.of(context).size.height / 2 - 100),
              builder: (context, ctl) {
                return CoachmarkDesc(
                  title: "You are now all set!",
                  text:
                      "If you experienced any problem, please submit a <b>report</b> on the <i>support page</i>.",
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

  void resetAnimation() {
    if (transController == null) transController = TransformationController();
    anim = Matrix4Tween(begin: transController!.value, end: Matrix4.identity())
        .animate(CurveTween(curve: Curves.easeOut).animate(zoomAnimController));
    zoomAnimController.forward(from: 0);
  }

  Future predictImage(
      String filePath, BuildContext context, Size screenSize) async {
    if (appController.hasConnection.value) {
      showLoaderDialog(context);
      List<dynamic>? prediction = await getPrediction(filePath);
      if (prediction == null) {
        Navigator.of(context).pop();
        Helper.errorSnackBar(
            title: "Unable to process request",
            message: "Please try again later.");
        return;
      } else {
        if (transController != null) transController!.dispose();
        transController = TransformationController();
        predictionImage = prediction[1];
        Navigator.of(context).pop();
        showPredictionDialog(
            context, prediction[0], predictionImage!, screenSize);
      }
    } else {
      appController.showConnectionSnackbar();
    }
  }

  Future searchInDictionary(String word) async {
    String query = appController.normalizeWord(word);
    Get.to(() => SearchScreen(fromKulitanScanner: true, input: query),
        duration: Duration(milliseconds: 500),
        transition: Transition.rightToLeft,
        curve: Curves.easeInOut);
  }

  Future copyToClipboard(String word) async {
    await Clipboard.setData(ClipboardData(text: word)).then((value) {
      Helper.successSnackBar(
          title: 'Clipboard', message: '"${word}" copied to clipboard.');
    }).catchError((error, stackTrace) {
      return Helper.errorSnackBar(
          title: tOhSnap, message: "Unable to copy to clipboard.");
    });
  }

  Future<List<dynamic>?> getPrediction(imagePath) async {
    File imgFile = File(imagePath);
    var api_url = "http://35.240.137.252/";
    final request = http.MultipartRequest("POST", Uri.parse(api_url));
    final header = {"Content-Type": "multipart/form-data"};
    request.files.add(http.MultipartFile(
        'file', imgFile.readAsBytes().asStream(), imgFile.lengthSync(),
        filename: imgFile.path.split('/').last));
    request.headers.addAll(header);
    final myRequest = await request.send();
    http.Response res = await http.Response.fromStream(myRequest);
    if (myRequest.statusCode == 200) {
      final resJson = jsonDecode(res.body);
      print("API response: " + resJson.toString());
      final prediction = resJson["prediction"];
      final annotated = Image.memory(base64Decode(resJson["image"]));
      return [prediction, annotated];
    } else {
      return null;
    }
  }

  void showPredictionDialog(BuildContext context, String prediction,
      Image annotated, Size screenSize) {
    if (transController != null) transController!.dispose();
    transController = TransformationController();
    showInfoDialog(
        context,
        "Result",
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: EdgeInsets.only(bottom: 10),
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: screenSize.height * 0.45),
              child: InteractiveViewer(
                  clipBehavior: Clip.none,
                  transformationController: transController,
                  onInteractionStart: (details) {
                    isVisible.value = false;
                  },
                  onInteractionEnd: (details) {
                    resetAnimation();
                    isVisible.value = true;
                  },
                  minScale: 1,
                  maxScale: 5,
                  panEnabled: false,
                  child: annotated),
            ),
            Obx(
              () => Container(
                padding: EdgeInsets.only(top: 15),
                alignment: Alignment.center,
                child: Text(
                  isVisible.value ? "TRANSLITERATED TEXT:" : "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: disabledGrey,
                      height: 1.1),
                ),
              ),
            ),
            Obx(
              () => Container(
                padding: EdgeInsets.only(bottom: 15, top: 5),
                child: Text(
                  isVisible.value ? prediction : "",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.robotoSlab(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: primaryOrangeDark,
                      height: 1.1),
                ),
              ),
            ),
            Obx(
              () => isVisible.value
                  ? Material(
                      borderRadius: BorderRadius.circular(25),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          searchInDictionary(prediction);
                        },
                        splashColor: primaryOrangeLight,
                        highlightColor: primaryOrangeLight.withOpacity(0.5),
                        child: Ink(
                          height: 40.0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Search in dictionary".toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
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
                    )
                  : Container(height: 40),
            ),
            SizedBox(
              height: 10,
            ),
            Obx(
              () => isVisible.value
                  ? Material(
                      borderRadius: BorderRadius.circular(25),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          copyToClipboard(prediction);
                        },
                        splashColor: primaryOrangeDarkShine,
                        highlightColor: primaryOrangeDarkShine.withOpacity(0.5),
                        child: Ink(
                          height: 40.0,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Copy to clipboard".toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: pureWhite,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: primaryOrangeLight,
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                    )
                  : Container(height: 40),
            ),
          ]),
        ),
        null,
        null,
        isVisible);
  }
}
