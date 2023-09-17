import 'package:amanu/screens/user_tools/controllers/modify_word_controller.dart';
import 'package:amanu/screens/user_tools/widgets/recording_studio.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class StudioFormField extends FormField {
  StudioFormField(
      {required ModifyController controller,
      required FormFieldSetter onSaved,
      required FormFieldValidator validator,
      AutovalidateMode mode = AutovalidateMode.onUserInteraction})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: controller.audioPath,
            autovalidateMode: mode,
            builder: (FormFieldState state) {
              return Column(
                children: [
                  Container(
                    height: 50,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Container(
                            decoration: BoxDecoration(
                              color: orangeCard,
                              borderRadius: BorderRadius.circular(25),
                              border: state.hasError
                                  ? Border.all(color: Colors.red.shade700)
                                  : null,
                            ),
                            child: Stack(children: [
                              Obx(
                                () => controller.hasFile.value
                                    ? new Container(
                                        padding: EdgeInsets.only(left: 15),
                                        child: Obx(
                                          () => new AudioFileWaveforms(
                                            size: Size(
                                              double.infinity,
                                              50.0,
                                            ),
                                            playerController:
                                                controller.playerController,
                                            enableSeekGesture:
                                                controller.rebuildAudio.value
                                                    ? true
                                                    : true,
                                            waveformType: WaveformType.long,
                                            // ignore: invalid_use_of_protected_member
                                            waveformData: [],
                                            playerWaveStyle: PlayerWaveStyle(
                                              liveWaveColor: primaryOrangeLight,
                                              spacing: 6.0,
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30.0),
                                              color: orangeCard,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        alignment: Alignment.center,
                                        padding:
                                            EdgeInsets.fromLTRB(25, 5, 5, 5),
                                        height: double.infinity,
                                        width: double.infinity,
                                        child: Text(
                                          "No data",
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: disabledGrey,
                                          ),
                                        ),
                                      ),
                              ),
                              Obx(
                                () => GestureDetector(
                                  onTap: () => controller
                                      .playAndStop(controller.playerController),
                                  child: Container(
                                    height: double.infinity,
                                    width: 40,
                                    margin: EdgeInsets.all(5.0),
                                    child: Icon(
                                      controller.isPlaying.value
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: pureWhite,
                                    ),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: controller.hasFile.value
                                            ? primaryOrangeDark
                                            : disabledGrey),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => RecordingStudioPage(), 
                                                              duration: Duration(milliseconds: 500),
                              transition: Transition.rightToLeft,
                              curve: Curves.easeInOut);
                              controller.playerController.stopPlayer();
                              state.reset();
                            },
                            child: Container(
                              height: double.infinity,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  tEnterStudio.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
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
                      ],
                    ),
                  ),
                  state.hasError
                      ? Container(
                          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                          width: double.infinity,
                          child: Text(
                            state.errorText!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Colors.red[700], fontSize: 12),
                          ))
                      : Container()
                ],
              );
            });
}
