class GoogleReviewModel {
  final String author;
  final double rating;
  final String text;
  final String relativePublishTime;

  const GoogleReviewModel({
    required this.author,
    required this.rating,
    required this.text,
    required this.relativePublishTime,
  });

  factory GoogleReviewModel.fromJson(Map<String, dynamic> json) {
    final rawRating = json['rating'];

    return GoogleReviewModel(
      author: json['author']?.toString() ?? '',
      rating: rawRating is num ? rawRating.toDouble() : 0.0,
      text: json['text']?.toString() ?? '',
      relativePublishTime:
          json['relative_publish_time']?.toString() ?? '',
    );
  }
}