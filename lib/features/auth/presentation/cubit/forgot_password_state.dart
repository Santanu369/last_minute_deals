import 'package:equatable/equatable.dart';
import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_status.dart';

class ForgotPasswordState extends Equatable {
  final ForgotPasswordStatus status;

  final String? userId;

  final DateTime? otpExpiry;

  final String? message;

  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.initial,
    this.userId,
    this.otpExpiry,
    this.message,
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    String? userId,
    DateTime? otpExpiry,
    String? message,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      otpExpiry: otpExpiry ?? this.otpExpiry,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, userId, otpExpiry, message];
}
