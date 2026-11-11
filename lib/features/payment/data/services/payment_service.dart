import 'package:lmd_app/features/payment/data/models/booking_details_response.dart';
import 'package:lmd_app/features/payment/data/models/cashfree_order_response.dart';
import 'package:lmd_app/features/payment/data/models/cashfree_session_response.dart';
import 'package:lmd_app/features/payment/data/models/cashfree_sync_response.dart';
import 'package:lmd_app/features/payment/data/models/checkout_response.dart';
import 'package:lmd_app/features/payment/data/models/create_booking_response.dart';
import 'package:lmd_app/features/payment/data/models/stay_quote_response.dart';

abstract class PaymentService {
  Future<CreateBookingResponse> createBooking({
    required Map<String, dynamic> body,
  });

  Future<CashfreeOrderResponse> createCashfreeOrder({
    required String bookingId,
    required String idempotencyKey,
  });

  Future<CashfreeSessionResponse> createCashfreeSession({
    required String orderId,
    required String returnUrl,
  });

  Future<CashfreeSyncResponse> syncPayment({required String bookingId});

  Future<StayQuoteResponse> getStayQuote({
    required String listingId,
    required String dealId,
    required String sku,
    required String checkIn,
    required String checkOut,
    int rooms = 1,
  });

  Future<CheckoutResponse> checkoutStay({required Map<String, dynamic> body});

  Future<BookingDetailsResponse> getBookingDetails({required String bookingId});
}
