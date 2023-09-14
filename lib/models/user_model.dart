import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final int phoneNo;
  final bool isExpert;
  final bool expertRequest;
  final String userName;
  final String? exFullName;
  final String? exBio;
  final String? cvUrl;
  final String? profileUrl;
  final List<dynamic>? contributions;
  final bool emailPublic;
  final bool phonePublic;
  final bool isAdmin;

  const UserModel(
      {required this.uid,
      required this.email,
      required this.phoneNo,
      required this.isExpert,
      required this.expertRequest,
      required this.userName,
      this.exFullName,
      this.exBio,
      this.cvUrl,
      this.profileUrl,
      this.contributions,
      this.emailPublic = false,
      this.phonePublic = false,
      this.isAdmin = false});

  toJson() {
    return {
      "uid": uid,
      "email": email,
      "phoneNo": phoneNo,
      "expertRequest": expertRequest,
      "isExpert": isExpert,
      "userName": userName,
      "exFullName": exFullName,
      "exBio": exBio,
      "cvUrl": cvUrl,
      "profileUrl": profileUrl,
      "contributions": contributions,
      "emailPublic": emailPublic,
      "phonePublic": phonePublic,
      "isAdmin": isAdmin,
    };
  }

  factory UserModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        uid: data["uid"],
        email: data["email"],
        phoneNo: data["phoneNo"],
        isExpert: data["isExpert"],
        expertRequest: data["expertRequest"],
        userName: data["userName"],
        exFullName: data["exFullName"],
        exBio: data["exBio"],
        cvUrl: data["cvUrl"],
        profileUrl: data["profileUrl"],
        contributions: data["contributions"],
        emailPublic: data["emailPublic"],
        phonePublic: data["phonePublic"],
        isAdmin: data["isAdmin"]);
  }
}
