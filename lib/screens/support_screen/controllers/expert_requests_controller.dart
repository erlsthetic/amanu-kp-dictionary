import 'package:amanu/models/user_model.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:get/get.dart';

class ExpertRequestsController extends GetxController {
  static ExpertRequestsController get instance => Get.find();
  final appController = Get.find<ApplicationController>();
  List<UserModel> expertRequests = [];

  @override
  void onInit() {
    super.onInit();
    if (appController.hasConnection.value) {
      getAllRequests();
    } else {
      appController.showConnectionSnackbar();
    }
  }

  Future getAllRequests() async {
    var snapshot = await DatabaseRepository.instance.getAllExpertRequests();
    expertRequests = new List.from(snapshot);
  }
}
