import 'package:lmd_app/features/hotel/data/models/retail_listing_model.dart';

class HotelResponse {
  final List<String> categories;
  final List<RetailListingModel> hotels;

  const HotelResponse({required this.categories, required this.hotels});

  factory HotelResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map ? json['data'] as Map<String, dynamic> : {};
    final hotelList = (json['hotels'] as List<dynamic>? ??
        data['allProducts'] as List<dynamic>? ??
        const <dynamic>[]);

    return HotelResponse(
      categories: ((json['categories'] as List<dynamic>? ??
                  data['categories'] as List<dynamic>? ??
                  const <dynamic>[]))
          .map((e) => e is Map ? (e['name'] ?? '').toString() : e.toString())
          .where((e) => e.isNotEmpty)
          .toList(),
      hotels: hotelList
          .map((e) => RetailListingModel.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
    );
  }
}
