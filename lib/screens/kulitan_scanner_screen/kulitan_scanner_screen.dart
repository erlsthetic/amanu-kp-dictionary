import 'dart:io';
import 'dart:ui';

import 'package:amanu/components/loader_dialog.dart';
import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/kulitan_scanner_screen/controllers/kulitan_scanner_controller.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/image_strings.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/components/three_part_header.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class KulitanScannerScreen extends StatefulWidget {
  KulitanScannerScreen({
    super.key,
    this.fromDrawer = true,
  });

  final bool fromDrawer;

  @override
  State<KulitanScannerScreen> createState() => _KulitanScannerScreenState();
}

class _KulitanScannerScreenState extends State<KulitanScannerScreen>
    with WidgetsBindingObserver {
  final drawerController = Get.find<DrawerXController>();
  final appController = Get.find<ApplicationController>();
  final controller = Get.put(KulitanScannerController());
  CameraController? camController;
  bool _isCameraInitialized = false;

  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentZoomLevel = 1.0;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;
  FlashMode? _currentFlashMode;
  bool _isRearCameraSelected = true;

  String? filePath;

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = camController;
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await previousCameraController?.dispose();

    if (mounted) {
      setState(() {
        camController = cameraController;
      });
    }

    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    cameraController
        .getMaxZoomLevel()
        .then((value) => _maxAvailableZoom = value);
    cameraController
        .getMinZoomLevel()
        .then((value) => _minAvailableZoom = value);
    cameraController
        .getMinExposureOffset()
        .then((value) => _minAvailableExposureOffset = value);
    cameraController
        .getMaxExposureOffset()
        .then((value) => _maxAvailableExposureOffset = value);
    _currentFlashMode = camController!.value.flashMode;

    await camController!.lockCaptureOrientation(DeviceOrientation.portraitUp);

    if (mounted) {
      setState(() {
        _isCameraInitialized = camController!.value.isInitialized;
      });
    }
  }

  Future toggleFlashMode() async {
    if (_currentFlashMode == FlashMode.off) {
      setState(() {
        _currentFlashMode = FlashMode.always;
      });
      await camController!.setFlashMode(
        FlashMode.always,
      );
    } else if (_currentFlashMode == FlashMode.always) {
      setState(() {
        _currentFlashMode = FlashMode.auto;
      });
      await camController!.setFlashMode(
        FlashMode.auto,
      );
    } else if (_currentFlashMode == FlashMode.auto) {
      setState(() {
        _currentFlashMode = FlashMode.torch;
      });
      await camController!.setFlashMode(
        FlashMode.torch,
      );
    } else {
      setState(() {
        _currentFlashMode = FlashMode.off;
      });
      await camController!.setFlashMode(
        FlashMode.off,
      );
    }
  }

  Future switchCamera() async {
    setState(() {
      _isCameraInitialized = false;
    });
    onNewCameraSelected(
      appController.cameras[_isRearCameraSelected ? 1 : 0],
    );
    setState(() {
      _isRearCameraSelected = !_isRearCameraSelected;
    });
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (camController == null) {
      return;
    }
    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    camController!.setExposurePoint(offset);
    camController!.setFocusPoint(offset);
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = camController;
    if (cameraController!.value.isTakingPicture) {
      return null;
    }
    showLoaderDialog(context);
    try {
      XFile file = await cameraController.takePicture();
      Navigator.of(context).pop();
      return file;
    } on CameraException catch (e) {
      print('Error occurred while taking picture: $e');
      Navigator.of(context).pop();
      Helper.errorSnackBar(
          title: "Unable to capture image.",
          message:
              "An error has occurred trying to capture image. pLease try again.");
      return null;
    }
  }

  Future pickFromFiles() async {
    final CameraController? cameraController = camController;
    if (cameraController!.value.isTakingPicture) {
      return null;
    }
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      setState(() {
        filePath = result.files.first.path!;
      });
    }
  }

  @override
  void initState() {
    onNewCameraSelected(appController.cameras[0]);

    if (appController.isFirstTimeScanner) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(seconds: 1), () {
          showTutorial();
        });
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    camController?.dispose();
    super.dispose();
  }

  TutorialCoachMark? tutorialCoachMark;

  void showTutorial() {
    tutorialCoachMark = TutorialCoachMark(
        pulseEnable: false,
        targets: controller.initTarget(),
        imageFilter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
        onFinish: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("isFirstTimeScanner", false);
          appController.isFirstTimeScanner = false;
        },
        onSkip: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool("isFirstTimeScanner", false);
          appController.isFirstTimeScanner = false;
        },
        hideSkip: true)
      ..show(context: context);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = camController;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    controller.context = context;
    return Padding(
      padding: EdgeInsets.only(bottom: screenPadding.bottom),
      child: Scaffold(
          key: controller.scannerAllKey,
          body: WillPopScope(
            onWillPop: () async {
              if (filePath != null) {
                setState(() {
                  filePath = null;
                });
                return Future.value(false);
              } else {
                return Future.value(true);
              }
            },
            child: Stack(
              children: [
                !_isCameraInitialized
                    ? Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: size.height,
                          width: size.width,
                          decoration: BoxDecoration(color: Colors.black),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        color: pureWhite),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Loading cameras...",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: pureWhite),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : filePath == null
                        ? Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
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
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              height: size.height,
                              width: size.width,
                              decoration: BoxDecoration(color: Colors.black),
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio:
                                      1 / camController!.value.aspectRatio,
                                  child: CameraPreview(
                                    camController!,
                                    child: LayoutBuilder(builder:
                                        (BuildContext context,
                                            BoxConstraints constraints) {
                                      return GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTapDown: (details) => onViewFinderTap(
                                            details, constraints),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            child: Container(
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
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              height: size.height,
                              width: size.width,
                              decoration: BoxDecoration(color: Colors.black),
                              child: AspectRatio(
                                aspectRatio:
                                    1 / camController!.value.aspectRatio,
                                child: Image.file(
                                  File(filePath!),
                                ),
                              ),
                            ),
                          ),
                Positioned(
                  right: 10,
                  top: 0,
                  child: filePath != null || !_isCameraInitialized
                      ? Container()
                      : Container(
                          height: size.height,
                          padding: EdgeInsets.fromLTRB(
                              0,
                              screenPadding.top + 80,
                              0,
                              (size.width * 0.2 + 80)),
                          child: Column(
                            key: controller.scannerExposureKey,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "EV " +
                                        _currentExposureOffset
                                            .toStringAsFixed(1),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Container(
                                    height: 30,
                                    child: Slider(
                                      value: _currentExposureOffset,
                                      min: _minAvailableExposureOffset,
                                      max: _maxAvailableExposureOffset,
                                      activeColor: Colors.white,
                                      inactiveColor: Colors.white30,
                                      onChanged: (value) async {
                                        setState(() {
                                          _currentExposureOffset = value;
                                        });
                                        await camController!
                                            .setExposureOffset(value);
                                      },
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: filePath != null || !_isCameraInitialized
                      ? Container()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: size.width,
                              height: 50,
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                key: controller.scannerZoomKey,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Slider(
                                      value: _currentZoomLevel,
                                      min: _minAvailableZoom,
                                      max: _maxAvailableZoom,
                                      activeColor: Colors.white,
                                      inactiveColor: Colors.white30,
                                      onChanged: (value) async {
                                        setState(() {
                                          _currentZoomLevel = value;
                                        });
                                        await camController!
                                            .setZoomLevel(value);
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black87,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _currentZoomLevel.toStringAsFixed(1) +
                                            'x',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                                height: size.width * 0.2 + 30,
                                width: size.width,
                                alignment: Alignment.topCenter,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: size.width * 0.2,
                                      width: size.width * 0.25,
                                      child: IconButton(
                                        icon: Icon(
                                          key: controller.scannerFlashKey,
                                          _currentFlashMode == FlashMode.off
                                              ? Icons.flash_off_rounded
                                              : _currentFlashMode ==
                                                      FlashMode.always
                                                  ? Icons.flash_on_rounded
                                                  : _currentFlashMode ==
                                                          FlashMode.auto
                                                      ? Icons.flash_auto_rounded
                                                      : Icons.highlight_rounded,
                                          color: pureWhite,
                                          size: 30,
                                        ),
                                        onPressed: () async {
                                          await toggleFlashMode();
                                        },
                                      ),
                                    ),
                                    Container(
                                      height: size.width * 0.2,
                                      width: size.width * 0.2,
                                      key: controller.scannerButtonKey,
                                      child: FittedBox(
                                        child: FloatingActionButton(
                                            splashColor: primaryOrangeLight,
                                            focusColor: primaryOrangeLight
                                                .withOpacity(0.5),
                                            backgroundColor: primaryOrangeDark,
                                            child: Padding(
                                                padding: EdgeInsets.all(5.0),
                                                child: Container(
                                                  height: double.infinity,
                                                  width: double.infinity,
                                                  child: SvgPicture.asset(
                                                      iAmanuWhiteButtonIcon),
                                                )),
                                            elevation: 3,
                                            onPressed: () async {
                                              await camController!.pausePreview;
                                              XFile? rawImage =
                                                  await takePicture();
                                              if (rawImage != null) {
                                                File rotatedImage =
                                                    await FlutterExifRotation
                                                        .rotateImage(
                                                            path:
                                                                rawImage.path);
                                                setState(() {
                                                  filePath = rotatedImage.path;
                                                });
                                                if (filePath != null) {
                                                  await controller.predictImage(
                                                      filePath!, context, size);
                                                }
                                              }
                                              await camController!
                                                  .resumePreview();
                                            }),
                                      ),
                                    ),
                                    Container(
                                      height: size.width * 0.2,
                                      width: size.width * 0.25,
                                      alignment: Alignment.center,
                                      child: IconButton(
                                        icon: Icon(
                                          key: controller.scannerSwitchKey,
                                          Icons.cameraswitch_rounded,
                                          color: pureWhite,
                                          size: 30,
                                        ),
                                        onPressed: () async {
                                          await switchCamera();
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                ),
                filePath == null
                    ? Positioned(
                        top: screenPadding.top,
                        right: 70,
                        child: Container(
                          key: controller.scannerUploadKey,
                          height: 70,
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () async {
                              await pickFromFiles();
                              if (filePath != null) {
                                await controller.predictImage(
                                    filePath!, context, size);
                              }
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
                          ),
                        ),
                      )
                    : Container(),
                filePath == null
                    ? ThreePartHeader(
                        hasBG: false,
                        hasTitle: false,
                        size: size,
                        screenPadding: screenPadding,
                        title: tKulitanScanner,
                        firstIcon: widget.fromDrawer
                            ? Icons.menu_rounded
                            : Icons.arrow_back_ios_new_rounded,
                        firstOnPressed: () {
                          widget.fromDrawer
                              ? drawerController.drawerToggle(context)
                              : Get.back();
                        },
                        secondOnPressed: () {
                          if (!camController!.value.isTakingPicture) {
                            showTutorial();
                          }
                        },
                      )
                    : ThreePartHeader(
                        hasBG: false,
                        hasTitle: false,
                        size: size,
                        screenPadding: screenPadding,
                        title: tKulitanScanner,
                        firstIcon: Icons.arrow_back_ios_new_rounded,
                        secondIconDisabled: true,
                        firstOnPressed: () {
                          setState(() {
                            filePath = null;
                          });
                        },
                      )
              ],
            ),
          )),
    );
  }
}
