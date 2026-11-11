import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/features/auth/presentation/widgets/auth_widgets.dart';

class OtpCard extends StatelessWidget {
  const OtpCard({
    super.key,
    required this.controller,
    required this.onVerify,
    required this.onResend,
    this.loading = false,
  });

  final TextEditingController controller;
  final VoidCallback onVerify;
  final VoidCallback onResend;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return AuthCardShell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AuthBackRow(),
          SizedBox(height: 16.h),
          Text('OTP Verification', style: DS.ts(16, FontWeight.w600, DS.textPrimary)),
          SizedBox(height: 8.h),
          Text(
            'Enter the 6-digit verification code sent to your email.',
            style: DS.ts(14, FontWeight.w400, DS.textSecondary, height: 20 / 14),
          ),
          SizedBox(height: 16.h),

          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 6,
            style: DS.ts(20, FontWeight.w600, DS.textPrimary, letterSpacing: 12),
            decoration: authInputDecoration(hint: '••••••').copyWith(
              counterText: '',
              hintStyle: DS.ts(20, FontWeight.w400, DS.textTertiary, letterSpacing: 12),
              contentPadding: EdgeInsets.symmetric(vertical: 12.h),
            ),
          ),
          SizedBox(height: 24.h),

          AuthSubmitButton(
            label: 'Verify OTP',
            loading: loading,
            onPressed: loading ? () {} : onVerify,
          ),
          SizedBox(height: 8.h),

          Center(
            child: TextButton(
              onPressed: loading ? null : onResend,
              style: TextButton.styleFrom(foregroundColor: DS.primaryBlue),
              child: Text('Resend OTP', style: DS.ts(14, FontWeight.w700, DS.primaryBlue)),
            ),
          ),
        ],
      ),
    );
  }
}