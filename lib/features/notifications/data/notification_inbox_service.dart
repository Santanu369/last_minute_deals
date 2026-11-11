import 'dart:convert';

import 'package:lmd_app/core/constants/api_constants.dart';
import 'package:lmd_app/core/network/api_service.dart';
import 'package:lmd_app/core/storage/secure_storage_service.dart';

class AppNotification {
  final String id;
  final String title;
  final String message;

  /// info | success | warning | error | system
  final String type;
  final DateTime? createdAt;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    required this.isRead,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      message: (json['message'] ?? '').toString(),
      type: (json['type'] ?? 'info').toString(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? '').toString())?.toLocal(),
      isRead: json['is_read'] == true,
    );
  }
}

typedef NotificationPage = ({
  List<AppNotification> items,
  int unread,
  int pages,
  bool signedIn,
});

/// In-app notification inbox (Lmd_user `/v1/retail/notifications`).
/// Push delivery / FCM token handling lives in core `NotificationService`.
class NotificationInboxService {
  final ApiService _api = ApiService();
  final SecureStorageService _storage = SecureStorageService();

  Future<Map<String, String>?> _authHeaders() async {
    final token = await _storage.getAccessToken();
    if (token == null || token.isEmpty) return null;
    return {'Authorization': 'Bearer $token'};
  }

  /// Signed in: the user's own notifications + broadcasts. Guests: public
  /// announcements only, which have no per-user read state.
  Future<NotificationPage> fetch({int page = 1, int limit = 20}) async {
    final headers = await _authHeaders();
    final signedIn = headers != null;

    final response = await _api.get(
      endpoint: signedIn
          ? ApiConstants.personalNotifications
          : ApiConstants.publicNotifications,
      headers: headers,
      queryParameters: {
        'page': '$page',
        'limit': '$limit',
        'sort_by': 'createdAt',
        'sort_order': 'desc',
      },
    );

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Session expired. Please log in again.');
    }
    if (response.statusCode != 200) {
      throw Exception('Failed to load notifications (${response.statusCode})');
    }

    final dynamic decoded;
    try {
      decoded = jsonDecode(response.body);
    } catch (_) {
      throw Exception('Unable to load notifications right now. Please try again later.');
    }

    final Map data =
        decoded is Map && decoded['data'] is Map ? decoded['data'] : const {};
    final raw = data['notifications'] as List<dynamic>? ?? [];
    final pagination = data['pagination'];
    final items = raw
        .whereType<Map<String, dynamic>>()
        .map(AppNotification.fromJson)
        .toList();
    if (!signedIn) {
      for (final n in items) {
        n.isRead = true;
      }
    }

    return (
      items: items,
      unread: signedIn ? (data['unreadCount'] as num?)?.toInt() ?? 0 : 0,
      pages: (pagination is Map ? pagination['pages'] as num? : null)?.toInt() ?? 1,
      signedIn: signedIn,
    );
  }

  Future<void> markRead(String id) =>
      _patch(ApiConstants.markNotificationRead(id));

  Future<void> markAllRead() => _patch(ApiConstants.markAllNotificationsRead);

  Future<void> _patch(String endpoint) async {
    final headers = await _authHeaders();
    if (headers == null) return;
    final response = await _api.patch(endpoint: endpoint, headers: headers);
    if (response.statusCode != 200) {
      throw Exception('Failed to update notifications (${response.statusCode})');
    }
  }
}
