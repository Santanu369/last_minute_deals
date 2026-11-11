import 'dart:convert';

import 'package:lmd_app/features/payment/data/models/booking_details_response.dart';
import 'package:lmd_app/features/payment/data/models/cashfree_order_response.dart';
import 'package:lmd_app/features/payment/data/models/cashfree_session_response.dart';
import 'package:lmd_app/features/payment/data/models/cashfree_sync_response.dart';
import 'package:lmd_app/features/payment/data/models/checkout_response.dart';
import 'package:lmd_app/features/payment/data/models/create_booking_response.dart';
import 'package:lmd_app/features/payment/data/models/stay_quote_response.dart';
import 'package:lmd_app/core/network/api_service.dart';
import 'package:lmd_app/features/payment/data/services/payment_service.dart';
import 'package:lmd_app/core/storage/secure_storage_service.dart';
import 'package:lmd_app/core/constants/api_constants.dart';

class PaymentServiceImpl implements PaymentService {
  final ApiService _apiService = ApiService();

  final SecureStorageService _storageService = SecureStorageService();
  @override
  Future<CreateBookingResponse> createBooking({
    required Map<String, dynamic> body,
  }) async {
    final response = await _apiService.post(
      endpoint: '${ApiConstants.bookings}',
      body: body,
    );

    if (response.statusCode == 200) {
      return CreateBookingResponse.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to create booking: ${response.body}');
  }

  @override
  Future<CashfreeOrderResponse> createCashfreeOrder({
    required String bookingId,
    required String idempotencyKey,
  }) async {
    final accessToken = await _storageService.getAccessToken();
    final response = await _apiService.post(
      endpoint: ApiConstants.cashfreeCreateOrder,
      headers: {'Authorization': 'Bearer $accessToken'},
      body: {'booking_id': bookingId, 'idempotency_key': idempotencyKey},
    );

    if (response.statusCode == 200) {
      return CashfreeOrderResponse.fromJson(jsonDecode(response.body));
    }

    throw Exception('Cashfree order failed: ${response.body}');
  }

  @override
  Future<CashfreeSessionResponse> createCashfreeSession({
    required String orderId,
    required String returnUrl,
  }) async {
    final accessToken = await _storageService.getAccessToken();

    final response = await _apiService.post(
      endpoint: '/v1/payments/cashfree/session',
      headers: {'Authorization': 'Bearer $accessToken'},
      body: {'order_id': orderId, 'return_url': returnUrl},
    );

    if (response.statusCode == 200) {
      return CashfreeSessionResponse.fromJson(jsonDecode(response.body));
    }

    throw Exception('Cashfree session failed: ${response.body}');
  }

  @override
  Future<CashfreeSyncResponse> syncPayment({required String bookingId}) async {
    final accessToken = await _storageService.getAccessToken();
    if (accessToken == null || accessToken.trim().isEmpty) {
      throw Exception('Session expired. Please login again.');
    }

    bool isEtg = false;
    try {
      final details = await getBookingDetails(bookingId: bookingId);
      if (details.staySku.toLowerCase().contains('etg') ||
          details.staySku.toLowerCase().contains('ratehawk') ||
          details.listingId.toLowerCase().contains('etg') ||
          details.listingId.toLowerCase().contains('ratehawk')) {
        isEtg = true;
      }
    } catch (e) {
      // print("Error fetching booking details in syncPayment: $e");
    }

    if (isEtg) {
      final response = await _apiService.post(
        endpoint: '/v1/hotels/etg/booking/finish',
        headers: {'Authorization': 'Bearer $accessToken'},
        body: {'booking_id': bookingId},
      );

      if (response.statusCode == 200) {
        return CashfreeSyncResponse.fromJson(jsonDecode(response.body));
      }

      throw Exception('Failed to finish ETG booking: ${response.body}');
    } else {
      final response = await _apiService.post(
        endpoint: '/v1/bookings/$bookingId/payments/cashfree/sync',
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        return CashfreeSyncResponse.fromJson(jsonDecode(response.body));
      }

      throw Exception('Payment sync failed: ${response.body}');
    }
  }

  @override
  Future<StayQuoteResponse> getStayQuote({
    required String listingId,
    required String dealId,
    required String sku,
    required String checkIn,
    required String checkOut,
    int rooms = 1,
  }) async {
    final response = await _apiService.get(
      endpoint:
          '/v1/public/listings/$listingId/stay-quote'
          '?deal_id=$dealId'
          '&sku=$sku'
          '&check_in=$checkIn'
          '&check_out=$checkOut'
          '&rooms=$rooms',
    );

    // print("QUOTE STATUS = ${response.statusCode}");
    // print("QUOTE BODY = ${response.body}");

    if (response.statusCode == 200) {
      return StayQuoteResponse.fromJson(jsonDecode(response.body));
    }

    if (response.statusCode == 409) {
      throw Exception('NO_AVAILABILITY');
    }

    throw Exception('Failed to fetch stay quote: ${response.body}');
  }

  @override
  Future<CheckoutResponse> checkoutStay({
    required Map<String, dynamic> body,
  }) async {
    final accessToken = await _storageService.getAccessToken();
    if (accessToken == null || accessToken.trim().isEmpty) {
      throw Exception(
        'Booking cannot succeed without a valid auth token. Please login again.',
      );
    }

    final String provider = body['provider'] ?? '';
    final isEtg =
        provider.toLowerCase() == 'etg' || provider.toLowerCase() == 'ratehawk';
    final endpoint = isEtg
        ? '/v1/hotels/etg/booking/form'
        : '/v1/retail/orders/single-item';

    final requestBody = Map<String, dynamic>.from(body)..remove('provider');
    if (!isEtg) {
      requestBody['variant_id'] = body['variant_id'];
      requestBody['quantity'] = body['stay']?['rooms'] ?? 1;

      final String paymentMethod = body['payment_method'] ?? 'cashfree';
      requestBody['payment_method'] = paymentMethod.toLowerCase();

      final guest = body['guest'] ?? {};
      final String guestName = guest['full_name'] ?? 'Guest';
      final String guestEmail = guest['email'] ?? '';
      final String guestPhone = guest['phone'] ?? '';

      requestBody['billing_address'] = {
        'name': guestName,
        'email': guestEmail,
        'address_line1': 'Digital Booking',
        'address_line2': '',
        'city': 'N/A',
        'state': 'N/A',
        'postal_code': '000000',
        'phone': guestPhone,
      };

      requestBody['shipping_address'] = {
        'name': guestName,
        'email': guestEmail,
        'address_line1': 'Digital Booking',
        'address_line2': '',
        'city': 'N/A',
        'state': 'N/A',
        'postal_code': '000000',
        'phone': guestPhone,
      };
    }

    final response = await _apiService.post(
      endpoint: endpoint,
      headers: {'Authorization': 'Bearer $accessToken'},
      body: requestBody,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return CheckoutResponse.fromJson(jsonDecode(response.body));
    }

    throw Exception('Checkout failed: ${response.body}');
  }

  @override
  Future<BookingDetailsResponse> getBookingDetails({
    required String bookingId,
  }) async {
    final accessToken = await _storageService.getAccessToken();
    // final token = print('BOOKING TOKEN: $accessToken');

    // Testing as auth session had issues..
    if (accessToken == null) {
      throw Exception('Session expired. Please login again.');
    }
    // final me = await AuthService().getMe(accessToken: accessToken);

    // print('ME RESPONSE: $me');
    // print('ME USER ID: ${me?.id}');

    final response = await _apiService.get(
      endpoint: '/v1/bookings/$bookingId',
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    // print('BOOKING STATUS: ${response.statusCode}');
    // print('BOOKING RESPONSE: ${response.body}');

    if (response.statusCode == 200) {
      return BookingDetailsResponse.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to fetch booking details: ${response.body}');
  }
  // @override
  // Future<BookingDetailsResponse> getBookingDetails({
  //   required String bookingId,
  // }) async {
  //   final accessToken = await SecureStorageService().getAccessToken();
  //   print('BOOKING TOKEN: $accessToken');
  //   final response = await _apiService.get(
  //     endpoint: '/v1/bookings/$bookingId',
  //     headers: {'Cookie': 'access_token=$accessToken'},
  //   );
  //   print("response of booking with booking id ${response.body}");

  //   if (response.statusCode == 200) {
  //     return BookingDetailsResponse.fromJson(jsonDecode(response.body));
  //   }

  //   throw Exception('Failed to fetch booking details: ${response.body}');
  // }
}
