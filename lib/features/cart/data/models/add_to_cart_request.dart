class AddToCartRequest {
  final String variantId;
  final String hotelId;

  final String hotelName;
  final String hotelLocation;
  final String roomType;

  final String checkInTime;
  final String checkOutTime;

  final String maxGuests;
  final String bedType;

  final DateTime checkIn;
  final DateTime checkOut;

  final double totalPrice;

  const AddToCartRequest({
    required this.variantId,
    required this.hotelId,
    required this.hotelName,
    required this.hotelLocation,
    required this.roomType,
    required this.checkInTime,
    required this.checkOutTime,
    required this.maxGuests,
    required this.bedType,
    required this.checkIn,
    required this.checkOut,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    final checkInDate = _format(checkIn);
    final checkOutDate = _format(checkOut);

    return {
      'variant_id': variantId,
      'quantity': 1,

      'selectedDates': {'checkIn': checkInDate, 'checkOut': checkOutDate},

      'booking_details': {
        'checkIn': checkInDate,
        'checkOut': checkOutDate,
        'check_in_date': checkInDate,
        'check_out_date': checkOutDate,

        'nights': checkOut.difference(checkIn).inDays,

        'totalPrice': totalPrice,

        'hotelName': hotelName,
        'hotelLocation': hotelLocation,
        'roomType': roomType,

        'checkInTime': checkInTime,
        'checkOutTime': checkOutTime,

        'maxGuests': maxGuests,
        'bedType': bedType,

        'isHotelBooking': true,

        'hotelId': hotelId,
        'variantId': variantId,
      },

      // duplicated exactly like website
      'checkIn': checkInDate,
      'checkOut': checkOutDate,

      'nights': checkOut.difference(checkIn).inDays,

      'totalPrice': totalPrice,

      'hotelName': hotelName,
      'hotelLocation': hotelLocation,
      'roomType': roomType,

      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,

      'maxGuests': maxGuests,
      'bedType': bedType,

      'isHotelBooking': true,

      'hotelId': hotelId,
      'variantId': variantId,
    };
  }

  String _format(DateTime d) => d.toIso8601String().split('T').first;
}
