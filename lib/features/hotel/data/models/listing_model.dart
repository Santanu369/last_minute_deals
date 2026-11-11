class ListingModel {
  final int hid;
  final String name;
  final String category;
  final String kind;
  final int starRating;
  final String city;
  final String countryCode;
  final String address;
  final List<String> images;
  final double price;
  final String currency;
  final String distance;

  const ListingModel({
    required this.hid,
    required this.name,
    this.category = 'Hotel',
    required this.kind,
    required this.starRating,
    required this.city,
    required this.countryCode,
    required this.address,
    required this.images,
    required this.price,
    required this.currency,
    required this.distance,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    final rawRating = json['starRating'] ?? json['google_rating'] ?? 0;
    final rawPrice =
        json['price'] ??
        json['min_price'] ??
        json['average_price'] ??
        json['rate'] ??
        0;

    return ListingModel(
      hid: json['hid'] ?? 0,
      name: json['name'] ?? '',
      category: json['category'] ?? 'Hotel',
      kind: json['kind'] ?? '',
      starRating: rawRating is num
          ? rawRating.toInt()
          : int.tryParse(rawRating.toString()) ?? 0,
      city: json['city'] ?? '',
      countryCode: json['countryCode'] ?? '',
      address: json['address'] ?? '',
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      price: rawPrice is num
          ? rawPrice.toDouble()
          : double.tryParse(rawPrice.toString()) ?? 0,
      currency: json['currency'] ?? '',
      distance: json['distance'] ?? json['distance_to_centre'] ?? '',
    );
  }
}
