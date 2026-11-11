import 'package:lmd_app/features/hotel/data/models/retail_listing_model.dart';

/// One server page of search results plus its pagination info.
class HotelSearchPage {
  final List<RetailListingModel> hotels;
  final int page;
  final int total;
  final bool hasMore;

  const HotelSearchPage({
    required this.hotels,
    required this.page,
    required this.total,
    required this.hasMore,
  });
}
