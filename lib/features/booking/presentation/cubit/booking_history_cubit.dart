import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lmd_app/features/booking/data/services/booking_service.dart';

import 'package:lmd_app/features/booking/presentation/cubit/booking_history_state.dart';

class BookingHistoryCubit extends Cubit<BookingHistoryState> {
  final BookingService _bookingService;

  BookingHistoryCubit({required BookingService bookingService})
    : _bookingService = bookingService,
      super(const BookingHistoryState());

  Future<void> loadBookingHistory() async {
    emit(state.copyWith(isLoading: true, clearError: true));

    try {
        // The API uses COMPLETED for successful bookings in some responses and
        // CONFIRMED in others, so classify the complete history locally.
        final bookings = await _bookingService.getMyBookings(status: '');

        final completed = bookings.where((booking) {
        final status = booking.status.trim().toUpperCase();
        return status == 'CONFIRMED' || status == 'COMPLETED';
        }).toList();
        final pending = bookings
          .where((booking) => booking.status.trim().toUpperCase() == 'PENDING')
          .toList();
        final failed = bookings
          .where((booking) => booking.status.trim().toUpperCase() == 'FAILED')
          .toList();

      debugPrint('====================================');
      debugPrint('BOOKING HISTORY LOADED');
      debugPrint('Completed: ${completed.length}');
      debugPrint('Pending: ${pending.length}');
      debugPrint('Failed: ${failed.length}');
      debugPrint('====================================');

      emit(
        state.copyWith(
          isLoading: false,
          completedBookings: completed,
          pendingBookings: pending,
          failedBookings: failed,
          clearError: true,
        ),
      );
    } catch (e) {
      debugPrint('Booking history error: $e');

      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    final isConfirmed = state.completedBookings.any(
      (booking) => booking.bookingId == bookingId,
    );

    if (!isConfirmed) {
      emit(
        state.copyWith(
          errorMessage: 'This booking is no longer available to cancel.',
        ),
      );
      return;
    }

    debugPrint('====================================');
    debugPrint('CANCEL BOOKING');
    debugPrint('bookingId = $bookingId');
    debugPrint('====================================');

    emit(
      state.copyWith(
        isCancelling: true,
        cancelBookingId: bookingId,
        clearError: true,
      ),
    );

    try {
      final response = await _bookingService.cancelBooking(
        bookingId: bookingId,
      );

      debugPrint('Cancel API response: $response');

      final success = response['success'] == true;

      if (!success) {
        throw Exception(
          response['message']?.toString() ?? 'Unable to cancel booking',
        );
      }

      debugPrint('Booking cancelled successfully');

      emit(state.copyWith(isCancelling: false, cancelBookingId: null));

      // Refresh booking history after cancellation
      await loadBookingHistory();
    } catch (e) {
      debugPrint('Cancel booking error: $e');

      emit(
        state.copyWith(
          isCancelling: false,
          cancelBookingId: null,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
