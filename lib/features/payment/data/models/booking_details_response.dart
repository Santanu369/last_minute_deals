import 'package:flutter/foundation.dart';

class BookingDetailsResponse {
  final String bookingId;
  final String status;
  final String paymentStatus;
  final String currency;
  final double amountTotal;
  final String expiresAt;

  final String listingId;
  final String listingTitle;
  final String listingAddress;
  final String listingCoverImageUrl;

  final String stayCheckIn;
  final String stayCheckOut;
  final int stayNights;
  final int stayRooms;
  final String staySku;
  final String stayRoomName;

  final String guestFullName;
  final String guestEmail;
  final String guestPhone;
  final String arrivalPreference;

  final String paymentKind;
  final String? paymentCardLast4;
  final String? paymentCardholderName;
  final String? paymentCardBrand;

  //For the Booking History page 
  final String? image;
  final List<String>? highlights;
  final String city;
  final String country;
  // final String 


  BookingDetailsResponse({
    required this.bookingId,
    required this.status,
    required this.paymentStatus,
    required this.currency,
    required this.amountTotal,
    required this.expiresAt,
    required this.listingId,
    required this.listingTitle,
    required this.listingAddress,
    required this.listingCoverImageUrl,
    required this.stayCheckIn,
    required this.stayCheckOut,
    required this.stayNights,
    required this.stayRooms,
    required this.staySku,
    required this.stayRoomName,
    required this.guestFullName,
    required this.guestEmail,
    required this.guestPhone,
    required this.arrivalPreference,
    required this.paymentKind,
    this.paymentCardLast4,
    this.paymentCardholderName,
    this.paymentCardBrand,

    this.image, 
    this.highlights, required this.city, required this.country,
  });

  factory BookingDetailsResponse.fromJson(Map<String, dynamic> json) {
    try {
      return BookingDetailsResponse(
        bookingId: (json['bookingId'] ?? json['booking_id'] ?? '').toString(),
        status: (json['status'] ?? '').toString(),
        paymentStatus: (json['paymentStatus'] ?? json['payment_status'] ?? '').toString(),
        currency: (json['currency'] ?? 'INR').toString(),
        amountTotal: double.tryParse((json['amountTotal'] ?? json['amount_total'] ?? 0).toString()) ?? 0.0,
        expiresAt: (json['expiresAt'] ?? json['expires_at'] ?? '').toString(),

        listingId: (json['hotelId'] ?? json['listing_id'] ?? '').toString(),
        listingTitle: (json['hotelName'] ?? json['listing_title'] ?? '').toString(),
        listingAddress: (json['address'] ?? json['listing_address'] ?? '').toString(),
        listingCoverImageUrl: (json['image'] ?? json['listing_cover_image_url'] ?? '').toString(),

        stayCheckIn: (json['checkIn'] ?? json['stay_check_in'] ?? '').toString(),
        stayCheckOut: (json['checkOut'] ?? json['stay_check_out'] ?? '').toString(),
        stayNights: int.tryParse((json['stayNights'] ?? json['stay_nights'] ?? 0).toString()) ?? 0,
        stayRooms: int.tryParse((json['stayRooms'] ?? json['stay_rooms'] ?? 0).toString()) ?? 0,
        staySku: (json['sku'] ?? json['stay_sku'] ?? '').toString(),
        stayRoomName: (json['roomName'] ?? json['stay_room_name'] ?? '').toString(),

        guestFullName: (json['guestName'] ?? json['guest_full_name'] ?? '').toString(),
        guestEmail: (json['guestEmail'] ?? json['guest_email'] ?? '').toString(),
        guestPhone: (json['guestPhone'] ?? json['guest_phone'] ?? '').toString(),
        arrivalPreference: (json['arrivalPreference'] ?? json['arrival_preference'] ?? '').toString(),

        paymentKind: (json['paymentKind'] ?? json['payment_kind'] ?? '').toString(),
        paymentCardLast4: json['paymentCardLast4']?.toString(),
        paymentCardholderName: json['paymentCardholderName']?.toString(),
        paymentCardBrand: json['paymentCardBrand']?.toString(), city: json['city']?.toString() ?? '', country: json['country']?.toString() ?? '', image: json['image']?.toString(), highlights: (json['highlights'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      );
    } catch (e) {
      debugPrint('Error parsing BookingDetailsResponse: $e');
      // Return a fallback object instead of crashing
      return BookingDetailsResponse(
        bookingId: 'Error',
        status: 'FAILED',
        paymentStatus: 'FAILED',
        currency: 'INR',
        amountTotal: 0.0,
        expiresAt: '',
        listingId: '',
        listingTitle: 'Parse Error',
        listingAddress: '',
        listingCoverImageUrl: '',
        stayCheckIn: '',
        stayCheckOut: '',
        stayNights: 0,
        stayRooms: 0,
        staySku: '',
        stayRoomName: '',
        guestFullName: '',
        guestEmail: '',
        guestPhone: '',
        arrivalPreference: '',
        paymentKind: '', city: '', country: '', image: '', highlights: [],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'status': status,
      'payment_status': paymentStatus,
      'currency': currency,
      'amount_total': amountTotal,
      'expires_at': expiresAt,
      'listing_id': listingId,
      'listing_title': listingTitle,
      'listing_address': listingAddress,
      'listing_cover_image_url': listingCoverImageUrl,
      'stay_check_in': stayCheckIn,
      'stay_check_out': stayCheckOut,
      'stay_nights': stayNights,
      'stay_rooms': stayRooms,
      'stay_sku': staySku,
      'stay_room_name': stayRoomName,
      'guest_full_name': guestFullName,
      'guest_email': guestEmail,
      'guest_phone': guestPhone,
      'arrival_preference': arrivalPreference,
      'payment_kind': paymentKind,
      'payment_card_last4': paymentCardLast4,
      'payment_cardholder_name': paymentCardholderName,
      'payment_card_brand': paymentCardBrand,
    };
  }
}