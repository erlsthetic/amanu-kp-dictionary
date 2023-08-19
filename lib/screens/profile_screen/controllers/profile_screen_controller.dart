import 'package:amanu/models/user_model.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/auth/helper_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();
  ProfileController({required this.isOtherProfile, this.userID});
  final bool isOtherProfile;
  final String? userID;
  final appController = Get.find<ApplicationController>();
  String? userName, userEmail, userFullName, userBio, userPic;
  bool? userIsExpert, userExpertRequest;
  List<String>? userContributions;
  String contributionCount = '';
  bool userNotFound = false;

  @override
  void onInit() async {
    super.onInit();
    if (isOtherProfile) {
      await getUserDetails();
      if (userContributions != null && userContributions!.length > 0) {
        contributionCount = userContributions!.length.toString();
      } else {
        contributionCount = '0';
      }
    } else {
      userName = appController.userName;
      userEmail = appController.userEmail;
      userIsExpert = appController.userIsExpert;
      userExpertRequest = appController.userExpertRequest;
      userPic = appController.userPicLocal ?? null;
      userFullName = appController.userFullName ?? null;
      userBio = appController.userBio ?? null;
      userContributions = appController.userContributions ?? null;
      if (appController.userContributions != null &&
          appController.userContributions!.length > 0) {
        contributionCount = appController.userContributions!.length.toString();
      } else {
        contributionCount = '0';
      }
    }
  }

  Future getUserDetails() async {
    if (userID == null) {
      Get.back();
      Helper.errorSnackBar(
          title: tOhSnap, message: "Unable to get user details.");
    }
    try {
      UserModel user =
          await DatabaseRepository.instance.getUserDetails(userID!);
      userName = user.userName;
      userEmail = user.email;
      userIsExpert = user.isExpert;
      userExpertRequest = user.expertRequest;
      userPic = user.profileUrl;
      if (user.isExpert) {
        userFullName = user.exFullName;
        userBio = user.exBio;
      }
      userContributions = user.contributions == null
          ? null
          : user.contributions!.map((e) => e.toString()).toList();
    } catch (e) {
      userNotFound = true;
    }
  }
}
