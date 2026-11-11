import 'package:lmd_app/features/hotel/data/models/listing_model.dart';

class HomeState {
  final bool isLoading;

  final List<ListingModel> homelistings;

  final List<ListingModel> nearbyListings;

  final List<ListingModel> searchListings;

  final List<ListingModel> stayAndSaveListings;

  final List<ListingModel> mostLovedStayListings;

  final List<ListingModel> weekendDeals;

  final String? currentLocation;

  final String? error;

  const HomeState({
    this.isLoading = false,
    this.homelistings = const [],
    this.nearbyListings = const [],
    this.searchListings = const [],
    this.stayAndSaveListings = const [],
    this.mostLovedStayListings = const [],
    this.weekendDeals = const [],
    this.currentLocation,
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    List<ListingModel>? homelistings,
    List<ListingModel>? nearbyListings,
    List<ListingModel>? searchListings,
    List<ListingModel>? stayAndSaveListings,
    List<ListingModel>? mostLovedStayListings,
    List<ListingModel>? weekendDeals,
    String? currentLocation,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,

      homelistings: homelistings ?? this.homelistings,

      nearbyListings: nearbyListings ?? this.nearbyListings,

      searchListings: searchListings ?? this.searchListings,

      stayAndSaveListings: stayAndSaveListings ?? this.stayAndSaveListings,

      weekendDeals: weekendDeals ?? this.weekendDeals,

      mostLovedStayListings:
          mostLovedStayListings ?? this.mostLovedStayListings,

      currentLocation: currentLocation ?? this.currentLocation,

      error: error,
    );
  }
}
