import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_state.dart';
import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_status.dart';
import 'package:lmd_app/features/auth/presentation/pages/login_page.dart';
import 'package:lmd_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:lmd_app/features/auth/presentation/widgets/new_password_card.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordCubit, ForgotPasswordState>(
      listener: (context, state) {
        if (state.status == ForgotPasswordStatus.passwordReset) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Password changed successfully')),
          );

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
          );
        }

        if (state.status == ForgotPasswordStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Failed to reset password')),
          );
        }
      },
      child: Scaffold(
        backgroundColor: DS.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.sizeOf(context).height,
              child: Stack(
                children: [
                  ...authBackdrop(),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: DS.maxWidth),
                        child: const NewPasswordCard(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}