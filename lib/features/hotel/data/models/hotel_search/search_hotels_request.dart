
class SearchHotelsRequest {
  final DateTime checkIn;
  final DateTime checkOut;
  final int rooms;
  final int adults;
  final List<int> children;
  final String residency;

  final String? query;
  final double? latitude;
  final double? longitude;
  final double radius;

  /// Server-side pagination (1-based), same as the web search page.
  final int page;
  final int limit;

  const SearchHotelsRequest({
    required this.checkIn,
    required this.checkOut,
    required this.rooms,
    required this.adults,
    required this.children,
    this.residency = 'IN',
    this.query,
    this.latitude,
    this.longitude,
    this.radius = 20,
    this.page = 1,
    this.limit = 20,
  });

  SearchHotelsRequest copyWith({int? page}) => SearchHotelsRequest(
        checkIn: checkIn,
        checkOut: checkOut,
        rooms: rooms,
        adults: adults,
        children: children,
        residency: residency,
        query: query,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        page: page ?? this.page,
        limit: limit,
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> body = {
      'checkin': _formatDate(checkIn),
      'checkout': _formatDate(checkOut),
      'residency': residency.toLowerCase(),
      'rooms': rooms,
      'adults': adults,
      'children': children,
      'guests': _guestsPerRoom(),
      'page': page,
      'limit': limit,
    };

    if (query?.trim().isNotEmpty ?? false) {
      body['query'] = query!.trim();
    } else if (_valid(latitude) != null && _valid(longitude) != null) {
      body['latitude'] = latitude;
      body['longitude'] = longitude;
      body['radius'] = radius;
    }
    // Neither: backend "browse" mode returns the top-rated default hotels (same as lmd-web).

    return body;
  }

  static double? _valid(double? v) => v != null && v.isFinite ? v : null;

  /// Splits the party across rooms (>= 1 adult per room, children round-robin)
  /// so totals match the search; duplicating the totals per room makes the
  /// supplier price and validate the wrong party size.
  List<Map<String, dynamic>> _guestsPerRoom() {
    final n = rooms < 1 ? 1 : rooms;
    final perRoomAdults = List<int>.filled(n, 0);
    var remaining = adults < n ? n : adults;
    for (var i = 0; remaining > 0; i = (i + 1) % n) {
      perRoomAdults[i]++;
      remaining--;
    }
    final perRoomChildren = List.generate(n, (_) => <int>[]);
    for (var i = 0; i < children.length; i++) {
      perRoomChildren[i % n].add(children[i]);
    }
    return List.generate(
      n,
      (i) => {'adults': perRoomAdults[i], 'children': perRoomChildren[i]},
    );
  }

  String _formatDate(DateTime date) =>
      "${date.year.toString().padLeft(4, '0')}-"
      "${date.month.toString().padLeft(2, '0')}-"
      "${date.day.toString().padLeft(2, '0')}";
}
