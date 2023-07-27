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
        body: Stack(
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
              child: Column(
                children: [
                  Expanded(
                    flex: 55,
                    child: Container(
                      width: double.infinity,
                      color: orangeCard,
                      padding: EdgeInsets.fromLTRB(40, 40, 40, 20),
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
                            padding: EdgeInsets.symmetric(
                                vertical: 40, horizontal: 30),
                            child: Column(
                              children: [],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 45,
                    child: Container(
                      width: double.infinity,
                      color: pureWhite,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          child: Column(
                            children: [
                              KulitanKey(
                                  buttonString: "k",
                                  buttonLabel: "ka",
                                  upperString: "ki",
                                  upperLabel: "ki",
                                  lowerString: "ku",
                                  lowerLabel: "ku",
                                  onTap: () {},
                                  onUpperSelect: () {},
                                  onLowerSelect: () {})
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
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
            )),
      ],
    ));
  }
}
