class PrebookRequest {
  final String bookHash;

  const PrebookRequest({required this.bookHash});

  Map<String, dynamic> toJson() => {'book_hash': bookHash};
}
