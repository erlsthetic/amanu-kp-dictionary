import 'package:amanu/models/add_request_model.dart';
import 'package:amanu/models/delete_request_model.dart';
import 'package:amanu/models/edit_request_model.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:get/get.dart';

class RequestsController extends GetxController {
  static RequestsController get instance => Get.find();
  List<dynamic> requests = [];

  @override
  void onInit() async {
    super.onInit();
    List<AddRequestModel> addRequests =
        await DatabaseRepository.instance.getAllAddRequests();
    List<EditRequestModel> editRequests =
        await DatabaseRepository.instance.getAllEditRequests();
    List<DeleteRequestModel> deleteRequests =
        await DatabaseRepository.instance.getAllDeleteRequests();
    requests.addAll(addRequests);
    requests.addAll(editRequests);
    requests.addAll(deleteRequests);
    requests.sort(
      (a, b) => a.requestId.compareTo(b.requestId),
    );
  }
}
