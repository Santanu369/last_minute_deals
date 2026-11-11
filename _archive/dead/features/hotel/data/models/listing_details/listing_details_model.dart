import 'package:lmd_app/features/hotel/data/models/listing_details/guest_review_model.dart';
import 'package:lmd_app/features/hotel/data/models/listing_details/listing_image_model.dart';
import 'package:lmd_app/features/hotel/data/models/listing_details/room_type_model.dart';
import 'package:lmd_app/features/hotel/data/models/listing_details/stay_day_pricing_model.dart';
import 'package:lmd_app/features/hotel/data/models/listing_details/vendor_model.dart';

class ListingDetailsModel {
  final String id;
  final String type;
  final String title;
  final String description;
  final String address;
  final String category;

  final Map<String, dynamic>? tags;

  final double lat;
  final double lng;
  final String geohash;

  final double ratingAvg;
  final int ratingCount;
  final double starRating;

  final int priceAmount;
  final String priceCurrency;

  final List<String> amenities;
  final List<String> flags;

  final VendorModel vendor;

  final List<ListingImageModel> images;
  final List<ListingImageModel> menuImages;

  final int discountBps;
  final int minDealPrice;
  final String dealCurrency;

  final List<RoomTypeModel> stayRoomTypes;

  final StayDayPricingModel? stayDayPricing;

  final String? stayRules;

  final List<GuestReviewModel> guestReviews;

  const ListingDetailsModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.address,
    required this.category,
    required this.tags,
    required this.lat,
    required this.lng,
    required this.geohash,
    required this.ratingAvg,
    required this.ratingCount,
    required this.starRating,
    required this.priceAmount,
    required this.priceCurrency,
    required this.amenities,
    required this.flags,
    required this.vendor,
    required this.images,
    required this.menuImages,
    required this.discountBps,
    required this.minDealPrice,
    required this.dealCurrency,
    required this.stayRoomTypes,
    required this.stayDayPricing,
    required this.stayRules,
    required this.guestReviews,
  });

  factory ListingDetailsModel.fromJson(Map<String, dynamic> json) {
    return ListingDetailsModel(
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      category: json['category'] ?? '',

      tags: json['tags'],

      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      geohash: json['geohash'] ?? '',
      ratingCount: (json['rating_count'] ?? 0).toInt(),

      priceAmount: (json['price_amount'] ?? 0).toInt(),

      discountBps: (json['discount_bps'] ?? 0).toInt(),

      minDealPrice: (json['min_deal_price'] ?? 0).toInt(),

      ratingAvg: (json['rating_avg'] ?? 0).toDouble(),
      // ratingCount: json['rating_count'] ?? 0,
      starRating: (json['star_rating'] ?? 0).toDouble(),

      // priceAmount: json['price_amount'] ?? 0,
      priceCurrency: json['price_currency'] ?? '',

      amenities: List<String>.from(json['amenities'] ?? []),
      flags: List<String>.from(json['flags'] ?? []),

      vendor: VendorModel.fromJson(json['vendor'] ?? {}),

      images: (json['images'] as List? ?? [])
          .map((e) => ListingImageModel.fromJson(e))
          .toList(),

      menuImages: (json['menu_images'] as List? ?? [])
          .map((e) => ListingImageModel.fromJson(e))
          .toList(),

      // discountBps: json['discount_bps'] ?? 0,
      // minDealPrice: json['min_deal_price'] ?? 0,
      dealCurrency: json['deal_currency'] ?? '',

      stayRoomTypes: (json['stay_room_types'] as List? ?? [])
          .map((e) => RoomTypeModel.fromJson(e))
          .toList(),
      // stayRoomTypes: [],
      stayDayPricing: json['stay_day_pricing'] != null
          ? StayDayPricingModel.fromJson(json['stay_day_pricing'])
          : null,

      stayRules: json['stay_rules'],

      guestReviews: (json['guest_reviews'] as List? ?? [])
          .map((e) => GuestReviewModel.fromJson(e))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'ListingDetailsModel(id: $id, type: $type, title: $title, description: $description, address: $address, category: $category, tags: $tags, lat: $lat, lng: $lng, geohash: $geohash, ratingAvg: $ratingAvg, ratingCount: $ratingCount, starRating: $starRating, priceAmount: $priceAmount, priceCurrency: $priceCurrency, amenities: $amenities, flags: $flags, vendor: $vendor, images: $images, menuImages: $menuImages, discountBps: $discountBps, minDealPrice: $minDealPrice, dealCurrency: $dealCurrency, stayRoomTypes: $stayRoomTypes, stayDayPricing: $stayDayPricing, stayRules: $stayRules, guestReviews: $guestReviews)';
  }
}
