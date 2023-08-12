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
  final List<String>? contributions;

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
      this.contributions});

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
    };
  }
}
