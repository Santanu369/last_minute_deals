import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:lmd_app/features/hotel/data/models/hotel_filter_config.dart';
import 'package:lmd_app/features/hotel/data/models/hotel_response.dart';
import 'package:lmd_app/features/hotel/data/models/hotel_search/hotel_search_page.dart';
import 'package:lmd_app/features/hotel/data/models/hotel_search/search_hotels_request.dart';
import 'package:lmd_app/features/hotel/data/models/retail_listing_model.dart';
import 'package:lmd_app/features/hotel/data/models/retail_hotel_details_model.dart';
import 'package:lmd_app/core/constants/api_constants.dart';

// IMPORTANT: correct the import path for your ApiConstants file
import 'package:lmd_app/core/network/api_service.dart';

class HotelService {
  final ApiService _apiService = ApiService();

  // ============================================================
  // GET LISTINGS BY KIND
  // ============================================================

  Future<HotelResponse> getHotels({
    String kind = 'hotel',
  }) async {
    final response = await _apiService.get(
      endpoint: ApiConstants.finalListing,
      queryParameters: {
        'kind': kind,
      },
    );

    // Removed duplicate print lines and conflict markers
    debugPrint('Hotel listing [$kind]');

    if (response.statusCode != 200) {
      throw Exception('Failed to load $kind listings');
    }

    return HotelResponse.fromJson(await ApiService.decodeJson(response.body));
  }

  // ============================================================
  // GET ALL LISTING TYPES
  // ============================================================

  static Future<List<RetailListingModel>>? _allInFlight;
  static List<RetailListingModel>? _allCached;
  static DateTime? _allAt;
  static const _allTtl = Duration(minutes: 5);

  /// All kinds (5 parallel requests). Shared across callers (home, wishlist
  /// enrichment, ...): concurrent calls join one request and results are reused
  /// for [_allTtl] unless [force] is set.
  Future<List<RetailListingModel>> getAllListings({bool force = false}) {
    if (_allInFlight != null) return _allInFlight!;
    final fresh = _allCached != null &&
        _allAt != null &&
        DateTime.now().difference(_allAt!) < _allTtl;
    if (!force && fresh) return Future.value(_allCached);

    return _allInFlight = _fetchAllListings().then((list) {
      _allCached = list;
      _allAt = DateTime.now();
      return list;
    }).whenComplete(() => _allInFlight = null);
  }

  Future<List<RetailListingModel>> _fetchAllListings() async {
    // Parallel; one failing kind must not blank the whole home screen.
    Object? firstError;
    final responses = await Future.wait(
      ['hotel', 'resort', 'villa', 'luxury-villa', 'camping'].map(
        (kind) => getHotels(kind: kind).then<HotelResponse?>((r) => r).catchError(
          (Object e) {
            firstError ??= e;
            return null;
          },
        ),
      ),
    );

    // 'villa' may already include luxury villas: keep each listing once.
    final seen = <String>{};
    final listings = <RetailListingModel>[
      for (final r in responses)
        if (r != null)
          for (final h in r.hotels)
            if (h.id.isEmpty || seen.add(h.id)) h,
    ];
    if (listings.isEmpty && firstError != null) throw firstError!;
    return listings;
  }

  // ============================================================
  // HOTEL DETAILS
  // ============================================================

  Future<RetailHotelDetailsModel> fetchHotelDetails(
    String productId, {
    String? source,
    double fallbackPrice = 0,
  }) async {
    // Supplier hotels (RateHawk / Hotelbeds) have numeric ids and are not retail
    // products (/retail/products/<number> is a 400); partner ids are ObjectIds.
    final src = (source ?? '').toLowerCase();
    final isSupplier = (src.isNotEmpty && src != 'partner') ||
        RegExp(r'^\d+$').hasMatch(productId);
    if (isSupplier) {
      return _fetchSupplierDetails(productId, src, fallbackPrice);
    }

    final response = await _apiService.get(
      endpoint: ApiConstants.retailProduct(productId),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load hotel details');
    }

    try {
      return RetailHotelDetailsModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      // Backend HTML ya galat shape ka data bhej sakta hai
      // (jaise search-result wale hotels ke liye jo retail-products collection me nahi hain)
      throw Exception('Hotel details not available for this listing');
    }
  }

  Future<RetailHotelDetailsModel> _fetchSupplierDetails(
    String hid,
    String source,
    double price,
  ) async {
    // Numeric ids collide across suppliers, so try the known source first and
    // fall back to the other one.
    final sources = <String>{
      if (source == 'ratehawk' || source == 'hotelbeds') source,
      'ratehawk',
      'hotelbeds',
    };

    dynamic root;
    for (final s in sources) {
      final response = await _apiService.get(
        endpoint: ApiConstants.hotelStatic(s, hid),
      );
      if (response.statusCode == 200) {
        root = await ApiService.decodeJson(response.body);
        break;
      }
    }
    if (root == null) {
      throw Exception('Failed to load hotel details');
    }
    final hotel = (root is Map && root['data'] is Map)
        ? (root['data']['hotel'] as Map?)
        : null;
    if (hotel == null) {
      throw Exception('Hotel details not available for this listing');
    }

    final images = hotel['images'] is List ? hotel['images'] as List : const [];
    final name = (hotel['name'] ?? '').toString();

    // Adapt to the retail shape the details/booking screens consume. Live rates
    // need dates (hotelpage); until that flow exists, expose one room option
    // priced from the search result so the screen can render.
    return RetailHotelDetailsModel.fromJson({
      'data': {
        '_id': hid,
        'name': name,
        'description': hotel['description'] ?? '',
        'category': {'name': 'hotel'},
        'images': images,
        'price': {'base_price': price, 'sale_price': price},
        'type_specific': {
          'hotel': {
            'location': {
              'address': hotel['address'] ?? '',
              'country': hotel['country'] ?? '',
            },
            'amenities': hotel['amenities'] is List ? hotel['amenities'] : [],
            'star_rating': (hotel['starRating'] as num?)?.toInt() ?? 0,
          },
        },
        'variants': [
          {
            '_id': hid,
            'variant_name': 'Standard Room',
            'price': {'base_price': price, 'sale_price': price},
            'images': images,
          },
        ],
      },
    });
  }

  // ============================================================
  // SEARCH HOTELS  (POST /v1/hotels/ratehawk/search - same call as lmd-web)
  // ============================================================

  static const _usdToInr = 83.33; // same fixed rate lmd-web uses for filtering

  Future<HotelSearchPage> searchHotels(SearchHotelsRequest request) async {
    final response = await _apiService.post(
      endpoint: ApiConstants.Rsearch,
      body: request.toJson(),
    );

    final dynamic data = await ApiService.decodeJson(response.body);

    if (response.statusCode >= 400) {
      // 4xx carries a user-facing reason (e.g. stay too long): surface it.
      final msg = data is Map ? data['message']?.toString() : null;
      throw Exception(
        response.statusCode < 500 && msg != null ? msg : 'Search failed',
      );
    }

    final root = data as Map;
    final payload = root['data'] is Map ? root['data'] as Map : root;
    final rawResults = payload['results'];
    final results = rawResults is List ? rawResults : const [];
    final pagination = (payload['pagination'] ?? root['pagination']) as Map?;

    final hotels = [
      for (final item in results)
        if (item is Map) _mapSearchItem(Map<String, dynamic>.from(item)),
    ];

    return HotelSearchPage(
      hotels: hotels,
      page: (pagination?['page'] as num?)?.toInt() ?? request.page,
      total: (pagination?['total'] as num?)?.toInt() ?? hotels.length,
      hasMore: pagination != null
          ? pagination['hasMore'] == true
          : hotels.length >= request.limit,
    );
  }

  /// Search result -> the listing model the cards and filters already use.
  RetailListingModel _mapSearchItem(Map<String, dynamic> item) {
    num? n(dynamic v) => v is num ? v : num.tryParse('${v ?? ''}');

    final currency = (item['currency'] ?? 'INR').toString().toUpperCase();
    var price = n(item['lowestPrice'] ?? item['price'])?.toDouble() ?? 0;
    if (currency == 'USD') price *= _usdToInr;


    final free = item['freeCancellation'];

    return RetailListingModel.fromJson({
      'id': (item['hid'] ?? item['id'] ?? '').toString(),
      'name': item['hotelName'] ?? item['name'] ?? '',
      'image': item['image'],
      'price': price,
      'sale_price': price,
      'base_price': price,
      'city': item['city'] ?? '',
      'country': item['country'] ?? '',
      'address': item['address'] ?? '',
      'kind': item['kind'] ?? 'hotel',
      'star_rating': n(item['starRating']) ?? 0,
      'rating': n(item['rating']) ?? 0,
      'google_rating': 0,
      'hotelSource': item['hotelSource'] ?? 'ratehawk',
      'serpFilters': item['serpFilters'],
      'meals': item['meals'],
      'meal': item['meal'],
      'hasBreakfast': item['hasBreakfast'],
      'freeCancellation': free != null && free != false,
    });
  }

  // ============================================================
  // FILTER DEFINITIONS (GET /v1/hotels/ratehawk/filters)
  // ============================================================

  /// Filter groups + options (labels/counts) and sort options.
  /// [context] is 'listing' or 'search', like lmd-web.
  Future<HotelFilterConfig> getFilterConfig({
    String? kind,
    String context = 'search',
  }) async {
    final response = await _apiService.get(
      endpoint: ApiConstants.hotelFilters,
      queryParameters: {if (kind != null) 'kind': kind, 'context': context},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to load filters');
    }
    final data = (jsonDecode(response.body) as Map)['data'] as Map? ?? {};
    return HotelFilterConfig.fromJson(Map<String, dynamic>.from(data));
  }
}
