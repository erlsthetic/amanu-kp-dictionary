class UserModel {
  final String uid;
  final String email;
  final int phoneNo;
  final bool isExpert;
  final String userName;
  final String? exFullName;
  final String? exBio;
  final String? cvUrl;
  final String? profileUrl;

  const UserModel(
      {required this.uid,
      required this.email,
      required this.phoneNo,
      required this.isExpert,
      required this.userName,
      this.exFullName,
      this.exBio,
      this.cvUrl,
      this.profileUrl});

  toJson() {
    return {
      "uid": uid,
      "email": email,
      "phoneNo": phoneNo,
      "isExpert": isExpert,
      "userName": userName,
      "exFullName": exFullName,
      "exBio": exBio,
      "cvUrl": cvUrl,
      "profileUrl": profileUrl,
    };
  }
}
