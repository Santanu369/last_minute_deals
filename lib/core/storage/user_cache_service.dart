import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lmd_app/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Caches the signed-in user (PII) in the platform keystore, not plain prefs.
class UserCacheService {
  static const _userKey = 'cached_user';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> saveUser(UserModel user) async {
    await _storage.write(key: _userKey, value: jsonEncode(user.toJson()));
  }

  Future<UserModel?> getUser() async {
    final jsonString = await _storage.read(key: _userKey);
    if (jsonString == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(jsonString));
    } catch (_) {
      await clear(); // corrupt cache must not block startup
      return null;
    }
  }

  Future<void> clear() async {
    await _storage.delete(key: _userKey);
    // Purge the plaintext copy written by older app versions.
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
