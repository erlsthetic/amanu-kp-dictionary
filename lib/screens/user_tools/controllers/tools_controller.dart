import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToolsController extends GetxController {
  static ToolsController get instance => Get.find();

  final GlobalKey<FormState> addWordFormKey = GlobalKey<FormState>();
  final GlobalKey<AnimatedListState> typeListKey = GlobalKey();

  //[[[def],[def]]]
  //[listKey, listKey]
  final List<GlobalKey<AnimatedListState>> definitionListKey = [];

  //RxString? typeSelected;

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

  final RxList<String> typeFields = <String>[].obs;

  final RxList<List<List<TextEditingController>>> definitionsFields =
      <List<List<TextEditingController>>>[].obs;

  void addTypeField(int i) {
    typeListKey.currentState?.insertItem(i);
    definitionListKey.insert(i, GlobalKey());
    typeFields.insert(i, '');
    definitionsFields.insert(i, []);
    addDefinitionField(i, 0);
  }

  void removeTypeField(int i) {
    typeFields.removeAt(i);
    typeListKey.currentState!.removeItem(i, (_, __) => Container());
  }

  void addDefinitionField(int i, int j) {
    definitionsFields[i].insert(j, [
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
      TextEditingController(),
    ]);
    definitionListKey[i].currentState?.insertItem(j);
  }

  void removeDefinitionField(int i, int j) {
    definitionsFields[i].removeAt(j);
    definitionListKey[i].currentState!.removeItem(j, (_, __) => Container());
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    addTypeField(0);
  }
}
