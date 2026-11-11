import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_state.dart';
import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_status.dart';
import 'package:lmd_app/features/auth/presentation/pages/login_page.dart';
import 'package:lmd_app/features/auth/presentation/widgets/auth_widgets.dart';

class ForgotCard extends StatefulWidget {
  const ForgotCard({super.key});

  @override
  State<ForgotCard> createState() => _ForgotCardState();
}

class _ForgotCardState extends State<ForgotCard> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    await context.read<ForgotPasswordCubit>().forgotPassword(
      email: _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthCardShell(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AuthBackRow(),
            SizedBox(height: 24.h),
            AuthField(
              controller: _emailController,
              hint: 'Enter your email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) return 'Email is required';
                if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(email)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: 8.h),
            BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
              builder: (context, state) => AuthSubmitButton(
                label: 'Send Reset Code',
                loading: state.status == ForgotPasswordStatus.loading,
                onPressed: _submit,
              ),
            ),
            SizedBox(height: 24.h),
            AuthLinkRow(
              prefix: 'Remember your password? ',
              action: 'Log In',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}