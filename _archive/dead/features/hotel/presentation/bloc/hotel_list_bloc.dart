import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/hotel/presentation/bloc/hotel_event.dart' show HotelEvent, LoadHotels;
import 'package:lmd_app/features/hotel/presentation/bloc/hotellist_state.dart';
import 'package:lmd_app/features/hotel/data/services/hotel_listing_service.dart';

class hotelListActivityBloc
    extends Bloc<HotelEvent, hotelListActivityState> {

  final HotelListingService service;

  hotelListActivityBloc(this.service)
      : super(const hotelListActivityState()) {

    on<LoadHotels>(_loadActivities);
  }

  Future<void> _loadActivities(
      LoadHotels event,
      Emitter<hotelListActivityState> emit) async {

    emit(state.copyWith(loading: true));

    try {

      final data = await service.getHotels();

      emit(state.copyWith(
        loading: false,
        activities: data,
      ));
    } catch (e) {

      emit(state.copyWith(
        loading: false,
        error: e.toString(),
      ));
    }
  }
}