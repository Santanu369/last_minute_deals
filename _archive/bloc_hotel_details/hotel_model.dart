import 'amenity_group_model.dart';

class HotelModel {
  final int hid;
  final String name;
  final String address;
  final String city;
  final String countryCode;
  final double latitude;
  final double longitude;

  final int starRating;

  final List<String> images;

  final String checkInTime;
  final String checkOutTime;

  final List<AmenityGroupModel> amenities;

  const HotelModel({
    required this.hid,
    required this.name,
    required this.address,
    required this.city,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.starRating,
    required this.images,
    required this.checkInTime,
    required this.checkOutTime,
    required this.amenities,
  });

  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      hid: json['hid'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: json['latitude'] ?? 0.0,
      longitude: json['longitude'] ?? 0.0,
      city: json['city'] ?? '',
      countryCode: json['countryCode'] ?? '',
      starRating: json['starRating'] ?? 0,
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      checkInTime: json['checkInTime'] ?? '',
      checkOutTime: json['checkOutTime'] ?? '',
      amenities: (json['amenities'] as List<dynamic>? ?? [])
          .map((e) => AmenityGroupModel.fromJson(e))
          .toList(),
    );
  }

  String get coverImage {
    if (images.isEmpty) return '';

    return images.first.replaceAll('{size}', '1024x768');
  }

  List<String> get imageUrls {
    return images.map((e) => e.replaceAll('{size}', '1024x768')).toList();
  }
}
