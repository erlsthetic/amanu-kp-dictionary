import 'dart:io';

import 'package:amanu/models/add_request_model.dart';
import 'package:amanu/models/delete_request_model.dart';
import 'package:amanu/models/edit_request_model.dart';
import 'package:amanu/models/feedback_model.dart';
import 'package:amanu/models/report_model.dart';
import 'package:amanu/models/user_model.dart';
import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/drawer_launcher.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

class DatabaseRepository extends GetxController {
  static DatabaseRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _realtimeDB = FirebaseDatabase.instance.ref();

  Future createUserOnDB(UserModel user, String uid) async {
    await _db.collection("users").doc(uid).set(user.toJson()).whenComplete(() {
      Helper.successSnackBar(
        title: tSuccess,
        message: tAccountCreated,
      );
      // ignore: body_might_complete_normally_catch_error
    }).catchError((error, stackTrace) {
      Helper.errorSnackBar(
        title: tOhSnap,
        message: tSomethingWentWrong,
      );
      print(error.toString());
    });
  }

  Future updateUserOnDB(Map<String, dynamic> changes, String uid) async {
    await _db.collection("users").doc(uid).update(changes).whenComplete(() {
      Helper.successSnackBar(
        title: tSuccess,
        message: tAccountUpdated,
      );
      // ignore: body_might_complete_normally_catch_error
    }).catchError((error, stackTrace) {
      Helper.errorSnackBar(
        title: tOhSnap,
        message: tSomethingWentWrong,
      );
      print(error.toString());
    });
  }

  Future<String?> uploadPic(
      String uid, String photoSource, bool fromGoogle) async {
    final listResults = await FirebaseStorage.instance
        .ref()
        .child('users/${uid}/profile')
        .listAll();
    if (listResults.items.length > 0) {
      for (Reference item in listResults.items) {
        await item.delete();
      }
    }
    String scaledSource = photoSource;
    if (fromGoogle) {
      scaledSource = photoSource.replaceAll("s96-c", "s492-c");
    }
    final fileExt =
        extension(fromGoogle ? File(scaledSource).path : scaledSource);
    final path = 'users/${uid}/profile/profilePic${fileExt}';
    final file = File(scaledSource);
    final ref = FirebaseStorage.instance.ref().child(path);
    String dlUrl = '';
    try {
      await ref.putFile(file);
      await ref.getDownloadURL().then((downloadUrl) {
        dlUrl = downloadUrl;
        return dlUrl;
      });
    } catch (e) {
      return null;
    }
    if (dlUrl != '') {
      return dlUrl;
    }
    return null;
  }

  Future<UserModel?> getUserDetails(String uid) async {
    final snapshot = await _db
        .collection("users")
        .where("uid", isEqualTo: uid)
        .get()
        .catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<String> getWordOfTheDay() async {
    final snapshot = await _db
        .collection("amanu")
        .doc("wordOfTheDay")
        .get()
        .catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
    if (snapshot.exists) {
      Map<String, dynamic>? data = snapshot.data();
      return data?["wordOfTheDay"] ?? "null";
    } else {
      return "null";
    }
  }

  Future createReportOnDB(ReportModel report, String timestamp) async {
    await _db
        .collection("reports")
        .doc(timestamp)
        .set(report.toJson())
        .catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    }).whenComplete(() {
      Get.back();
      Helper.successSnackBar(title: tReportSent, message: tReportSentBody);
    });
  }

  Future createFeedbackOnDB(FeedbackModel feedback, String timestamp) async {
    await _db
        .collection("feedbacks")
        .doc(timestamp)
        .set(feedback.toJson())
        .catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    }).whenComplete(() {
      Get.back();
      Helper.successSnackBar(title: tFeedbackSent, message: tFeedbackSentBody);
    });
  }

  Future createDeleteRequestOnDB(
      DeleteRequestModel request, String timestamp, String uid) async {
    await _db
        .collection("requests")
        .doc(timestamp + "-" + uid)
        .set(request.toJson())
        .catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    }).whenComplete(() {
      final drawerController = Get.find<DrawerXController>();
      drawerController.currentItem.value = DrawerItems.home;
      Get.offAll(() => DrawerLauncher());
      Helper.successSnackBar(
          title: tDeleteRequestSent, message: tRequestSentBody);
    });
  }

  Future<DeleteRequestModel?> getDeleteRequest(String requestID) async {
    final snapshot = await _db
        .collection("requests")
        .where("requestId", isEqualTo: requestID)
        .get()
        .catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
    final request =
        snapshot.docs.map((e) => DeleteRequestModel.fromSnapshot(e)).single;
    return request;
  }

  Future<List<DeleteRequestModel>> getAllDeleteRequests() async {
    final snapshot = await _db
        .collection("requests")
        .where("requestType", isEqualTo: 2)
        .get()
        .catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
    final requests =
        snapshot.docs.map((e) => DeleteRequestModel.fromSnapshot(e)).toList();
    return requests;
  }

  Future createAddRequestOnDB(
      AddRequestModel request, String timestamp, String uid) async {
    await _db
        .collection("requests")
        .doc(timestamp + "-" + uid)
        .set(request.toJson())
        .catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    }).whenComplete(() {
      final drawerController = Get.find<DrawerXController>();
      drawerController.currentItem.value = DrawerItems.home;
      Get.offAll(() => DrawerLauncher());
      Helper.successSnackBar(title: tAddRequestSent, message: tRequestSentBody);
    });
  }

  Future<AddRequestModel?> getAddRequest(String requestID) async {
    final snapshot = await _db
        .collection("requests")
        .where("requestId", isEqualTo: requestID)
        .get()
        .catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
    final request =
        snapshot.docs.map((e) => AddRequestModel.fromSnapshot(e)).single;
    return request;
  }

  Future<List<AddRequestModel>> getAllAddRequests() async {
    final snapshot = await _db
        .collection("requests")
        .where("requestType", isEqualTo: 0)
        .get()
        .catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
    final requests =
        snapshot.docs.map((e) => AddRequestModel.fromSnapshot(e)).toList();
    return requests;
  }

  Future createEditRequestOnDB(
      EditRequestModel request, String timestamp, String uid) async {
    await _db
        .collection("requests")
        .doc(timestamp + "-" + uid)
        .set(request.toJson())
        .catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    }).whenComplete(() {
      final drawerController = Get.find<DrawerXController>();
      drawerController.currentItem.value = DrawerItems.home;
      Get.offAll(() => DrawerLauncher());
      Helper.successSnackBar(
          title: tEditRequestSent, message: tRequestSentBody);
    });
  }

  Future<EditRequestModel?> getEditRequest(String requestID) async {
    final snapshot = await _db
        .collection("requests")
        .where("requestId", isEqualTo: requestID)
        .get()
        .catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
    final request =
        snapshot.docs.map((e) => EditRequestModel.fromSnapshot(e)).single;
    return request;
  }

  Future<List<EditRequestModel>> getAllEditRequests() async {
    final snapshot = await _db
        .collection("requests")
        .where("requestType", isEqualTo: 1)
        .get()
        .catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
    final requests =
        snapshot.docs.map((e) => EditRequestModel.fromSnapshot(e)).toList();
    return requests;
  }

  Future changeRequestState(String requestID, bool condition) async {
    await _db
        .collection("requests")
        .doc(requestID)
        .update({"isAvailable": condition}).catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
  }

  Future addWordOnDB(String wordID, Map details) async {
    await _realtimeDB
        .child("dictionary")
        .child(wordID)
        .set(details)
        .whenComplete(() {
      return Helper.successSnackBar(
          title: tSuccess, message: details["word"] + tAddSuccess);
    }).catchError((error, stackTrace) {
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
  }

  Future updateWordOnDB(String wordID, String prevWordID, Map details) async {
    if (prevWordID != wordID) {
      await _realtimeDB
          .child("dictionary")
          .child(prevWordID)
          .remove()
          .catchError((error, stackTrace) {
        return Helper.errorSnackBar(
            title: tOhSnap, message: tSomethingWentWrong);
      });
    }
    await _realtimeDB
        .child("dictionary")
        .child(wordID)
        .set(details)
        .whenComplete(() {
      return Helper.successSnackBar(
          title: tSuccess, message: details["word"] + tEditSuccess);
    }).catchError((error, stackTrace) {
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
  }

  Future removeWordOnDB(String wordID, String word) async {
    final snapshot = await _realtimeDB.child("dictionary").child(wordID).get();
    if (snapshot.exists) {
      await _realtimeDB
          .child("dictionary")
          .child(wordID)
          .remove()
          .whenComplete(() {
        return Helper.successSnackBar(
            title: tSuccess, message: word + tDeleteSuccess);
      }).catchError((error, stackTrace) {
        return Helper.errorSnackBar(
            title: tOhSnap, message: tSomethingWentWrong);
      });
    } else {
      return Helper.errorSnackBar(
          title: word + tDeleteNotFound, message: tDeleteNotFoundBody);
    }
  }
}
