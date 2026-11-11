import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_status.dart';
import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:lmd_app/features/auth/presentation/pages/login_page.dart';
import 'package:lmd_app/features/auth/presentation/pages/otp_page.dart';
import 'package:lmd_app/features/auth/presentation/widgets/auth_widgets.dart';

class RegisterCard extends StatefulWidget {
  const RegisterCard({super.key});

  @override
  State<RegisterCard> createState() => _RegisterCardState();
}

class _RegisterCardState extends State<RegisterCard> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _openUrl(String url, String name) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $name');
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await context.read<AuthCubit>().signup(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      phone: phoneController.text.trim(),
    );

    if (context.mounted && context.read<AuthCubit>().state.status == AuthStatus.success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => ForgotPasswordCubit(),
            child: OtpPage(
              userId: context.read<AuthCubit>().state.user?.id,
              isRegister: true,
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            ),
          ),
        ),
      );
    }
  }

  Widget _link(String text, String url, String name) => GestureDetector(
    onTap: () => _openUrl(url, name),
    child: Text(
      text,
      style: DS.ts(12, FontWeight.w600, DS.primaryBlue).copyWith(
        decoration: TextDecoration.underline,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final legal = DS.ts(12, FontWeight.w400, DS.textSecondary);

    return AuthCardShell(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthGoogleButton(
              label: 'Sign Up With Google',
              onTap: () => context.read<AuthCubit>().googleLogin(),
            ),
            SizedBox(height: 16.h),
            const AuthDivider(),
            SizedBox(height: 16.h),

            // First Name & Last Name
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AuthField(
                    controller: firstNameController,
                    hint: 'First Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) return 'First name is required';
                      if (value.length < 2) return 'Min 2 chars';
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: AuthField(
                    controller: lastNameController,
                    hint: 'Last Name',
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Last name is required'
                        : null,
                  ),
                ),
              ],
            ),
            AuthField(
              controller: emailController,
              hint: 'Enter your Email',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Email is required';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            AuthField(
              controller: phoneController,
              hint: 'Enter Phone Number',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Phone number is required';
                if (value.trim().length < 8) return 'Enter a valid phone number';
                return null;
              },
            ),
            AuthField(
              controller: passwordController,
              hint: 'Enter Password',
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Password is required';
                if (value.length < 8) return 'Password must be at least 8 characters';
                return null;
              },
            ),
            SizedBox(height: 24.h),

            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, authState) => AuthSubmitButton(
                label: 'Sign Up',
                loading: authState.status == AuthStatus.loading,
                onPressed: _submit,
              ),
            ),
            SizedBox(height: 16.h),

            // Terms & Conditions
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text('Signing up means you agree to the ',
                    textAlign: TextAlign.center, style: legal),
                _link('Privacy Policy', 'https://lastminutessdeal.com/privacy',
                    'Privacy Policy'),
                Text(' and ', style: legal),
                _link('Terms of Service', 'https://lastminutessdeal.com/terms',
                    'Terms of Service'),
              ],
            ),
            SizedBox(height: 24.h),

            AuthLinkRow(
              prefix: 'Already have an account? ',
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