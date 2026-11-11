// import 'dart:convert';

// import 'package:lmd_app/features/payment/models/booking_details_response.dart';
// import 'package:lmd_app/services/api_service.dart';
// import 'package:lmd_app/services/secure_storage_service.dart';

// class BookingService {
//   final ApiService _apiService = ApiService();
//   final SecureStorageService _storageService = SecureStorageService();

//   Future<List<BookingDetailsResponse>> getMyBookings({
//     required String status,
//   }) async {
//     final accessToken = await _storageService.getAccessToken();

//     if (accessToken == null || accessToken.isEmpty) {
//       throw Exception(
//         'You are not logged in. Please log in to view your bookings.',
//       );
//     }

//     const endpoint = '/v1/hotels/ratehawk/booking-history';

//     final response = await _apiService.get(
//       endpoint: endpoint,
//       headers: {
//         'Authorization': 'Bearer $accessToken',
//       },
//       queryParameters: {
//         'status': status,
//       },
//     );

//     debugPrint('========================================');
//     debugPrint('BOOKING HISTORY');
//     debugPrint('Status: $status');
//     debugPrint('URL: ${response.request?.url}');
//     debugPrint('Status Code: ${response.statusCode}');
//     debugPrint('Body: ${response.body}');
//     debugPrint('========================================');

//     if (response.statusCode == 401 || response.statusCode == 403) {
//       throw Exception('Session expired. Please log in again.');
//     }

//     if (response.statusCode != 200) {
//       throw Exception(
//         'Failed to load $status bookings (${response.statusCode})',
//       );
//     }

//     dynamic decoded;

//     try {
//       decoded = jsonDecode(response.body);
//     } catch (e) {
//       throw Exception(
//         'Unable to load $status bookings right now. Please try again later.',
//       );
//     }

//     if (decoded is! Map<String, dynamic>) {
//       throw Exception('Unexpected response from server.');
//     }

//     final data = decoded['data'];

//     if (data is! List) {
//       throw Exception('Unexpected booking data from server.');
//     }

//     return data
//         .whereType<Map<String, dynamic>>()
//         .map(
//           (json) => BookingDetailsResponse.fromJson(json),
//         )
//         .toList();
//   }
// }

import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:lmd_app/features/payment/data/models/booking_history_response.dart';
import 'package:lmd_app/core/network/api_service.dart';
import 'package:lmd_app/core/storage/secure_storage_service.dart';
import 'package:lmd_app/core/constants/api_constants.dart';

class BookingService {
  final ApiService _apiService = ApiService();
  final SecureStorageService _storageService = SecureStorageService();

  /// Price-on-request villa: sends an enquiry, no payment. Throws with the server message on failure.
  Future<void> sendPriceEnquiry(Map<String, dynamic> body) async {
    final token = await _storageService.getAccessToken();
    if (token == null || token.isEmpty) {
      throw Exception('Please log in to send an enquiry.');
    }
    final response = await _apiService.post(
      endpoint: ApiConstants.priceEnquiry,
      body: body,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Please log in to send an enquiry.');
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      String msg = 'Could not send your enquiry. Please try again.';
      try {
        msg = jsonDecode(response.body)['message']?.toString() ?? msg;
      } catch (_) {}
      throw Exception(msg);
    }
  }

  Future<Map<String, dynamic>> cancelBooking({
    required String bookingId,
  }) async {
    final accessToken = await _storageService.getAccessToken();

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception('Session expired. Please log in again.');
    }

    final response = await _apiService.post(
      endpoint: ApiConstants.cancelBooking,
      body: {'bookingId': bookingId},
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    debugPrint('========================================');
    debugPrint('CANCEL BOOKING API');
    debugPrint('Booking ID: $bookingId');
    debugPrint('URL: ${response.request?.url}');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('========================================');

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Session expired. Please log in again.');
    }

    dynamic decoded;

    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw Exception('Unable to read the cancellation response.');
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected response from cancellation server.');
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        decoded['message']?.toString() ??
            decoded['error']?.toString() ??
            'Unable to cancel booking.',
      );
    }

    return decoded;
  }

  Future<List<BookingHistoryItem>> getMyBookings({
    required String status,
  }) async {
    final accessToken = await _storageService.getAccessToken();

    if (accessToken == null || accessToken.isEmpty) {
      throw Exception(
        'You are not logged in. Please log in to view your bookings.',
      );
    }

    // const endpoint = '/v1/hotels/ratehawk/booking-history';

    final normalizedStatus = status.trim().toUpperCase();

    debugPrint('========================================');
    debugPrint('CALLING BOOKING HISTORY');
    debugPrint('Original status: "$status"');
    debugPrint('Normalized status: "$normalizedStatus"');
    debugPrint('========================================');

    final response = await _apiService.get(
      endpoint: ApiConstants.bookingHistory,
      headers: {'Authorization': 'Bearer $accessToken'},
      queryParameters: normalizedStatus.isEmpty
          ? null
          : {'status': normalizedStatus},
    );

    debugPrint('========================================');
    debugPrint('BOOKING HISTORY API');
    debugPrint('Status: "$normalizedStatus"');
    debugPrint('URL: ${response.request?.url}');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('========================================');

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Session expired. Please log in again.');
    }

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load $normalizedStatus bookings '
        '(${response.statusCode})',
      );
    }

    dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } on FormatException {
      throw Exception('Unable to read the booking history response.');
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Unexpected response from server.');
    }

    final bookingResponse = BookingHistoryResponse.fromJson(decoded);

    if (!bookingResponse.success) {
      throw Exception(
        bookingResponse.message.isEmpty
            ? 'Unable to load your booking history.'
            : bookingResponse.message,
      );
    }

    debugPrint('API success: ${bookingResponse.success}');

    debugPrint('API message: ${bookingResponse.message}');

    debugPrint(
      'Total bookings returned: '
      '${bookingResponse.data.length}',
    );

    for (final booking in bookingResponse.data) {
      debugPrint(
        'Booking: ${booking.bookingId} '
        '| Status: ${booking.status} '
        '| Hotel: ${booking.hotelName}',
      );
    }

    return bookingResponse.data;
  }
}
