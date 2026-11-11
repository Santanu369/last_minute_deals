import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lmd_app/core/constants/api_constants.dart';
import 'package:lmd_app/core/network/api_service.dart';
import 'package:lmd_app/core/storage/secure_storage_service.dart';
import 'package:uuid/uuid.dart';

/// Runs in its own isolate when a push arrives with the app in the background.
/// Must be top-level. The OS shows `notification` payloads itself; nothing to do.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

/// FCM: permission, token, registration with Lmd_user (`/v1/fcm/token`).
///
/// Flow: [init] at startup -> [registerWithBackend] once the user is signed in
/// (and again whenever FCM rotates the token) -> [unregister] before logout.
class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  /// Attached to MaterialApp so foreground pushes can show an in-app banner.
  final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static const _deviceIdKey = 'device_id';
  final _secure = const FlutterSecureStorage();
  final _tokens = SecureStorageService();

  FirebaseMessaging get _fcm => FirebaseMessaging.instance;
  bool _initialised = false;

  /// Last token successfully sent to the backend (skip redundant calls).
  String? _registeredToken;

  Future<void>? _initFuture;

  /// Idempotent and safe to call without awaiting; callers that need Firebase
  /// ready (register/unregister) await it themselves.
  Future<void> init() => _initFuture ??= _init();

  Future<void> _init() async {
    try {
      await Firebase.initializeApp();
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // iOS: show alerts while the app is open. (Android has no equivalent.)
      await _fcm.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      FirebaseMessaging.onMessage.listen(_showForegroundBanner);
      _fcm.onTokenRefresh.listen((t) => registerWithBackend(token: t));
      _initialised = true;
    } catch (e) {
      // Push is optional: a Firebase/config failure must never block app start.
      debugPrint('NotificationService.init failed: $e');
    }
  }

  /// Asks for notification permission (Android 13+/iOS), then registers the
  /// device token with the backend. No-op when signed out or permission denied.
  Future<void> registerWithBackend({String? token}) async {
    await init();
    if (!_initialised) return;
    try {
      final access = await _tokens.getAccessToken();
      if (access == null || access.isEmpty) return; // endpoint needs auth

      final settings = await _fcm.requestPermission();
      if (settings.authorizationStatus == AuthorizationStatus.denied) return;

      final fcmToken = token ?? await _fcm.getToken();
      if (fcmToken == null || fcmToken == _registeredToken) return;

      final res = await ApiService().post(
        endpoint: ApiConstants.fcmToken,
        headers: {'Authorization': 'Bearer $access'},
        body: {
          'fcm_token': fcmToken,
          'device_type': Platform.isIOS ? 'ios' : 'android',
          'device_id': await _deviceId(),
        },
      );
      if (res.statusCode == 200) _registeredToken = fcmToken;
    } catch (e) {
      debugPrint('FCM registration failed: $e');
    }
  }

  /// Detaches this device from the account. Call BEFORE clearing the access
  /// token, otherwise the request is unauthenticated and the old user keeps
  /// receiving this device's pushes.
  Future<void> unregister() async {
    await init();
    if (!_initialised) return;
    try {
      final access = await _tokens.getAccessToken();
      final fcmToken = _registeredToken ?? await _fcm.getToken();
      _registeredToken = null;
      if (access == null || fcmToken == null) return;

      await ApiService().delete(
        endpoint: ApiConstants.fcmToken,
        headers: {'Authorization': 'Bearer $access'},
        body: {'fcm_token': fcmToken},
      );
    } catch (e) {
      debugPrint('FCM unregister failed: $e');
    }
  }

  /// Stable per-install id so the backend can de-duplicate a device's tokens.
  Future<String> _deviceId() async {
    var id = await _secure.read(key: _deviceIdKey);
    if (id == null) {
      id = const Uuid().v4();
      await _secure.write(key: _deviceIdKey, value: id);
    }
    return id;
  }

  void _showForegroundBanner(RemoteMessage m) {
    final n = m.notification;
    if (n == null || Platform.isIOS) return; // iOS already presents it
    final text = [n.title, n.body].whereType<String>().where((s) => s.isNotEmpty).join('\n');
    if (text.isEmpty) return;
    messengerKey.currentState
      ?..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text), behavior: SnackBarBehavior.floating));
  }
}
