import 'package:lmd_app/features/payment/data/models/booking_details_response.dart';

abstract class BookingDetailsState {}

class BookingDetailsInitial extends BookingDetailsState {}

class BookingDetailsLoading extends BookingDetailsState {}

class BookingDetailsLoaded extends BookingDetailsState {
  final BookingDetailsResponse booking;

  BookingDetailsLoaded(this.booking);
}

class BookingDetailsError extends BookingDetailsState {
  final String message;

  BookingDetailsError(this.message);
}
