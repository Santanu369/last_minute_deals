// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lmd_app/models/retail_listing_model.dart';
// import 'package:lmd_app/services/hotel_service.dart';

// import 'hotel_state.dart';

// class HotelCubit extends Cubit<HotelState> {
//   final HotelService _hotelService;

//   HotelCubit(this._hotelService) : super(const HotelState());

//   Future<void> loadHotels() async {
//     try {
//       emit(state.copyWith(isLoading: true, error: null));

//       final response = await _hotelService.getHotels();

//       emit(
//         state.copyWith(
//           isLoading: false,
//           allListings: response.hotels,
//           visibleListings: response.hotels,
//         ),
//       );
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, error: e.toString()));
//     }
//   }

//   void changeCategory(String category) {
//     emit(
//       state.copyWith(
//         selectedCategory: category,
//         visibleListings: _applyFilters(
//           state.allListings,
//           category,
//           state.searchQuery,
//         ),
//       ),
//     );
//   }

//   void search(String query) {
//     emit(
//       state.copyWith(
//         searchQuery: query,
//         visibleListings: _applyFilters(
//           state.allListings,
//           state.selectedCategory,
//           query,
//         ),
//       ),
//     );
//   }

//   List<RetailListingModel> _applyFilters(
//     List<RetailListingModel> listings,
//     String category,
//     String query,
//   ) {
//     var filtered = listings;

//     if (category.toLowerCase() != 'all') {
//       filtered = filtered.where((listing) {
//         final cat = listing.category.toLowerCase().trim();

//         switch (category.toLowerCase()) {
//           case 'hotel':
//             return cat == 'hotel' || cat == 'hotels';

//           case 'resort':
//             return cat == 'resort' || cat == 'resorts';

//           case 'villa':
//             return cat == 'villa' || cat == 'villas';

//           default:
//             return true;
//         }
//       }).toList();
//     }

//     if (query.isNotEmpty) {
//       filtered = filtered.where((listing) {
//         return listing.name.toLowerCase().contains(query.toLowerCase());
//       }).toList();
//     }

//     return filtered;
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/hotel/data/models/retail_listing_model.dart';
import 'package:lmd_app/features/hotel/data/services/hotel_service.dart';

import 'package:lmd_app/features/hotel/presentation/cubit/hotel_state.dart';

class HotelCubit extends Cubit<HotelState> {
  final HotelService _hotelService;

  HotelCubit(this._hotelService)
      : super(const HotelState());

  // ============================================================
  // LOAD ALL LISTINGS
  // ============================================================

  Future<void>? _inFlight;
  bool _forceNext = false;
  DateTime? _loadedAt;
  static const _ttl = Duration(minutes: 5);

  /// Fetches all listings once; concurrent/repeat calls within [_ttl] reuse the
  /// result. Pass [force] (e.g. pull-to-refresh) to bypass the cache.
  Future<void> loadHotels({bool force = false}) {
    if (_inFlight != null) return _inFlight!;
    final fresh = _loadedAt != null &&
        DateTime.now().difference(_loadedAt!) < _ttl &&
        state.allListings.isNotEmpty;
    if (!force && fresh) return Future.value();
    _forceNext = force;
    return _inFlight = _fetchAll().whenComplete(() => _inFlight = null);
  }

  Future<void> _fetchAll() async {
    try {
      // Pull-to-refresh over existing content refreshes silently.
      if (state.allListings.isEmpty) {
        emit(state.copyWith(isLoading: true, error: null));
      }

      final listings =
          await _hotelService.getAllListings(force: _forceNext);

      emit(
        state.copyWith(
          isLoading: false,
          allListings: listings,
          visibleListings: listings,
          selectedCategory: 'all',
          searchQuery: '',
          error: null,
        ),
      );
      _loadedAt = DateTime.now();
    } catch (e) {
      // Keep showing the old data if a silent refresh fails.
      emit(
        state.copyWith(
          isLoading: false,
          error: state.allListings.isEmpty ? e.toString() : null,
        ),
      );
    }
  }

  // ============================================================
  // LOAD ONLY ONE KIND
  // ============================================================

  Future<void> loadByKind(String kind) async {
    try {
      emit(
        state.copyWith(
          isLoading: true,
          error: null,
        ),
      );

      final response =
          await _hotelService.getHotels(
        kind: kind,
      );

      final listings = response.hotels;

      emit(
        state.copyWith(
          isLoading: false,
          allListings: listings,
          visibleListings: listings,
          selectedCategory: kind,
          searchQuery: '',
          error: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString(),
        ),
      );
    }
  }

  // ============================================================
  // CATEGORY FILTER
  // ============================================================

  void changeCategory(String category) {
    final filtered = _applyFilters(
      state.allListings,
      category,
      state.searchQuery,
    );

    emit(
      state.copyWith(
        selectedCategory: category,
        visibleListings: filtered,
        error: null,
      ),
    );
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void search(String query) {
    final filtered = _applyFilters(
      state.allListings,
      state.selectedCategory,
      query,
    );

    emit(
      state.copyWith(
        searchQuery: query,
        visibleListings: filtered,
        error: null,
      ),
    );
  }

  // ============================================================
  // FILTER
  // ============================================================

  List<RetailListingModel> _applyFilters(
    List<RetailListingModel> listings,
    String category,
    String query,
  ) {
    var filtered =
        List<RetailListingModel>.from(listings);

    final selectedCategory =
        category.toLowerCase().trim();

    // ----------------------------------------------------------
    // KIND FILTER
    // ----------------------------------------------------------

    if (selectedCategory != 'all') {
      filtered = filtered.where((listing) {
        final kind =
            listing.kind.toLowerCase().trim();

        switch (selectedCategory) {
          case 'hotel':
          case 'hotels':
            return kind == 'hotel';

          case 'resort':
          case 'resorts':
            return kind == 'resort';

          case 'villa':
          case 'villas':
            return kind == 'villa';

          case 'camping':
          case 'camp':
            return kind == 'camping';

          case 'luxury-villa':
            return kind == 'luxury-villa';

          default:
            return true;
        }
      }).toList();
    }

    // ----------------------------------------------------------
    // SEARCH
    // ----------------------------------------------------------

    final searchText =
        query.toLowerCase().trim();

    if (searchText.isNotEmpty) {
      filtered = filtered.where((listing) {
        return listing.name
                .toLowerCase()
                .contains(searchText) ||
            listing.city
                .toLowerCase()
                .contains(searchText) ||
            listing.state
                .toLowerCase()
                .contains(searchText);
      }).toList();
    }

    return filtered;
  }

  // ============================================================
  // CLEAR SEARCH
  // ============================================================

  void clearSearch() {
    final filtered = _applyFilters(
      state.allListings,
      state.selectedCategory,
      '',
    );

    emit(
      state.copyWith(
        searchQuery: '',
        visibleListings: filtered,
      ),
    );
  }
}