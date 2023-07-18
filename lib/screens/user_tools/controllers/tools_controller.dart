import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToolsController extends GetxController {
  static ToolsController get instance => Get.find();
  RxString? typeSelected;

  List<DropdownMenuItem<String>> get typeDropItems {
    List<DropdownMenuItem<String>> wordTypes = [
      DropdownMenuItem(child: Text("noun"), value: "noun"),
      DropdownMenuItem(child: Text("verb"), value: "verb"),
      DropdownMenuItem(child: Text("adjective"), value: "adjective"),
      DropdownMenuItem(child: Text("adverb"), value: "adverb"),
      DropdownMenuItem(child: Text("particle"), value: "particle"),
    ];
    return wordTypes;
  }
}
