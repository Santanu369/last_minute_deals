import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart' show compute;

import 'package:http/http.dart' as http;
import 'package:lmd_app/core/constants/api_constants.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  final http.Client _client = http.Client();

  /// Decodes JSON off the UI thread once the payload is big enough to matter.
  static Future<dynamic> decodeJson(String body) => body.length > 20000
      ? compute(jsonDecode, body)
      : Future.value(jsonDecode(body));



  Future<http.Response> post({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,  
    // Map<String, String> data,
  }) async {
    try {
      return await _client
          .post(
            Uri.parse('${ApiConstants.baseUrl1}$endpoint'),
            headers: {'Content-Type': 'application/json', ...?headers},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timed out');
    }
  }

  Future<http.Response> put({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      return await _client
          .put(
            Uri.parse('${ApiConstants.baseUrl1}$endpoint'),
            headers: {'Content-Type': 'application/json', ...?headers},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timed out');
    }
  }

  Future<http.Response> patch({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      return await _client
          .patch(
            Uri.parse('${ApiConstants.baseUrl1}$endpoint'),
            headers: {'Content-Type': 'application/json', ...?headers},
            body: jsonEncode(body ?? const {}),
          )
          .timeout(const Duration(seconds: 15));
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timed out');
    }
  }

  Future<http.Response> delete({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    try {
      return await _client
          .delete(
            Uri.parse('${ApiConstants.baseUrl1}$endpoint'),
            headers: {'Content-Type': 'application/json', ...?headers},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 15));
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timed out');
    }
  }

 Future<http.Response> get({
  required String endpoint,
  Map<String, String>? headers,
  Map<String, String>? queryParameters,
}) async {
  try {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl1}$endpoint',
    ).replace(queryParameters: queryParameters);

    return await _client
        .get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            ...?headers,
          },
        )
        .timeout(const Duration(seconds: 15));
  } on SocketException {
    throw Exception('No internet connection');
  } on TimeoutException {
    throw Exception('Request timed out');
  }
}
}
