import 'package:cloud_firestore/cloud_firestore.dart';

class ReportModel {
  final String? email;
  final String problemType;
  final String subject;
  final String details;
  final String? imgUrl;
  final String timestamp;

  const ReportModel({
    this.email,
    required this.problemType,
    required this.subject,
    required this.details,
    this.imgUrl,
    required this.timestamp,
  });

  toJson() {
    return {
      "email": email,
      "problemType": problemType,
      "subject": this.subject,
      "details": this.details,
      "imgUrl": this.imgUrl,
      "timestamp": this.timestamp,
    };
  }

  factory ReportModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return ReportModel(
      email: data["email"],
      problemType: data["problemType"],
      subject: data["subject"],
      details: data["details"],
      imgUrl: data["imgUrl"],
      timestamp: data["timestamp"],
    );
  }
}
