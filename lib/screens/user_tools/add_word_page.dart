import 'package:amanu/screens/user_tools/controllers/tools_controller.dart';
import 'package:amanu/screens/user_tools/widgets/connection_selector.dart';
import 'package:amanu/screens/user_tools/widgets/kulitan_formfield.dart';
import 'package:amanu/screens/user_tools/widgets/studio_formfield.dart';
import 'package:amanu/screens/user_tools/widgets/tags_field.dart';
import 'package:amanu/screens/user_tools/widgets/word_info_section.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AddWordPage extends StatelessWidget {
  AddWordPage({
    super.key,
  });

  final controller = Get.put(ToolsController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          splashColor: primaryOrangeLight,
          focusColor: primaryOrangeLight.withOpacity(0.5),
          onPressed: () {
            controller.submitWord();
          },
          label: Text(
            tProceed.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: pureWhite,
              letterSpacing: 1.0,
            ),
          ),
          icon: Icon(Icons.keyboard_double_arrow_right),
        ),
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
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: controller.addWordFormKey,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              child: Text(
                                tAddInstructions,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.normal,
                                  color: darkGrey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              controller: controller.wordController,
                              validator: (value) {
                                if (value != null) {
                                  return controller.validateWord(value);
                                } else {
                                  return "Please enter word";
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: tWord + " *",
                                  hintText: tWord + " *",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              controller: controller.phoneticController,
                              validator: (value) {
                                if (value != null) {
                                  return controller.validatePhonetic(value);
                                } else {
                                  return "Please enter word phonetics";
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: tPhonetic + " *",
                                  hintText: tPhonetic + " *",
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                tPronunciation + " *",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  color: disabledGrey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            StudioFormField(
                                controller: controller,
                                onSaved: (value) {
                                  value = controller.audioPath;
                                },
                                validator: (value) {
                                  if (controller.audioPath == '') {
                                    return "Please provide audio pronunciation";
                                  } else {
                                    return null;
                                  }
                                }),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                tEngTrans,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  color: disabledGrey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            TagsField(
                              controller: controller.engTransController,
                              width: size.width - (60.0 + 55),
                              label: tEngTrans,
                            ),
                            /*Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Expanded(
                                      child: TagsField(
                                    controller: controller.engTransController,
                                    width: size.width - (60.0 + 55),
                                    label: tEngTrans,
                                  )),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.keyboard_arrow_up,
                                          color: pureWhite,
                                        )),
                                    decoration: BoxDecoration(
                                      color: primaryOrangeDark,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ],
                              ),
                            ),*/
                            Obx(() => controller.engTransEmpty.value
                                ? Container(
                                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                    width: double.infinity,
                                    child: Text(
                                      'You may want to provide a translation',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.yellow[700],
                                          fontSize: 12),
                                    ))
                                : Container()),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                tFilTrans,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  color: disabledGrey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            TagsField(
                              controller: controller.filTransController,
                              width: size.width - (60.0),
                              label: tFilTrans,
                            ),
                            Obx(() => controller.filTransEmpty.value
                                ? Container(
                                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                    width: double.infinity,
                                    child: Text(
                                      'You may want to provide a translation',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: Colors.yellow[700],
                                          fontSize: 12),
                                    ))
                                : Container()),
                            SizedBox(
                              height: 30.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                tInfoSec.toUpperCase(),
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                  color: muteBlack,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            WordInfoSection(controller: controller),
                            SizedBox(
                              height: 30.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                tKulitanSec.toUpperCase() + " *",
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                  color: muteBlack,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            KulitanFormField(
                                controller: controller,
                                onSaved: (value) {},
                                validator: (value) {
                                  if (controller.kulitanListEmpty.value) {
                                    return "Please provide Kulitan information for the word.";
                                  } else {
                                    return null;
                                  }
                                }),
                            SizedBox(
                              height: 30.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                tConnectionSec.toUpperCase(),
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                  color: muteBlack,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                tRelated,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  color: disabledGrey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TagsField(
                                      controller: controller.relatedController,
                                      width: size.width - (60.0),
                                      label: tRelated,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  GestureDetector(
                                    onTap: Feedback.wrapForTap(() {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ConnectionSelector(
                                              title: "Select related word",
                                              size: size,
                                            );
                                          });
                                    }, context),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.eject,
                                            color: pureWhite,
                                          )),
                                      decoration: BoxDecoration(
                                        color: primaryOrangeDark,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                tSynonyms,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  color: disabledGrey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TagsField(
                                      controller: controller.synonymController,
                                      width: size.width - (60.0),
                                      label: tSynonyms,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  GestureDetector(
                                    onTap: Feedback.wrapForTap(() {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ConnectionSelector(
                                                title: "Select synonym",
                                                size: size);
                                          });
                                    }, context),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.eject,
                                            color: pureWhite,
                                          )),
                                      decoration: BoxDecoration(
                                        color: primaryOrangeDark,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                tAntonyms,
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                  color: disabledGrey,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TagsField(
                                      controller: controller.antonymController,
                                      width: size.width - (60.0),
                                      label: tAntonyms,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  GestureDetector(
                                    onTap: Feedback.wrapForTap(() {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return ConnectionSelector(
                                                title: "Select antonym",
                                                size: size);
                                          });
                                    }, context),
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      child: Align(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.eject,
                                            color: pureWhite,
                                          )),
                                      decoration: BoxDecoration(
                                        color: primaryOrangeDark,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                tReferences.toUpperCase(),
                                textAlign: TextAlign.left,
                                style: GoogleFonts.poppins(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w600,
                                  color: muteBlack,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            TextFormField(
                              controller: controller.referencesController,
                              minLines: 1,
                              maxLines: 4,
                              decoration: InputDecoration(
                                  labelText: tSources,
                                  hintText: tSources,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                            ),
                            SizedBox(
                              height: 40.0,
                            ),
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
            ThreePartHeader(
              size: size,
              screenPadding: screenPadding,
              title: tAddWord,
            ),
          ],
        ));
  }
}
