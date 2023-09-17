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
import 'package:amanu/utils/application_controller.dart';
import 'package:amanu/utils/helper_controller.dart';
import 'package:amanu/utils/constants/text_strings.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as p;

class DatabaseRepository extends GetxController {
  static DatabaseRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;
  final _realtimeDB = FirebaseDatabase.instance.ref();

  Future createUserOnDB(UserModel user, String uid) async {
    await _db.collection("users").doc(uid).set(user.toJson()).then((value) {
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

  Future updateUserOnDB(
      Map<String, dynamic> changes, String uid, bool showSuccess) async {
    await _db.collection("users").doc(uid).update(changes).then((value) {
      if (showSuccess) {
        Helper.successSnackBar(
          title: tSuccess,
          message: tAccountUpdated,
        );
      }
    }).catchError((error, stackTrace) {
      if (showSuccess) {
        Helper.errorSnackBar(
          title: tOhSnap,
          message: tSomethingWentWrong,
        );
      }
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
        p.extension(fromGoogle ? File(scaledSource).path : scaledSource);
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

  Future<List<UserModel>> getAllExpertRequests() async {
    final snapshot = await _db
        .collection("users")
        .where("expertRequest", isEqualTo: true)
        .where("isExpert", isEqualTo: false)
        .get()
        .catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
    final requests =
        snapshot.docs.map((e) => UserModel.fromSnapshot(e)).toList();
    return requests;
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
        .then((value) {
      Get.back();
      Helper.successSnackBar(title: tReportSent, message: tReportSentBody);
    }).catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
  }

  Future deleteReportOnDB(
      String problemType, String subject, String timestamp) async {
    final snapshot = await _db
        .collection("reports")
        .where("timestamp", isEqualTo: timestamp)
        .where("problemType", isEqualTo: problemType)
        .where("subject", isEqualTo: subject)
        .get()
        .catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await _db
          .collection("reports")
          .doc(doc.id)
          .delete()
          .catchError((error, stackTrace) {
        print(error.toString());
        return Helper.errorSnackBar(
            title: tOhSnap, message: tSomethingWentWrong);
      });
    }
  }

  Future<List<ReportModel>> getAllReports() async {
    final snapshot =
        await _db.collection("reports").get().catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
    final reports =
        snapshot.docs.map((e) => ReportModel.fromSnapshot(e)).toList();
    return reports;
  }

  Future createFeedbackOnDB(FeedbackModel feedback, String timestamp) async {
    await _db
        .collection("feedbacks")
        .doc(timestamp)
        .set(feedback.toJson())
        .then((value) {
      Get.back();
      Helper.successSnackBar(title: tFeedbackSent, message: tFeedbackSentBody);
    }).catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
  }

  Future<List<FeedbackModel>> getAllFeedbacks() async {
    final snapshot =
        await _db.collection("feedbacks").get().catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
    final feedbacks =
        snapshot.docs.map((e) => FeedbackModel.fromSnapshot(e)).toList();
    return feedbacks;
  }

  Future createDeleteRequestOnDB(
      DeleteRequestModel request, String timestamp, String uid) async {
    await _db
        .collection("requests")
        .doc(timestamp + "-" + uid)
        .set(request.toJson())
        .then((value) {
      final drawerController = Get.find<DrawerXController>();
      drawerController.currentItem.value = DrawerItems.home;
      Get.offAll(() => DrawerLauncher(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
          curve: Curves.easeInOut);
      Helper.successSnackBar(
          title: tDeleteRequestSent, message: tRequestSentBody);
    }).catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
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
        .then((value) {
      final drawerController = Get.find<DrawerXController>();
      drawerController.currentItem.value = DrawerItems.home;
      Get.offAll(() => DrawerLauncher(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
          curve: Curves.easeInOut);
      Helper.successSnackBar(title: tAddRequestSent, message: tRequestSentBody);
    }).catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
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
        .then((value) {
      final drawerController = Get.find<DrawerXController>();
      drawerController.currentItem.value = DrawerItems.home;
      Get.offAll(() => DrawerLauncher(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
          curve: Curves.easeInOut);
      Helper.successSnackBar(
          title: tEditRequestSent, message: tRequestSentBody);
    }).catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
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

  Future<List<String>> uploadAudio(
      String wordID, String audioPath, String storagePath) async {
    final file = File(audioPath);
    final ext = p.extension(audioPath);
    final path = '${storagePath}/${wordID}/audio${ext}';
    final ref = FirebaseStorage.instance.ref().child(path);
    await ref.putFile(file);
    String audioUrl = '';
    await ref.getDownloadURL().then((downloadUrl) {
      audioUrl = downloadUrl;
    });
    return [path, audioUrl];
  }

  Future removeRequest(String requestID, String? audioPath) async {
    if (audioPath != null && audioPath != '') {
      await FirebaseStorage.instance.ref().child(audioPath).delete();
    }
    await _db
        .collection("requests")
        .doc(requestID)
        .delete()
        .catchError((error, stackTrace) {
      print(error.toString());
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
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

  Future<String> getAvailableWordKey(String key) async {
    final _realtimeDB = FirebaseDatabase.instance.ref();
    int modifier = 0;
    String currentString = key;
    bool notAvailable;
    var snapshot = await _realtimeDB.child("dictionary").child(key).get();
    if (snapshot.exists) {
      notAvailable = true;
      while (notAvailable) {
        currentString = key + modifier.toString();
        snapshot =
            await _realtimeDB.child("dictionary").child(currentString).get();
        if (snapshot.exists) {
          modifier += 1;
        } else {
          return currentString;
        }
      }
    } else {
      return currentString;
    }
  }

  Future<int> getDictionaryVersion() async {
    final dictionaryVersion = await _realtimeDB.child('version').get();
    return dictionaryVersion.value as int;
  }

  Future addWordOnDB(String wordID, Map details) async {
    await _realtimeDB
        .child("dictionary")
        .child(wordID)
        .set(details)
        .then((value) async {
      Map expert = details["expert"];
      Map contributors = details["contributors"];
      for (var uid in expert.values) {
        UserModel? user = await getUserDetails(uid);
        if (user != null) {
          Map<String, dynamic> changes = user.toJson();
          List<dynamic>? contributions = details["contributions"];
          if (contributions != null) {
            contributions.remove(wordID);
            contributions.add(wordID);
          } else {
            contributions = [];
            contributions.add(wordID);
          }
          changes["contributions"] = contributions;
          updateUserOnDB(changes, uid, false);
        }
      }
      for (var uid in contributors.values) {
        UserModel? user = await getUserDetails(uid);
        if (user != null) {
          Map<String, dynamic> changes = user.toJson();
          List<dynamic>? contributions = details["contributions"];
          if (contributions != null) {
            contributions.remove(wordID);
            contributions.add(wordID);
          } else {
            contributions = [];
            contributions.add(wordID);
          }
          changes["contributions"] = contributions;
          updateUserOnDB(changes, uid, false);
        }
      }
      return Helper.successSnackBar(
          title: tSuccess,
          message: details["word"]
                  .replaceAll("<i>", "")
                  .replaceAll("</i>", "")
                  .replaceAll("<b>", "")
                  .replaceAll("</b>", "")
                  .replaceAll("<u>", "")
                  .replaceAll("</u>", "") +
              tAddSuccess);
    }).catchError((error, stackTrace) {
      return Helper.errorSnackBar(title: tOhSnap, message: tSomethingWentWrong);
    });
  }

  Future updateWordOnDB(String wordID, String prevWordID, Map details) async {
    if (prevWordID != '') {
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
    }
    await _realtimeDB
        .child("dictionary")
        .child(wordID)
        .set(details)
        .then((value) async {
      Map expert = details["expert"];
      Map contributors = details["contributors"];
      for (var uid in expert.values) {
        UserModel? user = await getUserDetails(uid);
        if (user != null) {
          Map<String, dynamic> changes = user.toJson();
          List<dynamic>? contributions = details["contributions"];
          if (contributions != null) {
            contributions.remove(wordID);
            contributions.add(wordID);
          } else {
            contributions = [];
            contributions.add(wordID);
          }
          changes["contributions"] = contributions;
          updateUserOnDB(changes, uid, false);
        }
      }
      for (var uid in contributors.values) {
        UserModel? user = await getUserDetails(uid);
        if (user != null) {
          Map<String, dynamic> changes = user.toJson();
          List<dynamic>? contributions = details["contributions"];
          if (contributions != null) {
            contributions.remove(wordID);
            contributions.add(wordID);
          } else {
            contributions = [];
            contributions.add(wordID);
          }
          changes["contributions"] = contributions;
          updateUserOnDB(changes, uid, false);
        }
      }
      return Helper.successSnackBar(
          title: tSuccess,
          message: details["word"]
                  .replaceAll("<i>", "")
                  .replaceAll("</i>", "")
                  .replaceAll("<b>", "")
                  .replaceAll("</b>", "")
                  .replaceAll("<u>", "")
                  .replaceAll("</u>", "") +
              tEditSuccess);
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
          .then((value) {
        return Helper.successSnackBar(
            title: tSuccess,
            message: word
                    .replaceAll("<i>", "")
                    .replaceAll("</i>", "")
                    .replaceAll("<b>", "")
                    .replaceAll("</b>", "")
                    .replaceAll("<u>", "")
                    .replaceAll("</u>", "") +
                tDeleteSuccess);
      }).catchError((error, stackTrace) {
        return Helper.errorSnackBar(
            title: tOhSnap, message: tSomethingWentWrong);
      });
    } else {
      return Helper.errorSnackBar(
          title: word
                  .replaceAll("<i>", "")
                  .replaceAll("</i>", "")
                  .replaceAll("<b>", "")
                  .replaceAll("</b>", "")
                  .replaceAll("<u>", "")
                  .replaceAll("</u>", "") +
              tDeleteNotFound,
          message: tDeleteNotFoundBody);
    }
  }
}
