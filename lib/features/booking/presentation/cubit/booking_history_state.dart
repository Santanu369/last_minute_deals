import 'package:equatable/equatable.dart';
import 'package:lmd_app/features/payment/data/models/booking_history_response.dart';

class BookingHistoryState extends Equatable {
  final bool isLoading;
  final bool isCancelling;
  final String? cancelBookingId;

  final List<BookingHistoryItem> completedBookings;
  final List<BookingHistoryItem> pendingBookings;
  final List<BookingHistoryItem> failedBookings;

  final String? errorMessage;

  const BookingHistoryState({
    this.isCancelling = false,
    this.isLoading = false,
    this.completedBookings = const [],
    this.pendingBookings = const [],
    this.failedBookings = const [],
    this.errorMessage,
    this.cancelBookingId,
  });

  BookingHistoryState copyWith({
    bool? isLoading,
    bool? isCancelling,
    String? cancelBookingId,

    List<BookingHistoryItem>? completedBookings,
    List<BookingHistoryItem>? pendingBookings,
    List<BookingHistoryItem>? failedBookings,

    String? errorMessage,

    bool clearError = false,
  }) {
    return BookingHistoryState(
      isLoading: isLoading ?? this.isLoading,

      isCancelling: isCancelling ?? this.isCancelling,
      cancelBookingId: cancelBookingId ?? this.cancelBookingId,

      completedBookings: completedBookings ?? this.completedBookings,

      pendingBookings: pendingBookings ?? this.pendingBookings,

      failedBookings: failedBookings ?? this.failedBookings,

      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isCancelling,
    cancelBookingId,
    completedBookings,
    pendingBookings,
    failedBookings,
    errorMessage,
  ];
}
