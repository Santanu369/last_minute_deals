import 'dart:convert';

import 'package:lmd_app/features/hotel/data/models/retail_listing_model.dart';
import 'package:lmd_app/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:lmd_app/core/network/api_service.dart';
import 'package:lmd_app/features/hotel/data/services/hotel_service.dart';
import 'package:lmd_app/core/storage/secure_storage_service.dart';
import 'package:lmd_app/core/constants/api_constants.dart';

class WishlistService {
  final ApiService _apiService = ApiService();
  final SecureStorageService _storageService = SecureStorageService();
  final HotelService _hotelService = HotelService();

  Future<Map<String, String>> _authHeaders() async {
    final token = await _storageService.getAccessToken();
    if (token == null || token.isEmpty) {
      throw Exception('You are not logged in. Please log in to view your wishlist.');
    }
    return {'Authorization': 'Bearer $token'};
  }

  Future<List<WishlistItemModel>> getWishlist({int page = 1, int limit = 10}) async {
    final headers = await _authHeaders();

    final response = await _apiService.get(
      endpoint: '${ApiConstants.wishlist}?page=$page&limit=$limit',
      headers: headers,
    );

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Session expired. Please log in again.');
    }
    if (response.statusCode != 200) {
      throw Exception('Failed to load wishlist (${response.statusCode})');
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (e) {
      throw Exception('Unable to load wishlist right now. Please try again later.');
    }

    final rawItems = decoded['data']?['wishlist'] as List<dynamic>? ?? [];

    final items = rawItems
        .map((e) => WishlistItemModel.fromJson(e as Map<String, dynamic>))
        .toList();

    // ---- Enrichment: wishlist API doesn't send google_rating (and the
    // single-product endpoint doesn't have it either — only the home
    // listing endpoints do). So we fetch the same listings that power the
    // home page once, then merge rating/location into each wishlist item
    // by matching product id. Frontend-only fix, no backend change needed.
    return _enrichWithRatingAndLocation(items);
  }

  Future<List<WishlistItemModel>> _enrichWithRatingAndLocation(
      List<WishlistItemModel> items,
      ) async {
    final hasPartnerItems = items.any((i) => i.hotelSource == 'partner');
    if (!hasPartnerItems) return items;

    Map<String, RetailListingModel> listingsById = {};
    try {
      final allListings = await _hotelService.getAllListings();
      for (final listing in allListings) {
        if (listing.id.isNotEmpty) listingsById[listing.id] = listing;
      }
    } catch (_) {
      // If this fails, keep the wishlist working — just without enrichment.
      return items;
    }

    return items.map((item) {
      if (item.hotelSource != 'partner' || item.productId == null) return item;

      final listing = listingsById[item.productId];
      if (listing == null) return item;

      return item.copyWith(
        rating: listing.hasGoogleRating ? listing.googleRating : item.rating,
        reviewCount:
        listing.googleReviewCount > 0 ? listing.googleReviewCount : item.reviewCount,
        city: listing.city.isNotEmpty ? listing.city : item.city,
        state: listing.state.isNotEmpty ? listing.state : item.state,
      );
    }).toList();
  }

  /// One light request: is this hotel saved? (`GET /wishlist/check/:id`)
  Future<bool> isInWishlist({required String id, required String hotelSource}) async {
    final headers = await _authHeaders();
    final response = await _apiService.get(
      endpoint: ApiConstants.checkWishlist(id, hotelSource),
      headers: headers,
    );
    if (response.statusCode != 200) return false;
    final data = jsonDecode(response.body);
    return data is Map && data['data'] is Map && data['data']['isInWishlist'] == true;
  }

  Future<void> toggleWishlist({required String id, required String hotelSource}) async {
    final headers = await _authHeaders();

    final endpoint = '${ApiConstants.wishlist}/toggle/$id';

    final response = await _apiService.post(
      endpoint: endpoint,
      headers: headers,
      body: {'hotel_source': hotelSource},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to update wishlist');
    }
  }
}