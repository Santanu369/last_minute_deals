import 'dart:convert';

import 'package:lmd_app/features/hotel/data/models/listing_model.dart';
import 'package:lmd_app/core/network/api_service.dart';
import 'package:lmd_app/core/constants/api_constants.dart';

class HotelListingService {
  final ApiService _apiService = ApiService();

  /// Fetch general hotel listings
  Future<List<ListingModel>> getHotels() async {
    final response = await _apiService.get(
      endpoint: ApiConstants.hotelListings,
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      final List<dynamic> data = json is Map<String, dynamic>
          ? (json['hotels'] as List<dynamic>? ??
                json['data'] as List<dynamic>? ??
                const [])
          : (json as List<dynamic>);

      return data.map((e) => ListingModel.fromJson(e)).toList();
    }

    throw Exception('Failed to load hotels: ${response.statusCode}');
  }
}
