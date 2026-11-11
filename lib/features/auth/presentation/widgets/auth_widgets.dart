import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';

/// Shared building blocks for the auth screens (login, register, forgot, OTP, new password).

/// Horizontal inset that keeps content inside the 420px design-system wrapper.
double authSideInset(BuildContext context) => math.max(
  DS.screenPadding.w,
  (MediaQuery.sizeOf(context).width - DS.maxWidth) / 2,
);

/// Decorative corner SVGs, tinted with the primary blue.
List<Widget> authBackdrop() {
  final filter = ColorFilter.mode(DS.primaryBlue.withValues(alpha: 0.12), BlendMode.srcIn);
  return [
    Positioned(
      left: 0,
      top: 0,
      child: SvgPicture.asset('assets/imgs/Frame 190.svg', colorFilter: filter),
    ),
    Positioned(
      right: 0,
      top: 20,
      child: SvgPicture.asset('assets/imgs/Frame 191.svg', colorFilter: filter),
    ),
  ];
}

InputDecoration authInputDecoration({required String hint, Widget? suffixIcon}) {
  OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(DS.radiusInput.r),
    borderSide: BorderSide(color: c, width: w),
  );

  return InputDecoration(
    isDense: true,
    hintText: hint,
    hintStyle: DS.ts(14, FontWeight.w400, DS.textTertiary, height: 1.4),
    errorStyle: DS.ts(11, FontWeight.w400, DS.accentRed, height: 1.0),
    contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
    filled: true,
    fillColor: DS.card,
    suffixIcon: suffixIcon,
    border: border(DS.borderMedium),
    enabledBorder: border(DS.borderMedium),
    focusedBorder: border(DS.primaryBlue, 1.5),
    errorBorder: border(DS.accentRed),
    focusedErrorBorder: border(DS.accentRed, 1.5),
  );
}

/// Full-screen layout: corner art, title + subtitle on top, card pinned to the bottom.
class AuthPageLayout extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget card;

  const AuthPageLayout({
    super.key,
    required this.title,
    required this.subtitle,
    required this.card,
  });

  @override
  Widget build(BuildContext context) {
    final side = authSideInset(context);

    return Scaffold(
      backgroundColor: DS.background,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    ...authBackdrop(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 80.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: side),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: DS.ts(20, FontWeight.w700, DS.textPrimary)),
                              SizedBox(height: 8.h),
                              Text(subtitle,
                                  style: DS.ts(14, FontWeight.w400, DS.textSecondary)),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: side, vertical: 16.h),
                          child: card,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthCardShell extends StatelessWidget {
  final Widget child;
  const AuthCardShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    decoration: DS.cardDecoration(),
    padding: EdgeInsets.all(DS.screenPadding.w),
    child: child,
  );
}

class AuthBackRow extends StatelessWidget {
  const AuthBackRow({super.key});

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.centerLeft,
    child: InkWell(
      onTap: () => Navigator.pop(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_back, size: 20.r, color: DS.textSecondary),
          SizedBox(width: 8.w),
          Text('Back', style: DS.ts(14, FontWeight.w500, DS.textSecondary)),
        ],
      ),
    ),
  );
}

/// 48px input with 28px reserved below for the validation message.
class AuthField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final String? Function(String?) validator;
  final TextInputType? keyboardType;
  final bool isPassword;

  const AuthField({
    super.key,
    required this.controller,
    required this.hint,
    required this.validator,
    this.keyboardType,
    this.isPassword = false,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 76.h,
    child: Align(
      alignment: Alignment.topCenter,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPassword && !_visible,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        style: DS.ts(14, FontWeight.w400, DS.textPrimary, height: 1.4),
        decoration: authInputDecoration(
          hint: widget.hint,
          suffixIcon: widget.isPassword
              ? InkWell(
            onTap: () => setState(() => _visible = !_visible),
            child: Icon(
              _visible ? Icons.visibility : Icons.visibility_off,
              color: DS.textSecondary,
              size: 20.r,
            ),
          )
              : null,
        ),
      ),
    ),
  );
}

class AuthGoogleButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const AuthGoogleButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => Container(
    height: 48.h,
    decoration: BoxDecoration(
      color: DS.card,
      borderRadius: BorderRadius.circular(DS.radiusButton.r),
      border: Border.all(color: DS.borderMedium),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(DS.radiusButton.r),
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/icons/google.png', width: 24.w, height: 24.w),
            SizedBox(width: 12.w),
            Text(label, style: DS.ts(14, FontWeight.w600, DS.textPrimary)),
          ],
        ),
      ),
    ),
  );
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(child: Divider(thickness: 1, color: DS.borderLight)),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Text('or', style: DS.ts(14, FontWeight.w400, DS.textTertiary)),
      ),
      const Expanded(child: Divider(thickness: 1, color: DS.borderLight)),
    ],
  );
}

/// Full-width primary CTA (56px) with an inline loading state.
class AuthSubmitButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const AuthSubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: DSPrimaryButton(
      height: 56,
      onPressed: onPressed,
      child: loading
          ? SizedBox(
        width: 20.r,
        height: 20.r,
        child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      )
          : Text(label, style: DS.ts(16, FontWeight.w600, Colors.white)),
    ),
  );
}

/// "Already have an account?  Log In" style row.
class AuthLinkRow extends StatelessWidget {
  final String prefix;
  final String action;
  final VoidCallback onTap;

  const AuthLinkRow({super.key, required this.prefix, required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) => Wrap(
    alignment: WrapAlignment.center,
    children: [
      Text(prefix, style: DS.ts(14, FontWeight.w400, DS.textSecondary)),
      InkWell(
        onTap: onTap,
        child: Text(action, style: DS.ts(14, FontWeight.w700, DS.primaryBlue)),
      ),
    ],
  );
}