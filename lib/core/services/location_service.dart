import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lmd_app/core/constants/default_location.dart';
import 'package:lmd_app/core/storage/location_storage_service.dart';

class LocationService {
  LocationService._();

  static final instance = LocationService._();

  ({double latitude, double longitude})? _cached;

  /// Asks for location permission (the OS prompt shows only while undecided).
  /// Returns null when denied, services are off, or the fix fails/times out.
  Future<Position?> getCurrentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low, // city-level is enough for search
          timeLimit: Duration(seconds: 8),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  /// Valid coordinates for search: the device location if permitted, else Pune.
  Future<({double latitude, double longitude})> searchCoordinates() async {
    if (_cached != null) return _cached!;
    final p = await getCurrentPosition();
    final coords = p != null && p.latitude.isFinite && p.longitude.isFinite
        ? (latitude: p.latitude, longitude: p.longitude)
        : (latitude: DefaultLocation.latitude, longitude: DefaultLocation.longitude);
    // Only cache a real fix; a denial may be changed in settings later.
    if (p != null) _cached = coords;
    return coords;
  }

  /// Destination text for a search with no typed destination: the user's city
  /// if permitted, else Pune. (The search API's lat/lng path currently 500s
  /// server-side, so we search by name like the web does.)
  Future<String> searchQuery() async {
    final p = await getCurrentPosition();
    if (p != null) {
      try {
        final marks = await placemarkFromCoordinates(p.latitude, p.longitude);
        final city = marks.first.locality?.trim();
        if (city != null && city.isNotEmpty) return city;
      } catch (_) {}
    }
    return DefaultLocation.name;
  }

  Future<String> getLocationName(double lat, double lng) async {
    final placemarks = await placemarkFromCoordinates(lat, lng);

    final place = placemarks.first;
    final location = '${place.locality}, ${place.country}';
    await LocationStorageService().saveLocation(location);

    return location;
  }
}
