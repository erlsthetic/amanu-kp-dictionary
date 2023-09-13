import 'dart:io';

import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/kulitan_scanner_screen/controllers/kulitan_scanner_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class KulitanScannerScreen extends StatelessWidget with WidgetsBindingObserver {
  KulitanScannerScreen({
    super.key,
    this.fromDrawer = true,
  });

  final bool fromDrawer;
  final drawerController = Get.find<DrawerXController>();
  final controller = Get.put(KulitanScannerController());

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller.cameraController;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      controller.initCamera(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Padding(
      padding: EdgeInsets.only(bottom: screenPadding.bottom),
      child: Scaffold(
          body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Obx(() => controller.cameraError.value == false
                ? controller.withImage.value
                    ? Container(
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.35),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.35)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0, 0.2, 0.8, 1],
                          ),
                        ),
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        decoration: BoxDecoration(color: Colors.black),
                        height: size.height,
                        width: size.width,
                        child: controller.imagePath.value != ''
                            ? InteractiveViewer(
                                clipBehavior: Clip.none,
                                transformationController:
                                    controller.transController,
                                onInteractionEnd: (details) {
                                  controller.resetAnimation();
                                },
                                minScale: 1,
                                maxScale: 5,
                                panEnabled: false,
                                child: AspectRatio(
                                  aspectRatio: 1 /
                                      controller
                                          .cameraController.value.aspectRatio,
                                  child: FittedBox(
                                    child: controller.predictionImage ??
                                        Image.file(
                                          File(controller.imagePath.value),
                                        ),
                                  ),
                                ),
                              )
                            : Container(),
                      )
                    : Container(
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(0.35),
                              Colors.transparent,
                              Colors.transparent,
                              Colors.black.withOpacity(0.35)
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: [0, 0.2, 0.8, 1],
                          ),
                        ),
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        height: size.height,
                        width: size.width,
                        decoration: BoxDecoration(color: Colors.black),
                        child: controller.isInitialized.value
                            ? AspectRatio(
                                aspectRatio: 1 /
                                    controller
                                        .cameraController.value.aspectRatio,
                                child:
                                    CameraPreview(controller.cameraController))
                            : Center(child: CircularProgressIndicator()))
                : Container(
                    foregroundDecoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.black.withOpacity(0.35),
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black.withOpacity(0.35)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0, 0.2, 0.8, 1],
                      ),
                    ),
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    height: size.height,
                    width: size.width,
                    child: Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_rounded,
                          color: disabledGrey,
                          size: 50,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          controller.cameraErrorString.value,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: disabledGrey),
                        )
                      ],
                    )),
                  )),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
                height: size.height * 0.17,
                width: size.width,
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(
                      () => controller.withImage.value ||
                              !controller.isInitialized.value
                          ? Container()
                          : Container(
                              height: size.width * 0.17,
                              width: size.width * 0.25,
                              child: IconButton(
                                icon: Icon(
                                  controller.flashMode.value == 0
                                      ? Icons.flash_off_rounded
                                      : controller.flashMode.value == 1
                                          ? Icons.flash_on_rounded
                                          : Icons.flash_auto_rounded,
                                  color: pureWhite,
                                  size: 30,
                                ),
                                onPressed: () {
                                  controller.toggleFlash();
                                },
                              ),
                            ),
                    ),
                    Obx(
                      () => Container(
                        height: size.width * 0.17,
                        width: size.width * 0.17,
                        child: FittedBox(
                          child: FloatingActionButton(
                              splashColor: primaryOrangeLight,
                              focusColor: primaryOrangeLight.withOpacity(0.5),
                              backgroundColor: primaryOrangeDark,
                              child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Container(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: controller.withImage.value
                                        ? Padding(
                                            padding: EdgeInsets.all(15),
                                            child: SvgPicture.asset(iClose,
                                                colorFilter: ColorFilter.mode(
                                                    pureWhite,
                                                    BlendMode.srcIn)),
                                          )
                                        : SvgPicture.asset(
                                            iAmanuWhiteButtonIcon),
                                  )),
                              elevation: 3,
                              onPressed: () {
                                controller.takePicture(context, size);
                              }),
                        ),
                      ),
                    ),
                    Obx(
                      () => controller.withImage.value ||
                              !controller.isInitialized.value
                          ? Container()
                          : Container(
                              height: size.width * 0.17,
                              width: size.width * 0.25,
                              alignment: Alignment.center,
                              child: IconButton(
                                icon: Icon(
                                  Icons.cameraswitch_rounded,
                                  color: pureWhite,
                                  size: 30,
                                ),
                                onPressed: () {
                                  controller.switchCamera();
                                },
                              ),
                            ),
                    ),
                  ],
                )),
          ),
          Obx(
            () => controller.withImage.value || !controller.isInitialized.value
                ? Container()
                : ThreePartHeader(
                    hasBG: false,
                    hasTitle: false,
                    size: size,
                    screenPadding: screenPadding,
                    title: tKulitanScanner,
                    firstIcon: fromDrawer
                        ? Icons.menu_rounded
                        : Icons.arrow_back_ios_new_rounded,
                    firstOnPressed: () {
                      fromDrawer
                          ? drawerController.drawerToggle(context)
                          : Get.back();
                    },
                  ),
          ),
          Obx(
            () => controller.withImage.value || !controller.isInitialized.value
                ? Container()
                : Positioned(
                    top: screenPadding.top,
                    right: 70,
                    child: Container(
                        height: 70,
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () {
                            controller.fromUpload(context, size);
                          },
                          child: Text(
                            "UPLOAD\nINSTEAD",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                height: 1.1,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: pureWhite),
                          ),
                        ))),
          )
        ],
      )),
    );
  }
}
