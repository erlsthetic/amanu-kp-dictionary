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
}
