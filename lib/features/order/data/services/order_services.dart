import 'dart:convert';

import 'package:lmd_app/features/order/data/models/create_order_request.dart';
import 'package:lmd_app/features/order/data/models/create_order_response.dart';
import 'package:lmd_app/core/network/api_service.dart';
import 'package:lmd_app/core/storage/secure_storage_service.dart';
import 'package:lmd_app/core/constants/api_constants.dart';

class OrderService {
  final ApiService _api = ApiService();
  final SecureStorageService _storageService = SecureStorageService();

  Future<CreateOrderResponse> createOrder(CreateOrderRequest request) async {
    final accessToken = await _storageService.getAccessToken();

    if (accessToken == null) {
      throw Exception('Session expired. Please login again.');
    }

    final response = await _api.post(
      endpoint: ApiConstants.createOrderFromCart,
      body: request.toJson(),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.body);
    }

    return CreateOrderResponse.fromJson(jsonDecode(response.body));
  }
}
