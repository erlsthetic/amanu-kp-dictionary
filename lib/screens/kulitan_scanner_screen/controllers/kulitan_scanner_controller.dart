import 'dart:io';

import 'package:amanu/components/info_dialog.dart';
import 'package:amanu/components/loader_dialog.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../utils/constants/app_colors.dart';

class KulitanScannerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static KulitanScannerController get instance => Get.find();
  final appController = Get.find<ApplicationController>();
  RxBool cameraError = false.obs;
  RxString cameraErrorString = ''.obs;
  RxInt flashMode = 0.obs;
  int cameraMode = 0;
  RxBool withImage = false.obs;
  RxString imagePath = ''.obs;
  late CameraController cameraController;
  final resolutionPresets = ResolutionPreset.values;
  ResolutionPreset currentResolutionPreset = ResolutionPreset.high;
  RxBool isInitialized = false.obs;
  Image? predictionImage = null;
  TransformationController? transController;
  TapDownDetails? tapDownDetails;
  late AnimationController zoomAnimController;
  Animation<Matrix4>? anim;

  @override
  void onClose() {
    super.onClose();
    cameraController.dispose();
    if (transController != null) transController!.dispose();
    zoomAnimController.dispose();
  }

  @override
  void onInit() async {
    super.onInit();
    final firstCamera = appController.cameras.first;
    await initCamera(firstCamera);
    transController = TransformationController();
    zoomAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            if (transController == null)
              transController = TransformationController();
            transController!.value = anim!.value;
          });
  }

  void resetAnimation() {
    if (transController == null) transController = TransformationController();
    anim = Matrix4Tween(begin: transController!.value, end: Matrix4.identity())
        .animate(CurveTween(curve: Curves.easeOut).animate(zoomAnimController));
    zoomAnimController.forward(from: 0);
  }

  Future initCamera(CameraDescription cam) async {
    cameraController = CameraController(cam, ResolutionPreset.max,
        imageFormatGroup: ImageFormatGroup.jpeg);

    try {
      await cameraController.initialize().then((value) {
        isInitialized.value = true;
      });
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          cameraError.value = true;
          cameraErrorString.value =
              "Camera access denied.\nGo to Settings > App Permissions and allow camera access to " +
                  tAppName;
          break;
        default:
          cameraError.value = true;
          cameraErrorString.value =
              "Camera error has occurred.\nPlease try restarting the application.";
          break;
      }
    }
  }

  Future switchCamera() async {
    if (cameraMode == 0) {
      if (appController.cameras.length > 1) {
        initCamera(appController.cameras[1]);
      } else {
        Helper.successSnackBar(
            title: "Camera switch on single camera.",
            message: "There's only one camera in this device.");
      }
    } else if (cameraMode == 1) {
      if (appController.cameras.length > 0) {
        initCamera(appController.cameras[0]);
      } else {
        Helper.successSnackBar(
            title: "Camera switch failed.",
            message: "There's no camera in this device.");
      }
    }
  }

  void toggleFlash() {
    if (flashMode.value == 0) {
      flashMode.value = 1;
      cameraController.setFlashMode(FlashMode.always);
    } else if (flashMode.value == 1) {
      flashMode.value = 2;
      cameraController.setFlashMode(FlashMode.auto);
    } else if (flashMode.value == 2) {
      flashMode.value = 0;
      cameraController.setFlashMode(FlashMode.always);
    }
  }

  Future takePicture(BuildContext context, Size screenSize) async {
    if (appController.hasConnection.value) {
      if (!isInitialized.value || cameraController.value.isTakingPicture) {
        return;
      }
      if (withImage.value) {
        withImage.value = false;
        imagePath.value = '';
      } else {
        showLoaderDialog(context);
        XFile img = await cameraController.takePicture();
        imagePath.value = img.path;
        List<dynamic>? prediction = await getPrediction(imagePath.value);
        if (prediction == null) {
          Navigator.of(context).pop();
          Helper.errorSnackBar(
              title: "Unable to process request",
              message: "Please try again later.");
          return;
        } else {
          if (transController != null) transController!.dispose();
          tapDownDetails = null;
          transController = TransformationController();
          predictionImage = prediction[1];
          withImage.value = !withImage.value;
          Navigator.of(context).pop();
          showPredictionDialog(
              context, prediction[0], predictionImage!, screenSize);
        }
      }
    } else {
      appController.showConnectionSnackbar();
    }
  }

  Future fromUpload(BuildContext context, Size screenSize) async {
    if (appController.hasConnection.value) {
      if (cameraController.value.isTakingPicture) {
        return;
      }
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        showLoaderDialog(context);
        final filePath = result.files.first.path!;
        imagePath.value = filePath;
        List<dynamic>? prediction = await getPrediction(imagePath.value);
        if (prediction == null) {
          Navigator.of(context).pop();
          Helper.errorSnackBar(
              title: "Unable to process request",
              message: "Please try again later.");
          return;
        } else {
          if (transController != null) transController!.dispose();
          tapDownDetails = null;
          transController = TransformationController();
          predictionImage = prediction[1];
          withImage.value = !withImage.value;
          Navigator.of(context).pop();
          showPredictionDialog(
              context, prediction[0], predictionImage!, screenSize);
        }
      }
    } else {
      appController.showConnectionSnackbar();
    }
  }

  Future<List<dynamic>?> getPrediction(imagePath) async {
    File imgFile = File(imagePath);
    var api_url = "http://35.240.137.252/";
    final request = http.MultipartRequest("POST", Uri.parse(api_url));
    final header = {"Content-Type": "multipart/form-data"};
    request.files.add(http.MultipartFile(
        'file', imgFile.readAsBytes().asStream(), imgFile.lengthSync(),
        filename: imgFile.path.split('/').last));
    request.headers.addAll(header);
    final myRequest = await request.send();
    http.Response res = await http.Response.fromStream(myRequest);
    if (myRequest.statusCode == 200) {
      final resJson = jsonDecode(res.body);
      print("API response: " + resJson.toString());
      final prediction = resJson["prediction"];
      final annotated = Image.memory(base64Decode(resJson["image"]));
      return [prediction, annotated];
    } else {
      return null;
    }
  }

  void showPredictionDialog(BuildContext context, String prediction,
      Image annotated, Size screenSize) {
    showInfoDialog(
        context,
        "Result",
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              padding: EdgeInsets.only(bottom: 10),
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: screenSize.height * 0.45),
              child: annotated,
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              alignment: Alignment.center,
              child: Text(
                "TRANSLITERATED TEXT:",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    color: disabledGrey,
                    height: 1.1),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 15, top: 5),
              child: Text(
                prediction,
                textAlign: TextAlign.center,
                style: GoogleFonts.robotoSlab(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: primaryOrangeDark,
                    height: 1.1),
              ),
            ),
            Material(
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () {},
                splashColor: primaryOrangeLight,
                highlightColor: primaryOrangeLight.withOpacity(0.5),
                child: Ink(
                  height: 40.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Search in dictionary".toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
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
            ),
            SizedBox(
              height: 10,
            ),
            Material(
              borderRadius: BorderRadius.circular(25),
              child: InkWell(
                borderRadius: BorderRadius.circular(25),
                onTap: () {},
                splashColor: primaryOrangeDarkShine,
                highlightColor: primaryOrangeDarkShine.withOpacity(0.5),
                child: Ink(
                  height: 40.0,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Copy to clipboard".toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: pureWhite,
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: primaryOrangeLight,
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ]),
        ));
  }
}
