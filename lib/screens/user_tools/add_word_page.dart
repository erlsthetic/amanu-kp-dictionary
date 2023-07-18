import 'package:amanu/screens/user_tools/controllers/tools_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:coast/coast.dart';
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
    final topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: Text(
            tAddWord.toUpperCase(),
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              color: pureWhite,
              letterSpacing: 1.0,
            ),
          ),
          icon: Icon(Icons.add),
        ),
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
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Form(
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
                            Container(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: lightGrey,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: Container(
                                      height: double.infinity,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          tEnterStudio.toUpperCase(),
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
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                tEngTrans + " *",
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
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                          labelText: tEngTrans,
                                          hintText: tEngTrans,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0))),
                                    ),
                                  ),
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
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              width: double.infinity,
                              child: Text(
                                tFilTrans + " *",
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
                            TextFormField(
                              minLines: 1,
                              maxLines: 4,
                              decoration: InputDecoration(
                                  labelText: tFilTrans,
                                  hintText: tFilTrans,
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0))),
                            ),
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 120.0,
                                    child: DropdownButtonFormField(
                                      items: controller.typeDropItems,
                                      onChanged: (String? newValue) {
                                        controller.typeSelected?.value =
                                            newValue!;
                                      },
                                      value: controller.typeSelected?.value,
                                      decoration: InputDecoration(
                                          labelText: tWordType + " *",
                                          hintText: tWordType + " *",
                                          hintMaxLines: 5,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0))),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.add,
                                          color: pureWhite,
                                        )),
                                    decoration: BoxDecoration(
                                      color: primaryOrangeDark,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.only(left: 30),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                          labelText: tDefinition + " *",
                                          hintText: tDefinition + " *",
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0))),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Icon(
                                          Icons.add,
                                          color: pureWhite,
                                        )),
                                    decoration: BoxDecoration(
                                      color: primaryOrangeDark,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 60),
                              child: TextFormField(
                                minLines: 1,
                                maxLines: 4,
                                decoration: InputDecoration(
                                    labelText: tDialect,
                                    hintText: tDialect,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0))),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 60),
                              child: TextFormField(
                                minLines: 1,
                                maxLines: 4,
                                decoration: InputDecoration(
                                    labelText: tExample,
                                    hintText: tExample,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0))),
                              ),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 60),
                              child: TextFormField(
                                minLines: 1,
                                maxLines: 4,
                                decoration: InputDecoration(
                                    labelText: tExTrans,
                                    hintText: tExTrans,
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0))),
                              ),
                            ),
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
                            Placeholder(
                              fallbackHeight: 300,
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Container(
                              height: 50.0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  tEnterKulitanEditor.toUpperCase(),
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
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                          labelText: tSynonyms,
                                          hintText: tSynonyms,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0))),
                                    ),
                                  ),
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
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                          labelText: tAntonyms,
                                          hintText: tAntonyms,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0))),
                                    ),
                                  ),
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
                                    child: TextFormField(
                                      minLines: 1,
                                      maxLines: 4,
                                      decoration: InputDecoration(
                                          labelText: tRelated,
                                          hintText: tRelated,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0))),
                                    ),
                                  ),
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
                          tag: 'HamburgerMenu',
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
                          tAddWord,
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
