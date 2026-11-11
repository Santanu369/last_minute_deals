import 'package:lmd_app/features/auth/data/models/user_model.dart';

// class AuthResponseModel {
//   final String accessToken;
//   final String refreshToken;
//   final UserModel user;

//   AuthResponseModel({
//     required this.accessToken,
//     required this.refreshToken,
//     required this.user,
//   });

//   factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
//     return AuthResponseModel(
//       accessToken: json['access_token'] ?? '',
//       refreshToken: json['refresh_token'] ?? '',
//       user: UserModel.fromJson(json['user']),
//     );
//   }
// }
class AuthResponseModel {
  final bool success;
  final String message;
  final String token;
  final UserModel user;

  const AuthResponseModel({
    required this.success,
    required this.message,
    required this.token,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] ?? json['data'] ?? {};

    return AuthResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'] ?? userJson['token'] ?? '',
      user: UserModel.fromJson(userJson),
    );
  }
}
