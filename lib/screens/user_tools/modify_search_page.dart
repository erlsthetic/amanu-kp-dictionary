import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:flutter/material.dart';

class ModifySearchPage extends StatelessWidget {
  ModifySearchPage({
    super.key,
    required this.editMode,
  });
  final bool editMode;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Scaffold(
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
              child: Column(
                children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                      child: Column(
                        children: [],
                      ),
                    ),
                  ),
                ],
              )),
        ),
        ThreePartHeader(
          size: size,
          screenPadding: screenPadding,
          title: editMode ? tEditWord : tDeleteWord,
          additionalHeight: 64.0,
        ),
        Positioned(
          top: screenPadding.top + 65,
          left: 0,
          child: Container(
            height: 55.0,
            width: size.width - 40,
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12.5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(30)),
                color: pureWhite),
            child:
                Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Icon(
                Icons.search,
                size: 30.0,
                color: primaryOrangeDark,
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: TextField(
                        style: TextStyle(fontSize: 18, color: muteBlack),
                        decoration:
                            InputDecoration.collapsed(hintText: "Search"),
                      )))
            ]),
          ),
        ),
      ],
    ));
  }
}
