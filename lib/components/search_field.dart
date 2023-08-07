import 'package:amanu/screens/search_screen/controllers/search_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
  });

  final SearchWordController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: double.infinity,
        width: double.infinity,
        alignment: Alignment.center,
        child: TextField(
          style: TextStyle(fontSize: 18, color: muteBlack),
          decoration: InputDecoration.collapsed(hintText: "Search"),
          onChanged: (value) => controller.searchWord(value),
        ));
  }
}
