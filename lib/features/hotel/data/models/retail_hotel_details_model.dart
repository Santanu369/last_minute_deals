import 'package:lmd_app/core/utils/image_url.dart';

List<String> _safeImageList(dynamic value) {
  if (value is! List) return const [];

  // Detail galleries use the large size, like lmd-web.
  return value
      .map((e) => ImageUrl.clean(e, size: ImageUrl.full))
      .where((item) => item.isNotEmpty)
      .toList();
}

class RetailHotelDetailsModel {
  final String id;
  final String name;
  final String description;

  final String category;
  final String city;
  final String state;
  final String country;
  final String address;

  final List<String> images;
  final List<String> amenities;

  final double basePrice;
  final double salePrice;
  final int discountPercentage;

  final int starRating;
  final bool petFriendly;
  final bool smokingAllowed;

  final String checkInTime;
  final String checkOutTime;

  final List<RetailVariant> variants;

  const RetailHotelDetailsModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.city,
    required this.state,
    required this.country,
    required this.address,
    required this.images,
    required this.amenities,
    required this.basePrice,
    required this.salePrice,
    required this.discountPercentage,
    required this.starRating,
    required this.petFriendly,
    required this.smokingAllowed,
    required this.checkInTime,
    required this.checkOutTime,
    required this.variants,
  });

  factory RetailHotelDetailsModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    final hotel = data['type_specific']?['hotel'] ?? {};
    final location = hotel['location'] ?? {};
    final price = data['price'] ?? {};

    return RetailHotelDetailsModel(
      id: data['_id'] ?? '',
      name: data['name'] ?? '',
      description: data['description'] ?? '',

      category: data['category']?['name'] ?? '',

      city: location['city'] ?? '',
      state: location['state'] ?? '',
      country: location['country'] ?? '',
      address: location['address'] ?? '',

      images: _safeImageList(data['images']),

      amenities: (hotel['amenities'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),

      basePrice: (price['base_price'] ?? 0).toDouble(),

      salePrice: (price['sale_price'] ?? 0).toDouble(),

      discountPercentage: price['discount_percentage'] ?? 0,

      starRating: hotel['star_rating'] ?? 0,

      petFriendly: hotel['pet_friendly'] ?? false,

      smokingAllowed: hotel['smoking_allowed'] ?? false,

      checkInTime: hotel['check_in_time'] ?? '',

      checkOutTime: hotel['check_out_time'] ?? '',

      variants: (data['variants'] as List? ?? [])
          .map((e) => RetailVariant.fromJson(e))
          .toList(),
    );
  }
  RetailVariant get defaultVariant => variants.first;

  String get location => '$address, $city, $state, $country';
}

class RetailVariant {
  final String id;
  final String name;

  final double basePrice;
  final double salePrice;
  final int discountPercentage;

  final String roomType;
  final String bedType;
  final int maxOccupancy;
  final int areaSqFt;

  final List<String> images;

  final bool enquiryOnly;
  final String enquiryLabel;

  const RetailVariant({
    required this.id,
    required this.name,
    required this.basePrice,
    required this.salePrice,
    required this.discountPercentage,
    required this.roomType,
    required this.bedType,
    required this.maxOccupancy,
    required this.images,
    required this.areaSqFt,
    this.enquiryOnly = false,
    this.enquiryLabel = 'Price on request',
  });

  factory RetailVariant.fromJson(Map<String, dynamic> json) {
    final price = json['price'] ?? {};
    final hotel = json['type_specific']?['hotel'] ?? {};

    final ep = json['enquiry_pricing'];
    final on = ep is Map && ep['enabled'] == true;
    final label = on ? (ep['public_label'] ?? '').toString().trim() : '';

    return RetailVariant(
      enquiryOnly: on,
      enquiryLabel: label.isEmpty ? 'Price on request' : label,
      id: json['_id'] ?? '',

      name: json['variant_name'] ?? '',

      basePrice: (price['base_price'] ?? 0).toDouble(),

      salePrice: (price['sale_price'] ?? 0).toDouble(),

      discountPercentage: (price['discount_percentage'] ?? 0).toInt(),

      roomType: hotel['room_type'] ?? '',

      bedType: hotel['bed_type'] ?? '',

      maxOccupancy: hotel['max_occupancy'] ?? 0,

      images: _safeImageList(json['images']),

      areaSqFt: (hotel['area_sq_ft'] ?? 0).toInt(),
    );
  }
}
