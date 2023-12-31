import 'dart:ui';

import 'package:amanu/screens/user_tools/controllers/kulitan_controller.dart';
import 'package:amanu/screens/user_tools/widgets/kulitan_key.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class KulitanEditorPage extends StatefulWidget {
  KulitanEditorPage({
    super.key,
  });

  @override
  State<KulitanEditorPage> createState() => _KulitanEditorPageState();
}

class _KulitanEditorPageState extends State<KulitanEditorPage> {
  final controller = Get.put(KulitanController());
  final appController = Get.find<ApplicationController>();
  TutorialCoachMark? tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (appController.isFirstTimeKulitan) {
        showTutorial();
      }
    });
  }

  void showTutorial() {
    Future.delayed(Duration(seconds: 1), () {
      tutorialCoachMark = TutorialCoachMark(
          pulseEnable: false,
          targets: controller.initTarget(),
          imageFilter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
          onFinish: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool("isFirstTimeKulitan", false);
            appController.isFirstTimeKulitan = false;
          },
          onSkip: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setBool("isFirstTimeKulitan", false);
            appController.isFirstTimeKulitan = false;
          },
          hideSkip: true)
        ..show(context: context);
    });
  }

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    final blinkerKey = new GlobalKey();
    return Padding(
      padding: EdgeInsets.only(bottom: screenPadding.bottom),
      child: Scaffold(
          key: controller.kulitanScreenKey,
          body: WillPopScope(
            onWillPop: () async {
              controller.checkIfEmpty();
              controller.saveKulitan();
              return Future.value(true);
            },
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              child: Stack(
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
                      child: Container(
                        width: double.infinity,
                        color: orangeCard,
                        padding: EdgeInsets.fromLTRB(40, 40, 40,
                            (4.0 * 60) + (3.0 * 10.0) + (2.0 * 20.0) + 20),
                        child: Container(
                          key: controller.kulitanViewerKey,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: pureWhite,
                                ),
                                BoxShadow(
                                  color: muteBlack.withOpacity(0.25),
                                ),
                                BoxShadow(
                                    offset: Offset(1, 1),
                                    color: pureWhite,
                                    blurStyle: BlurStyle.inner)
                              ]),
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              padding: EdgeInsets.only(bottom: 50),
                              physics: BouncingScrollPhysics(),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 40, horizontal: 30),
                                child: Obx(
                                  () => Column(
                                    children: <Widget>[
                                      for (MapEntry line in controller
                                          .kulitanStringList
                                          .asMap()
                                          .entries)
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.symmetric(
                                              vertical: 5.0),
                                          child: Obx(
                                            () => (controller.currentSpace
                                                            .value ==
                                                        0 &&
                                                    line.key ==
                                                        controller
                                                            .currentLine.value)
                                                ? Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Container(
                                                          constraints:
                                                              BoxConstraints(
                                                                  minHeight: 60,
                                                                  maxHeight: 80,
                                                                  minWidth: 180,
                                                                  maxWidth:
                                                                      240),
                                                          child: FittedBox(
                                                            child:
                                                                AnimatedOpacity(
                                                              opacity: controller
                                                                      .blinkerShow
                                                                      .value
                                                                  ? 1.0
                                                                  : 0.0,
                                                              duration: Duration(
                                                                  milliseconds:
                                                                      controller
                                                                          .showDuration),
                                                              child: Container(
                                                                key: blinkerKey,
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            3),
                                                                height: 35,
                                                                width: 2.0,
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        primaryOrangeDark,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                          flex: 2,
                                                          child: Container())
                                                    ],
                                                  )
                                                : Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 8,
                                                        child: Container(
                                                          constraints:
                                                              BoxConstraints(
                                                                  minHeight: 60,
                                                                  maxHeight: 80,
                                                                  minWidth: 180,
                                                                  maxWidth:
                                                                      240),
                                                          child: line.value
                                                                      .length ==
                                                                  0
                                                              ? Container()
                                                              : FittedBox(
                                                                  fit: BoxFit
                                                                      .contain,
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        line.value
                                                                            .join(),
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'KulitanKeith',
                                                                            fontSize:
                                                                                35,
                                                                            color:
                                                                                primaryOrangeDark),
                                                                      ),
                                                                      if (line.key ==
                                                                          controller
                                                                              .currentLine
                                                                              .value)
                                                                        AnimatedOpacity(
                                                                          opacity: controller.blinkerShow.value
                                                                              ? 1.0
                                                                              : 0.0,
                                                                          duration:
                                                                              Duration(milliseconds: controller.showDuration),
                                                                          child:
                                                                              Container(
                                                                            key:
                                                                                blinkerKey,
                                                                            margin:
                                                                                EdgeInsets.only(left: 3),
                                                                            height:
                                                                                35,
                                                                            width:
                                                                                2.0,
                                                                            decoration:
                                                                                BoxDecoration(color: primaryOrangeDark, borderRadius: BorderRadius.circular(5)),
                                                                          ),
                                                                        )
                                                                    ],
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          alignment:
                                                              Alignment.center,
                                                          constraints:
                                                              BoxConstraints(
                                                                  minHeight: 60,
                                                                  maxHeight: 80,
                                                                  minWidth: 30,
                                                                  maxWidth: 60),
                                                          child: line.value
                                                                      .length ==
                                                                  0
                                                              ? Container()
                                                              : Container(
                                                                  child: Text(
                                                                    line.value
                                                                        .join()
                                                                        .replaceAll(
                                                                            "aa",
                                                                            "á")
                                                                        .replaceAll(
                                                                            "ai",
                                                                            "e")
                                                                        .replaceAll(
                                                                            "au",
                                                                            "o")
                                                                        .replaceAll(
                                                                            "ii",
                                                                            "í")
                                                                        .replaceAll(
                                                                            "uu",
                                                                            "ú")
                                                                        .replaceAll(
                                                                            "ia",
                                                                            "ya")
                                                                        .replaceAll(
                                                                            "ua",
                                                                            "wa"),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        color:
                                                                            primaryOrangeDark),
                                                                  ),
                                                                ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ThreePartHeader(
                    key: controller.kulitanSaveKey,
                    size: size,
                    screenPadding: screenPadding,
                    title: tKulitanEditor,
                    firstOnPressed: () {
                      controller.checkIfEmpty();
                      controller.saveKulitan();
                      Get.back();
                    },
                    firstIcon: Icons.save_rounded,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Container(
                      height: (4.0 * 60) + (3.0 * 10.0) + (2.0 * 20.0),
                      padding: EdgeInsets.all(20.0),
                      width: size.width,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(30)),
                        color: pureWhite,
                      ),
                      child: Table(
                        key: controller.kulitanKeyboardKey,
                        defaultColumnWidth: FlexColumnWidth(1.0),
                        children: <TableRow>[
                          TableRow(children: <Widget>[
                            for (List<String> keyRow
                                in controller.keyboardData[0])
                              Container(
                                margin: EdgeInsets.all(5.0),
                                child: KulitanKey(
                                    buttonString: keyRow[0],
                                    buttonLabel: keyRow[1],
                                    upperString: keyRow[2],
                                    upperLabel: keyRow[3],
                                    lowerString: keyRow[4],
                                    lowerLabel: keyRow[5],
                                    onTap: () {
                                      controller.addCharacter(keyRow[0]);
                                      print(keyRow[0]);
                                    },
                                    onUpperSelect: () {
                                      controller.addCharacter(keyRow[2]);
                                      print(keyRow[2]);
                                    },
                                    onLowerSelect: () {
                                      controller.addCharacter(keyRow[4]);
                                      print(keyRow[4]);
                                    }),
                              ),
                            Container(
                              margin: EdgeInsets.all(5.0),
                              child: KulitanKey(
                                buttonString: "clear",
                                onTap: () {
                                  controller.clearList();
                                },
                              ),
                            ),
                          ]),
                          TableRow(children: <Widget>[
                            for (List<String> keyRow
                                in controller.keyboardData[1])
                              Container(
                                margin: EdgeInsets.all(5.0),
                                child: KulitanKey(
                                    buttonString: keyRow[0],
                                    buttonLabel: keyRow[1],
                                    upperString: keyRow[2],
                                    upperLabel: keyRow[3],
                                    lowerString: keyRow[4],
                                    lowerLabel: keyRow[5],
                                    onTap: () {
                                      controller.addCharacter(keyRow[0]);
                                      Scrollable.ensureVisible(
                                          blinkerKey.currentContext!);
                                      print(keyRow[0]);
                                    },
                                    onUpperSelect: () {
                                      controller.addCharacter(keyRow[2]);
                                      Scrollable.ensureVisible(
                                          blinkerKey.currentContext!);
                                      print(keyRow[2]);
                                    },
                                    onLowerSelect: () {
                                      controller.addCharacter(keyRow[4]);
                                      Scrollable.ensureVisible(
                                          blinkerKey.currentContext!);
                                      print(keyRow[4]);
                                    }),
                              ),
                            Container(),
                          ]),
                          TableRow(children: <Widget>[
                            for (List<String> keyRow
                                in controller.keyboardData[2])
                              Container(
                                margin: EdgeInsets.all(5.0),
                                child: KulitanKey(
                                    buttonString: keyRow[0],
                                    buttonLabel: keyRow[1],
                                    upperString: keyRow[2],
                                    upperLabel: keyRow[3],
                                    lowerString: keyRow[4],
                                    lowerLabel: keyRow[5],
                                    onTap: () {
                                      controller.addCharacter(keyRow[0]);
                                      Scrollable.ensureVisible(
                                          blinkerKey.currentContext!);
                                      print(keyRow[0]);
                                    },
                                    onUpperSelect: () {
                                      controller.addCharacter(keyRow[2]);
                                      Scrollable.ensureVisible(
                                          blinkerKey.currentContext!);
                                      print(keyRow[2]);
                                    },
                                    onLowerSelect: () {
                                      controller.addCharacter(keyRow[4]);
                                      Scrollable.ensureVisible(
                                          blinkerKey.currentContext!);
                                      print(keyRow[4]);
                                    }),
                              ),
                            Container(
                              margin: EdgeInsets.all(5.0),
                              child: KulitanKey(
                                buttonString: "delete",
                                onTap: () {
                                  controller.deleteCharacter();
                                  Scrollable.ensureVisible(
                                      blinkerKey.currentContext!);
                                },
                              ),
                            ),
                          ]),
                          TableRow(children: <Widget>[
                            Container(),
                            for (List<String> keyRow
                                in controller.keyboardData[3])
                              Container(
                                margin: EdgeInsets.all(5.0),
                                child: KulitanKey(
                                    buttonString: keyRow[0],
                                    buttonLabel: keyRow[1],
                                    upperString: keyRow[2],
                                    upperLabel: keyRow[3],
                                    lowerString: keyRow[4],
                                    lowerLabel: keyRow[5],
                                    onTap: () {
                                      controller.addCharacter(keyRow[0]);
                                      Scrollable.ensureVisible(
                                          blinkerKey.currentContext!);
                                      print(keyRow[0]);
                                    },
                                    onUpperSelect: () {
                                      controller.addCharacter(keyRow[2]);
                                      Scrollable.ensureVisible(
                                          blinkerKey.currentContext!);
                                      print(keyRow[2]);
                                    },
                                    onLowerSelect: () {
                                      controller.addCharacter(keyRow[4]);
                                      Scrollable.ensureVisible(
                                          blinkerKey.currentContext!);
                                      print(keyRow[4]);
                                    }),
                              ),
                            Container(),
                            Container(
                              margin: EdgeInsets.all(5.0),
                              child: KulitanKey(
                                buttonString: "enter",
                                onTap: () {
                                  controller.enterNewLine();
                                  Scrollable.ensureVisible(
                                      blinkerKey.currentContext!);
                                },
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
