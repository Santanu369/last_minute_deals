class HotelPageRequest {
  final String hid;
  final DateTime checkIn;
  final DateTime checkOut;
  final int rooms;
  final int adults;
  final List<int> children;
  final String residency;

  const HotelPageRequest({
    required this.hid,
    required this.checkIn,
    required this.checkOut,
    required this.rooms,
    required this.adults,
    required this.children,
    this.residency = 'IN',
  });

  factory HotelPageRequest.defaultSearch({required String hid}) {
    return HotelPageRequest(
      hid: hid,
      checkIn: DateTime.now(),
      checkOut: DateTime.now().add(const Duration(days: 1)),
      rooms: 1,
      adults: 2,
      children: const [],
    );
  }
}
