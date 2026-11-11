class BookingHistoryResponse {
  final bool success;
  final String message;
  final List<BookingHistoryItem> data;

  BookingHistoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BookingHistoryResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return BookingHistoryResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] is List
          ? (json['data'] as List)
              .whereType<Map>()
              .map(
                (item) => BookingHistoryItem.fromJson(
                  Map<String, dynamic>.from(item),
                ),
              )
              .toList()
          : const [],
    );
  }
}

class BookingHistoryItem {
  final String bookingId;
  final String hotelId;
  final String hotelName;
  final String status;
  final String roomType;
  final String guestName;
  final String guestEmail;
  final String guestPhone;
  final String paymentMethod;
  final double totalAmount;

  final String checkIn;
  final String checkOut;

  final String createdAt;

  final String image;

  final double rating;

  final List<String> highlights;

  final String city;
  final String countryCode;
  final String countryName;

  final String address;
  final String description;

  BookingHistoryItem({
    required this.bookingId,
    required this.hotelId,
    required this.hotelName,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.roomType,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
    required this.paymentMethod,
    required this.totalAmount,
    required this.createdAt,
    required this.image,
    required this.rating,
    required this.highlights,
    required this.city,
    required this.countryCode,
    required this.countryName,
    required this.address,
    required this.description,
  });

  factory BookingHistoryItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return BookingHistoryItem(
        bookingId: _stringValue(json, 'bookingId', 'booking_id'),

        hotelId: _stringValue(json, 'hotelId', 'hotel_id'),

        hotelName: _stringValue(json, 'hotelName', 'hotel_name'),

        checkIn: _stringValue(json, 'checkIn', 'check_in'),

        checkOut: _stringValue(json, 'checkOut', 'check_out'),

        status: _stringValue(json, 'status'),

        roomType: _stringValue(json, 'roomType', 'roomName'),

        guestName: _stringValue(json, 'guestName', 'guestFullName'),

        guestEmail: _stringValue(json, 'guestEmail', 'guest_email'),

        guestPhone: _stringValue(json, 'guestPhone', 'guest_phone'),

        paymentMethod: _stringValue(json, 'paymentMethod', 'payment_kind'),

        totalAmount: _parseDouble(
          json['totalAmount'] ??
              json['amountTotal'] ??
              json['amount_total'] ??
              json['amount'],
        ),

        createdAt: _stringValue(json, 'createdAt', 'created_at'),

        image: _stringValue(json, 'image', 'image_url'),

      rating: _parseDouble(
        json['rating'],
      ),

      highlights:
          json['highlights'] is List
              ? (json['highlights'] as List)
                  .map((e) => e.toString())
                  .toList()
              : [],

        city: _stringValue(json, 'city'),

        countryCode: _stringValue(json, 'countryCode', 'country_code'),

        countryName: _stringValue(json, 'countryName', 'country_name'),

        address: _stringValue(json, 'address'),

        description: _stringValue(json, 'description'),
    );
  }

      static String _stringValue(
      Map<String, dynamic> json,
      String key, [
      String? fallbackKey,
      ]) {
      return (json[key] ?? (fallbackKey == null ? null : json[fallbackKey]))
          ?.toString() ??
        '';
      }

  static double _parseDouble(dynamic value) {
    if (value == null) {
      return 0.0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value.toString(),
        ) ??
        0.0;
  }

  int get nights {
    if (checkIn.isEmpty ||
        checkOut.isEmpty ||
        checkIn == 'null' ||
        checkOut == 'null') {
      return 0;
    }

    try {
      final start = DateTime.parse(checkIn);
      final end = DateTime.parse(checkOut);

      return end.difference(start).inDays;
    } catch (_) {
      return 0;
    }
  }

  String get location {
    if (city.isNotEmpty && countryName.isNotEmpty) {
      return '$city, $countryName';
    }

    if (city.isNotEmpty) {
      return city;
    }

    return countryCode;
  }
} 