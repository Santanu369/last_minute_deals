import 'package:lmd_app/core/utils/image_url.dart';
import 'package:lmd_app/features/hotel/data/models/google_review_model.dart';

class RetailListingModel {
  final String id;
  final String sku;
  final String slug;

  final String name;
  final String description;

  final String category;
  final String subcategory;
  final String kind;
  final String hotelSource;

  final int starRating;

  final String city;
  final String state;
  final String country;
  final String address;
  final String pincode;

  final List<String> images;

  final String variantId;

  final double basePrice;
  final double salePrice;
  final int discountPercentage;

  final bool isFeatured;
  final bool isPopular;

  final double rating;
  final double googleRating;
  final int googleReviewCount;
  final String googlePlaceId;
  final List<GoogleReviewModel> googleReviews;

  final String checkInTime;
  final String checkOutTime;

  final String vendorStoreId;
  final String vendorStoreName;
  final String mapUrl;
  final double? distance;

  // Filter data returned by POST /hotels/ratehawk/search (empty for partner listings).
  final List<String> serpFilters;
  final List<String> meals;
  final bool hasBreakfast;
  final bool freeCancellation;

  /// Vendor hides the price ("Price on request"); guest sends an enquiry instead of booking.
  final bool priceHidden;
  final String priceLabel;

  const RetailListingModel({
    required this.id,
    required this.sku,
    required this.slug,
    required this.name,
    required this.description,
    required this.category,
    required this.subcategory,
    required this.kind,
    this.hotelSource = 'partner',
    required this.starRating,
    required this.city,
    required this.state,
    required this.country,
    required this.address,
    required this.pincode,
    required this.images,
    required this.variantId,
    required this.basePrice,
    required this.salePrice,
    required this.discountPercentage,
    required this.isFeatured,
    required this.isPopular,
    required this.rating,
    required this.googleRating,
    required this.googleReviewCount,
    required this.googleReviews,
    required this.checkInTime,
    required this.checkOutTime,
    required this.vendorStoreId,
    required this.vendorStoreName,
    required this.mapUrl,
    required this.googlePlaceId,
    this.distance,
    this.serpFilters = const [],
    this.meals = const [],
    this.hasBreakfast = false,
    this.freeCancellation = false,
    this.priceHidden = false,
    this.priceLabel = 'Price on request',
  });

  factory RetailListingModel.fromJson(Map<String, dynamic> json) {
    final nestedHotel = (json['type_specific'] is Map)
        ? Map<String, dynamic>.from(json['type_specific']['hotel'] ?? {})
        : <String, dynamic>{};

    final nestedLocation = (nestedHotel['location'] is Map)
        ? Map<String, dynamic>.from(nestedHotel['location'])
        : <String, dynamic>{};

    final flatLocation = (json['location'] is Map)
        ? Map<String, dynamic>.from(json['location'])
        : <String, dynamic>{};

    final location = nestedLocation.isNotEmpty ? nestedLocation : flatLocation;

    final rawImages = (json['images'] is List)
        ? json['images'] as List<dynamic>
        : ((nestedHotel['images'] is List)
        ? nestedHotel['images'] as List<dynamic>
        : const <dynamic>[]);

    final imageUrl = ImageUrl.clean(json['image']);

    final images = <String>[];
    for (final image in rawImages) {
      final url = ImageUrl.clean(image);
      if (url.isNotEmpty) images.add(url);
    }
    if (imageUrl.isNotEmpty && !images.contains(imageUrl)) {
      images.insert(0, imageUrl);
    }

    final variants = (json['variants'] is List)
        ? json['variants'] as List<dynamic>
        : const <dynamic>[];
    final variant = variants.isNotEmpty
        ? Map<String, dynamic>.from(variants.first as Map)
        : <String, dynamic>{};

    final priceMap = (variant['price'] is Map)
        ? Map<String, dynamic>.from(variant['price'])
        : <String, dynamic>{};
    final directPriceMap = (json['price'] is Map)
        ? Map<String, dynamic>.from(json['price'])
        : <String, dynamic>{};

    final basePriceValue = (priceMap['base_price'] ??
        directPriceMap['base_price'] ??
        json['base_price'] ??
        json['price'] ??
        priceMap['value'] ??
        0);
    final salePriceValue = (priceMap['sale_price'] ??
        directPriceMap['sale_price'] ??
        json['sale_price'] ??
        json['price'] ??
        basePriceValue ??
        0);

    final discountValue = (priceMap['discount_percentage'] ??
        directPriceMap['discount_percentage'] ??
        json['discount_percentage'] ??
        0);

    final googleReviewsList = ((variant['google_reviews'] ?? json['google_reviews']) is List)
        ? ((variant['google_reviews'] ?? json['google_reviews']) as List<dynamic>)
        : const <dynamic>[];

    final googleReviews = googleReviewsList
        .map((e) => GoogleReviewModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    final categoryValue = (json['category'] is Map)
        ? (json['category']['name'] ?? '')
        : (json['category'] ?? '');

    final fallbackKind = (json['kind'] ?? nestedHotel['kind'] ?? 'hotel').toString();

    // Safe extraction with default fallback 'partner'
    final rawSource = json['hotel_source'] ?? json['source'] ?? json['hotelSource'];
    final sourceValue = (rawSource != null && rawSource.toString().trim().isNotEmpty)
        ? rawSource.toString()
        : 'partner';

    final enquiry = variant['enquiry_pricing'] ?? json['enquiry_pricing'];
    final enquiryOn = enquiry is Map && enquiry['enabled'] == true;
    final hidden = json['price_hidden'] == true || enquiryOn;
    final label = (json['price_label'] ?? (enquiry is Map ? enquiry['public_label'] : null))
        ?.toString()
        .trim();

    return RetailListingModel(
      priceHidden: hidden,
      priceLabel: (label == null || label.isEmpty) ? 'Price on request' : label,
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      sku: (json['sku'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      kind: fallbackKind,
      hotelSource: sourceValue,
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      category: categoryValue.toString(),
      subcategory: (json['subcategory'] is Map
          ? (json['subcategory']['name'] ?? '')
          : (json['subcategory'] ?? ''))
          .toString(),
      starRating: ((nestedHotel['star_rating'] ?? json['star_rating'] ?? 0) as num).toInt(),
      city: (location['city'] ?? json['city'] ?? '').toString(),
      state: (location['state'] ?? json['state'] ?? '').toString(),
      country: (location['country'] ?? json['country'] ?? '').toString(),
      address: (location['address'] ?? json['address'] ?? '').toString(),
      pincode: (location['pincode'] ?? json['pincode'] ?? '').toString(),
      images: images,
      variantId: (variant['_id'] ?? json['variant_id'] ?? '').toString(),
      basePrice: (basePriceValue is num ? basePriceValue : 0).toDouble(),
      salePrice: (salePriceValue is num ? salePriceValue : 0).toDouble(),
      discountPercentage: (discountValue is num ? discountValue : 0).toInt(),
      isFeatured: (json['is_featured'] ?? nestedHotel['is_featured'] ?? false) as bool,
      isPopular: (json['is_popular'] ?? nestedHotel['is_popular'] ?? false) as bool,
      rating: ((json['rating'] is Map)
          ? (json['rating']['average'] ?? 0)
          : (json['rating'] ?? 0))
          .toDouble(),
      googleRating: ((variant['google_rating'] ?? json['google_rating'] ?? 0) as num).toDouble(),
      googleReviewCount:
      ((variant['google_user_rating_count'] ?? json['google_user_rating_count'] ?? 0) as num)
          .toInt(),
      googlePlaceId: (variant['google_place_id'] ?? json['google_place_id'] ?? '').toString(),
      checkInTime: (nestedHotel['check_in_time'] ?? json['check_in_time'] ?? '').toString(),
      checkOutTime: (nestedHotel['check_out_time'] ?? json['check_out_time'] ?? '').toString(),
      vendorStoreId: ((json['vendor_store_id'] is Map)
          ? (json['vendor_store_id']['_id'] ?? '')
          : (json['vendor_store_id'] ?? ''))
          .toString(),
      vendorStoreName: ((json['vendor_store_id'] is Map)
          ? (json['vendor_store_id']['store_name'] ?? '')
          : '')
          .toString(),
      mapUrl: ((json['vendor_store_id'] is Map)
          ? (json['vendor_store_id']['store_url'] ?? json['store_url'] ?? '')
          : (json['store_url'] ?? ''))
          .toString(),
      googleReviews: googleReviews,
      distance: (location['distance'] ?? json['distance'] ?? null) is num
          ? (location['distance'] ?? json['distance']).toDouble()
          : null,
      serpFilters: _strings(json['serpFilters']),
      meals: _strings(json['meals']).isNotEmpty
          ? _strings(json['meals'])
          : _strings(json['meal']),
      hasBreakfast: json['hasBreakfast'] == true,
      freeCancellation: json['freeCancellation'] == true,
    );
  }

  static List<String> _strings(dynamic v) {
    if (v is List) return v.map((e) => e.toString()).toList();
    if (v is String && v.isNotEmpty) return [v];
    return const [];
  }

  /// Lower-cased text the filter sheet matches facility/meal/etc. options against.
  String get searchableText => [
        name,
        category,
        kind,
        subcategory,
        ...serpFilters,
        ...meals,
        if (hasBreakfast) 'breakfast included breakfast',
        if (freeCancellation) 'free cancellation',
      ].join(' ').toLowerCase();

  String get thumbnail => images.isNotEmpty ? images.first : '';

  bool get hasDiscount => salePrice > 0 && salePrice < basePrice;

  bool get hasGoogleRating => googleRating > 0;

  bool get hasUserRating => rating > 0;

  String get fullAddress =>
      [address, city, state, country].where((e) => e.isNotEmpty).join(', ');
}