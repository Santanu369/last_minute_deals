class Booking {
  final String bookingId;
  final String hotelName;
  final String city;
  final String image;
  final DateTime checkIn;
  final DateTime checkOut;
  final int adults;
  final int rooms;
  final String roomType;
  final double roomCharges;
  final double discount;
  final double tax;
  final double totalPaid;

  Booking({
    required this.bookingId,
    required this.hotelName,
    required this.city,
    required this.image,
    required this.checkIn,
    required this.checkOut,
    required this.adults,
    required this.rooms,
    required this.roomType,
    required this.roomCharges,
    required this.discount,
    required this.tax,
    required this.totalPaid,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['bookingId'],
      hotelName: json['hotel']['name'],
      city: json['hotel']['city'],
      image: json['hotel']['image'],
      checkIn: DateTime.parse(json['checkIn']),
      checkOut: DateTime.parse(json['checkOut']),
      adults: json['adults'],
      rooms: json['rooms'],
      roomType: json['roomType'],
      roomCharges: json['payment']['roomCharges'].toDouble(),
      discount: json['payment']['discount'].toDouble(),
      tax: json['payment']['tax'].toDouble(),
      totalPaid: json['payment']['totalPaid'].toDouble(),
    );
  }
}

class BookingList {
  final List<Booking> bookings;

  BookingList({required this.bookings});

  factory BookingList.fromJson(List<dynamic> json) {
    List<Booking> bookings = json.map((booking) => Booking.fromJson(booking)).toList();
    return BookingList(bookings: bookings);
  }
}

// Direct local list for immediate display
List<Booking> localProducts = [
  Booking(
    bookingId: '1',
    hotelName: 'Hotel Sunshine',
    city: 'New York',
    image: 'https://plus.unsplash.com/premium_photo-1661964071015-d97428970584?fm=jpg&q=60&w=3000&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aG90ZWx8ZW58MHx8MHx8fDA%3D',
    checkIn: DateTime(2024, 7, 20),
    checkOut: DateTime(2024, 7, 25),
    adults: 2,
    rooms: 1,
    roomType: 'Deluxe',
    roomCharges: 5000.0,
    discount: 50.0,
    tax: 45.0,
    totalPaid: 495.0,
  ),
  
];

