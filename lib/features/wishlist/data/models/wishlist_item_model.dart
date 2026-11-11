class WishlistItemModel {
  final String hotelSource; // "partner" or "ratehawk"
  final String? hid; // for ratehawk
  final String? productId; // partner mongo _id (from product_id._id)
  final String name;
  final String image;
  final String city;
  final String state;
  final double price;
  final double? rating; // google_rating — null if not available
  final int? reviewCount; // google_user_rating_count — null if not available

  const WishlistItemModel({
    required this.hotelSource,
    this.hid,
    this.productId,
    required this.name,
    required this.image,
    required this.city,
    required this.state,
    required this.price,
    this.rating,
    this.reviewCount,
  });

  /// "Pune, Maharashtra" style combined location string.
  /// Falls back gracefully if either piece is missing.
  String get location {
    if (city.isNotEmpty && state.isNotEmpty) return '$city, $state';
    if (city.isNotEmpty) return city;
    if (state.isNotEmpty) return state;
    return '';
  }

  factory WishlistItemModel.fromJson(Map<String, dynamic> json) {
    final hotelSource = json['hotel_source'] ?? 'partner';

    if (hotelSource == 'ratehawk') {
      final ratingRaw = json['google_rating'];
      final reviewCountRaw = json['google_user_rating_count'];

      return WishlistItemModel(
        hotelSource: hotelSource,
        hid: json['hid']?.toString() ?? '',
        productId: null,
        name: '', // RateHawk detail abhi available nahi, hotelpage API se aayega
        image: '',
        city: '',
        state: '',
        price: 0,
        rating: ratingRaw != null ? double.tryParse(ratingRaw.toString()) : null,
        reviewCount:
        reviewCountRaw != null ? int.tryParse(reviewCountRaw.toString()) : null,
      );
    }

    // Partner item — product_id ke andar populated data hota hai
    final product = json['product_id'] as Map<String, dynamic>? ?? {};

    final images = (product['images'] as List<dynamic>? ?? [])
        .map((e) => e['url']?.toString() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();

    final variants = product['variants'] as List? ?? [];
    final variant = variants.isNotEmpty
        ? variants.first as Map<String, dynamic>
        : <String, dynamic>{};
    final price = variant['price'] ?? {};

    final hotel = product['type_specific']?['hotel'] ?? {};
    final location = hotel['location'] ?? {};

    // Wishlist API abhi ye fields nahi bhejta — enrichment step
    // (WishlistService) inhe baad mein fetchHotelDetails() se merge karega.
    final ratingRaw = variant['google_rating'];
    final reviewCountRaw = variant['google_user_rating_count'];

    return WishlistItemModel(
      hotelSource: hotelSource,
      hid: null,
      productId: product['_id'] ?? '',
      name: product['name'] ?? '',
      image: images.isNotEmpty ? images.first : '',
      city: location['city'] ?? '',
      state: location['state'] ?? '',
      price: (price['sale_price'] ?? price['base_price'] ?? 0).toDouble(),
      rating: ratingRaw != null ? double.tryParse(ratingRaw.toString()) : null,
      reviewCount:
      reviewCountRaw != null ? int.tryParse(reviewCountRaw.toString()) : null,
    );
  }

  /// Returns a copy with the given fields overridden — used by
  /// WishlistService to merge in rating/location fetched separately
  /// from the single-product details endpoint.
  WishlistItemModel copyWith({
    String? name,
    String? image,
    String? city,
    String? state,
    double? price,
    double? rating,
    int? reviewCount,
  }) {
    return WishlistItemModel(
      hotelSource: hotelSource,
      hid: hid,
      productId: productId,
      name: name ?? this.name,
      image: image ?? this.image,
      city: city ?? this.city,
      state: state ?? this.state,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }

  // Toggle/remove API ke liye jo id chahiye — RateHawk ke liye hid, Partner ke liye productId
  String get id => hotelSource == 'ratehawk' ? (hid ?? '') : (productId ?? '');
}