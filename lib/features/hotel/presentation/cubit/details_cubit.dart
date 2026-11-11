import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/details_state.dart';
import 'package:lmd_app/features/hotel/data/services/hotel_service.dart';

// class DetailsCubit extends Cubit<DetailsState> {
//   DetailsCubit() : super(const DetailsState());

//   final ListingService _listingService = ListingService();

//   Future<void> loadHotelDetails({required HotelPageRequest request}) async {
//     try {
//       emit(state.copyWith(isLoading: true, error: null));

//       final hotelDetails = await _listingService.fetchHotelDetails(
//         request: request,
//       );

//       emit(state.copyWith(isLoading: false, hotel: hotelDetails));
//     } catch (e) {
//       emit(state.copyWith(isLoading: false, error: e.toString()));
//     }
//   }
// }

class DetailsCubit extends Cubit<DetailsState> {
  final HotelService _hotelService;

  DetailsCubit(this._hotelService) : super(const DetailsState());

  Future<void> loadHotelDetails({
    required String productId,
    String? source,
    double fallbackPrice = 0,
  }) async {
    try {
      // Refreshing already-loaded details keeps the page visible.
      if (state.hotel == null) emit(state.copyWith(isLoading: true, error: null));

      final hotel = await _hotelService.fetchHotelDetails(
        productId,
        source: source,
        fallbackPrice: fallbackPrice,
      );

      emit(state.copyWith(isLoading: false, hotel: hotel));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
