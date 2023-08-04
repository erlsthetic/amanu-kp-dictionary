import 'dart:async';
import 'dart:convert';

import 'package:amanu/utils/constants/app_colors.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationController extends GetxController {
  static ApplicationController get instance => Get.find();

  final _realtimeDB = FirebaseDatabase.instance.ref();
  late StreamSubscription subscription;
  bool hasConnection = false;
  bool isOnWifi = false;

  @override
  void onInit() {
    super.onInit();
    subscription = Connectivity().onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        hasConnection = await InternetConnectionChecker().hasConnection;
      }
      isOnWifi = hasConnection
          ? result == ConnectivityResult.wifi
              ? false
              : true
          : false;
      print("hasConnection: ${hasConnection}");
      print("isOnWiFi: ${isOnWifi}");
    });
  }

  void showConnectionSnackbar(BuildContext context) {
    final title = hasConnection ? "Connected" : "Disconnected";
    final message = hasConnection
        ? isOnWifi
            ? "You are connected thru WiFi."
            : "You are connected thru mobile data."
        : "There is no internet connection";
    final color = hasConnection
        ? Colors.green.withOpacity(0.75)
        : Colors.redAccent.withOpacity(0.75);
    final icon = hasConnection ? Icons.check_circle : Icons.error;
    Get.snackbar(title, message,
        backgroundColor: color,
        colorText: pureWhite,
        icon: Icon(
          icon,
          color: pureWhite,
          size: 20,
        ),
        duration: Duration(seconds: 5),
        shouldIconPulse: true);
  }

  bool isLoggedIn = false;
  String? userID, userName, userEmail;
  int? userPhone;
  bool? userIsExpert, userExpertRequest;
  String? userFullName, userBio, userPic;

  Future getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isLoggedIn")) {
      isLoggedIn = prefs.getBool("isLoggedIn")!;
    } else {
      prefs.setBool("isLoggedIn", isLoggedIn);
    }
    userID = prefs.containsKey("userID") ? prefs.getString("userID") : null;
    userName =
        prefs.containsKey("userName") ? prefs.getString("userName") : null;
    userEmail =
        prefs.containsKey("userEmail") ? prefs.getString("userEmail") : null;
    userPhone =
        prefs.containsKey("userPhone") ? prefs.getInt("userPhone") : null;
    userIsExpert = prefs.containsKey("userIsExpert")
        ? prefs.getBool("userIsExpert")
        : null;
    userExpertRequest = prefs.containsKey("userExpertRequest")
        ? prefs.getBool("userExpertRequest")
        : null;
    userFullName = prefs.containsKey("userFullName")
        ? prefs.getString("userFullName")
        : null;
    userBio = prefs.containsKey("userBio") ? prefs.getString("userBio") : null;
    userPic = prefs.containsKey("userPic") ? prefs.getString("userPic") : null;
  }

  String? dictionaryVersion, dictionaryContentAsString;
  Map<String, dynamic> dictionaryContent = {};

  Future checkDictionary() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (hasConnection) {
      if (prefs.containsKey("dictionaryVersion")) {
        final storedVersion = prefs.getString("dictionaryVersion");
        final currentVersion = await getDictionaryVersion();
        if (currentVersion != storedVersion) {
          dictionaryContent = await downloadDictionary();
          dictionaryContentAsString = json.encode(dictionaryContent);
          prefs.setString("dictionaryVersion", currentVersion);
          prefs.setString(
              "dictionaryContentAsString", dictionaryContentAsString!);
        } else if (currentVersion == storedVersion) {
          dictionaryVersion = prefs.getString("dictionaryVersion");
          dictionaryContentAsString =
              prefs.getString("dictionaryContentAsString");
          dictionaryContent = json.decode(dictionaryContentAsString!);
        }
      } else {
        dictionaryVersion = await getDictionaryVersion();
        dictionaryContent = await downloadDictionary();
        dictionaryContentAsString = json.encode(dictionaryContent);
        prefs.setString("dictionaryVersion", dictionaryVersion!);
        prefs.setString(
            "dictionaryContentAsString", dictionaryContentAsString!);
      }
    } else {
      if (prefs.containsKey("dictionaryVersion")) {
        dictionaryVersion = prefs.getString("dictionaryVersion");
        dictionaryContentAsString =
            prefs.getString("dictionaryContentAsString");
        dictionaryContent = json.decode(dictionaryContentAsString!);
      } else {
        //no data
      }
    }
  }

  Future<Map<String, dynamic>> downloadDictionary() async {
    final dictionarySnapshot = await _realtimeDB.child('dictionary').get();
    return Map<String, dynamic>.from(dictionarySnapshot.value as dynamic);
  }

  Future<String> getDictionaryVersion() async {
    final dictionaryVersion = await _realtimeDB.child('version').get();
    return dictionaryVersion.value as String;
  }
}
