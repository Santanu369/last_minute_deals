import 'package:shared_preferences/shared_preferences.dart';

class LocationStorageService {
  static const String _locationKey = 'current_location';
  Future<void> saveLocation(String location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_locationKey, location);
  }

  Future<String?> getLocation() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_locationKey);
  }
}
