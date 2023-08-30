import 'package:amanu/models/delete_request_model.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ModifySearchController extends GetxController {
  static ModifySearchController get instance => Get.find();
  final appController = Get.find<ApplicationController>();
  final GlobalKey<FormState> notesFormKey = GlobalKey<FormState>();
  late TextEditingController notesController;
  var notes = '';

  @override
  void onInit() {
    super.onInit();
    notesController = new TextEditingController();
  }

  Future submitDelete(String wordID) async {
    if (appController.userIsExpert ?? false) {
      if (appController.hasConnection.value) {
        DatabaseRepository.instance.removeWordOnDB(wordID);
      }
    } else {
      final notesValid = notesFormKey.currentState!.validate();
      if (!notesValid) {
        return;
      }
      notesFormKey.currentState!.save();
      final String timestamp =
          DateFormat('yyyy-MM-dd(HH:mm:ss)').format(DateTime.now());
      DeleteRequestModel request = DeleteRequestModel(
          requestId: timestamp + "-" + (appController.userID ?? ''),
          uid: appController.userID ?? '',
          requestType: 2,
          isAvailable: true,
          requestNotes: notes == '' ? null : notes,
          timestamp: timestamp,
          wordID: wordID,
          word: appController.dictionaryContent[wordID]["word"]);
      if (appController.hasConnection.value) {
        DatabaseRepository.instance.createDeleteRequestOnDB(
            request, timestamp, appController.userID ?? '');
      }
    }
  }
}
