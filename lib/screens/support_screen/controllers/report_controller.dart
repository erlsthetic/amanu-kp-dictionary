import 'dart:io';

import 'package:amanu/models/report_model.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:intl/intl.dart';

class ReportController extends GetxController {
  static ReportController get instance => Get.find();
  final databaseRepo = Get.put(DatabaseRepository());
  final appController = Get.find<ApplicationController>();
  RxBool isProcessing = false.obs;

  RxString? typeSelected;

  var email = '';
  var subject = '';
  var reportType = '';
  var reportDetail = '';
  var fileUrl = '';

  final GlobalKey<FormState> reportFormKey = GlobalKey<FormState>();

  late TextEditingController emailController,
      subjectController,
      detailsController;

  @override
  void onInit() {
    super.onInit();

    emailController = TextEditingController();
    subjectController = TextEditingController();
    detailsController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    emailController.dispose();
    subjectController.dispose();
    detailsController.dispose();
    email = '';
    subject = '';
    reportType = '';
    reportDetail = '';
    fileUrl = '';
  }

//Validation
  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  List<DropdownMenuItem<String>> get typeDropItems {
    List<DropdownMenuItem<String>> problemTypes = [
      DropdownMenuItem(
          child: Text("Account related problem"),
          value: "Account related problem"),
      DropdownMenuItem(
          child: Text("Content related problem"),
          value: "Content related problem"),
      DropdownMenuItem(
          child: Text("Bugs and crashes"), value: "Bugs and crashes"),
      DropdownMenuItem(child: Text("Others"), value: "Others"),
    ];
    return problemTypes;
  }

  // Select file
  PlatformFile? pickedFile = null;
  RxBool selectEmpty = true.obs;
  RxBool fileAccepted = false.obs;
  RxString selectedText = 'No file selected.'.obs;

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      final _file = File(result.files.first.path!);
      if ((_file.lengthSync() / (1024 * 1024)) < 10) {
        pickedFile = result.files.first;
        fileAccepted.value = true;
        selectEmpty.value = false;
        selectedText.value = pickedFile!.name.toString();
      } else {
        pickedFile = result.files.first;
        selectEmpty.value = false;
        selectedText.value = pickedFile!.name.toString();
        fileAccepted.value = false;
      }
    } else {
      return;
    }
  }

  void removeSelection() {
    pickedFile = null;
    selectEmpty.value = true;
    fileAccepted.value = false;
    selectedText.value = 'No file selected.';
  }

  Future<void> uploadPhoto(String time) async {
    if (appController.hasConnection.value) {
      final path = 'reports/${time}/${pickedFile!.name}';
      final file = File(pickedFile!.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      await ref.putFile(file);
      await ref.getDownloadURL().then((downloadUrl) {
        fileUrl = downloadUrl;
      });
    } else {
      appController.showConnectionSnackbar();
    }
  }

  Future<void> sendReport() async {
    if (appController.hasConnection.value) {
      final String timestamp =
          DateFormat('yyyy-MM-dd (HH:mm:ss)').format(DateTime.now());
      final reportFormValid = reportFormKey.currentState!.validate();
      if (!reportFormValid || (selectEmpty == false && fileAccepted == false)) {
        return;
      }
      reportFormKey.currentState!.save();
      isProcessing.value = true;

      if (selectEmpty == false && fileAccepted == true) {
        await uploadPhoto(timestamp);
      }

      final reportInfo = ReportModel(
          email: email != '' ? email : null,
          problemType: reportType,
          subject: subject,
          details: reportDetail,
          timestamp: timestamp,
          imgUrl: fileUrl != '' ? fileUrl : null);

      await databaseRepo.createReportOnDB(reportInfo, timestamp);
    } else {
      appController.showConnectionSnackbar();
    }
  }
}
