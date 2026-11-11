class SearchGuestModel {
  final int adults;
  final List<int> children;

  const SearchGuestModel({required this.adults, required this.children});

  factory SearchGuestModel.fromJson(Map<String, dynamic> json) {
    return SearchGuestModel(
      adults: json['adults'] ?? 0,
      children: (json['children'] as List<dynamic>? ?? [])
          .map((e) => e as int)
          .toList(),
    );
  }

  int get totalGuests => adults + children.length;

  bool get hasChildren => children.isNotEmpty;
}
