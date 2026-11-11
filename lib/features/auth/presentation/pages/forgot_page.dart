import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_state.dart';
import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_status.dart';
import 'package:lmd_app/features/auth/presentation/pages/otp_page.dart';
import 'package:lmd_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:lmd_app/features/auth/presentation/widgets/forgot_card.dart';

class ForgotPage extends StatefulWidget {
  const ForgotPage({super.key});

  @override
  State<ForgotPage> createState() => _ForgotPageState();
}

class _ForgotPageState extends State<ForgotPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.otpSent) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<ForgotPasswordCubit>(),
                child: const OtpPage(),
              ),
            ),
          );
        }

        if (state.status == ForgotPasswordStatus.error) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message ?? '')));
        }
      },
      child: const AuthPageLayout(
        title: 'Forgot Password',
        subtitle: 'Enter your email to receive a code to reset password',
        card: ForgotCard(),
      ),
    );
  }
}