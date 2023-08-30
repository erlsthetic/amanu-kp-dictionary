import 'package:cloud_firestore/cloud_firestore.dart';

class EditRequestModel {
  final String uid;
  final int requestType;
  final bool isAvailable;
  final String timestamp;
  final String? requestNotes;
  final String prevWordID;
  final String wordID;
  final String word;
  final String normalizedWord;
  final String prn;
  final String prnUrl;
  final String prnStoragePath;
  final List<dynamic> engTrans;
  final List<dynamic> filTrans;
  final List<Map<String, dynamic>> meanings;
  final List<List<dynamic>> kulitanChars;
  final Map<dynamic, dynamic> otherRelated;
  final Map<dynamic, dynamic> synonyms;
  final Map<dynamic, dynamic> antonyms;
  final String sources;
  final Map<dynamic, dynamic> contributors;
  final Map<dynamic, dynamic> expert;
  final String lastModifiedTime;

  const EditRequestModel({
    required this.uid,
    required this.timestamp,
    this.requestType = 1,
    this.isAvailable = true,
    this.requestNotes = null,
    required this.prevWordID,
    required this.wordID,
    required this.word,
    required this.normalizedWord,
    required this.prn,
    required this.prnUrl,
    required this.prnStoragePath,
    required this.engTrans,
    required this.filTrans,
    required this.meanings,
    required this.kulitanChars,
    required this.otherRelated,
    required this.synonyms,
    required this.antonyms,
    required this.sources,
    required this.contributors,
    required this.expert,
    required this.lastModifiedTime,
  });

  toJson() {
    return {
      "uid": uid,
      "timestamp": timestamp,
      "requestType": requestType,
      "isAvailable": isAvailable,
      "requestNotes": requestNotes,
      "prevWordID": prevWordID,
      "wordID": wordID,
      "word": word,
      "normalizedWord": normalizedWord,
      "prn": prn,
      "prnUrl": prnUrl,
      "prnStoragePath": prnStoragePath,
      "engTrans": engTrans,
      "filTrans": filTrans,
      "meanings": meanings,
      "kulitanChars": kulitanChars,
      "otherRelated": otherRelated,
      "synonyms": synonyms,
      "antonyms": antonyms,
      "sources": sources,
      "contributors": contributors,
      "expert": expert,
      "lastModifiedTime": lastModifiedTime,
    };
  }

  factory EditRequestModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return EditRequestModel(
      uid: data["uid"],
      timestamp: data["timestamp"],
      requestType: data["requestType"],
      isAvailable: data["isAvailable"],
      requestNotes: data["requestNotes"],
      prevWordID: data["prevWordID"],
      wordID: data["wordID"],
      word: data["word"],
      normalizedWord: data["normalizedWord"],
      prn: data["prn"],
      prnUrl: data["prnUrl"],
      prnStoragePath: data["prnStoragePath"],
      engTrans: data["engTrans"],
      filTrans: data["filTrans"],
      meanings: data["meanings"],
      kulitanChars: data["kulitanChars"],
      otherRelated: data["otherRelated"],
      synonyms: data["synonyms"],
      antonyms: data["antonyms"],
      sources: data["sources"],
      contributors: data["contributors"],
      expert: data["expert"],
      lastModifiedTime: data["lastModifiedTime"],
    );
  }
}
