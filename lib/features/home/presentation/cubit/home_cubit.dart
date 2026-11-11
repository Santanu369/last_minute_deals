import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/home/presentation/cubit/home_state.dart';
import 'package:lmd_app/core/services/location_service.dart';

import 'package:lmd_app/features/hotel/data/services/listing_service.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  final ListingService _listingService = ListingService();
  // final LocationService _locationService = LocationService();
  final LocationService _locationService = LocationService.instance;
  // load the search listings based on the location of the user
  Future<void> loadSearchedListings({
    required double lat,
    required double lng,
  }) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final searchListings = await _listingService.searchListings(
        lat: lat,
        lng: lng,
      );

      emit(state.copyWith(isLoading: false, searchListings: searchListings));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  // load the public listings with live deals
  Future<void> loadListings() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final homelistings = await _listingService.getPublicListings(page: 1);

      emit(state.copyWith(isLoading: false, homelistings: homelistings.hotels));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  // Future<void> loadNearbyStaycations() async {
  //   try {
  //     emit(state.copyWith(isLoading: true, error: null));

  //     final nearbyListings = await _listingService.fetchNearbyStaycations(
  //       18.5204,
  //       73.8567,
  //     );

  //     emit(state.copyWith(isLoading: false, nearbyListings: nearbyListings));
  //   } catch (e) {
  //     emit(
  //       state.copyWith(
  //         isLoading: false,
  //         error: e.toString().replaceFirst('Exception: ', ''),
  //       ),
  //     );
  //   }
  // }

  Future<void> loadMostLovedListings() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final mostLovedListings = await _listingService
          .fetchMostLovedStayListings();

      emit(
        state.copyWith(
          isLoading: false,
          mostLovedStayListings: mostLovedListings,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  // Future<void> loadWeekendDeals() async {
  //   try {
  //     emit(state.copyWith(isLoading: true, error: null));

  //     final weekendListings = await _listingService.fetchWeekendDeals();

  //     emit(state.copyWith(isLoading: false, weekendDeals: weekendListings));
  //   } catch (e) {
  //     emit(
  //       state.copyWith(
  //         isLoading: false,
  //         error: e.toString().replaceFirst('Exception: ', ''),
  //       ),
  //     );
  //   }
  // }

  Future<void> loadStayAndSaveListings() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final stayAndSaveListings = await _listingService
          .fetchStayAndSaveListings();

      emit(
        state.copyWith(
          isLoading: false,
          stayAndSaveListings: stayAndSaveListings,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  Future<void> loadUserLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();

      if (position == null) return;

      final locationName = await _locationService.getLocationName(
        position.latitude,
        position.longitude,
      );

      emit(state.copyWith(currentLocation: locationName));

      await loadSearchedListings(
        lat: position.latitude,
        lng: position.longitude,
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString().replaceFirst('Exception: ', '')));
    }
  }
}
