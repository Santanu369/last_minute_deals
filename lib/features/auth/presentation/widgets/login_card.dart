import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_status.dart';
import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:lmd_app/features/auth/presentation/pages/forgot_page.dart';
import 'package:lmd_app/features/auth/presentation/pages/register_page.dart';
import 'package:lmd_app/features/auth/presentation/widgets/auth_widgets.dart';

class LoginCard extends StatefulWidget {
  const LoginCard({super.key});

  @override
  State<LoginCard> createState() => _LoginCardState();
}

class _LoginCardState extends State<LoginCard> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await context.read<AuthCubit>().login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
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
            AuthGoogleButton(
              label: 'Sign In With Google',
              onTap: () => context.read<AuthCubit>().googleLogin(),
            ),
            SizedBox(height: 16.h),
            const AuthDivider(),
            SizedBox(height: 16.h),
            AuthField(
              controller: emailController,
              hint: 'Enter your Email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) return 'Email is required';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
                  return 'Enter a valid email';
                }
                return null;
              },
            ),
            AuthField(
              controller: passwordController,
              hint: 'Enter Password',
              isPassword: true,
              validator: (value) =>
              (value ?? '').isEmpty ? 'Password is required' : null,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => ForgotPasswordCubit(),
                      child: const ForgotPage(),
                    ),
                  ),
                ),
                child: Text('Forgot Password?',
                    style: DS.ts(14, FontWeight.w600, DS.primaryBlue)),
              ),
            ),
            SizedBox(height: 24.h),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) => AuthSubmitButton(
                label: 'Log In',
                loading: authState.status == AuthStatus.loading,
                onPressed: _submit,
              ),
            ),
            SizedBox(height: 24.h),
            AuthLinkRow(
              prefix: "Don't have an account? ",
              action: 'Sign Up',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RegisterPage()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}