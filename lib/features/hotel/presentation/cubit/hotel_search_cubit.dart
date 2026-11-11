import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lmd_app/features/hotel/data/models/hotel_search/search_hotels_request.dart';
import 'package:lmd_app/features/hotel/data/services/hotel_service.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/hotel_search_state.dart';

class HotelSearchCubit extends Cubit<HotelSearchState> {
  HotelSearchCubit(this._hotelService) : super(const HotelSearchState());

  final HotelService _hotelService;
  SearchHotelsRequest? _request; // criteria of the active search, for paging

  Future<void> searchHotels(SearchHotelsRequest request) async {
    _request = request.copyWith(page: 1);
    emit(const HotelSearchState(isLoading: true));

    try {
      final page = await _hotelService.searchHotels(_request!);
      emit(
        HotelSearchState(
          isSuccess: true,
          results: page.hotels,
          page: page.page,
          total: page.total,
          hasMore: page.hasMore,
        ),
      );
    } catch (e) {
      emit(
        HotelSearchState(
          isSuccess: false,
          errorMessage: e.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }

  /// Next server page of the active search, appended (deduped by id).
  Future<void> loadMore() async {
    final req = _request;
    if (req == null || state.isLoading || state.isLoadingMore || !state.hasMore) {
      return;
    }
    emit(state.copyWith(isLoadingMore: true));
    try {
      final page =
          await _hotelService.searchHotels(req.copyWith(page: state.page + 1));
      final seen = state.results.map((h) => h.id).toSet();
      emit(
        state.copyWith(
          isLoadingMore: false,
          results: [
            ...state.results,
            ...page.hotels.where((h) => seen.add(h.id)),
          ],
          page: page.page,
          total: page.total,
          hasMore: page.hasMore,
        ),
      );
    } catch (_) {
      // Keep what we have; the user can tap Load more again.
      emit(state.copyWith(isLoadingMore: false));
    }
  }

  void clearSearch() {
    _request = null;
    emit(const HotelSearchState());
  }
}
