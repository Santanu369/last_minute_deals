import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:lmd_app/features/hotel/data/models/hotel_search/search_hotels_request.dart';
import 'package:lmd_app/features/hotel/data/services/hotel_service.dart';

// Hits the real API. Run explicitly: flutter test test/live_api_test.dart
void main() {
  setUpAll(() => HttpOverrides.global = null);

  test('search by query + details for partner and RateHawk ids', () async {
    final svc = HotelService();
    final page = await svc.searchHotels(SearchHotelsRequest(
      checkIn: DateTime.now().add(const Duration(days: 20)),
      checkOut: DateTime.now().add(const Duration(days: 21)),
      rooms: 1,
      adults: 2,
      children: const [],
      query: 'Pune',
    ));
    expect(page.hotels, isNotEmpty);
    final h = page.hotels.first;
    final d = await svc.fetchHotelDetails(h.id, fallbackPrice: h.salePrice);
    expect(d.name, isNotEmpty);
    expect(d.variants, isNotEmpty);

    final rh = await svc.fetchHotelDetails('10766747', fallbackPrice: 1000);
    expect(rh.name, isNotEmpty);
    expect(rh.variants.first.salePrice, 1000);

    // Hotelbeds ids are numeric too; with or without a source hint it must resolve.
    final hb = await svc.fetchHotelDetails('1', source: 'hotelbeds');
    expect(hb.name, isNotEmpty);
    final hb2 = await svc.fetchHotelDetails('1');
    expect(hb2.name, hb.name);
  }, timeout: const Timeout(Duration(seconds: 120)));
}
