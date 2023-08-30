import 'package:cloud_firestore/cloud_firestore.dart';

class DeleteRequestModel {
  final String requestId;
  final String uid;
  final int requestType;
  final bool isAvailable;
  final String timestamp;
  final String? requestNotes;
  final String wordID;
  final String word;

  const DeleteRequestModel({
    required this.requestId,
    required this.uid,
    required this.timestamp,
    this.requestType = 2,
    this.isAvailable = true,
    this.requestNotes = null,
    required this.wordID,
    required this.word,
  });

  toJson() {
    return {
      "requestId": requestId,
      "uid": uid,
      "timestamp": timestamp,
      "requestType": requestType,
      "isAvailable": isAvailable,
      "requestNotes": requestNotes,
      "wordID": wordID,
      "word": word,
    };
  }

  factory DeleteRequestModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return DeleteRequestModel(
      requestId: data["requestId"],
      uid: data["uid"],
      timestamp: data["timestamp"],
      requestType: data["requestType"],
      isAvailable: data["isAvailable"],
      requestNotes: data["requestNotes"],
      wordID: data["wordID"],
      word: data["word"],
    );
  }
}
