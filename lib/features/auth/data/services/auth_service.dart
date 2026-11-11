import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:lmd_app/features/auth/data/models/user_model.dart';
import 'package:lmd_app/core/network/api_service.dart';
// import 'package:lmd_app/services/secure_storage_service.dart';
import 'package:lmd_app/core/constants/api_constants.dart';

import 'package:lmd_app/features/auth/data/models/auth_response_model.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  // final SecureStorageService _storageService = SecureStorageService();

  Future<AuthResponseModel> googleSignup({required String idToken}) async {
    final response = await _apiService.post(
      endpoint: ApiConstants.googleCallback,
      body: {'id_token': idToken},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(data);
    } else {
      throw Exception(data['detail'] ?? 'Google signup failed');
    }
  }

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.post(
      endpoint: ApiConstants.login,
      body: {'email': email, 'password': password},
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(data);
    } else {
      throw Exception(data['message'] ?? 'Login failed');
    }
  }

// ```dart
Future<AuthResponseModel> googleLogin({
  required String email,
  required String name,
  String? picture,
  required String sub,
  required String idToken,
  String? fcmToken,
  required String deviceType,
  String? deviceId,
}) async {
  final response = await _apiService.post(
    endpoint: ApiConstants.googleCallback,
    body: {
      'email': email,
      'name': name,
      'picture': picture,
      'sub': sub,
      'id_token': idToken,
      'fcm_token': fcmToken,
      'device_type': deviceType,
      'device_id': deviceId,
    },
  );

  debugPrint('========== GOOGLE API ==========');
  debugPrint('Status: ${response.statusCode}');
  debugPrint('================================');

  final data = jsonDecode(response.body);

  if (response.statusCode >= 200 && response.statusCode < 300) {
    return AuthResponseModel.fromJson(data);
  }

  throw Exception(
    data['message'] ??
        data['detail'] ??
        data['error'] ??
        'Google login failed',
  );
}
// ```


  Future<AuthResponseModel> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
  }) async {
    final response = await _apiService.post(
      endpoint: ApiConstants.signup,
      body: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
        'phoneNumber': phone,
        'phone_number': phone,
        'userName': phone,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return AuthResponseModel.fromJson(data);
    } else {
      throw Exception(data['message'] ?? 'Signup failed');
    }
  }

  Future<UserModel?> getMe({required String accessToken}) async {
    try {
      final response = await _apiService.get(
        endpoint: ApiConstants.me,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final userJson = decoded['user'] ?? decoded['data'] ?? decoded;
        return UserModel.fromJson(userJson);
      }

      return null;
    } catch (_) {
      rethrow;
    }
  }

  Future<UserModel?> updateProfile({
    required String accessToken,
    required Map<String, dynamic> data,
  }) async {
    try {
      final localPath = data['profileImageLocalPath'] as String?;
      if (localPath != null && localPath.isNotEmpty) {
        final uri = Uri.parse('${ApiConstants.baseUrl1}${ApiConstants.profile}');
        debugPrint('Multipart PUT Request - Method: PUT, URL: $uri');

        final request = http.MultipartRequest('PUT', uri);
        request.headers['Authorization'] = 'Bearer $accessToken';

        // Add all fields except local path and network image
        data.forEach((key, value) {
          if (key != 'profileImageLocalPath' && key != 'profileImage' && value != null) {
            request.fields[key] = value.toString();
          }
        });

        // Add file under multiple common field keys for maximum backend compatibility (payload size is safe due to compression)
        final filename = localPath.split('/').last.split('\\').last;
        request.files.add(await http.MultipartFile.fromPath('profileImage', localPath, filename: filename));
        request.files.add(await http.MultipartFile.fromPath('profile_image', localPath, filename: filename));
        request.files.add(await http.MultipartFile.fromPath('image', localPath, filename: filename));
        request.files.add(await http.MultipartFile.fromPath('avatar', localPath, filename: filename));
        request.files.add(await http.MultipartFile.fromPath('file', localPath, filename: filename));

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        debugPrint('Multipart PUT Response - Status Code: ${streamedResponse.statusCode}');

        final contentType = response.headers['content-type'] ?? '';
        if (!contentType.contains('application/json')) {
          final preview = response.body.substring(0, response.body.length > 300 ? 300 : response.body.length);
          throw Exception('Server returned non-JSON response (${streamedResponse.statusCode}): $preview');
        }

        if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
          final decoded = jsonDecode(response.body);
          final userJson = decoded['user'] ?? decoded['data'] ?? decoded;
          return UserModel.fromJson(userJson);
        } else {
          final decoded = jsonDecode(response.body);
          throw Exception(decoded['message'] ?? decoded['error'] ?? 'Failed to upload image. (Status: ${streamedResponse.statusCode})');
        }
      } else {
        final url = '${ApiConstants.baseUrl1}${ApiConstants.profile}';
        debugPrint('JSON PUT Request - Method: PUT, URL: $url');

        final response = await _apiService.put(
          endpoint: ApiConstants.profile,
          headers: {'Authorization': 'Bearer $accessToken'},
          body: data,
        );

        debugPrint('JSON PUT Response - Status Code: ${response.statusCode}');

        final contentType = response.headers['content-type'] ?? '';
        if (!contentType.contains('application/json')) {
          final preview = response.body.substring(0, response.body.length > 300 ? 300 : response.body.length);
          throw Exception('Server returned non-JSON response (${response.statusCode}): $preview');
        }

        if (response.statusCode == 200 || response.statusCode == 201) {
          final decoded = jsonDecode(response.body);
          final userJson = decoded['user'] ?? decoded['data'] ?? decoded;
          return UserModel.fromJson(userJson);
        } else {
          final decoded = jsonDecode(response.body);
          throw Exception(decoded['message'] ?? decoded['error'] ?? 'Failed to update profile. (Status: ${response.statusCode})');
        }
      }
    } catch (_) {
      rethrow;
    }
  }

  // Future<AuthResponseModel?> refreshToken({
  //   required String refreshToken,
  // }) async {
  //   final response = await _apiService.post(
  //     endpoint: ApiConstants.refresh,
  //     body: {'refresh_token': refreshToken},
  //   );

  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);

  //     return AuthResponseModel.fromJson(data);
  //   }

  //   return null;
  // }
  Future<Map<String, dynamic>> verifyOtp({
    required String userId,
    required String otp,
  }) async {
    final response = await _apiService.post(
      endpoint: ApiConstants.verifyOtp,
      body: {'userId': userId, 'otp': otp},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    throw Exception(data['message'] ?? 'OTP verification failed.');
  }

  Future<Map<String, dynamic>?> forgotPassword({required String email}) async {
    final response = await _apiService.post(
      endpoint: ApiConstants.forgotPassword,
      body: {'email': email},
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    }
    return null;
  }

  Future<Map<String, dynamic>> resendOtp({required String userId}) async {
    final response = await _apiService.post(
      endpoint: ApiConstants.resendOtp,
      body: {'userId': userId},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    throw Exception(data['message'] ?? 'Failed to resend OTP.');
  }

  Future<Map<String, dynamic>> resetPassword({
    required String userId,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final response = await _apiService.post(
      endpoint: ApiConstants.resetPassword,
      body: {
        'userId': userId,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    throw Exception(data['message'] ?? 'Password reset failed.');
  }

  // Future<Map<String, dynamic>?> resetPassword({
  //   required String token,
  //   required String newPassword,
  // }) async {
  //   final response = await _apiService.post(
  //     endpoint: ApiConstants.resetPassword,
  //     body: {'token': token, 'new_password': newPassword},
  //   );
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     return data;
  //   }
  //   return null;
  // }

  // bro just create an auth_session_service.dart and put that there cuz its securestorage and authservice session creation.
  // Future<String?> getValidAccessToken() async {
  //   final accessToken = await _storageService.getAccessToken();

  //   if (accessToken == null) {
  //     return null;
  //   }

  //   final user = await getMe(accessToken: accessToken);

  //   if (user != null) {
  //     return accessToken;
  //   }

  //   final refreshToken1 = await _storageService.getRefreshToken();

  //   if (refreshToken1 == null) {
  //     return null;
  //   }

  //   final authResponse = await refreshToken(refreshToken: refreshToken1);

  //   if (authResponse == null) {
  //     return null;
  //   }

  //   await _storageService.saveTokens(
  //     accessToken: authResponse.accessToken,
  //     refreshToken: authResponse.refreshToken,
  //   );

  //   return authResponse.accessToken;
  // }
}
