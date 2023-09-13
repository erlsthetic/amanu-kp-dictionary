import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amanu/models/user_model.dart';
import 'package:amanu/screens/home_screen/controllers/drawerx_controller.dart';
import 'package:amanu/screens/home_screen/controllers/home_page_controller.dart';
import 'package:amanu/screens/home_screen/home_screen.dart';
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
    isFirstTimeUse = true;
    hasConnection.value = await InternetConnectionChecker().hasConnection;
    subscription = await listenToConnectionState();
    await updateUserInfo();
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
      Get.offAll(() => OnBoardingScreen());
    } else {
      final drawerController = Get.find<DrawerXController>();
      drawerController.currentItem.value = DrawerItems.home;
      Get.offAll(() => HomeScreen());
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
    });
  }

  void showConnectionSnackbar() {
    final title = hasConnection.value ? "Connected" : "Disconnected";
    final message = hasConnection.value
        ? isOnWifi.value
            ? "You are connected thru WiFi."
            : "You are connected thru mobile data."
        : "There is no internet connection";
    final color = hasConnection.value
        ? Colors.green.withOpacity(0.75)
        : Colors.redAccent.withOpacity(0.75);
    final icon = hasConnection.value ? Icons.check_circle : Icons.error;
    Get.snackbar(title, message,
        backgroundColor: color,
        colorText: pureWhite,
        icon: Icon(
          icon,
          color: pureWhite,
          size: 20,
        ),
        duration: Duration(seconds: 3),
        shouldIconPulse: true);
  }

  // -- USER MANAGEMENT

  bool isLoggedIn = false;
  String? userID, userName, userEmail;
  int? userPhone;
  bool? userIsExpert, userExpertRequest, userEmailPublic, userPhonePublic;
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
              userData.phonePublic);
        }
      } else {
        if (prefs.containsKey("userID")) {
          await getSavedUserDetails();
        } else {
          await changeLoginState(false);
          await changeUserDetails(null, null, null, null, null, null, null,
              null, null, null, null, null, null);
        }
      }
    } else {
      await changeUserDetails(null, null, null, null, null, null, null, null,
          null, null, null, null, null);
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
      bool? _userPhonePublic) async {
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
    await saveUserDetails();
    printUserDetails();
  }

  Future<String?> saveUserPicToLocal(String? userPic) async {
    if (userPic != null) {
      try {
        String picExt = userPic.split("?").first;
        final appStorage = await getApplicationDocumentsDirectory();
        final fileExt = extension(File(picExt).path);
        final tempPhoto = File('${appStorage.path}/profilePic$fileExt');
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
  String? dictionaryVersion, dictionaryContentAsString;
  RxBool noData = false.obs;

  Future checkDictionary() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (hasConnection.value) {
      if (prefs.containsKey("dictionaryVersion")) {
        final storedVersion = prefs.getString("dictionaryVersion");
        final currentVersion = await getDictionaryVersion();
        if (currentVersion != storedVersion) {
          dictionaryContentUnsorted = await downloadDictionary();
          dictionaryContentAsString = json.encode(dictionaryContentUnsorted);
          prefs.setString("dictionaryVersion", currentVersion);
          prefs.setString(
              "dictionaryContentAsString", dictionaryContentAsString!);
        } else if (currentVersion == storedVersion) {
          dictionaryVersion = prefs.getString("dictionaryVersion");
          dictionaryContentAsString =
              prefs.getString("dictionaryContentAsString");
          dictionaryContentUnsorted = json.decode(dictionaryContentAsString!);
        }
      } else {
        dictionaryVersion = await getDictionaryVersion();
        dictionaryContentUnsorted = await downloadDictionary();
        dictionaryContentAsString = json.encode(dictionaryContentUnsorted);
        prefs.setString("dictionaryVersion", dictionaryVersion!);
        prefs.setString(
            "dictionaryContentAsString", dictionaryContentAsString!);
      }
    } else {
      if (prefs.containsKey("dictionaryVersion")) {
        dictionaryVersion = prefs.getString("dictionaryVersion");
        dictionaryContentAsString =
            prefs.getString("dictionaryContentAsString");
        dictionaryContentUnsorted = json.decode(dictionaryContentAsString!);
      } else {
        noData.value = true;
        dictionaryVersion = null;
      }
    }
    print("dictionaryVersion: " + dictionaryVersion.toString());
    print("dictionaryContentUnsorted: " + dictionaryContent.toString());
  }

  Future<Map<String, dynamic>> downloadDictionary() async {
    final dictionarySnapshot = await _realtimeDB.child('dictionary').get();
    return Map<String, dynamic>.from(dictionarySnapshot.value as dynamic);
  }

  Future<String> getDictionaryVersion() async {
    final dictionaryVersion = await _realtimeDB.child('version').get();
    return dictionaryVersion.value as String;
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
      return prefs.getBool("isFirstTimeUse")!;
    } else {
      prefs.setBool("isFirstTimeUse", true);
      return prefs.getBool("isFirstTimeUse")!;
    }
  }

  Future<bool> checkFirstTimeHome() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeHome")) {
      return prefs.getBool("isFirstTimeHome")!;
    } else {
      prefs.setBool("isFirstTimeHome", true);
      return prefs.getBool("isFirstTimeHome")!;
    }
  }

  Future<bool> checkFirstTimeBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeBookmarks")) {
      return prefs.getBool("isFirstTimeBookmarks")!;
    } else {
      prefs.setBool("isFirstTimeBookmarks", true);
      return prefs.getBool("isFirstTimeBookmarks")!;
    }
  }

  Future<bool> checkFirstTimeModify() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeModify")) {
      return prefs.getBool("isFirstTimeModify")!;
    } else {
      prefs.setBool("isFirstTimeModify", true);
      return prefs.getBool("isFirstTimeModify")!;
    }
  }

  Future<bool> checkFirstTimeKulitanEditor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeKulitanEditor")) {
      return prefs.getBool("isFirstTimeKulitanEditor")!;
    } else {
      prefs.setBool("isFirstTimeKulitanEditor", true);
      return prefs.getBool("isFirstTimeKulitanEditor")!;
    }
  }

  Future<bool> checkFirstTimeStudio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeStudio")) {
      return prefs.getBool("isFirstTimeStudio")!;
    } else {
      prefs.setBool("isFirstTimeStudio", true);
      return prefs.getBool("isFirstTimeStudio")!;
    }
  }

  Future<bool> checkFirstTimeDetail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeDetail")) {
      return prefs.getBool("isFirstTimeDetail")!;
    } else {
      prefs.setBool("isFirstTimeDetail", true);
      return prefs.getBool("isFirstTimeDetail")!;
    }
  }

  Future<bool> checkFirstTimeScanner() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeScanner")) {
      return prefs.getBool("isFirstTimeScanner")!;
    } else {
      prefs.setBool("isFirstTimeScanner", true);
      return prefs.getBool("isFirstTimeScanner")!;
    }
  }

  Future<bool> checkFirstTimeRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeRequests")) {
      return prefs.getBool("isFirstTimeRequests")!;
    } else {
      prefs.setBool("isFirstTimeRequests", true);
      return prefs.getBool("isFirstTimeRequests")!;
    }
  }

  Future<bool> checkFirstTimeProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeOnboarding")) {
      return prefs.getBool("isFirstTimeOnboarding")!;
    } else {
      prefs.setBool("isFirstTimeOnboarding", true);
      return prefs.getBool("isFirstTimeOnboarding")!;
    }
  }

  Future<bool> checkFirstTimeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("isFirstTimeOnboarding")) {
      return prefs.getBool("isFirstTimeOnboarding")!;
    } else {
      prefs.setBool("isFirstTimeOnboarding", true);
      return prefs.getBool("isFirstTimeOnboarding")!;
    }
  }

  //
  Map<String, dynamic> dictionaryContentUnsorted = {
    "hello": {
      "word": "hello",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition":
                  "an utterance of <i>'hello'</i>; a <b>greeting</b>.",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao.",
              "dialect": "guagua",
              "origin": "something something",
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "<b>used as a <i>greeting</i></b>.",
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!",
              "dialect": null,
              "origin": null,
            },
            {
              "definition": "used as <b>opening</b> in <i>phone</i> calls.",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito.",
              "dialect": "somewhere",
              "origin": "hello its me",
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "otherRelated": {"pangangamusta": null},
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com",
      "contributors": {
        "EJGV": "kXBFrfI4rmTzwyfXEipUoPSAMI43",
        "AmanuTeam": "sad8U389JSJsduash872",
        "AnotherPerson": "dfsd342csdx23423csf"
      },
      "expert": {"EJGV": "kXBFrfI4rmTzwyfXEipUoPSAMI43"},
      "lastModifiedTime": "2023-08-05 (12:40:33)"
    },
    "hello9": {
      "word": "hello9",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": null,
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao.",
              "dialect": "guagua",
              "origin": "something something",
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!",
              "dialect": null,
              "origin": null,
            },
            {
              "definition": "used as opening in phone calls.",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito.",
              "dialect": "somewhere",
              "origin": "hello its me",
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "otherRelated": {"pangangamusta": null},
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com",
      "contributors": {
        "AmanuTeam": "sad8U389JSJsduash872",
        "AnotherPerson": "dfsd342csdx23423csf"
      },
      "expert": {"TheExpert": "sad8U389JSJsduash872"},
      "lastModifiedTime": "2023-08-05 (12:40:33)"
    },
    "hello3": {
      "word": "hello3",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao.",
              "dialect": "guagua",
              "origin": null,
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!",
              "dialect": null,
              "origin": null,
            },
            {
              "definition": "used as opening in phone calls.",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito.",
              "dialect": "somewhere",
              "origin": "hello its me",
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "otherRelated": {"pangangamusta": null},
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com",
      "contributors": {
        "EJGV": "kXBFrfI4rmTzwyfXEipUoPSAMI43",
        "AmanuTeam": "sad8U389JSJsduash872",
        "AnotherPerson": "dfsd342csdx23423csf"
      },
      "expert": {"EJGV": "kXBFrfI4rmTzwyfXEipUoPSAMI43"},
      "lastModifiedTime": "2023-08-05 (12:40:33)"
    },
    "hello5": {
      "word": "hello5",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao.",
              "dialect": "guagua",
              "origin": "something something",
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!",
              "dialect": null,
              "origin": null,
            },
            {
              "definition": "used as opening in phone calls.",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito.",
              "dialect": "somewhere",
              "origin": "hello its me",
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        [],
        ["mu", "s"],
        ["ta"]
      ],
      "otherRelated": {"pangangamusta": null},
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com",
      "contributors": {
        "AmanuTeam": "sad8U389JSJsduash872",
        "AnotherPerson": "dfsd342csdx23423csf"
      },
      "expert": {"TheExpert": "sad8U389JSJsduash872"},
      "lastModifiedTime": "2023-08-05 (12:40:33)"
    },
    "hello4": {
      "word": "hello4",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao.",
              "dialect": null,
              "origin": "something something",
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!",
              "dialect": null,
              "origin": null,
            },
            {
              "definition": "used as opening in phone calls.",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito.",
              "dialect": "somewhere",
              "origin": "hello its me",
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "otherRelated": {"pangangamusta": null},
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com",
      "contributors": {
        "AmanuTeam": "sad8U389JSJsduash872",
        "AnotherPerson": "dfsd342csdx23423csf"
      },
      "expert": {"TheExpert": "sad8U389JSJsduash872"},
      "lastModifiedTime": "2023-08-05 (12:40:33)"
    },
    "hello2": {
      "word": "hello2",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao.",
              "dialect": "guagua",
              "origin": "something something",
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!",
              "dialect": null,
              "origin": null,
            },
            {
              "definition": "used as opening in phone calls.",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito.",
              "dialect": "somewhere",
              "origin": "hello its me",
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "otherRelated": {"pangangamusta": null},
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "sources": null,
      "contributors": {
        "AmanuTeam": "sad8U389JSJsduash872",
        "AnotherPerson": "dfsd342csdx23423csf"
      },
      "expert": {"TheExpert": "sad8U389JSJsduash872"},
      "lastModifiedTime": "2023-08-05 (12:40:33)"
    },
    "hello1": {
      "word": "hello1",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao.",
              "dialect": "guagua",
              "origin": "something something",
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!",
              "dialect": null,
              "origin": null,
            },
            {
              "definition": "used as opening in phone calls.",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito.",
              "dialect": "somewhere",
              "origin": "hello its me",
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "otherRelated": null,
      "synonyms": null,
      "antonyms": null,
      "sources": "Only Me. (n.d). Only Me. Sample.com",
      "contributors": {
        "EJGV": "kXBFrfI4rmTzwyfXEipUoPSAMI43",
        "AmanuTeam": "sad8U389JSJsduash872",
        "AnotherPerson": "dfsd342csdx23423csf"
      },
      "expert": {"EJGV": "kXBFrfI4rmTzwyfXEipUoPSAMI43"},
      "lastModifiedTime": "2023-08-05 (12:40:33)"
    },
    "hello7": {
      "word": "hello7",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao.",
              "dialect": "guagua",
              "origin": "something something",
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!",
              "dialect": null,
              "origin": null,
            },
            {
              "definition": "used as opening in phone calls.",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito.",
              "dialect": "somewhere",
              "origin": "hello its me",
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "otherRelated": {"pangangamusta": null},
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com",
      "contributors": null,
      "expert": {"TheExpert": "sad8U389JSJsduash872"},
      "lastModifiedTime": "2023-08-05 (12:40:33)"
    },
    "hello6": {
      "word": "hello6",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao.",
              "dialect": "guagua",
              "origin": "something something",
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!",
              "dialect": null,
              "origin": null,
            },
            {
              "definition": "used as opening in phone calls.",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito.",
              "dialect": "somewhere",
              "origin": "hello its me",
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "otherRelated": {"pangangamusta": "hello"},
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com",
      "contributors": {
        "AmanuTeam": "sad8U389JSJsduash872",
        "AnotherPerson": "dfsd342csdx23423csf"
      },
      "expert": {"TheExpert": "sad8U389JSJsduash872"},
      "lastModifiedTime": "2023-08-05 (12:40:33)"
    },
    "hello8": {
      "word": "hello8",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao.",
              "dialect": "guagua",
              "origin": "something something",
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!",
              "dialect": null,
              "origin": null,
            },
            {
              "definition": "used as opening in phone calls.",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito.",
              "dialect": "somewhere",
              "origin": "hello its me",
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "otherRelated": {"pangangamusta": null},
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com",
      "contributors": {
        "AmanuTeam": "sad8U389JSJsduash872",
        "AnotherPerson": "dfsd342csdx23423csf"
      },
      "expert": null,
      "lastModifiedTime": "2023-08-05 (12:40:33)"
    },
    "hello0": {
      "word": "hello0",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fsample%2Faudio.mp3?alt=media&token=c3f767b0-d1f7-4fe3-b3f0-16bcedb91f7e",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "example": null,
              "exampleTranslation": null,
              "dialect": "guagua",
              "origin": "something something",
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!",
              "dialect": null,
              "origin": null,
            },
            {
              "definition": "used as opening in phone calls.",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito.",
              "dialect": "somewhere",
              "origin": "hello its me",
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "otherRelated": {"pangangamusta": null},
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com",
      "contributors": {
        "AmanuTeam": "sad8U389JSJsduash872",
        "AnotherPerson": "dfsd342csdx23423csf"
      },
      "expert": {"TheExpert": "sad8U389JSJsduash872"},
      "lastModifiedTime": "2023-08-05 (12:40:33)"
    },
  };
}
