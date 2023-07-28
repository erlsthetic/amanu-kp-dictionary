import 'package:amanu/screens/user_tools/controllers/kulitan_controller.dart';
import 'package:amanu/screens/user_tools/widgets/kulitan_key.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:coast/coast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class KulitanEditorPage extends StatelessWidget {
  KulitanEditorPage({
    super.key,
  });

  final controller = Get.put(KulitanController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: Stack(
        children: [
          Positioned(
            top: topPadding + 50,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              height: size.height - 110,
              width: size.width,
              child: Container(
                width: double.infinity,
                color: orangeCard,
                padding: EdgeInsets.fromLTRB(
                    40, 40, 40, (4.0 * 60) + (4.0 * 10.0) + (2.0 * 20.0)),
                child: Container(
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
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                      child: Column(
                        children: [],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Crab(
              tag: "AppBar",
              child: Container(
                width: size.width,
                height: topPadding + 70,
                decoration: BoxDecoration(
                    gradient: orangeGradient,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(30.0))),
              ),
            ),
          ),
          Positioned(
            top: topPadding,
            left: 0,
            child: Container(
              height: 70,
              width: size.width,
              padding: EdgeInsets.fromLTRB(5, 0, 10, 0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Crab(
                      tag: 'BackButton',
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          weight: 10,
                        ),
                        color: pureWhite,
                        iconSize: 30,
                      ),
                    ),
                    Text(
                      tKulitanEditor,
                      style: GoogleFonts.robotoSlab(
                          fontSize: 24,
                          color: pureWhite,
                          fontWeight: FontWeight.bold),
                    ),
                    Crab(
                      tag: 'HelpButton',
                      child: IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.help),
                        color: pureWhite,
                        iconSize: 30,
                      ),
                    ),
                  ]),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: (4.0 * 60) + (3.0 * 10.0) + (2.0 * 20.0),
              padding: EdgeInsets.all(20.0),
              width: size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                color: pureWhite,
              ),
              child: Table(
                defaultColumnWidth: FlexColumnWidth(1.0),
                children: <TableRow>[
                  TableRow(children: <Widget>[
                    for (List<String> keyRow in controller.keyboardData[0])
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
                              print(keyRow[0]);
                            },
                            onUpperSelect: () {
                              print(keyRow[2]);
                            },
                            onLowerSelect: () {
                              print(keyRow[4]);
                            }),
                      ),
                    Container(),
                  ]),
                  TableRow(children: <Widget>[
                    for (List<String> keyRow in controller.keyboardData[1])
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
                              print(keyRow[0]);
                            },
                            onUpperSelect: () {
                              print(keyRow[2]);
                            },
                            onLowerSelect: () {
                              print(keyRow[4]);
                            }),
                      ),
                    Container(),
                  ]),
                  TableRow(children: <Widget>[
                    for (List<String> keyRow in controller.keyboardData[2])
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
                              print(keyRow[0]);
                            },
                            onUpperSelect: () {
                              print(keyRow[2]);
                            },
                            onLowerSelect: () {
                              print(keyRow[4]);
                            }),
                      ),
                    Container(),
                  ]),
                  TableRow(children: <Widget>[
                    Container(),
                    for (List<String> keyRow in controller.keyboardData[3])
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
                              print(keyRow[0]);
                            },
                            onUpperSelect: () {
                              print(keyRow[2]);
                            },
                            onLowerSelect: () {
                              print(keyRow[4]);
                            }),
                      ),
                    Container(),
                    Container(),
                  ]),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
