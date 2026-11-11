import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

class MapLauncher {
  static Future<void> open(String url) async {
    if (url.isEmpty) return;

    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch URL: $e');
    }
  }

  static Future<void> openGooglePlace(String placeId, String query) async {
    if (placeId.isEmpty) {
      await openMapSearch(query);
      return;
    }

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}&query_place_id=$placeId',
    );

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch place ID map: $e');
    }
  }

  static Future<void> openMapSearch(String query) async {
    if (query.isEmpty) return;

    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}',
    );

    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Could not launch map search: $e');
    }
  }
}
