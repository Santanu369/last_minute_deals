import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:lmd_app/core/constants/api_constants.dart';

import 'package:lmd_app/features/booking/data/models/booking_models.dart';

class BookingRepository {
  // Replace with your backend URL
  static String get baseUrl => ApiConstants.baseUrl1;

  Future<Booking> getBooking(String bookingId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/bookings/$bookingId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Booking.fromJson(json);
    } else {
      throw Exception('Failed to load booking');
    }
  }

  Future<List<Booking>> getMyBookings(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users/$userId/bookings'),
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);

      return data
          .map((booking) => Booking.fromJson(booking))
          .toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }
}