import 'package:amanu/screens/search_screen/controllers/search_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchFilter extends StatelessWidget {
  const SearchFilter({
    super.key,
    required this.controller,
  });

  final SearchWordController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: Feedback.wrapForTap(() {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: pureWhite,
                            borderRadius: BorderRadius.circular(30.0)),
                        margin: EdgeInsets.only(right: 12, top: 12),
                        width: double.infinity,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 70,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                  color: primaryOrangeDark,
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(30.0))),
                              child: Text(
                                "Search options",
                                style: GoogleFonts.robotoSlab(
                                    fontSize: 24,
                                    color: pureWhite,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20.0),
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "SEARCH BY",
                                      style: TextStyle(
                                          color: primaryOrangeDark,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Divider(
                                      color: disabledGrey,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Wrap(
                                      alignment: WrapAlignment.spaceAround,
                                      spacing: 15,
                                      runSpacing: 5,
                                      children: [
                                        for (var option in {
                                          "Word": "word",
                                          "Eng Trans": "engTrans",
                                          "Fil Trans": "filTrans",
                                          "Related": "related",
                                          "Synonym": "synonym",
                                          "Antonym": "antonym",
                                          "Definition": "definition"
                                        }.entries)
                                          FilterOption(
                                              controller: controller,
                                              label: option.key,
                                              refVal: option.value)
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ]),
                            )
                          ],
                        ),
                      ),
                      Positioned(
                        right: 0.0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: CircleAvatar(
                              radius: 18.0,
                              backgroundColor: Colors.white,
                              child:
                                  Icon(Icons.close, color: primaryOrangeDark),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        }, context),
        child: Icon(
          Icons.manage_search_rounded,
          size: 30,
          color: pureWhite,
        ),
      ),
    );
  }
}

class FilterOption extends StatelessWidget {
  const FilterOption({
    super.key,
    required this.controller,
    required this.label,
    required this.refVal,
  });

  final SearchWordController controller;
  final String label;
  final String refVal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 60,
      child: Column(children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, color: disabledGrey),
        ),
        SizedBox(
          height: 5,
        ),
        Obx(
          () => FlutterSwitch(
            padding: 2,
            width: 55,
            height: 30,
            valueFontSize: 12,
            toggleSize: 26,
            value: refVal == "word"
                ? controller.searchInWord.value
                : refVal == "engTrans"
                    ? controller.searchInEngTrans.value
                    : refVal == "filTrans"
                        ? controller.searchInFilTrans.value
                        : refVal == "related"
                            ? controller.searchInRelated.value
                            : refVal == "synonym"
                                ? controller.searchInSynonyms.value
                                : refVal == "antonym"
                                    ? controller.searchInAntonyms.value
                                    : refVal == "definition"
                                        ? controller.searchInDefinition.value
                                        : false,
            borderRadius: 30,
            showOnOff: true,
            onToggle: (value) {
              refVal == "word"
                  ? controller.searchInWord.value = value
                  : refVal == "engTrans"
                      ? controller.searchInEngTrans.value = value
                      : refVal == "filTrans"
                          ? controller.searchInFilTrans.value = value
                          : refVal == "related"
                              ? controller.searchInRelated.value = value
                              : refVal == "synonym"
                                  ? controller.searchInSynonyms.value = value
                                  : refVal == "antonym"
                                      ? controller.searchInAntonyms.value =
                                          value
                                      : refVal == "definition"
                                          ? controller
                                              .searchInDefinition.value = value
                                          : null;
            },
            activeColor: primaryOrangeDark,
          ),
        )
      ]),
    );
  }
}
