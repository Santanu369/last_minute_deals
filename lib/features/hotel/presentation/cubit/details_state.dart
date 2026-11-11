import 'package:lmd_app/features/hotel/data/models/retail_hotel_details_model.dart';

class DetailsState {
  final bool isLoading;

  final RetailHotelDetailsModel? hotel;

  final String? error;

  const DetailsState({this.isLoading = false, this.hotel, this.error});

  DetailsState copyWith({
    bool? isLoading,
    RetailHotelDetailsModel? hotel,
    String? error,
  }) {
    return DetailsState(
      isLoading: isLoading ?? this.isLoading,
      hotel: hotel ?? this.hotel,
      error: error,
    );
  }
}
