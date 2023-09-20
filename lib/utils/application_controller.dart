import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amanu/models/user_model.dart';
import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/controllers/home_page_controller.dart';
import 'package:amanu/screens/home_screen/drawer_launcher.dart';
import 'package:amanu/screens/home_screen/widgets/app_drawer.dart';
import 'package:amanu/screens/onboarding_screen/onboarding_screen.dart';
import 'package:amanu/utils/auth/database_repository.dart';
import 'package:amanu/utils/constants/app_colors.dart';
import 'package:camera/camera.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sortedmap/sortedmap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';

class ApplicationController extends GetxController {
  static ApplicationController get instance => Get.find();

  // -- INSTANTIATIONS
  final _realtimeDB = FirebaseDatabase.instance.ref();
  late List<CameraDescription> cameras;

  // -- ON START RUN
  @override
  void onInit() async {
    super.onInit();
    isFirstTimeUse = await checkFirstTimeUse();
    isFirstTimeBookmarks = await checkFirstTimeBookmarks();
    isFirstTimeDetail = await checkFirstTimeDetail();
    isFirstTimeHome = await checkFirstTimeHome();
    isFirstTimeKulitan = await checkFirstTimeKulitanEditor();
    isFirstTimeModify = await checkFirstTimeModify();
    isFirstTimeOnboarding = await checkFirstTimeOnboarding();
    isFirstTimeProfile = await checkFirstTimeProfile();
    isFirstTimeRequests = await checkFirstTimeRequests();
    isFirstTimeScanner = await checkFirstTimeScanner();
    isFirstTimeStudio = await checkFirstTimeStudio();

    print(isFirstTimeUse);

    hasConnection.value = await InternetConnectionChecker().hasConnection;
    subscription = await listenToConnectionState();
    // await putToDictionary(dcContent, "crqRUSQ7u0OjJJHvZWMvjNxROML2");
    await updateUserInfo();
    await checkDictionary();
    dictionaryContent = await sortDictionary(dictionaryContentUnsorted);
    wordOfTheDay = await checkWordOfTheDay();
    await checkBookmarks();
    await Get.put(HomePageController(wordOfTheDay: wordOfTheDay),
        permanent: true);
    await Get.put(DrawerXController(), permanent: true);
    cameras = await availableCameras();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    if (isFirstTimeUse) {
      Get.offAll(() => OnBoardingScreen(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
          curve: Curves.easeInOut);
    } else {
      final drawerController = Get.find<DrawerXController>();
      drawerController.currentItem.value = DrawerItems.home;
      Get.offAll(() => DrawerLauncher(),
          duration: Duration(milliseconds: 500),
          transition: Transition.downToUp,
          curve: Curves.easeInOut);
    }
  }

  // -- CONNECTION MANAGEMENT
  late StreamSubscription subscription;
  RxBool hasConnection = false.obs;
  RxBool isOnWifi = false.obs;

  StreamSubscription<dynamic> listenToConnectionState() {
    return Connectivity().onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        hasConnection.value = await InternetConnectionChecker().hasConnection;
      }
      isOnWifi.value = hasConnection.value
          ? result == ConnectivityResult.wifi
              ? true
              : false
          : false;
      print("hasConnection: ${hasConnection}");
      print("isOnWiFi: ${isOnWifi}");
      showConnectionSnackbar();
    });
  }

  void showConnectionSnackbar() {
    final title = hasConnection.value ? "Connected" : "Disconnected";
    final message = hasConnection.value
        ? isOnWifi.value
            ? "You are connected thru WiFi. Live functions will be available."
            : "You are connected thru mobile data. Live functions will be available."
        : "There is no internet connection. Running on offline mode.";
    final color = hasConnection.value
        ? Colors.green.withOpacity(0.75)
        : Colors.redAccent.withOpacity(0.75);
    final icon = hasConnection.value ? Icons.wifi : Icons.wifi_off;
    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: pureWhite,
      icon: Icon(
        icon,
        color: pureWhite,
        size: 30,
      ),
      duration: Duration(seconds: 3),
      shouldIconPulse: true,
      isDismissible: true,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
    );
  }

  // -- USER MANAGEMENT

  bool isLoggedIn = false;
  String? userID, userName, userEmail;
  int? userPhone;
  bool? userIsExpert,
      userExpertRequest,
      userEmailPublic,
      userPhonePublic,
      userIsAdmin;
  String? userFullName, userBio, userPic;
  List<String>? userContributions;
  String? userPicLocal;

  Future updateUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isLoggedIn")) {
      await changeLoginState(prefs.getBool("isLoggedIn") ?? false);
      userID = prefs.getString("userID") ?? null;
    } else {
      changeLoginState(false);
    }

    if (isLoggedIn) {
      if (hasConnection.value) {
        UserModel? userData =
            await DatabaseRepository.instance.getUserDetails(userID!);
        if (userData != null) {
          await changeUserDetails(
              userID,
              userData.userName,
              userData.email,
              userData.phoneNo,
              userData.isExpert,
              userData.expertRequest,
              userData.exFullName,
              userData.exBio,
              userData.profileUrl,
              userData.contributions,
              await saveUserPicToLocal(userData.profileUrl),
              userData.emailPublic,
              userData.phonePublic,
              userData.isAdmin);
        }
      } else {
        if (prefs.containsKey("userID")) {
          await getSavedUserDetails();
        } else {
          await changeLoginState(false);
          await changeUserDetails(null, null, null, null, null, null, null,
              null, null, null, null, null, null, null);
        }
      }
    } else {
      await changeUserDetails(null, null, null, null, null, null, null, null,
          null, null, null, null, null, null);
    }
  }

  Future getSavedUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
    userContributions = prefs.containsKey("userContributions")
        ? prefs.getStringList("userContributions")
        : null;
    userPicLocal = prefs.containsKey("userPicLocal")
        ? prefs.getString("userPicLocal")
        : null;
    userEmailPublic = prefs.containsKey("userEmailPublic")
        ? prefs.getBool("userEmailPublic")
        : null;
    userPhonePublic = prefs.containsKey("userPhonePublic")
        ? prefs.getBool("userPhonePublic")
        : null;
    userIsAdmin =
        prefs.containsKey("userIsAdmin") ? prefs.getBool("userIsAdmin") : null;
  }

  Future changeLoginState(bool condition) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn = condition;
    prefs.setBool("isLoggedIn", condition);
    print("savedLoginState: " + condition.toString());
  }

  Future changeUserDetails(
      String? _userID,
      String? _userName,
      String? _userEmail,
      int? _userPhone,
      bool? _userIsExpert,
      bool? _userExpertRequest,
      String? _userFullName,
      String? _userBio,
      String? _userPic,
      List<dynamic>? _userContributions,
      String? _userPicLocal,
      bool? _userEmailPublic,
      bool? _userPhonePublic,
      bool? _userIsAdmin) async {
    userID = _userID;
    userName = _userName;
    userEmail = _userEmail;
    userPhone = _userPhone;
    userIsExpert = _userIsExpert;
    userExpertRequest = _userExpertRequest;
    userFullName = _userFullName;
    userBio = _userBio;
    userPic = _userPic;
    userContributions = _userContributions == null
        ? null
        : _userContributions.map((e) => e.toString()).toList();
    userEmailPublic = _userEmailPublic;
    userPhonePublic = _userPhonePublic;
    userPicLocal = _userPicLocal;
    userIsAdmin = _userIsAdmin;
    await saveUserDetails();
    printUserDetails();
  }

  Future<String?> saveUserPicToLocal(String? userPic) async {
    userPicLocal = null;
    if (userPic != null) {
      try {
        String picExt = userPic.split("?").first;
        final appStorage = await getApplicationDocumentsDirectory();
        final fileExt = extension(File(picExt).path);
        final tempPhoto =
            File('${appStorage.path}/profilePic${userID}${fileExt}');
        final response = await Dio().get(
          userPic,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            receiveTimeout: Duration(seconds: 15),
          ),
        );
        final raf = tempPhoto.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();
        return tempPhoto.path;
      } catch (e) {
        return null;
      }
    } else {
      return null;
    }
  }

  void printUserDetails() {
    print("userID: " + (userID ?? "null"));
    print("userName: " + (userName ?? "null"));
    print("userEmail: " + (userEmail ?? "null"));
    print("userPhone: " + (userPhone == null ? "null" : userPhone.toString()));
    print("userIsExpert: " +
        (userIsExpert == null ? "null" : userIsExpert.toString()));
    print("userExpertRequest: " +
        (userExpertRequest == null ? "null" : userExpertRequest.toString()));
    print("userFullName: " + (userFullName ?? "null"));
    print("userBio: " + (userBio ?? "null"));
    print("userPic: " + (userPic ?? "null"));
    print("userContributions: " +
        (userContributions == null ? "null" : userContributions.toString()));
    print("userPicLocal: " + (userPicLocal ?? "null"));

    print("userEmailPublic: " +
        (userEmailPublic == null ? "null" : userEmailPublic.toString()));
    print("userPhonePublic: " +
        (userPhonePublic == null ? "null" : userPhonePublic.toString()));
    print("userIsAdmin: " +
        (userIsAdmin == null ? "null" : userIsAdmin.toString()));
  }

  Future saveUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID != null
        ? prefs.setString("userID", userID!)
        : prefs.remove("userID");
    userEmail != null
        ? prefs.setString("userEmail", userEmail!)
        : prefs.remove("userEmail");
    userName != null
        ? prefs.setString("userName", userName!)
        : prefs.remove("userName");
    userPhone != null
        ? prefs.setInt("userPhone", userPhone!)
        : prefs.remove("userPhone");
    userIsExpert != null
        ? prefs.setBool("userIsExpert", userIsExpert!)
        : prefs.remove("userIsExpert");
    userExpertRequest != null
        ? prefs.setBool("userExpertRequest", userExpertRequest!)
        : prefs.remove("userExpertRequest");
    userFullName != null
        ? prefs.setString("userFullName", userFullName!)
        : prefs.remove("userFullName");
    userBio != null
        ? prefs.setString("userBio", userBio!)
        : prefs.remove("userBio");
    userPic != null
        ? prefs.setString("userPic", userPic!)
        : prefs.remove("userPic");
    userContributions != null
        ? prefs.setStringList("userContributions", userContributions!)
        : prefs.remove("userContributions");
    userPicLocal != null
        ? prefs.setString("userPicLocal", userPicLocal!)
        : prefs.remove("userPicLocal");
    userEmailPublic != null
        ? prefs.setBool("userEmailPublic", userIsExpert!)
        : prefs.remove("userEmailPublic");
    userPhonePublic != null
        ? prefs.setBool("userPhonePublic", userIsExpert!)
        : prefs.remove("userPhonePublic");
    userIsAdmin != null
        ? prefs.setBool("userIsAdmin", userIsExpert!)
        : prefs.remove("userIsAdmin");
  }

  // -- WORD OF THE DAY
  late String wordOfTheDay;

  Future<String> checkWordOfTheDay() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (hasConnection.value) {
      String liveWotd = await DatabaseRepository.instance.getWordOfTheDay();
      prefs.setString("wordOfTheDay", liveWotd);
      return liveWotd;
    } else {
      if (prefs.containsKey("wordOfTheDay")) {
        return prefs.getString("wordOfTheDay")!;
      } else {
        return "null";
      }
    }
  }

  // -- BOOKMARKS MANAGEMENT
  RxList<String> bookmarks = <String>[].obs;

  Future checkBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("bookmarks")) {
      bookmarks.value = prefs.getStringList("bookmarks")!;
    } else {
      prefs.setStringList("bookmarks", bookmarks);
    }
    print("Bookmarks: " + bookmarks.toString());
  }

  // -- DICTIONARY MANAGEMENT
  String? dictionaryContentAsString;
  RxBool noData = false.obs;
  int? dictionaryVersion;
  Map<String, dynamic> dictionaryContentUnsorted = {};

  Future checkDictionary() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (hasConnection.value) {
      // if (prefs.containsKey("dictionaryVersion")) {
      //   final storedVersion = prefs.getInt("dictionaryVersion");
      //   final currentVersion = await getDictionaryVersion();
      //   if (currentVersion != storedVersion) {
      //     dictionaryContentUnsorted = await downloadDictionary();
      //     dictionaryContent = sortDictionary(dictionaryContentUnsorted);
      //     dictionaryContentAsString = json.encode(dictionaryContentUnsorted);
      //     prefs.setInt("dictionaryVersion", currentVersion);
      //     prefs.setString(
      //         "dictionaryContentAsString", dictionaryContentAsString!);
      //   } else if (currentVersion == storedVersion) {
      //     dictionaryVersion = prefs.getInt("dictionaryVersion");
      //     dictionaryContentAsString =
      //         prefs.getString("dictionaryContentAsString");
      //     dictionaryContentUnsorted = json.decode(dictionaryContentAsString!);
      //     dictionaryContent = sortDictionary(dictionaryContentUnsorted);
      //   }
      // } else {
      //   dictionaryVersion = await getDictionaryVersion();
      //   dictionaryContentUnsorted = await downloadDictionary();
      //   dictionaryContent = sortDictionary(dictionaryContentUnsorted);
      //   dictionaryContentAsString = json.encode(dictionaryContent);
      //   prefs.setInt("dictionaryVersion", dictionaryVersion!);
      //   prefs.setString(
      //       "dictionaryContentAsString", dictionaryContentAsString!);
      // }
      dictionaryVersion = await getDictionaryVersion();
      dictionaryContentUnsorted = await downloadDictionary();
      dictionaryContent = sortDictionary(dictionaryContentUnsorted);
      dictionaryContentAsString = json.encode(dictionaryContent);
      prefs.setInt("dictionaryVersion", dictionaryVersion!);
      prefs.setString("dictionaryContentAsString", dictionaryContentAsString!);
    } else {
      if (prefs.containsKey("dictionaryVersion")) {
        dictionaryVersion = prefs.getInt("dictionaryVersion");
        dictionaryContentAsString =
            prefs.getString("dictionaryContentAsString");
        dictionaryContentUnsorted = json.decode(dictionaryContentAsString!);
        dictionaryContent = sortDictionary(dictionaryContentUnsorted);
      } else {
        noData.value = true;
        dictionaryVersion = null;
      }
    }
    print("dictionaryVersion: " + dictionaryVersion.toString());
    print("dictionaryContent: " + dictionaryContent.toString());
  }

  Future<Map<String, dynamic>> downloadDictionary() async {
    final dictionarySnapshot = await _realtimeDB.child('dictionary').get();
    return Map<String, dynamic>.from(dictionarySnapshot.value as dynamic);
  }

  Future<int> getDictionaryVersion() async {
    final dictionaryVersion = await _realtimeDB.child('version').get();
    return dictionaryVersion.value as int;
  }

  SortedMap<Comparable<dynamic>, dynamic> sortDictionary(
      Map<String, dynamic> map) {
    var sortedMap = new SortedMap(Ordering.byKey());
    sortedMap.addAll(map);
    return sortedMap;
  }

  var dictionaryContent = {};

  // -- USE MANAGEMENT
  late bool isFirstTimeUse;
  Future<bool> checkFirstTimeUse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeUse")) {
      print("print here");
      return prefs.getBool("isFirstTimeUse")!;
    } else {
      prefs.setBool("isFirstTimeUse", true);
      return prefs.getBool("isFirstTimeUse")!;
    }
  }

  late bool isFirstTimeHome;
  Future<bool> checkFirstTimeHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeHome")) {
      return prefs.getBool("isFirstTimeHome")!;
    } else {
      prefs.setBool("isFirstTimeHome", true);
      return prefs.getBool("isFirstTimeHome")!;
    }
  }

  late bool isFirstTimeBookmarks;
  Future<bool> checkFirstTimeBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeBookmarks")) {
      return prefs.getBool("isFirstTimeBookmarks")!;
    } else {
      prefs.setBool("isFirstTimeBookmarks", true);
      return prefs.getBool("isFirstTimeBookmarks")!;
    }
  }

  late bool isFirstTimeModify;
  Future<bool> checkFirstTimeModify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeModify")) {
      return prefs.getBool("isFirstTimeModify")!;
    } else {
      prefs.setBool("isFirstTimeModify", true);
      return prefs.getBool("isFirstTimeModify")!;
    }
  }

  late bool isFirstTimeKulitan;
  Future<bool> checkFirstTimeKulitanEditor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeKulitanEditor")) {
      return prefs.getBool("isFirstTimeKulitanEditor")!;
    } else {
      prefs.setBool("isFirstTimeKulitanEditor", true);
      return prefs.getBool("isFirstTimeKulitanEditor")!;
    }
  }

  late bool isFirstTimeStudio;
  Future<bool> checkFirstTimeStudio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeStudio")) {
      return prefs.getBool("isFirstTimeStudio")!;
    } else {
      prefs.setBool("isFirstTimeStudio", true);
      return prefs.getBool("isFirstTimeStudio")!;
    }
  }

  late bool isFirstTimeDetail;
  Future<bool> checkFirstTimeDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeDetail")) {
      return prefs.getBool("isFirstTimeDetail")!;
    } else {
      prefs.setBool("isFirstTimeDetail", true);
      return prefs.getBool("isFirstTimeDetail")!;
    }
  }

  late bool isFirstTimeScanner;
  Future<bool> checkFirstTimeScanner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeScanner")) {
      return prefs.getBool("isFirstTimeScanner")!;
    } else {
      prefs.setBool("isFirstTimeScanner", true);
      return prefs.getBool("isFirstTimeScanner")!;
    }
  }

  late bool isFirstTimeRequests;
  Future<bool> checkFirstTimeRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeRequests")) {
      return prefs.getBool("isFirstTimeRequests")!;
    } else {
      prefs.setBool("isFirstTimeRequests", true);
      return prefs.getBool("isFirstTimeRequests")!;
    }
  }

  late bool isFirstTimeProfile;
  Future<bool> checkFirstTimeProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeProfile")) {
      return prefs.getBool("isFirstTimeProfile")!;
    } else {
      prefs.setBool("isFirstTimeProfile", true);
      return prefs.getBool("isFirstTimeProfile")!;
    }
  }

  late bool isFirstTimeOnboarding;
  Future<bool> checkFirstTimeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeOnboarding")) {
      return prefs.getBool("isFirstTimeOnboarding")!;
    } else {
      prefs.setBool("isFirstTimeOnboarding", true);
      return prefs.getBool("isFirstTimeOnboarding")!;
    }
  }

  String normalizeWord(String word) {
    String normalWord = word
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[àáâäæãåā]'), 'a')
        .replaceAll(RegExp(r'[îïíīįì]'), 'i')
        .replaceAll(RegExp(r'[ûüùúū]'), 'u')
        .replaceAll(RegExp(r'[èéêëēėę]'), 'e')
        .replaceAll(RegExp(r'[ôöòóœøōõ]'), 'o')
        .replaceAll(RegExp(r'[!-,\.-@\[-`{-¿]'), '');
    return normalWord;
  }

  Future putToDictionary(Map<String, dynamic> content, String uid) async {
    List<dynamic> wordIDs = [];
    for (MapEntry entry in content.entries) {
      print(entry.key);
      wordIDs.add(entry.key);
      await FirebaseDatabase.instance
          .ref()
          .child("dictionary")
          .child(entry.key)
          .set(entry.value);
    }
    UserModel? userG = await DatabaseRepository.instance.getUserDetails(uid);
    if (userG != null) {
      var changes = userG.toJson();
      changes["contributions"] = wordIDs;
      print(changes.toString());
      await DatabaseRepository.instance.updateUserOnDB(changes, uid, false);
    }
  }

  Map<String, dynamic> dcContent = {
    "A": {
      "word": "A",
      "normalizedWord": "A",
      "pronunciation": "a",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["a"],
      "filipinoTranslations": ["a"],
      "meanings": [
        {
          "partOfSpeech": "letter",
          "definitions": [
            {
              "definition":
                  "first letter of the Spanish and Capampangan <i>abecedes</i>, and Tagalog <i>abakada</i>",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "a2": {
      "word": "á",
      "normalizedWord": "a",
      "pronunciation": "a",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["á"],
      "filipinoTranslations": ["á"],
      "meanings": [
        {
          "partOfSpeech": "conjunction",
          "definitions": [
            {
              "definition":
                  "used between an adjective ending with a consonant and a noun, or vice versa",
              "example": "macuyad <i>a</i> lubid",
              "exampleTranslation": "short rope",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "a3": {
      "word": "à",
      "normalizedWord": "a",
      "pronunciation": "à",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["à"],
      "filipinoTranslations": ["à"],
      "meanings": [
        {
          "partOfSpeech": "adverb",
          "definitions": [
            {
              "definition": "so, very",
              "example": "<i>a</i> calagu na, <i>a</i> lagu na",
              "exampleTranslation": "she is so pretty, she is very pretty",
              "dialect": "Macabebe, Masantol",
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "prefix",
          "definitions": [
            {
              "definition":
                  "denoting something accidental; to have met at a place by chance",
              "example": "<i>abalag ke</i>",
              "exampleTranslation": "I accidentally lost it",
              "dialect": "Macabebe, Masantol",
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "a4": {
      "word": "a-",
      "normalizedWord": "a-",
      "pronunciation": "a-",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["a-"],
      "filipinoTranslations": ["a-"],
      "meanings": [
        {
          "partOfSpeech": "prefix",
          "definitions": [
            {
              "definition":
                  "denotes privation or negation in some Spanish and English words",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            },
            {
              "definition":
                  "denotes something accidental or potential in many Capampangan verbs",
              "example": "<i>adala</i>",
              "exampleTranslation": "can carry",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "aa": {
      "word": "á-â",
      "normalizedWord": "a-a",
      "pronunciation": "á·â",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["a-"],
      "filipinoTranslations": ["a-"],
      "meanings": [
        {
          "partOfSpeech": "adjective, noun",
          "definitions": [
            {
              "definition": "in baby talk, dirty, excrement, anything dirty",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            },
            {
              "definition": "dirty, excrement, anything dirty",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "intransitive verb",
          "definitions": [
            {
              "definition": "to move the bowels",
              "example": "mag <i>á-â</i> ku",
              "exampleTranslation": "I will take a bowel",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a", "a"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "AB": {
      "word": "AB",
      "normalizedWord": "AB",
      "pronunciation": "AB",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["AB"],
      "filipinoTranslations": ["AB"],
      "meanings": [
        {
          "partOfSpeech": "abbreviation",
          "definitions": [
            {
              "definition": "type of blood",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            },
            {
              "definition": "Bachelor of Arts, Bachiller king Arte, BA",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a", "b"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "aba": {
      "word": "abâ",
      "normalizedWord": "aba",
      "pronunciation": "a·bâ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["abâ"],
      "filipinoTranslations": ["abâ"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "delay, prolongation of time",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "verb",
          "definitions": [
            {
              "definition": "to prolong, to lengthen, to become delayed",
              "example": "<i>Miaban aldo</i>",
              "exampleTranslation": "delayed/put off for many days",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["a"],
        ["ba", "a"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "aba2": {
      "word": "Abá!",
      "normalizedWord": "aba",
      "pronunciation": "a·bá",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["aba"],
      "filipinoTranslations": ["aba"],
      "meanings": [
        {
          "partOfSpeech": "interjection",
          "definitions": [
            {
              "definition":
                  "with nuances of surprise, admiration (when the syllable ba is pronounced long)",
              "example": "<i>Abaaah</i>",
              "exampleTranslation": "Oh my gosh!, Oh my!",
              "dialect": null,
              "origin": null
            },
            {
              "definition":
                  "of irony, doubt or hesitation (when it is pronounced short)",
              "example": "<i>Aba</i>",
              "exampleTranslation": "Oh?",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a"],
        ["ba"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "abac": {
      "word": "abac",
      "normalizedWord": "abac",
      "pronunciation": "a·bac",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["morning"],
      "filipinoTranslations": ["umaga"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "morning",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "adverb",
          "definitions": [
            {
              "definition": "time of the day, from dawn till noon",
              "example": "bucas <i>abac</i>",
              "exampleTranslation": "tomorrow morning",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a"],
        ["ba", "k"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "abaca": {
      "word": "abaca",
      "normalizedWord": "abaca",
      "pronunciation": "a·ba·ca",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["abaca"],
      "filipinoTranslations": ["abaca"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "the hemp plant",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "verb",
          "definitions": [
            {
              "definition": "manabaca - to gather/obtain hemp fibers",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a"],
        ["ba"],
        ["ka"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "abacus": {
      "word": "abacus",
      "normalizedWord": "abacus",
      "pronunciation": "a·ba·cus",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["abacus"],
      "filipinoTranslations": ["abakó"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "a calculating instrument consisting of a frame with beads on rods or wires",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a"],
        ["ba"],
        ["ku", "s"]
      ],
      "otherRelated": {"abacu": null},
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "abad": {
      "word": "abàd",
      "normalizedWord": "abad",
      "pronunciation": "a·bàd",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["abad"],
      "filipinoTranslations": ["abad"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "a little bleeding, or a slight wound on the cheek.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "transitive verb",
          "definitions": [
            {
              "definition": "to cause a slight wound",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "his knife",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "history",
          "definitions": [
            {
              "definition":
                  "the act of slightly wounding children on the the cheek was practiced by certain hilots as an antidote to certain infant diseases",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["a"],
        ["ba", "d"]
      ],
      "otherRelated": {"abad": "abad2"},
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "abad2": {
      "word": "abad",
      "normalizedWord": "abad",
      "pronunciation": "a·bad",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["unceasing"],
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "adverb",
          "definitions": [
            {
              "definition": "unceasing",
              "example": "<i>Abad</i> mu ya casi?",
              "exampleTranslation":
                  "You should not have trusted that person, he is too astute/cunning.",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a"],
        ["ba", "d"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "abàd3": {
      "word": "abàd",
      "normalizedWord": "abad",
      "pronunciation": "a·bad",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["abbot"],
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "a title given to the Superior of an Abbey, or monastery for men religious.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a"],
        ["ba", "d"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "abadesa": {
      "word": "abadesa",
      "normalizedWord": "abadesa",
      "pronunciation": "a·ba·de·sa",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["abbess"],
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "a title given to the Superior or head of an Abbey or convent for nuns.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a"],
        ["ba"],
        ["de"],
        ["sa"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "abadiya": {
      "word": "abadiya",
      "normalizedWord": "abadiya",
      "pronunciation": "a·ba·di·ya",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["abbey"],
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "a monastery under an abbot (abad), or a convent under an abbess (abadesa)",
              "example":
                  "<i>Ing Abadiya ning Montserrat ya ing makibandi king Colegio ning San Beda, Mentía.</i>",
              "exampleTranslation":
                  "The Abbey of Our Lady of Montserrat owns and runs San Beda College in Manila.",
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a"],
        ["ba"],
        ["di"],
        ["ya"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "babad": {
      "word": "babad",
      "normalizedWord": "babad",
      "pronunciation": "ba·bad",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "adjectival noun",
          "definitions": [
            {
              "definition":
                  "the soaked thing or wet object: in its conjugation, it is active:",
              "example": "<i>bababad</i>",
              "exampleTranslation": "to soak purposely",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ba"],
        ["ba", "d"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "ba": {
      "word": "Ba!",
      "normalizedWord": "ba!",
      "pronunciation": "ba",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "interjection",
          "definitions": [
            {
              "definition": "expressing disgust or surprise",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            },
            {
              "definition": "short for aba.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ba"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "ba2": {
      "word": "ba",
      "normalizedWord": "ba",
      "pronunciation": "ba",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "adverb",
          "definitions": [
            {
              "definition": "in order that; that",
              "example": "<i>ba</i> mung balu",
              "exampleTranslation": "That you may know",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ba"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "baba": {
      "word": "baba",
      "normalizedWord": "baba",
      "pronunciation": "ba·ba",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["chin"],
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "the chin (not the beard)",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ba"],
        ["ba"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "baba2": {
      "word": "babâ",
      "normalizedWord": "baba",
      "pronunciation": "ba·bâ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "to go down",
              "example": "<i>baba</i> ku, tuki ka?",
              "exampleTranslation": "I will go down, are you coming with me?",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ba"],
        ["ba"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "ca": {
      "word": "ca",
      "normalizedWord": "ca",
      "pronunciation": "ka",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "prefix",
          "definitions": [
            {
              "definition": "denoting recentness; as soon as",
              "example": "<i>cagulut na</i>",
              "exampleTranslation": "As soon as he turns his back;",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ka"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "caba": {
      "word": "caba",
      "normalizedWord": "caba",
      "pronunciation": "ka·ba",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "food taken on a platter, or in a basket,like those donated to a convent, or taken tothe convent on Holy Thusday for feedingthe poor.",
              "example": "<i>Magcabá</i>",
              "exampleTranslation": "to bring food thus",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["ba"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "cabag": {
      "word": "cabag",
      "normalizedWord": "cabag",
      "pronunciation": "ka·bag",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "sound of footsteps of one passing by, like those of horses",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "verb",
          "definitions": [
            {
              "definition": "to make that sound by stomping when angry",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["ba", "g"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "da": {
      "word": "da",
      "normalizedWord": "da",
      "pronunciation": "da",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "pronoun",
          "definitions": [
            {
              "definition": "they; said they, they said",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "pronoun",
          "definitions": [
            {
              "definition": "their",
              "example": "ding manuc <i>da</i>",
              "exampleTranslation": "<i>Their</i> chickens",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["da"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "daba": {
      "word": "daba",
      "normalizedWord": "daba",
      "pronunciation": "da·ba",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "a large earthen jar; a large porcelain bowl",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["da"],
        ["ba"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "dabal": {
      "word": "dabal",
      "normalizedWord": "dabal",
      "pronunciation": "da·bal",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition": "corpulent, or bad shape of the body",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "corpulence, corpulency",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["da"],
        ["ba", "l"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "dabilbil": {
      "word": "dabilbil",
      "normalizedWord": "dabilbil",
      "pronunciation": "da·bil·bil",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "the whizzing sound of water flowing rapidly",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["da"],
        ["bi", "l"],
        ["bi", "l"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "dabulbul": {
      "word": "dabulbul",
      "normalizedWord": "dabulbul",
      "pronunciation": "da·bul·bul",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "neutral verb",
          "definitions": [
            {
              "definition":
                  "to spurt, to jet the water entering in great spurts, like in a hand-basket, or in a broken banca",
              "example":
                  "<i>Micarabulbul lulubing danum, or micarabulbul ya ing bangca.</i>",
              "exampleTranslation":
                  "Reporting the spurting of the water intothe banca.",
              "dialect": null,
              "origin": null
            },
            {
              "definition":
                  "the water entering in great spurts, like in a hand-basket, or in a broken banca",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["da"],
        ["bu", "l"],
        ["bu", "l"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "e": {
      "word": "e / eh",
      "normalizedWord": "eh",
      "pronunciation": "e",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "neutral verb",
          "definitions": [
            {
              "definition":
                  "an expression added to some remark denoting regret or blame,",
              "example": "Maina ya casi, <i>eh</i>",
              "exampleTranslation": "He is just weak, that's why.",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a", "i"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "e2": {
      "word": "e",
      "normalizedWord": "e",
      "pronunciation": "e",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "adverb of negation",
          "definitions": [
            {
              "definition": "of prohibition",
              "example": "<i>E</i> cu bisa",
              "exampleTranslation": "I do not like",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a", "i"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "ebun": {
      "word": "ebun",
      "normalizedWord": "ebun",
      "pronunciation": "e·bun",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["egg"],
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "egg of fowls; suckling of quadrupeds, like cows, sheep, etc.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "verb",
          "definitions": [
            {
              "definition": "to lay eggs, or to have a suckling.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a", "i"],
        ["bu", "n"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "ebus": {
      "word": "ebus",
      "normalizedWord": "ebus",
      "pronunciation": "e·bus",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "the wild palm of buri",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a", "i"],
        ["bu", "s"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "eco": {
      "word": "eco",
      "normalizedWord": "eco",
      "pronunciation": "e·ko",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "residue, dried scum that is at the bottom of the container of wine, bague, alubebe, or jams, jellies",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a", "i"],
        ["ko"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "fabula": {
      "word": "fabula",
      "normalizedWord": "fabula",
      "pronunciation": "fa·bu·la",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "fable; a story made up to teacha lesson",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["fa"],
        ["bu"],
        ["la"]
      ],
      "otherRelated": null,
      "synonyms": {"picutda": null, "picatsa": null},
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "fabrica": {
      "word": "fabrica",
      "normalizedWord": "fabrica",
      "pronunciation": "fab·ri·ka",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["factory"],
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "building or group of buildings where goods are manufacturedby collective production.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["fa", "b"],
        ["ri"],
        ["ka"]
      ],
      "otherRelated": null,
      "synonyms": {"pigaguan": null},
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "fabuloso": {
      "word": "fabuloso",
      "normalizedWord": "fabuloso",
      "pronunciation": "fa·bu·lo·so",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["fabulous"],
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition":
                  "belonging to the realm of fable; fantastic, extraordinary",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["fa"],
        ["bu"],
        ["lo"],
        ["so"]
      ],
      "otherRelated": null,
      "synonyms": {
        "cabalitan": null,
        "e caraniuan": null,
        "pambihira": null,
        "macapagmulala": null
      },
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "faccion": {
      "word": "faccion",
      "normalizedWord": "faccion",
      "pronunciation": "fak·si·yon",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["faction"],
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "a small opposition group within a larger group, or one tending to split off, generally with a tinge or suggestion of unscrupulous self-interest",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["fa", "c"],
        ["si"],
        ["a", "u", "n"],
      ],
      "otherRelated": null,
      "synonyms": {
        "pamicampicampi": null,
        "pamipanig-panig": null,
        "pamipangcat-pangcat": null
      },
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "facilidad": {
      "word": "facilidad",
      "normalizedWord": "facilidad",
      "pronunciation": "fa·si·li·dad",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["faction"],
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "an aptitude of or for doing some specified thing easily",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["fa"],
        ["si"],
        ["li"],
        ["da", "d"]
      ],
      "otherRelated": null,
      "synonyms": {"Cacayanan king pamagobra": null},
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "gabac": {
      "word": "gabac",
      "normalizedWord": "gabac",
      "pronunciation": "ga·bak",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition": "a thing torn, ripped, like cloth",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "verb",
          "definitions": [
            {
              "definition": "to tear",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "verb passive",
          "definitions": [
            {
              "definition": "to be torn",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "neutral verb",
          "definitions": [
            {
              "definition": "to become torn",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ga"],
        ["ba", "k"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "gabe": {
      "word": "gabe",
      "normalizedWord": "gabe",
      "pronunciation": "ga·be",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["garret"],
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "awning outside the dingding of the house",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition": "with many gabe's",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "v"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ga"],
        ["be"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "gabi": {
      "word": "gabi",
      "normalizedWord": "gabi",
      "pronunciation": "ga·bi",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition": "a broken object, like a broken china jar",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "active verb",
          "definitions": [
            {
              "definition": "to break; to rend",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ga"],
        ["bi"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "gabil": {
      "word": "gabil",
      "normalizedWord": "gabil",
      "pronunciation": "ga·bil",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition": "a ragged object",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ga"],
        ["bi", "l"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "gaboc": {
      "word": "gaboc",
      "normalizedWord": "gaboc",
      "pronunciation": "ga·bok",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "porcelain or china jar with a cover/lid.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ga"],
        ["bo", "k"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "habagat": {
      "word": "habagat",
      "normalizedWord": "habagat",
      "pronunciation": "ha·ba·gat",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "west or southwest wind; southwest monsoon",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a"],
        ["ba"],
        ["ga", "t"]
      ],
      "otherRelated": null,
      "synonyms": {"anğin abagat": null, "albugan": null, "paroba": null},
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "habilidad": {
      "word": "habilidad",
      "normalizedWord": "habilidad",
      "pronunciation": "ha·bi·li·dad",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "ability, ableness, dexterity, expertness, cleverness, mastery, talent, knowlege, skill; quickness, nimbleness,speed; instinct; cunning.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a"],
        ["bi"],
        ["li"],
        ["da", "d"]
      ],
      "otherRelated": null,
      "synonyms": {"anğin abagat": null, "albugan": null, "paroba": null},
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "habitacion": {
      "word": "habitacion",
      "normalizedWord": "habitacion",
      "pronunciation": "ha·bi·ta·si·yon",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "dwelling, residence, habitation, abode, lodging; room, suite of rooms; chamber, apartments; habitat",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a"],
        ["bi"],
        ["ta"],
        ["si"],
        ["a", "u", "n"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "habito": {
      "word": "habito",
      "normalizedWord": "habito",
      "pronunciation": "ha·bi·to",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "religious dress, habit, garment, cassock.",
              "example": "Magsulud <i>habito</i>, misuluran habito",
              "exampleTranslation":
                  "Be invested with the cassock, to profess, to take vows.",
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a"],
        ["bi"],
        ["to"]
      ],
      "otherRelated": null,
      "synonyms": {"ugali": null, "lumo": null},
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "habitual": {
      "word": "habitual",
      "normalizedWord": "habitual",
      "pronunciation": "ha·bi·tu·wal",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition":
                  "performed as the result of a habit; usual, customary, accustomed; inveterate, frequent, common.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a"],
        ["bi"],
        ["tu", "a", "l"]
      ],
      "otherRelated": null,
      "synonyms": {
        "ugali na": null,
        "piugalian": null,
        "acalumon": null,
        "acasanayan": null,
        "caraniuan": null,
        "keralasan": null,
        "sadianan": null
      },
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "iba": {
      "word": "<u>i</u>bâ",
      "normalizedWord": "iba",
      "pronunciation": "i·bâ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["Cicca acida"],
      "filipinoTranslations": ["Bankiling"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "the tree <i>Bankiling (Cicca acida)</i> and its rounded fleshy greenish-white fruits eten as sour-flavoring for sigang, made into jellies or jams, and also pickled.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["i"],
        ["ba"]
      ],
      "otherRelated": {"Ibâ": "Ibâ"},
      "synonyms": {"Camias": "Camias"},
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "ibe": {
      "word": "<u>i</u>be",
      "normalizedWord": "ibe",
      "pronunciation": "i·be",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["dizzy", "intoxicated"],
      "filipinoTranslations": ["nahihilo", "lasing"],
      "meanings": [
        {
          "partOfSpeech": "verb",
          "definitions": [
            {
              "definition":
                  "<i>maibe</i>, <i>meibe</i>, to become giddy, or faint, become intoxicated for chewing betel nut.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "adverb",
          "definitions": [
            {
              "definition": "<i>Melaibe</i>, close to becoming intoxicated.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            },
            {
              "definition":
                  "<i>Panğaibe</i>, the fact of being intoxicated by chewing the betel nut concoction.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["i"],
        ["b"],
        ["i"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "ingat": {
      "word": "<u>i</u>nğat",
      "normalizedWord": "ingat",
      "pronunciation": "i·nğat",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["carefulness"],
      "filipinoTranslations": ["pagiging maingat"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "carefulness.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "verb",
          "definitions": [
            {
              "definition": "to guard something with much care.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            },
            {
              "definition": "to take care, or become careful for/of something.",
              "example": "<i>Mimingat ka.</i>",
              "exampleTranslation": "Take care.",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["i"],
        ["nga"],
        ["t"]
      ],
      "otherRelated": {"Maca": "Maca"},
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "Juan Tamad": {
      "word": "Juan Tamad",
      "normalizedWord": "Juan Tamad",
      "pronunciation": "Juan·Ta·mad",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["lazy John"],
      "filipinoTranslations": ["Juan tamad"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "a character in a folklore made the butt of jokes and funny comments for his extreme laziness.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            },
            {
              "definition": "an epitome of laziness.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["u"],
        ["wa"],
        ["n"],
        ["ta"],
        ["ma"],
        ["d"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "jubileo": {
      "word": "jubileo",
      "normalizedWord": "jubileo",
      "pronunciation": "ju·bi·le·o",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["jubilee"],
      "filipinoTranslations": ["jubileo"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "a 50th anniversary.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            },
            {
              "definition":
                  "an anniversary other than 50th, silver jubilee, 25th, diamond jubilee, 60th-75th",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            },
            {
              "definition":
                  "<i>Jewish hist.</i> a festival held at 50-year intervals to celebrate the deliverance from Egypt",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            },
            {
              "definition":
                  "<i>in Roman Catholicism,</i> a year of special indulgence, declared every quarter of a century,",
              "example":
                  "1900, 1925, 1950, 1975, 2000, or in special commemorations of salvation history, e.g. 1933, 1983, 2033 etc.",
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["di"],
        ["u"],
        ["bi"],
        ["le"],
        ["yo"]
      ],
      "otherRelated": null,
      "synonyms": {
        "Año Santo": "Año Santo",
        "Holy Year": "Holy Year",
        "pabanuang jubileo": "pabanuang jubileo",
        "obleo": "obleo"
      },
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "jueteng": {
      "word": "ju<u>e</u>teng",
      "normalizedWord": "jueteng",
      "pronunciation": "jue·teng",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["lottery"],
      "filipinoTranslations": ["loterya"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "a game of pairing numbers, like a lottery, using balls or chips 37 in number, drawing only two of them from the <i>tambiolo.</i>",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Chinese"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["di"],
        ["u"],
        ["i"],
        ["t"],
        ["i"],
        ["ng"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "kealan": {
      "word": "k<u>e</u>alan",
      "normalizedWord": "kealan",
      "pronunciation": "kea·lan",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["shamelessness", "nothingness"],
      "filipinoTranslations": ["kawalanghiyaan", "kawalan"],
      "meanings": [
        {
          "partOfSpeech": "adverb, preposition",
          "definitions": [
            {
              "definition":
                  "absence of, lack of, as in <i>kealan marine</i>, shamelessness, being without shame.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "nothingness.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ki"],
        ["a", "i"],
        ["la"],
        ["n"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "keca": {
      "word": "k<u>e</u>ca",
      "normalizedWord": "keca",
      "pronunciation": "ke·ca",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["your", "yours"],
      "filipinoTranslations": ["iyong", "inyo"],
      "meanings": [
        {
          "partOfSpeech": "pronoun",
          "definitions": [
            {
              "definition": "second person",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ki"],
        ["i"],
        ["ka"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "kislap": {
      "word": "k<u>i</u>slap",
      "normalizedWord": "kislap",
      "pronunciation": "kis·lap",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["sheen", "sparkle"],
      "filipinoTranslations": ["ningning", "kislap"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "sheen, flash, brilliance, sparkle, twinkle.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "neutral verb",
          "definitions": [
            {
              "definition":
                  "to glitter, to sparkle, to flash, to show its sheen, brilliance.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ki"],
        ["s"],
        ["la"],
        ["p"]
      ],
      "otherRelated": {"Kinang": "Kinang", "kintab": "kintab"},
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "lababo": {
      "word": "lab<u>a</u>bo",
      "normalizedWord": "lababo",
      "pronunciation": "la·ba·bo",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["kitchen sink", "wash stand"],
      "filipinoTranslations": ["lababo"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "wash-stand, wash basin, kitchen sink, lavatory.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            },
            {
              "definition":
                  "in the Catholic Mass, the rite of washing the hands after the offertory.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["la"],
        ["ba"],
        ["b"],
        ["u"]
      ],
      "otherRelated": null,
      "synonyms": {"Pipanuasangamat": "Pipanuasan gamat"},
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "labanus": {
      "word": "laban<u>u</u>s",
      "normalizedWord": "labanus",
      "pronunciation": "la·ba·nus",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["radish"],
      "filipinoTranslations": ["labanos"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "a root crop.",
              "example":
                  "<i>Ing tidtad a labanus at camatis ampón ditac a asin, maniaman yang gauan tililan para king derang a bulig.</i>",
              "exampleTranslation":
                  "Chopped radishes and tomatoes with a pinch or two of salt are a palatable side dish when eaten with a broiled mudfish.",
              "dialect": null,
              "origin": "Spanish (<i>rabano</i>)"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["la"],
        ["ba"],
        ["nu"],
        ["s"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "laing": {
      "word": "laing",
      "normalizedWord": "laing",
      "pronunciation": "la·ing",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "leaves or stems of the <i>gandus</i> (gabi/yam).",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["la"],
        ["i"],
        ["ng"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "manas": {
      "word": "man<u>a</u>s",
      "normalizedWord": "manas",
      "pronunciation": "ma·nas",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["dropsy", "edema"],
      "filipinoTranslations": ["madulas"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "local swelling due to the accumulation of serous fluid in the cellular tissue, caused by defective circulation (blood or lymph).",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            },
            {
              "definition":
                  "swelling of the extremities, symptomatic of beriberi or lack of vitamin B.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ma"],
        ["na"],
        ["s"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "mesa": {
      "word": "m<u>e</u>sa",
      "normalizedWord": "mesa",
      "pronunciation": "me·sa",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["table"],
      "filipinoTranslations": ["mesa"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "The table itself, dining table, <i>lamesang pipanganan</i>, or office table.",
              "example": "<i>The table is open for nominations.</i>",
              "exampleTranslation":
                  "<i>Ing mesa macabuclat ya para king nominación.</i>",
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["m"],
        ["i"],
        ["sa"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "mo": {
      "word": "mo",
      "normalizedWord": "mo",
      "pronunciation": "mo",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["you", "them"],
      "filipinoTranslations": ["ikaw", "sila"],
      "meanings": [
        {
          "partOfSpeech": "pronoun",
          "definitions": [
            {
              "definition":
                  "<i>ikit mo ri Maria at i Juana,</i> here <i>mo</i> is a combined form or short for mu la.",
              "example": "<i>Atiu i tata mo?</i>",
              "exampleTranslation": "Is your father at home?",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["m"],
        ["u"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "nieve": {
      "word": "ni<u>e</u>ve",
      "normalizedWord": "nieve",
      "pronunciation": "nie·ve",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["snow"],
      "filipinoTranslations": ["niyebe"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "snow, snow flakes, snow fall.",
              "example": "<i>Mababaldug ing nieve.</i>",
              "exampleTranslation": "The snow falls in flakes.",
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ni"],
        ["i"],
        ["b"],
        ["i"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "ninu": {
      "word": "n<u>i</u>nu",
      "normalizedWord": "ninu",
      "pronunciation": "ni·nu",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["who"],
      "filipinoTranslations": ["sino"],
      "meanings": [
        {
          "partOfSpeech": "pronoun",
          "definitions": [
            {
              "definition": "it refers to the person performing the action.",
              "example": "<i>Ninu ing minapsi caniting libru?</i>",
              "exampleTranslation": "Who compiled this book?",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["ni"],
        ["nu"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "noble": {
      "word": "n<u>o</u>ble",
      "normalizedWord": "noble",
      "pronunciation": "no·ble",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["noble", "respectable"],
      "filipinoTranslations": ["marangal", "kagalang-galang"],
      "meanings": [
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition":
                  "noble, eminent, illustrious, high-born, honorable, respectable, generous.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["n"],
        ["u"],
        ["bi"],
        ["l"],
        ["i"]
      ],
      "otherRelated": null,
      "synonyms": {
        "Sugi": "Sugi",
        "budni": "budni",
        "mayacayan": "mayacayan",
        "cagalanggalang": "cagalanggalang",
        "igagalang": "igagalang",
        "prominente": "prominente",
        "dayang azul": "dayang azul"
      },
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "nganga": {
      "word": "nğ<u>a</u>nğa",
      "normalizedWord": "nganga",
      "pronunciation": "nğa·nğa",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["to open mouth"],
      "filipinoTranslations": ["upang ibuka ang bibig"],
      "meanings": [
        {
          "partOfSpeech": "neutral verb",
          "definitions": [
            {
              "definition": "to open mouth.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["nga"],
        ["nga"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "ngatngat": {
      "word": "nğ<u>a</u>tnğat",
      "normalizedWord": "ngatngat",
      "pronunciation": "nğat·nğat",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["gnaw"],
      "filipinoTranslations": ["kumagat"],
      "meanings": [
        {
          "partOfSpeech": "noun, adjective",
          "definitions": [
            {
              "definition": "sound of rat gnawing something.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["nga"],
        ["t"],
        ["nga"],
        ["t"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "ngeni": {
      "word": "nğ<u>e</u>ni",
      "normalizedWord": "ngeni",
      "pronunciation": "nğe·ni",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["now"],
      "filipinoTranslations": ["ngayon"],
      "meanings": [
        {
          "partOfSpeech": "adverb",
          "definitions": [
            {
              "definition": "of time, now.",
              "example": "<i>Nğeni na</i>",
              "exampleTranslation": "Now at this very moment.",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["nge"],
        ["ni"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "obligacion": {
      "word": "obligaci<u>o</u>n",
      "normalizedWord": "obligacion",
      "pronunciation": "ob·li·ga·cion",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["obligation"],
      "filipinoTranslations": ["obligasyon"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "a binding legal agreement or a moral responsibility.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            },
            {
              "definition":
                  "something which a person is bound to do or not do as a result of such an agreement or responsibility.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a", "u"],
        ["b"],
        ["li"],
        ["ga"],
        ["s"],
        ["i"],
        ["a", "u"],
        ["n"]
      ],
      "otherRelated": null,
      "synonyms": {"tungculan": "tungculan", "catungculan": "catungculan"},
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "ocupado": {
      "word": "ocup<u>a</u>do",
      "normalizedWord": "ocupado",
      "pronunciation": "o·cu·pa·do",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["occupied"],
      "filipinoTranslations": ["inookupahan"],
      "meanings": [
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition":
                  "in the possession of, already rented, has occupants, already tenanted.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a", "u"],
        ["cu"],
        ["pa"],
        ["d"],
        ["u"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "once": {
      "word": "<u>o</u>nce",
      "normalizedWord": "once",
      "pronunciation": "on·ce",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["eleven"],
      "filipinoTranslations": ["labing-isa"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "the figure eleven; eleven in number, eleventh.",
              "example": "<i>Las once</i>",
              "exampleTranslation": "Eleven o' clock",
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["a", "u"],
        ["n"],
        ["ca", "i"],
      ],
      "otherRelated": null,
      "synonyms": {"labingmetung": "labingmetung"},
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "paciencia": {
      "word": "paci<u>e</u>ncia",
      "normalizedWord": "paciencia",
      "pronunciation": "pa·cien·cia",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["patience"],
      "filipinoTranslations": ["pasensya"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "patience, endurance, forbearance, tolerance.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        },
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition": "very patient, forbearing, tolerant",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        },
        {
          "partOfSpeech": "verb",
          "definitions": [
            {
              "definition": "be patient towards others",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            },
            {
              "definition": "be contented with what cannot be helped",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["pa"],
        ["ca", "i"],
        ["n"],
        ["ci"],
        ["a"]
      ],
      "otherRelated": null,
      "synonyms": {
        "mapibabata": "mapibabata",
        "mapanupaya": "mapanupaya",
        "Capibabatan": "Capibabatan",
        "capanupayan": "capanupayan"
      },
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "palitu": {
      "word": "pal<u>i</u>tu",
      "normalizedWord": "palitu",
      "pronunciation": "pa·li·tu",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["small stick"],
      "filipinoTranslations": ["maliit na stick"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "small stick, a matchstick, toothpick.",
              "example": "<i>Capalitu</i>",
              "exampleTranslation": "A single matchstick.",
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "adverb",
          "colloquial"
              "definitions": [
            {
              "definition": "depalitu - cannot be distinguished",
              "example": "<i>depalitu, depalitu mu ing acbung</i>",
              "exampleTranslation":
                  "explosion that is heard, but could not be distinguished if it is far or near",
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["pa"],
        ["li"],
        ["tu"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "pisu": {
      "word": "p<u>i</u>su",
      "normalizedWord": "pisu",
      "pronunciation": "pi·su",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["storey"],
      "filipinoTranslations": ["palapag"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "floor in buildings.",
              "example": "<i>Pepatali yang bale a maki atlung pisu.</i>",
              "exampleTranslation": "He built a three-storey house.",
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["pi"],
        ["su"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "querida": {
      "word": "quer<u>i</u>da",
      "normalizedWord": "querida",
      "pronunciation": "que·ri·da",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["concubine"],
      "filipinoTranslations": ["babae"],
      "meanings": [
        {
          "partOfSpeech": "noun, adjective",
          "definitions": [
            {
              "definition":
                  "a paramour, a kept woman, a live in partner, esp. with a married man.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["k"],
        ["u"],
        ["a", "i"],
        ["ri"],
        ["da"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "que sera sera": {
      "word": "qu<u>e</u> ser<u>a</u> ser<u>a</u>",
      "normalizedWord": "que sera sera",
      "pronunciation": "que·se·ra·se·ra",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["inevitably"],
      "filipinoTranslations": ["hindi maiiwasan"],
      "meanings": [
        {
          "partOfSpeech": "adverb",
          "definitions": [
            {
              "definition": "literally, what will be, will be.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        },
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "a stoic atitude of, let the fortune take care of itself.",
              "example":
                  "<i>Bahala na ing daratang/paintungul; miras na ing miras.</i>",
              "exampleTranslation": "Let us cross the bridge when we reach it.",
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["k"],
        ["u"],
        ["a", "i"],
        ["s"],
        ["i"],
        ["da"],
        ["s"],
        ["i"],
        ["da"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "quezo": {
      "word": "qu<u>e</u>zo",
      "normalizedWord": "quezo",
      "pronunciation": "que·zo",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["cheese"],
      "filipinoTranslations": ["keso"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "a solid food of high protein content made from the pressed curds of milk.",
              "example": "<i>Keso de bola</i>",
              "exampleTranslation": "Cheese ball",
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        }
      ],
      "kulitan-form": [
        ["k"],
        ["u"],
        ["a", "i"],
        ["s"],
        ["a", "u"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "ra": {
      "word": "ra",
      "normalizedWord": "ra",
      "pronunciation": "ra",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["Their", "They"],
      "filipinoTranslations": ["Sakanila", "kanila"],
      "meanings": [
        {
          "partOfSpeech": "pronoun",
          "definitions": [
            {
              "definition": "variant of <i>da</i>'",
              "example": "ing payung <i>ra</i>; ing cama <i>ra</i>",
              "exampleTranslation": "<i>their</i> umbrella; <i>their</i> bed",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["ra"]
      ],
      "otherRelated": {"da": "da"},
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "recreo": {
      "word": "rec<u>r</u>eo",
      "normalizedWord": "recreo",
      "pronunciation": "re·c<u>r</u>eo",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["recreation"],
      "filipinoTranslations": ["libangan"],
      "meanings": [
        {
          "partOfSpeech": "pronoun",
          "definitions": [
            {
              "definition":
                  "a leisure time activity engaged in for the sake of refreshment",
              "example": "<i>rec<u>r</u>eo</i> ya ing pamagpinta",
              "exampleTranslation": "painting is a form of <i>recreation</i>",
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        },
        {
          "partOfSpeech": "verb",
          "definitions": [
            {
              "definition":
                  "to engage in recreation; a pastime; to attend a hobby",
              "example": "<i>magrec<u>r</u>eo</i> la",
              "exampleTranslation":
                  "they are participating in <i>recreation</i>",
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        },
      ],
      "kulitan-form": [
        ["ra", "i", "k"],
        ["ra", "i"],
        ["u"]
      ],
      "otherRelated": null,
      "synonyms": {
        "limbangan": "limbangan",
        "libangan": "libangan",
        "pamagconsuelo": "pamagconsuelo",
        "recreacion": "recreacion"
      },
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "rimas": {
      "word": "r<u>i</u>mas",
      "normalizedWord": "rimas",
      "pronunciation": "r<u>i</u>·mas",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["breadfruit"],
      "filipinoTranslations": ["kamansi"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "a tree (<i>Artocarpus altilis</i>) that grows tall, branchy, with leaves around the tip of its branches, and its seedless fruits that look like the camansi or the yangca, the jackfruit",
              "example": "<i>R<u>i</u>mas</i> ing kakanan da",
              "exampleTranslation": "They are eating <i>breadfruit</i>",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["ri"],
        ["ma", "s"]
      ],
      "otherRelated": {"camansi": "camansi", "yangca": "yangca"},
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "romansa": {
      "word": "rom<u>a</u>nsa",
      "normalizedWord": "romansa",
      "pronunciation": "ro·m<u>a</u>n·sa",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["romance", "a love affair", "a love story"],
      "filipinoTranslations": ["pag-iibigan", "minamahal"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "the quality of being romantic; an imaginative story of idealized love; tender or intimate relationship between lovers",
              "example": "Ing karelang <i>rom<u>a</u>nsa</i>",
              "exampleTranslation": "Their <i>romance</i>",
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        },
        {
          "partOfSpeech": "verb",
          "definitions": [
            {
              "definition": "expressing fondess and love for each other",
              "example": "<i>Mipagromansa</i> lang adua",
              "exampleTranslation": "They are <i>romancing</i> each other",
              "dialect": null,
              "origin": "Spanish"
            }
          ]
        },
      ],
      "kulitan-form": [
        ["r", "u"],
        ["ma", "n"],
        ["sa"]
      ],
      "otherRelated": {"romantico": "romantico"},
      "synonyms": {
        "mipaglambing": "mipaglambing",
        "mipaglambis": "mipaglambis"
      },
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "rugu": {
      "word": "rug<u>u</u>",
      "normalizedWord": "rugu",
      "pronunciation": "ru·g<u>u</u>",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": [
        "please",
        "humbly",
        "merely",
        "with mercy",
        "pity",
        "tauntingly"
      ],
      "filipinoTranslations": ["basta lang", "maari", "puwede"],
      "meanings": [
        {
          "partOfSpeech": "adverb",
          "definitions": [
            {
              "definition":
                  "a word that has many nuances in Capampangan; it may mean,please, humbly, merely, with mercy or pity, condescencion, irony, tauntingly",
              "example":
                  "melacuan ya <i>rugu</i>; oini <i>rugu</i>; ay naman <i>dugo!</i>",
              "exampleTranslation":
                  "he's in misery; here it is; how could you!",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["ru"],
        ["gu"]
      ],
      "otherRelated": {"dugo": "dugo"},
      "synonyms": {"dugo": "dugo"},
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "sabac": {
      "word": "s<u>a</u>bac",
      "normalizedWord": "sabac",
      "pronunciation": "s<u>a</u>·bac",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["mortise", "fight"],
      "filipinoTranslations": ["butas", "laban"],
      "meanings": [
        {
          "partOfSpeech": "pronoun",
          "definitions": [
            {
              "definition":
                  "the mortise on posts to hold beams or rafters, or the hole cut in the material to take the end of another part, esp. a hole in a piece of wood designed to receive the shaped end (tenon) of another piece",
              "example": "Isaktu me king <i>sabac</i>",
              "exampleTranslation": "Align it within the <i>mortise</i>",
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "verb",
          "definitions": [
            {
              "definition":
                  "to join or fasten securely; to make cut or such a hole, to mortise. From this it acquires and extended sense of force against something or some persons",
              "example":
                  "<i>mipasabac</i> ya king gerra; <i>isabac</i> me king obra",
              "exampleTranslation":
                  "he was <i>placed</i> at the battle front; <i>employ</i> all his capabilities to work",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["sa"],
        ["ba", "k"]
      ],
      "otherRelated": {"laban": "laban"},
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "selan": {
      "word": "s<u>e</u>lan",
      "normalizedWord": "selan",
      "pronunciation": "s<u>e</u>·lan",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["sensitivity"],
      "filipinoTranslations": ["pihikan"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "delicacy to touch; choosiness or discriminating in a matter of choice; avoidance of anything offensive to modesty; constitutional weakness, susceptibility to disease",
              "example": "Ana kang <i>selan</i> keng makanyan a tema",
              "exampleTranslation":
                  "You're so <i>sensitive</i> about that topic",
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition":
                  "morally or physically delicate; very discriminating in taste or choice; diffident",
              "example": "<i>maselan</i> ing panaun",
              "exampleTranslation": "<i>inclement</i> weather",
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "verb",
          "definitions": [
            {
              "definition":
                  "become discriminating in choice, times becoming difficult, precarious, delicate, dangerous",
              "example": "<i>seselan</i> na ca mu",
              "exampleTranslation": "You're just playing <i>hard to please</i>",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["sa", "i"],
        ["la", "n"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "sias": {
      "word": "si<u>a</u>s",
      "normalizedWord": "sias",
      "pronunciation": "si·y<u>a</u>s",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["stiffness", "hard"],
      "filipinoTranslations": ["matigas", "matibay"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "hardness",
              "example": "<i>kasiasan</i> ku keng pamangan",
              "exampleTranslation": "This food is too <i>hard</i>",
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "neutral verb",
          "definitions": [
            {
              "definition": "to become hard, stiff, to harden, to get erect",
              "example": "<i>pasiasan</i> ke pa ing hielo",
              "exampleTranslation": "i'm letting the ice get <i>harder</i>",
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition": "hard, erect stiff",
              "example": "<i>masias a pusu</i>; <i>masias a lub</i>",
              "exampleTranslation": "hard-hearted; stubborn",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["si", "a", "s"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "soning": {
      "word": "s<u>o</u>ning",
      "normalizedWord": "soning",
      "pronunciation": "s<u>o</u>·ning",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["epilepsy"],
      "filipinoTranslations": ["kisay"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "Epilepsy",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "neutral verb",
          "definitions": [
            {
              "definition":
                  "to have an attack of epilepsy, to experience an epileptic fit",
              "example": "<i>Sosoning</i> ya ing kanakung anak",
              "exampleTranslation": "My son is having an <i>eplipetic fit</i>",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["sa", "u"],
        ["sa", "u"],
        ["ni", "ng"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "sua": {
      "word": "suâ",
      "normalizedWord": "sua",
      "pronunciation": "swa",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["pomelo", "grapefruit"],
      "filipinoTranslations": ["suha"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "a large pome, like grapefruit, or pomelo",
              "example": "buri ko reng <i>sua</i>",
              "exampleTranslation": "I like <i>pomelo</i>",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["su", "a"]
      ],
      "otherRelated": {"masua": "masua"},
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "tau2": {
      "word": "t<u>a</u>u",
      "normalizedWord": "tau",
      "pronunciation": "t<u>a</u>·u",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["light a fire"],
      "filipinoTranslations": ["magpabaga"],
      "meanings": [
        {
          "partOfSpeech": "transitive verb",
          "definitions": [
            {
              "definition":
                  "to light a fire, including blowing the embers to produce flames, to inflame a small spark",
              "example": "<i>patau</i> ka pa",
              "exampleTranslation": "can you<i>light the fire</i>",
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "neutral verb",
          "definitions": [
            {
              "definition": "with company, the firewood and the fire",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["ta"],
        ["u"]
      ],
      "otherRelated": {"silab": "silab", "pali": "pali"},
      "synonyms": {"silab": "silab"},
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "terac": {
      "word": "t<u>e</u>rac",
      "normalizedWord": "terac",
      "pronunciation": "t<u>e</u>·rac",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["dance"],
      "filipinoTranslations": ["sayaw"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "dance, of a man",
              "example": "cha-cha ing favorito kong <i>terac/i>",
              "exampleTranslation": "cha-cha is my favorite <i>dance</i>",
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "transitive verb",
          "definitions": [
            {
              "definition":
                  "to dance, to execute a dance step, to engage in dancing",
              "example": "<i>tumerac</i> ka pa",
              "exampleTranslation": "Go <i>dancing</i>",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["t", "a", "i"],
        ["ra", "k"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "tibuc": {
      "word": "tib<u>u</u>c",
      "normalizedWord": "tibuc",
      "pronunciation": "ti·b<u>u</u>c",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["throb", "beat"],
      "filipinoTranslations": ["tibok", "pumintig"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "throb, pulsation, heart beat, yearning",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "neutral verb",
          "definitions": [
            {
              "definition": "<i>tinibuc</i> - to throb",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "transitive verb",
          "definitions": [
            {
              "definition": "<i>titibuc</i> - desire",
              "example": "<i>titibuc</i> ning pusu cu",
              "exampleTranslation": "what my heart <i>desires</i>",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["ti"],
        ["bu", "c"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "tocador": {
      "word": "tocad<u>o</u>r",
      "normalizedWord": "tocador",
      "pronunciation": "to·ca·d<u>o</u>r",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["dresser", "dressing table"],
      "filipinoTranslations": ["aparador", "tokador"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "ladies' dressing table with a large mirror",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["ta", "u"],
        ["ka"],
        ["da", "u", "r"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "tudtud": {
      "word": "t<u>u</u>dtud",
      "normalizedWord": "tudtud",
      "pronunciation": "t<u>u</u>d·tud",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["sleep", "dormition"],
      "filipinoTranslations": ["tulog"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "asleep",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "neutral verb",
          "definitions": [
            {
              "definition": "to fall asleep",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["tu", "d"],
        ["tu", "d"]
      ],
      "otherRelated": {"pagal": "pagal", "kera": "kera"},
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "ua": {
      "word": "u<u>a</u>",
      "normalizedWord": "ua",
      "pronunciation": "u·w<u>a</u>",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["yes", "aggree"],
      "filipinoTranslations": ["oo", "sang-ayon"],
      "meanings": [
        {
          "partOfSpeech": "adverb",
          "definitions": [
            {
              "definition": "used to express affirmation",
              "example": "<i>Ua</i>, canacu ya iyan",
              "exampleTranslation": "<i>Yes</i> that's mine",
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "verb",
          "definitions": [
            {
              "definition": "to say yes, to give an affirmative asnwer",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["u", "a"]
      ],
      "otherRelated": {"wa": "wa"},
      "synonyms": {"wa": "wa"},
      "antonyms": {"ali": "ali"},
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "ugali": {
      "word": "ug<u>a</u>li",
      "normalizedWord": "ugali",
      "pronunciation": "u·g<u>a</u>·li",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["habit", "custom"],
      "filipinoTranslations": ["ugali"],
      "meanings": [
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition":
                  "Custom, usage, it is said of an ordinary thing, not so good, not so bad.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        }
      ],
      "kulitan-form": [
        ["u"],
        ["ga"],
        ["li"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "ugse": {
      "word": "ugs<u>e</u>",
      "normalizedWord": "ugse",
      "pronunciation": "ug·s<u>e</u>",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["throw", "thrown"],
      "filipinoTranslations": ["tapon", "tinapon"],
      "meanings": [
        {
          "partOfSpeech": "transitional verb",
          "definitions": [
            {
              "definition": "to throw away, ",
              "example": "<i>manugse</i> ka pamung basura",
              "exampleTranslation": "<i>throw away</i> the trash",
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "first passive",
          "definitions": [
            {
              "definition": "that which is thrown away",
              "example": "<i>inugs<u>e</u></i> na ne",
              "exampleTranslation": "He <i>threw</i> it",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["u", "g"],
        ["sa", "i"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "ulad": {
      "word": "<u>u</u>lad",
      "normalizedWord": "ulad",
      "pronunciation": "u·lad",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["worm", "caterpillar"],
      "filipinoTranslations": ["uod"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "worms, in general",
              "example": "ating <i><u>u</u>lad</i> keng gabun",
              "exampleTranslation": "there's a <i>worm</i> on the ground",
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "neutral verb",
          "definitions": [
            {
              "definition": "full of worms ",
              "example": "<i>manulad</i> nala reng prutas",
              "exampleTranslation":
                  "the fruits are already <i>full of worms</i>",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["u"],
        ["la", "d"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "ulila": {
      "word": "ul<u>i</u>la",
      "normalizedWord": "ulila",
      "pronunciation": "u·l<u>i</u>·la",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": [
        "orphan",
      ],
      "filipinoTranslations": ["ulila"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "orphaned of his father, totally orphaned, no parents, no siblings.",
              "example": "<i>Ul<u>i</u>la</i> ya i Gibs",
              "exampleTranslation": "Gibs is an <i>orphan</i>",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["u"],
        ["li"],
        ["la"],
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "valido": {
      "word": "v<u>a</u>lido",
      "normalizedWord": "valido",
      "pronunciation": "v<u>a</u>·li·do",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["valid", "authentic"],
      "filipinoTranslations": ["totoo"],
      "meanings": [
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition":
                  "Seen to be in agreement with facts or to be logically sound",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            },
            {
              "definition": "In conformitiy with the law, and therfore binding",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            },
            {
              "definition": "Based on sound principle",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["va"],
        ["li"],
        ["da", "u"]
      ],
      "otherRelated": {
        "husto": "husto",
        "istu": "istu",
        "ustu": "ustu",
        "istung": "istung"
      },
      "synonyms": {
        "husto": "husto",
        "istu": "istu",
        "ustu": "ustu",
        "istung": "istung"
      },
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "ventilador": {
      "word": "ventilad<u>o</u>r",
      "normalizedWord": "ventilador",
      "pronunciation": "ven·ti·la·d<u>o</u>r",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["ventillator", "electric fan"],
      "filipinoTranslations": ["bentiladór"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "electric fan of various models: ceiling fan, oscillating desk fan, fan with a stand",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            },
            {
              "definition": "motor fan, exhaust fan",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["v", "a", "i", "n"],
        ["ti"],
        ["la"],
        ["da", "u", "r"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "viernes": {
      "word": "vi<u>e</u>rnes",
      "normalizedWord": "viernes",
      "pronunciation": "vi·<u>e</u>r·nes",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["friday"],
      "filipinoTranslations": ["biyernes"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "Friday, fast day;",
              "example": "<i>Vi<u>e</u>rnes</i> ngeni",
              "exampleTranslation": "It is <i>friday</i> today",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["vi"],
        ["a", "i", "r"],
        ["na", "i", "s"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "vulcan": {
      "word": "vulc<u>a</u>n",
      "normalizedWord": "vulcan",
      "pronunciation": "vul·c<u>a</u>n",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["volcano"],
      "filipinoTranslations": ["bulkan"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "a rift or vent in the earth's crush through which molten material from the detphs of the earth is erupted at the surface as flows of lava or clouds of gas and ashes",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["vu", "l"],
        ["ca", "n"]
      ],
      "otherRelated": {
        "abu": "abu",
        "acbung": "acbung",
        "explosivo": "explosivo"
      },
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "vocabulario": {
      "word": "vocabul<u>a</u>rio",
      "normalizedWord": "vocabulario",
      "pronunciation": "vo·ca·bu·l<u>a</u>·rio",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["vocabulary"],
      "filipinoTranslations": ["bokabularyo"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "a list of words, usually aranged alphabetically and defined, explained or translated",
              "example":
                  "ing <i>vocabul<u>a</u>rio</i> ning libru mipnu yang amanung tecnic",
              "exampleTranslation":
                  "the <i>vocabulary</i> of the book is full of technical words",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["v", "a", "u"],
        ["ca"],
        ["b", "u"],
        ["la", "r"],
        ["i", "a", "u"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "wacas": {
      "word": "wac<u>a</u>s",
      "normalizedWord": "wacas",
      "pronunciation": "wa·c<u>a</u>s",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["end"],
      "filipinoTranslations": ["wakas"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "the end, or tip of a thing, ot its edge, like at the edge of the town, or at the end of the book, where it ends, like the four last things/ends of man",
              "example": "Apin ita ing <i>wac<u>a</u>s</i> ning libru",
              "exampleTranslation": "That's the end of the book",
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "neutral verb",
          "definitions": [
            {
              "definition":
                  "to come last, be put at the last, or at the edge, like the sentinels, or guards as the gate",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["u", "a"],
        ["ka", "s"]
      ],
      "otherRelated": null,
      "synonyms": {"completo": "completo", "inari": "inari"},
      "antonyms": {"alitari": "alitari"},
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },

    "wali": {
      "word": "w<u>a</u>li",
      "normalizedWord": "wali",
      "pronunciation": "w<u>a</u>·li",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["younger sibling"],
      "filipinoTranslations": ["nakababatang kapatid"],
      "meanings": [
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition":
                  "Younger brother, in relation to his older siblings It is also a word of endearment",
              "example": "<i>W<u>a</u>li</i> ke i Steven",
              "exampleTranslation": "Steven is my <i>younger brother</i>",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["u", "a"],
        ["li"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    //TODO
    "wanan": {
      "word": "wan<u>a</u>n",
      "normalizedWord": "wanan",
      "pronunciation": "wa·n<u>a</u>n",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["right"],
      "filipinoTranslations": ["kanan"],
      "meanings": [
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition": "all that is on the righthand side",
              "example": "Atiu ya cing canacung <i>wan<u>a</u>n</i>",
              "exampleTranslation": "He is on my right",
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "neutral verb",
          "definitions": [
            {
              "definition": "become placed on the righthand side",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["u", "a"],
        ["na", "n"]
      ],
      "otherRelated": {"caili": "caili"},
      "synonyms": null,
      "antonyms": {"caili": "caili"},
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "wari": {
      "word": "w<u>a</u>ri",
      "normalizedWord": "wari",
      "pronunciation": "w<u>a</u>·ri",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "adjective , conjunction",
          "definitions": [
            {
              "definition":
                  "given but not admitted, admitted but not conceded.",
              "example": "Depat cu <i>wari</i>, inya palsalanan mu co?",
              "exampleTranslation": "Did I do it? Why are you blaming me?",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["u", "a"],
        ["ri"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "wigwig": {
      "word": "wigw<u>i</u>g",
      "normalizedWord": "wigwig",
      "pronunciation": "wig·w<u>i</u>g",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["sprinkle"],
      "filipinoTranslations": ["diligan"],
      "meanings": [
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition": "to sprinkle, to fall, like dew",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["wi", "g"],
        ["wi", "g"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "x": {
      "word": "x",
      "normalizedWord": "x",
      "pronunciation": "eks",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": [
        "x",
      ],
      "filipinoTranslations": ["ekis"],
      "meanings": [
        {
          "partOfSpeech": "letter",
          "definitions": [
            {
              "definition":
                  "the 24th letter of the English and Filipino alphabets (sounded as 'z' when an initial letter; the 26th letter (ekis) of the Spanish and Capampangan alphabets. Many words which in old documents were written with X have been changed to J, or even written with x, are pronounced as j or h, e.g. Don Quixote = Don Quijote; Ximenez =Jimenez; Mexico= Méjico. In the Tagalog and old Capampangan alphabets x is equivalent to fcs, e.g. extra = ekstra or ecstra",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["sa"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "xi": {
      "word": "xi",
      "normalizedWord": "xi",
      "pronunciation": "tzai",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "the 14th letter ( E, Ş = x ) of the Greek alphabet.",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["si"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "ya": {
      "word": "ya",
      "normalizedWord": "ya",
      "pronunciation": "ya",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["he", "she", "it"],
      "filipinoTranslations": ["siya"],
      "meanings": [
        {
          "partOfSpeech": "pronoun",
          "definitions": [
            {
              "definition":
                  "personal pronoun in the third person singular, nominative case ",
              "example": "<i>Ya</i> ing capatad cu",
              "exampleTranslation": "That's my brother",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["i", "a"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "yayat": {
      "word": "y<u>a</u>yat",
      "normalizedWord": "yayat",
      "pronunciation": "y<u>a</u>·yat",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["thin", "lean"],
      "filipinoTranslations": ["payat"],
      "meanings": [
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition": "thiness ",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "neutral verb",
          "definitions": [
            {
              "definition": "to become thin",
              "example": "Bisa nacung <i>may<u>a</u>yat</i>",
              "exampleTranslation": "I want to be <i>thinner</i>",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["i", "a"],
        ["i", "a", "t"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "yangyang": {
      "word": "yangy<u>a</u>ng",
      "normalizedWord": "yangyang",
      "pronunciation": "yang·y<u>a</u>ng",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["to dry"],
      "filipinoTranslations": ["pagtuyo"],
      "meanings": [
        {
          "partOfSpeech": "verb",
          "definitions": [
            {
              "definition":
                  "to expose to the air for drying, to bring out and expose to the air",
              "example": "<i>Yangyang</i> cu la reng malan ku king linya.",
              "exampleTranslation": "I'll dry my clothes on a clothesline",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["i", "a", "ng"],
        ["i", "a", "ng"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "yari": {
      "word": "yari",
      "normalizedWord": "yari",
      "pronunciation": "ya·ri",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["done", "finished"],
      "filipinoTranslations": ["tapos"],
      "meanings": [
        {
          "partOfSpeech": "adjective",
          "definitions": [
            {
              "definition": "completed thing, finished",
              "example": "<i>Yari</i> nacu cing clasi cu",
              "exampleTranslation": "I'm <i>done</i> with my classes",
              "dialect": null,
              "origin": null
            }
          ]
        },
        {
          "partOfSpeech": "verb",
          "definitions": [
            {
              "definition": "finishing",
              "example": "My class is about to <i>finish</i>",
              "exampleTranslation": "<i>Mayari</i> ne ing clasi cu",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["i", "a"],
        ["ri"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "yata": {
      "word": "y<u>a</u>tâ",
      "normalizedWord": "yata",
      "pronunciation": "y<u>a</u>·tâ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["doubt", "unsure"],
      "filipinoTranslations": ["hindi siguro"],
      "meanings": [
        {
          "partOfSpeech": "adverb",
          "definitions": [
            {
              "definition":
                  "it is not a verbiage, a word to fill up a line, but one that expresses a trace of doubt",
              "example": "Iya pin <i>y<u>a</u>tâ</i>",
              "exampleTranslation": "I think its him",
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["i", "a"],
        ["ta"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "zambales": {
      "word": "zamb<u>a</u>les",
      "normalizedWord": "zambales",
      "pronunciation": "zam·b<u>a</u>·les",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": null,
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "Zambales. ft. the province along the S.W. coast of Luzon island, Philippines, contigous with Bataan to the south, Pampanga and Tarlac to the east and Pangasinan to the north; it belongs to Region III",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["za", "m"],
        ["ba"],
        ["l", "a", "i", "s"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "zapote": {
      "word": "zap<u>o</u>te",
      "normalizedWord": "zapote",
      "pronunciation": "za·p<u>o</u>·te",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["sapodilla", "sapote"],
      "filipinoTranslations": ["null"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "sapodilla tree and its fruits",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["za"],
        ["p", "u"],
        ["t", "a", "i"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "zaragate": {
      "word": "zarag<u>a</u>te",
      "normalizedWord": "zaragate",
      "pronunciation": "za·ra·g<u>a</u>·te",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["Rascal"],
      "filipinoTranslations": ["haragan"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "rascal,rogue <i>see pilyu,salvahe</i>",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["za"],
        ["ra"],
        ["ga"],
        ["t", "i"]
      ],
      "otherRelated": null,
      "synonyms": {"salvahe": "salvahe", "pilyu": "pilyu"},
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "zarza": {
      "word": "z<u>a</u>rza",
      "normalizedWord": "zarza",
      "pronunciation": "z<u>a</u>r·za",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["bramble"],
      "filipinoTranslations": ["tinik"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "bramble, blackberry-bush; thorns, difficulties. <i>see sapinit,sucsuc,dawe </i>",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["za", "r"],
        ["za"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "zarzuela": {
      "word": "zarzu<u>e</u>la",
      "normalizedWord": "zarzuela",
      "pronunciation": "za·zu·<u>e</u>·la",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["zarzuela"],
      "filipinoTranslations": ["sarsuwela"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "light musical dramatic performance, musical comedy, comic opera, stage play",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["za", "r"],
        ["zu"],
        ["a", "i"],
        ["la"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    },
    "zona": {
      "word": "z<u>o</u>na",
      "normalizedWord": "zona",
      "pronunciation": "z<u>o</u>·na",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["zone"],
      "filipinoTranslations": ["tinik"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "an area within which a characteristic activity is carried on, or an area set aside for a specific purpose, residential zone, industrial zone, military zone, war zone, school zone, hospital zone, church zone etc",
              "example": null,
              "exampleTranslation": null,
              "dialect": null,
              "origin": null
            }
          ]
        },
      ],
      "kulitan-form": [
        ["z", "u"],
        ["na"],
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Kapampangan Dictionary by Fr. Veneracio Samson",
      "contributors": null,
      "expert": {"AmanuKP": "crqRUSQ7u0OjJJHvZWMvjNxROML2"},
      "lastModifiedTime": "2023-09-01 (12:00:00)"
    }
  };
}
