import 'package:flutter/foundation.dart';
import 'package:lmd_app/features/cart/data/models/add_buffet_to_cart_request.dart';
import 'package:lmd_app/features/cart/data/models/add_to_cart_request.dart';
import 'package:lmd_app/core/network/api_service.dart';
import 'package:lmd_app/core/storage/secure_storage_service.dart';
import 'package:lmd_app/core/constants/api_constants.dart';

class CartService {
  final ApiService _api = ApiService();
  final SecureStorageService _storage = SecureStorageService();

  Future<void> addToCart(AddToCartRequest request) async {
    final token = await _storage.getAccessToken();

    if (token == null) {
      throw Exception('Session expired');
    }

    final response = await _api.post(
      endpoint: ApiConstants.cartItems,
      body: request.toJson(),
      headers: {'Authorization': 'Bearer $token'},
    );

    debugPrint(response.statusCode.toString());

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }

  Future<void> addBuffetToCart(AddBuffetToCartRequest request) async {
    final response = await _api.post(
      endpoint: ApiConstants.cartItems,
      body: request.toJson(),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }
}
