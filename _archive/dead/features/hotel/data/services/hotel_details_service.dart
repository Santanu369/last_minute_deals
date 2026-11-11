import 'dart:convert';

import 'package:lmd_app/features/hotel/data/models/hotel_details/hotel_details_model.dart';

import 'package:lmd_app/core/network/api_service.dart';

class HotelDetailsService {

  final ApiService _api = ApiService();

  Future<HotelDetailsModel> getHotelDetails(
      int hid) async {

    final response = await _api.get(
      endpoint:
          '/v1/hotels/ratehawk/details/$hid',
    );

    if (response.statusCode == 200) {

      final json = jsonDecode(response.body);

      return HotelDetailsModel.fromJson(
        json['data'],
      );
    }

    throw Exception('Failed to load hotel');
  }
}