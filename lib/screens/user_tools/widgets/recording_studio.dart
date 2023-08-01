import 'package:amanu/screens/user_tools/controllers/recorder_controller.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:amanu/widgets/components/three_part_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class RecordingStudioPage extends StatelessWidget {
  RecordingStudioPage({
    super.key,
  });

  final controller = Get.put(StudioController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenPadding = MediaQuery.of(context).padding;
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          top: screenPadding.top + 50,
          left: 0,
          right: 0,
          child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              height: size.height - screenPadding.top - 50,
              width: size.width,
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        tUploadAudio,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: disabledGrey,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 60.0,
                        child: Stack(
                          children: [
                            Container(
                              height: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                border: Border.all(color: Color(0xFF9B9B9B)),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Obx(
                                      () => ElevatedButton(
                                        onPressed: () {
                                          controller.selectEmpty.value
                                              ? controller.selectFile()
                                              : controller.removeSelection();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            minimumSize:
                                                Size(80.0, double.infinity),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.horizontal(
                                                        left: Radius.circular(
                                                            20.0)))),
                                        child: Icon(
                                          controller.selectEmpty.value
                                              ? Icons.attach_file
                                              : Icons.close,
                                          size: 30.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      height: 60,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Obx(
                                          () => Text(
                                            controller.selectedText.value,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.normal,
                                              color: darkGrey,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(() => controller.selectEmpty.value
                          ? controller.fileError.value
                              ? Container(
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                  width: double.infinity,
                                  child: Text(
                                    'Please select an audio file or record below.',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.red[700], fontSize: 11.5),
                                  ))
                              : Container()
                          : controller.fileAccepted.value
                              ? Container()
                              : Container(
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                  width: double.infinity,
                                  child: Text(
                                    'File must not exceed 10MB.',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: Colors.red[700], fontSize: 11.5),
                                  ))),
                      SizedBox(
                        height: 20.0,
                      ),
                      Obx(
                        () => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: !controller.selectEmpty.value &&
                                  controller.fileAccepted.value
                              ? Container(
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                  child: Stack(children: [
                                    AudioFileWaveforms(
                                      size: Size(
                                        MediaQuery.of(context).size.width,
                                        50.0,
                                      ),
                                      playerController:
                                          controller.playerController,
                                      enableSeekGesture: true,
                                      waveformType: WaveformType.long,
                                      waveformData: [],
                                      playerWaveStyle: const PlayerWaveStyle(
                                        liveWaveColor: primaryOrangeLight,
                                        spacing: 6.0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        color: orangeCard,
                                      ),
                                      padding: EdgeInsets.only(left: 25),
                                    ),
                                    Obx(
                                      () => SizedBox(
                                        height: 50.0,
                                        width: 50.0,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            controller.playAndStop(
                                                controller.playerController);
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  primaryOrangeDark,
                                              fixedSize: Size(50.0, 50.0),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              40.0)))),
                                          child: Icon(
                                            controller.isPlaying.value
                                                ? Icons.pause
                                                : Icons.play_arrow,
                                            size: 20.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                )
                              : Container(),
                        ),
                      ),
                      SizedBox(
                        height: 50.0,
                      ),
                      Row(children: <Widget>[
                        Expanded(
                            child: Divider(
                          thickness: 2.0,
                        )),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "OR",
                            textAlign: TextAlign.left,
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              color: disabledGrey,
                            ),
                          ),
                        ),
                        Expanded(
                            child: Divider(
                          thickness: 2.0,
                        )),
                      ]),
                      SizedBox(
                        height: 40.0,
                      ),
                      Text(
                        tRecordAudio,
                        textAlign: TextAlign.left,
                        style: GoogleFonts.poppins(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: disabledGrey,
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Obx(
                        () => AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: controller.isRecordingCompleted.value
                              ? AudioFileWaveforms(
                                  size: Size(
                                    MediaQuery.of(context).size.width,
                                    150.0,
                                  ),
                                  playerController:
                                      controller.recordPlayerController,
                                  enableSeekGesture: true,
                                  waveformType: WaveformType.long,
                                  waveformData: [],
                                  playerWaveStyle: const PlayerWaveStyle(
                                    fixedWaveColor: Colors.white54,
                                    liveWaveColor: primaryOrangeLight,
                                    spacing: 6.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: orangeCard,
                                  ),
                                )
                              : AudioWaveforms(
                                  size: Size(
                                      MediaQuery.of(context).size.width, 150.0),
                                  recorderController:
                                      controller.recorderController,
                                  enableGesture: true,
                                  waveStyle: WaveStyle(
                                    waveColor: primaryOrangeLight,
                                    spacing: 6.0,
                                    showBottom: true,
                                    showMiddleLine: true,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: orangeCard,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        height: 80.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(
                              () => SizedBox(
                                height: 50.0,
                                width: 50.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (controller.isRecordingCompleted.value)
                                      controller.refreshWave();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          controller.isRecordingCompleted.value
                                              ? primaryOrangeDark
                                              : disabledGrey,
                                      minimumSize: Size(50.0, 50.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40.0)))),
                                  child: Icon(
                                    Icons.delete,
                                    size: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Obx(
                              () => !controller.isRecordingCompleted.value
                                  ? SizedBox(
                                      height: 70.0,
                                      width: 70.0,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          controller.startOrStopRecording();
                                        },
                                        style: ElevatedButton.styleFrom(
                                            minimumSize: Size(70.0, 70.0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(40.0)))),
                                        child: Icon(
                                          controller.isRecording.value
                                              ? Icons.stop
                                              : Icons.mic,
                                          size: 35.0,
                                        ),
                                      ),
                                    )
                                  : Container(),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            Obx(
                              () => SizedBox(
                                height: 50.0,
                                width: 50.0,
                                child: ElevatedButton(
                                  onPressed: () {
                                    controller.isRecordingCompleted.value &&
                                            !controller.isRecording.value
                                        ? controller.playAndStop(
                                            controller.recordPlayerController)
                                        : null;
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: controller
                                                  .isRecordingCompleted.value &&
                                              !controller.isRecording.value
                                          ? primaryOrangeDark
                                          : disabledGrey,
                                      minimumSize: Size(50.0, 50.0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(40.0)))),
                                  child: Icon(
                                    controller.recorderPlaying.value
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    size: 18.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Obx(() => controller.submitError.value
                          ? Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(vertical: 20.0),
                              alignment: Alignment.center,
                              child: Text(
                                controller.submitErrorMsg.value,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.red[700], fontSize: 14),
                              ),
                            )
                          : Container()),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              controller.submitFile();
                            },
                            style: ElevatedButton.styleFrom(
                              alignment: Alignment.center,
                              minimumSize: Size(100, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              tSubmitAudio.toUpperCase(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: pureWhite,
                                letterSpacing: 1.0,
                              ),
                            )),
                      )
                    ],
                  ),
                ),
              )),
        ),
        isProcessingWithHeader(controller.isLoading.value, size, screenPadding),
        for (Widget widget in threePartHeader(size, screenPadding,
            tRecordStudio, Icons.arrow_back_ios_new_rounded, Icons.help, () {
          Get.back();
        }, () {}, 0))
          widget
      ],
    ));
  }
}
