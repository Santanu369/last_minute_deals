import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/features/auth/presentation/cubit/forgot_password_cubit.dart';
import 'package:lmd_app/features/auth/presentation/widgets/auth_widgets.dart';

class NewPasswordCard extends StatefulWidget {
  const NewPasswordCard({super.key});

  @override
  State<NewPasswordCard> createState() => _NewPasswordCardState();
}

class _NewPasswordCardState extends State<NewPasswordCard> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    context.read<ForgotPasswordCubit>().resetPassword(
      newPassword: _newPasswordController.text.trim(),
      confirmPassword: _confirmPasswordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.sizeOf(context).height;
    final body = DS.ts(14, FontWeight.w400, DS.textSecondary);

    return Container(
      height: h * .75,
      width: double.infinity,
      decoration: BoxDecoration(
        color: DS.card,
        borderRadius: BorderRadius.vertical(top: Radius.circular(DS.radiusHero.r)),
        border: Border.all(color: DS.borderLight),
        boxShadow: DS.shadowCard,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(DS.screenPadding.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 10.h),
              const AuthBackRow(),
              SizedBox(height: 16.h),
              Text('New Password',
                  textAlign: TextAlign.center,
                  style: DS.ts(20, FontWeight.w700, DS.textPrimary)),
              SizedBox(height: 8.h),
              Text('Enter the code &', textAlign: TextAlign.center, style: body),
              Text(' write your new password', textAlign: TextAlign.center, style: body),
              SizedBox(height: 24.h),

              AuthField(
                controller: _newPasswordController,
                hint: 'New Password',
                keyboardType: TextInputType.visiblePassword,
                validator: (value) =>
                (value?.trim() ?? '').isEmpty ? 'newPassword is required' : null,
              ),
              AuthField(
                controller: _confirmPasswordController,
                hint: 'Confirm New Password',
                validator: (value) {
                  final confirmPassword = value;
                  if (confirmPassword!.isEmpty) return 'confirmPassword is required';
                  if (_newPasswordController.text != confirmPassword) {
                    return "confirm password doesn't match";
                  }
                  return null;
                },
              ),
              SizedBox(height: 12.h),

              AuthSubmitButton(label: 'Confirm Password', onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}