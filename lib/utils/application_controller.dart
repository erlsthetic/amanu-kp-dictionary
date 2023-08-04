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
              ? true
              : false
          : false;
      print("hasConnection: ${hasConnection}");
      print("isOnWiFi: ${isOnWifi}");
    });
    checkBookmarks();
    getUserInfo();
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

  // -- DICTIONARY MANAGEMENT

  String? dictionaryVersion, dictionaryContentAsString;
  RxBool noData = false.obs;

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
        noData.value = true;
        dictionaryVersion = null;
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

  List<String> bookmarks = [];
  Future checkBookmarks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("bookmarks")) {
      bookmarks = prefs.getStringList("bookmarks")!;
    } else {
      prefs.setStringList("bookmarks", bookmarks);
    }
  }

  Map<String, dynamic> dictionaryContent = {
    "hello": {
      "word": "hello",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fhello%2Faudio.mp3?alt=media&token=2b865188-63b5-4b90-904c-6722a492e467",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "dialect": "guagua",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao."
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "dialect": null,
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!"
            },
            {
              "definition": "used as opening in phone calls.",
              "dialect": "somewhere",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito."
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "otherRelated": {"pangangamusta": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com"
    },
    "hello0": {
      "word": "hello0",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fhello%2Faudio.mp3?alt=media&token=2b865188-63b5-4b90-904c-6722a492e467",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "dialect": "guagua",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao."
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "dialect": null,
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!"
            },
            {
              "definition": "used as opening in phone calls.",
              "dialect": "somewhere",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito."
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        []
      ],
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "otherRelated": {"pangangamusta": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com"
    },
    "hello1": {
      "word": "hello1",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fhello%2Faudio.mp3?alt=media&token=2b865188-63b5-4b90-904c-6722a492e467",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "dialect": "guagua",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao."
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "dialect": null,
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!"
            },
            {
              "definition": "used as opening in phone calls.",
              "dialect": "somewhere",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito."
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "synonyms": {},
      "antonyms": {"ayoko": null, "bye": null},
      "otherRelated": {"pangangamusta": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com"
    },
    "hello2": {
      "word": "hello2",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fhello%2Faudio.mp3?alt=media&token=2b865188-63b5-4b90-904c-6722a492e467",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "dialect": "guagua",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao."
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "dialect": null,
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!"
            },
            {
              "definition": "used as opening in phone calls.",
              "dialect": "somewhere",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito."
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "otherRelated": {"pangangamusta": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com"
    },
    "hello3": {
      "word": "hello3",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fhello%2Faudio.mp3?alt=media&token=2b865188-63b5-4b90-904c-6722a492e467",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": [],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "dialect": "guagua",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao."
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "dialect": null,
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!"
            },
            {
              "definition": "used as opening in phone calls.",
              "dialect": "somewhere",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito."
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "otherRelated": {"pangangamusta": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com"
    },
    "hello4": {
      "word": "hello4",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fhello%2Faudio.mp3?alt=media&token=2b865188-63b5-4b90-904c-6722a492e467",
      "englishTranslations": [],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "dialect": "guagua",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao."
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "dialect": null,
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!"
            },
            {
              "definition": "used as opening in phone calls.",
              "dialect": "somewhere",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito."
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "otherRelated": {"pangangamusta": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com"
    },
    "hello5": {
      "word": "hello5",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fhello%2Faudio.mp3?alt=media&token=2b865188-63b5-4b90-904c-6722a492e467",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "dialect": "guagua",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao."
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "dialect": null,
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!"
            },
            {
              "definition": "used as opening in phone calls.",
              "dialect": "somewhere",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito."
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "otherRelated": {"pangangamusta": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com"
    },
    "hello6": {
      "word": "hello6",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fhello%2Faudio.mp3?alt=media&token=2b865188-63b5-4b90-904c-6722a492e467",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "dialect": "guagua",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao."
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "dialect": null,
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!"
            },
            {
              "definition": "used as opening in phone calls.",
              "dialect": "somewhere",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito."
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "otherRelated": {"pangangamusta": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com"
    },
    "hello7": {
      "word": "hello7",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fhello%2Faudio.mp3?alt=media&token=2b865188-63b5-4b90-904c-6722a492e467",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "dialect": "guagua",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao."
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "dialect": null,
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!"
            },
            {
              "definition": "used as opening in phone calls.",
              "dialect": "somewhere",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito."
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "otherRelated": {"pangangamusta": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com"
    },
    "hello8": {
      "word": "hello8",
      "normalizedWord": "hello",
      "pronunciation": "həˈləʊ",
      "pronunciationAudio":
          "https://firebasestorage.googleapis.com/v0/b/amanu-kpd.appspot.com/o/dictionary%2Fhello%2Faudio.mp3?alt=media&token=2b865188-63b5-4b90-904c-6722a492e467",
      "englishTranslations": ["hello", "hi"],
      "filipinoTranslations": ["kamusta", "musta"],
      "meanings": [
        {
          "partOfSpeech": "noun",
          "definitions": [
            {
              "definition": "an utterance of 'hello'; a greeting.",
              "dialect": "guagua",
              "example": "she said her hello to the stranger.",
              "exampleTranslation":
                  "sinabi niya ang kanyang pangangamusta sa tao."
            }
          ]
        },
        {
          "partOfSpeech": "exclamation",
          "definitions": [
            {
              "definition": "used as a greeting.",
              "dialect": null,
              "example": "hello there, Katie!",
              "exampleTranslation": "kamusta, Katie!"
            },
            {
              "definition": "used as opening in phone calls.",
              "dialect": "somewhere",
              "example": "Hello, this is Katie speaking.",
              "exampleTranslation": "Kamusta, si Katie ito."
            },
          ]
        }
      ],
      "kulitan-form": [
        ["ka"],
        ["mu", "s"],
        ["ta"]
      ],
      "synonyms": {"musta": null, "sup": null},
      "antonyms": {"ayoko": null, "bye": null},
      "otherRelated": {"pangangamusta": null},
      "sources": "Only Me. (n.d). Only Me. Sample.com"
    }
  };
}
