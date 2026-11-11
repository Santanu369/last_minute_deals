import 'package:flutter_test/flutter_test.dart';
import 'package:lmd_app/features/hotel/data/models/hotel_search/search_hotels_request.dart';

void main() {
  test('guests are split across rooms, totals preserved (matches lmd-web)', () {
    final json = SearchHotelsRequest(
      checkIn: DateTime(2026, 9, 1),
      checkOut: DateTime(2026, 9, 3),
      rooms: 2,
      adults: 3,
      children: [5, 7],
      query: 'Goa',
      page: 2,
    ).toJson();

    final guests = json['guests'] as List;
    expect(guests.map((g) => g['adults']), [2, 1]);
    expect(guests.expand((g) => g['children'] as List), [5, 7]);
    expect(json['checkin'], '2026-09-01');
    expect(json['residency'], 'in');
    expect(json['page'], 2);
    expect(json['query'], 'Goa');
  });

  test('no query and no coordinates -> valid Pune lat/lng, never null', () {
    final json = SearchHotelsRequest(
      checkIn: DateTime(2026, 9, 1),
      checkOut: DateTime(2026, 9, 2),
      rooms: 1,
      adults: 2,
      children: const [],
    ).toJson();
    expect(json['latitude'], 18.5204);
    expect(json['longitude'], 73.8567);
    expect(json.containsKey('query'), isFalse);
  });
}
