import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackModel {
  final int rating;
  final String? additionalNotes;
  final String timestamp;

  const FeedbackModel({
    this.additionalNotes,
    required this.rating,
    required this.timestamp,
  });

  toJson() {
    return {
      "rating": this.rating,
      "additionalNotes": this.additionalNotes,
      "timestamp": this.timestamp,
    };
  }

  factory FeedbackModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return FeedbackModel(
      additionalNotes: data["additionalNotes"],
      rating: data["rating"],
      timestamp: data["timestamp"],
    );
  }
}
