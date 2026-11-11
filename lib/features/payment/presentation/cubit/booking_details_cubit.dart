import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/payment/presentation/cubit/booking_details_state.dart';
import 'package:lmd_app/features/payment/data/services/payment_service.dart';

class BookingDetailsCubit extends Cubit<BookingDetailsState> {
  final PaymentService _paymentService;

  BookingDetailsCubit(this._paymentService) : super(BookingDetailsInitial());

  Future<void> getBookingDetails(String bookingId) async {
    try {
      emit(BookingDetailsLoading());

      final booking = await _paymentService.getBookingDetails(
        bookingId: bookingId,
      );

      emit(BookingDetailsLoaded(booking));
    } catch (e) {
      debugPrint('booking page error: $e');
      emit(BookingDetailsError(e.toString()));
    }
  }
}
