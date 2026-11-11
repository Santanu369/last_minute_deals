import 'package:lmd_app/features/hotel/data/models/retail_listing_model.dart';

class HotelState {
  final List<RetailListingModel> allListings;
  final List<RetailListingModel> visibleListings;

  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;

  final int page;

  final String selectedCategory;
  final String searchQuery;

  final String? error;

  const HotelState({
    this.allListings = const [],
    this.visibleListings = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.page = 1,
    this.selectedCategory = 'all',
    this.searchQuery = '',
    this.error,
  });

  /// Today's Hotel Deals
  ///
  /// Current API doesn't provide discount information,
  /// so filter only by hotel kind.
  List<RetailListingModel> get todayDeals => _ofKind('hotel');

  /// Instant Approval Stays
  ///
  /// Current API doesn't provide instant_approval information.
  /// Temporary fallback: hotel listings.
  List<RetailListingModel> get instantApprovalStays => _ofKind('hotel');

  /// Popular Resorts
  ///
  /// Current API doesn't provide is_popular.
  /// Filter by resort kind.
  List<RetailListingModel> get popularResorts => _ofKind('resort');

  /// Popular Hotels
  List<RetailListingModel> get popularHotels => _ofKind('hotel');

  /// Villas
  List<RetailListingModel> get villas => _ofKind('villa');

  /// Camping
  List<RetailListingModel> get camping => _ofKind('camping');

  // Derived lists are memoised per (immutable) state instance, not rebuilt on
  // every access. Expando keeps the const constructor intact.
  static final Expando<Map<String, List<RetailListingModel>>> _memo = Expando();

  List<RetailListingModel> _ofKind(String kind) {
    final m = _memo[this] ??= {};
    return m[kind] ??= allListings
        .where((l) => l.kind.toLowerCase() == kind)
        .toList(growable: false);
  }

  HotelState copyWith({
    List<RetailListingModel>? allListings,
    List<RetailListingModel>? visibleListings,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
    String? selectedCategory,
    String? searchQuery,
    String? error,
  }) {
    return HotelState(
      allListings: allListings ?? this.allListings,
      visibleListings: visibleListings ?? this.visibleListings,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      error: error,
    );
  }
}