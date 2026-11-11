import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:lmd_app/features/booking/data/models/prebook_request.dart';
import 'package:lmd_app/features/booking/data/models/prebook_response.dart';
import 'package:lmd_app/core/network/api_service.dart';
import 'package:lmd_app/core/storage/secure_storage_service.dart';
import 'package:lmd_app/core/constants/api_constants.dart';

class RatehawkBookingService {
  final ApiService _apiService = ApiService();
  final SecureStorageService _secureStorage = SecureStorageService();

  Future<PrebookResponse> prebook({required PrebookRequest request}) async {
    final accessToken = await _secureStorage.getAccessToken();
    final response = await _apiService.post(
      headers: {'Authorization': 'Bearer $accessToken'},
      endpoint: ApiConstants.prebook,
      body: request.toJson(),
    );
    debugPrint('Prebook response: ${response.body}');
    if (response.statusCode != 200) {
      throw Exception(
        'Prebook failed: ${response.statusCode}\n${response.body}',
      );
    }

    return PrebookResponse.fromJson(jsonDecode(response.body));
  }
}
