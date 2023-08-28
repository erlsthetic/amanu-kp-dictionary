import 'dart:io';
import 'package:path/path.dart';

import 'package:amanu/screens/user_tools/controllers/modify_word_controller.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';

class StudioController extends GetxController {
  static StudioController get instance => Get.find();

  final addPageController = Get.find<ModifyController>();

  late final RecorderController recorderController;
  late final PlayerController playerController;
  late final PlayerController recordPlayerController;

  String? recordPath;
  String? selectedFile;
  RxBool isRecording = false.obs;
  RxBool isRecordingCompleted = false.obs;
  RxBool isPlaying = false.obs;
  RxBool recorderPlaying = false.obs;
  RxBool isLoading = true.obs;
  RxBool submitError = false.obs;
  RxString submitErrorMsg = "".obs;
  late Directory appDirectory;

  void _getDir() async {
    appDirectory = await getApplicationDocumentsDirectory();
    recordPath = "${appDirectory.path}/recording.m4a";
    isLoading.value = false;
  }

  void _initializeControllers() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 44100;
    recordPlayerController = PlayerController();
    playerController = PlayerController();
  }

  void startOrStopRecording() async {
    try {
      if (isRecording.value) {
        recorderController.reset();

        final path = await recorderController.stop(false);

        if (path != null) {
          isRecordingCompleted.value = true;
          debugPrint(path);
          debugPrint("Recorded file size: ${File(path).lengthSync()}");
        }
      } else {
        await recorderController.record(path: recordPath!);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      recordPlayerController.preparePlayer(path: recordPath!);
      isRecording.value = !isRecording.value;
      submitError.value = false;
    }
  }

  void refreshWave() {
    if (isRecording.value) recorderController.refresh();
    isRecordingCompleted.value = false;
    recordPlayerController.stopPlayer();
  }

  void playAndStop(PlayerController controller) async {
    if (controller.playerState == PlayerState.playing) {
      await controller.pausePlayer();
    } else {
      await controller.startPlayer(finishMode: FinishMode.loop);
    }

    playerController.playerState == PlayerState.playing
        ? isPlaying.value = true
        : isPlaying.value = false;

    recordPlayerController.playerState == PlayerState.playing
        ? recorderPlaying.value = true
        : recorderPlaying.value = false;
  }

  // Select file
  PlatformFile? pickedFile = null;
  RxBool selectEmpty = true.obs;
  RxBool fileError = false.obs;
  RxBool fileAccepted = false.obs;
  RxString selectedText = 'No file selected.'.obs;

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null) {
      final _file = File(result.files.first.path!);
      if ((_file.lengthSync() / (1024 * 1024)) < 10) {
        pickedFile = result.files.first;
        selectedFile = pickedFile!.path;
        fileAccepted.value = true;
        selectEmpty.value = false;
        fileError.value = false;
        selectedText.value = pickedFile!.name.toString();
        playerController.preparePlayer(path: selectedFile!);
        submitError.value = false;
      } else {
        pickedFile = result.files.first;
        selectedFile = null;
        selectEmpty.value = false;
        selectedText.value = pickedFile!.name.toString();
        fileAccepted.value = false;
        fileError.value = false;
      }
    } else {
      fileError.value = true;
      selectedFile = null;
      return;
    }
  }

  void removeSelection() {
    selectedFile = null;
    pickedFile = null;
    selectEmpty.value = true;
    fileAccepted.value = false;
    selectedText.value = 'No file selected.';
    playerController.stopPlayer();
    isPlaying.value = false;
  }

  void submitFile() async {
    if (!isRecordingCompleted.value &&
        !(!selectEmpty.value && fileAccepted.value)) {
      submitError.value = true;
      submitErrorMsg.value =
          "No audio detected. Please select an audio file or use the recorder.";
      return;
    } else if (isRecordingCompleted.value &&
        (!selectEmpty.value && fileAccepted.value)) {
      submitError.value = true;
      submitErrorMsg.value =
          "Two audios detected. Please remove audio from one of the options.";
      return;
    } else {
      if (isRecordingCompleted.value) {
        isLoading.value = true;
        addPageController.hasFile.value = true;
        addPageController.playerController.stopPlayer();
        addPageController.playerController.preparePlayer(path: recordPath!);
        addPageController.audioPath = recordPath!;
        Get.back();
        addPageController.rebuildAudio.value =
            !addPageController.rebuildAudio.value;
        addPageController.playerController.seekTo(0);
      }
      if (!selectEmpty.value && fileAccepted.value) {
        isLoading.value = true;
        addPageController.hasFile.value = true;
        addPageController.playerController.stopPlayer();
        addPageController.playerController.preparePlayer(path: selectedFile!);
        addPageController.audioPath = selectedFile!;
        Get.back();
        addPageController.rebuildAudio.value =
            !addPageController.rebuildAudio.value;
        addPageController.playerController.seekTo(0);
      }
    }
  }

  void checkForFile() async {
    if (recordPath == null) {
      appDirectory = await getApplicationDocumentsDirectory();
      recordPath = await "${appDirectory.path}/recording.m4a";
      isLoading.value = false;
    }
    if (addPageController.audioPath != "") {
      if (addPageController.audioPath == recordPath!) {
        recordPlayerController.startPlayer();
        recordPlayerController.preparePlayer(path: recordPath!);
        isRecordingCompleted.value = true;
        submitError.value = false;
      } else {
        selectedFile = addPageController.audioPath;
        fileAccepted.value = true;
        selectEmpty.value = false;
        fileError.value = false;
        selectedText.value = basename(addPageController.audioPath);
        playerController.stopPlayer();
        playerController.preparePlayer(path: selectedFile!);
        submitError.value = false;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    _getDir();
    _initializeControllers();
    checkForFile();
  }

  @override
  void onClose() {
    super.onClose();
    recorderController.dispose();
    playerController.dispose();
    recordPlayerController.dispose();
  }
}
