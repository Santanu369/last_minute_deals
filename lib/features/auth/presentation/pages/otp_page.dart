import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/app/shell/widget_tree.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/features/auth/data/services/auth_service.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_status.dart';
import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_state.dart';
import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_status.dart';
import 'package:lmd_app/features/auth/presentation/pages/new_password_page.dart';
import 'package:lmd_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:lmd_app/features/auth/presentation/widgets/otp_card.dart';
import 'package:lmd_app/features/home/presentation/cubit/home_cubit.dart';

class OtpPage extends StatefulWidget {
  final String? userId;
  final bool isRegister;
  final String? email;
  final String? password;

  const OtpPage({
    super.key,
    this.userId,
    this.isRegister = false,
    this.email,
    this.password,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final side = authSideInset(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
          listener: (context, state) {
            if (state.status == ForgotPasswordStatus.otpVerified) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<ForgotPasswordCubit>(),
                    child: const NewPasswordPage(),
                  ),
                ),
              );
            }

            if (state.status == ForgotPasswordStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? 'OTP verification failed')),
              );
            }
          },
        ),
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.authenticated) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => HomeCubit(),
                    child: const WidgetTree(),
                  ),
                ),
              );
            }

            if (state.status == AuthStatus.error && widget.isRegister) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message ?? 'OTP verification failed')),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: DS.background,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              ...authBackdrop(),
              Positioned(
                top: 120.h,
                left: side,
                child: Text('Welcome Back to your ',
                    style: DS.ts(20, FontWeight.w700, DS.textPrimary)),
              ),
              Positioned(
                top: 152.h,
                left: side,
                child: Row(
                  children: [
                    Text('Last Minutes Deal ',
                        style: DS.ts(16, FontWeight.w600, DS.textSecondary)),
                    Text('Account ', style: DS.ts(16, FontWeight.w600, DS.textPrimary)),
                  ],
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 0),
                curve: Curves.easeOut,
                left: side,
                right: side,
                bottom: keyboardHeight > 0 ? keyboardHeight - 40 : 24,
                child: OtpCard(
                  controller: otpController,
                  loading: context.watch<AuthCubit>().state.status == AuthStatus.loading,
                  onVerify: () {
                    if (otpController.text.length != 6) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
                      );
                      return;
                    }

                    if (widget.isRegister) {
                      context.read<AuthCubit>().verifyRegisterOtp(
                        userId: widget.userId ?? '',
                        otp: otpController.text.trim(),
                        email: widget.email ?? '',
                        password: widget.password ?? '',
                      );
                    } else {
                      context.read<ForgotPasswordCubit>().verifyOtp(
                        otp: otpController.text.trim(),
                      );
                    }
                  },
                  onResend: () {
                    if (widget.isRegister) {
                      AuthService().resendOtp(userId: widget.userId ?? '');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('OTP resent successfully.')),
                      );
                    } else {
                      context.read<ForgotPasswordCubit>().resendOtp();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}