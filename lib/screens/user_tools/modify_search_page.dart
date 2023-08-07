import 'package:amanu/components/search_filter.dart';
import 'package:amanu/components/search_result_list.dart';
import 'package:amanu/screens/search_screen/controllers/search_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModifySearchPage extends StatelessWidget {
  ModifySearchPage({
    super.key,
    required this.editMode,
  });
  final bool editMode;

  final AudioPlayer player = AudioPlayer();
  final controller = Get.put(SearchWordController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: screenPadding.top + 50 + 64,
          left: 0,
          right: 0,
          child: SearchResultList(
              height: size.height - 110,
              width: size.width,
              size: size,
              controller: controller,
              player: player),
        ),
        ThreePartHeader(
          size: size,
          screenPadding: screenPadding,
          title: editMode ? tEditWord : tDeleteWord,
          additionalHeight: 64.0,
          secondIconDisabled: true,
        ),
        Positioned(
          top: screenPadding.top + 20,
          right: 20,
          child: Hero(
              tag: 'secondButton',
              child: Transform.scale(
                  scale: 1.2, child: SearchFilter(controller: controller))),
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
                        onChanged: (value) => controller.searchWord(value),
                      )))
            ]),
          ),
        ),
      ],
    ));
  }
}
