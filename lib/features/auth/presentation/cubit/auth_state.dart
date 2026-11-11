import 'package:equatable/equatable.dart';

import 'package:lmd_app/features/auth/data/models/user_model.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_status.dart';

class AuthState extends Equatable {
  final AuthStatus status;
  final UserModel? user;
  final String? message;
  final String? errorCode;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.message,
    this.errorCode,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    String? message,
    String? errorCode,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      message: message,
      errorCode: errorCode,
    );
  }

  @override
  List<Object?> get props => [
        status,
        user,
        message,
        errorCode,
      ];
}