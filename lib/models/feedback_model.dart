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
}
