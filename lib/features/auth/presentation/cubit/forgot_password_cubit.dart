import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:lmd_app/features/auth/data/services/auth_service.dart';

import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_state.dart';
import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_status.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(const ForgotPasswordState());

  final AuthService _authService = AuthService();

  String _cleanError(Object e) {
    return e.toString().replaceFirst('Exception: ', '');
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      emit(state.copyWith(status: ForgotPasswordStatus.loading, message: null));

      final response = await _authService.forgotPassword(email: email);

      final data = response!['data'];

      emit(
        state.copyWith(
          status: ForgotPasswordStatus.otpSent,
          userId: data['userId'],
          otpExpiry: DateTime.tryParse(data['otpExpiry']),
          message: response['message'],
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          message: _cleanError(e),
        ),
      );
    }
  }

  Future<void> verifyOtp({required String otp}) async {
    try {
      emit(state.copyWith(status: ForgotPasswordStatus.loading, message: null));

      await _authService.verifyOtp(userId: state.userId!, otp: otp);

      emit(state.copyWith(status: ForgotPasswordStatus.otpVerified));
    } catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          message: _cleanError(e),
        ),
      );
    }
  }

  Future<void> resendOtp() async {
    try {
      emit(state.copyWith(status: ForgotPasswordStatus.loading, message: null));

      await _authService.resendOtp(userId: state.userId!);

      emit(
        state.copyWith(
          status: ForgotPasswordStatus.otpSent,
          message: 'OTP resent successfully.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          message: _cleanError(e),
        ),
      );
    }
  }

  Future<void> resetPassword({
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      emit(state.copyWith(status: ForgotPasswordStatus.loading, message: null));

      await _authService.resetPassword(
        userId: state.userId!,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      emit(
        state.copyWith(
          status: ForgotPasswordStatus.passwordReset,
          message: 'Password changed successfully.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: ForgotPasswordStatus.error,
          message: _cleanError(e),
        ),
      );
    }
  }
}
