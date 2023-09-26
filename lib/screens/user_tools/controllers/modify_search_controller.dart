import 'package:amanu/models/delete_request_model.dart';
import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/controllers/home_page_controller.dart';
import 'package:amanu/screens/home_screen/drawer_launcher.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
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

  Future submitDelete(String wordID, BuildContext context) async {
    if (appController.hasConnection.value) {
      if (appController.userIsExpert ?? false) {
        DatabaseRepository.instance
            .removeWordOnDB(
                wordID, appController.dictionaryContent[wordID]["word"])
            .then((value) async {
          await appController.checkDictionary();
          appController.update();
          final homeController = Get.find<HomePageController>();
          await homeController.getInformation();
        });
        Navigator.pop(context);

        final drawerController = Get.find<DrawerXController>();
        drawerController.currentItem.value = DrawerItems.home;
        Get.offAll(() => DrawerLauncher(),
            duration: Duration(milliseconds: 500),
            transition: Transition.downToUp,
            curve: Curves.easeInOut);
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
            userName: appController.userName ?? '',
            requestType: 2,
            isAvailable: true,
            requestNotes: notes == '' ? null : notes,
            timestamp: timestamp,
            wordID: wordID,
            word: appController.dictionaryContent[wordID]["word"]);
        if (appController.hasConnection.value) {
          DatabaseRepository.instance.createDeleteRequestOnDB(
              request, timestamp, appController.userID ?? '');
          Navigator.pop(context);
        } else {
          appController.showConnectionSnackbar();
        }
      }
    } else {
      appController.showConnectionSnackbar();
    }
  }
}
