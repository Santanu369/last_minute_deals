class GuestReviewModel {
  final String id;

  final String guestName;

  final int rating;

  final String title;
  final String body;

  final DateTime? createdAt;

  const GuestReviewModel({
    required this.id,
    required this.guestName,
    required this.rating,
    required this.title,
    required this.body,
    required this.createdAt,
  });

  factory GuestReviewModel.fromJson(Map<String, dynamic> json) {
    return GuestReviewModel(
      id: json['id'] ?? '',
      guestName: json['guest_name'] ?? '',
      rating: json['rating'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
    );
  }
}
