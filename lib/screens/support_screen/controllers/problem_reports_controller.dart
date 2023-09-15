import 'package:amanu/models/report_model.dart';
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:get/get.dart';

class ProblemReportsController extends GetxController {
  static ProblemReportsController get instance => Get.find();
  final appController = Get.find<ApplicationController>();
  List<ReportModel> reports = [];

  @override
  void onInit() {
    super.onInit();
    if (appController.hasConnection.value) {
      getReports();
    } else {
      appController.showConnectionSnackbar();
    }
  }

  Future getReports() async {
    var snapshot = await DatabaseRepository.instance.getAllReports();
    reports = new List.from(snapshot);
  }
}
