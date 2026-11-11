import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:lmd_app/features/hotel/data/models/hotel_details/hotel_details_model.dart';
import 'package:lmd_app/features/hotel/data/models/hotel_details/hotel_page_request.dart';
import 'package:lmd_app/core/models/paginated_response.dart';
import 'package:lmd_app/core/constants/api_constants.dart';

import 'package:lmd_app/features/hotel/data/models/listing_model.dart';

import 'package:lmd_app/core/network/api_service.dart';

class ListingService {
  final ApiService _apiService = ApiService();

  Future<List<ListingModel>> searchListings({
    required double lat,
    required double lng,
  }) async {
    final response = await _apiService.get(
      endpoint:
          '${ApiConstants.searchListings}'
          '?lat=$lat&lng=$lng&radius_km=50&limit=50',
    );

    final data = jsonDecode(response.body);
    final items = data['items'] as List<dynamic>;
    debugPrint('search items $items');
    return items.map((e) => ListingModel.fromJson(e)).toList();
  }

  // Future<List<ListingModel>> getPublicListings() async {
  //   final response = await _apiService.get(
  //     endpoint:
  //         '/v1/public/listings'
  //         '?page=1'
  //         '&page_size=20'
  //         '&sort=newest'
  //         '&has_live_deal=true',
  //   );

  //   final data = jsonDecode(response.body);
  //   debugPrint('public listings data $data');

  //   final items = data['items'] as List<dynamic>;

  //   return items.map((e) => ListingModel.fromJson(e)).toList();
  // }

  Future<List<ListingModel>> getComprehensiveHotels() async {
    final response = await _apiService.get(
      endpoint: ApiConstants.comprehensiveHome,
      queryParameters: {'type': 'HOTELS'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load hotels');
    }

    final data = jsonDecode(response.body);

    final products = data['data']['allProducts'] as List;

    return products.map((e) => ListingModel.fromJson(e)).toList();
  }

  Future<PaginatedResponse<ListingModel>> getPublicListings({
    required int page,
  }) async {
    final response = await _apiService.get(
      endpoint:
          '${ApiConstants.listings}'
          '?page=$page'
          '&page_size=20'
          '&sort=newest'
          '&has_live_deal=true',
    );

    final data = jsonDecode(response.body);

    return PaginatedResponse(
      page: data['page'],
      count: data['count'],
      // pageSize: data['page_size'],
      // hasMore: data['has_more'],
      hotels: (data['items'] as List)
          .map((e) => ListingModel.fromJson(e))
          .toList(),
    );
  }

  // Future<PaginatedResponse<ListingModel>> getHotelListings({
  //   required int page,
  // }) async {
  //   final response = await _apiService.get(
  //     endpoint:
  //         '${ApiConstants.listings}'
  //         '?page=$page'
  //         '&page_size=20'
  //         '&type=STAY'
  //         '&has_live_deal=true',
  //   );

  //   final data = jsonDecode(response.body);
  //   debugPrint('hotel listings with pagination data $data');

  //   return PaginatedResponse(
  //          page: data['page'],
  //     count: data['count'],
  //     // pageSize: data['page_size'],
  //     // hasMore: data['has_more'],
  //     hotels: (data['items'] as List)
  //         .map((e) => ListingModel.fromJson(e))
  //         .toList(),
  //   );
  // }
  Future<PaginatedResponse<ListingModel>> getHotelListings({
    required double lat,
    required double lng,
    required int page,
    int limit = 20,
    int? starRating,
  }) async {
    var endpoint =
        '${ApiConstants.hotelListings}'
        '?lat=$lat'
        '&lng=$lng'
        '&page=$page'
        '&limit=$limit';

    if (starRating != null) {
      endpoint += '&starRating=$starRating';
    }

    final response = await _apiService.get(endpoint: endpoint);

    if (response.statusCode != 200) {
      throw Exception('Failed to load hotel listings');
    }

    final data = jsonDecode(response.body);

    debugPrint('hotel listings with pagination data $data');

    return PaginatedResponse<ListingModel>(
      page: data['page'] ?? 1,
      count: data['count'] ?? 0,
      hotels: (data['hotels'] as List<dynamic>)
          .map((e) => ListingModel.fromJson(e))
          .toList(),
    );
  }

  // get BUFFET listings
  Future<PaginatedResponse<ListingModel>> getBuffetListings({
    required int page,
  }) async {
    final response = await _apiService.get(
      endpoint:
          '${ApiConstants.listings}'
          '?page=$page'
          '&page_size=20'
          '&type=BUFFET'
          '&has_live_deal=true',
    );

    final data = jsonDecode(response.body);
    debugPrint('buffet listings with pagination data $data');

    return PaginatedResponse(
      page: data['page'],
      count: data['count'],
      // pageSize: data['page_size'],
      // hasMore: data['has_more'],
      hotels: (data['items'] as List)
          .map((e) => ListingModel.fromJson(e))
          .toList(),
    );
  }

  // Future<List<DealModel>> fetchDeals(String listingId) async {
  //   final response = await _apiService.get(
  //     endpoint: '/v1/public/deals?listing_id=$listingId',
  //   );

  //   if (response.statusCode == 200) {
  //     final List<dynamic> data = jsonDecode(response.body);

  //     return data.map((e) => DealModel.fromJson(e)).toList();
  //   }

  //   throw Exception('Failed to fetch deals: ${response.body}');
  // }

  // Future<List<ListingModel>> fetchWeekendDeals() async {
  //   final response = await _apiService.get(
  //     endpoint:
  //         '${ApiConstants.listings}'
  //         '?page=1'
  //         '&page_size=4'
  //         '&type=STAY'
  //         '&has_live_deal=true',
  //   );

  //   final data = jsonDecode(response.body);
  //   // debugPrint('live deals data $data');

  //   final items = data['items'] as List<dynamic>;

  //   return items.map((e) => ListingModel.fromJson(e)).toList();
  // }

  // Future<List<ListingModel>> fetchNearbyStaycations(
  //   final double lat,
  //   final double lng,
  // ) async {
  //   final response = await _apiService.get(
  //     endpoint:
  //         '${ApiConstants.listings}'
  //         '?page=1'
  //         '&page_size=2'
  //         '&lat=$lat&lng=$lng'
  //         '&type=STAY'
  //         '&sort=distance'
  //         '&has_live_deal=true',
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);

  //     final List items = data["items"];

  //     return items.map((item) => ListingModel.fromJson(item)).toList();
  //   } else {
  //     throw Exception("Failed to load staycations");
  //   }
  // }

  Future<List<ListingModel>> fetchMostLovedStayListings() async {
    final response = await _apiService.get(
      endpoint:
          '${ApiConstants.listings}'
          '?page=1'
          '&page_size=4'
          '&sort=rating'
          '&type=STAY'
          '&has_live_deal=true',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List items = data['items'];

      return items.map((item) => ListingModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load most loved listings');
    }
  }

  Future<List<ListingModel>> fetchStayAndSaveListings() async {
    final response = await _apiService.get(
      endpoint:
          '${ApiConstants.listings}'
          '?page=1'
          '&page_size=4'
          '&type=STAY'
          '&sort=price_asc'
          '&has_live_deal=true',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final List items = data['items'];

      return items.map((item) => ListingModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load stay and save listings');
    }
  }

  /// For the details page, we will fetch the details of the listing using the id and then navigate to the details page with the details data.

  Future<HotelDetailsModel> fetchHotelDetails({
    required HotelPageRequest request,
  }) async {
    final response = await _apiService.post(
      endpoint: ApiConstants.hotelPage,
      body: {
        'hid': request.hid,
        'checkin': request.checkIn.toIso8601String().split('T').first,
        'checkout': request.checkOut.toIso8601String().split('T').first,
        'residency': request.residency,
        'rooms': request.rooms,
        'adults': request.adults,
        'children': request.children,
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load hotel details: ${response.statusCode}\n${response.body}',
      );
    }

    final data = jsonDecode(response.body);

    return HotelDetailsModel.fromJson(data);
  }
}
