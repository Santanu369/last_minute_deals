import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Last Minutes Deal – Design System tokens (from the design-system PDF).
/// Raw design values; `DS.ts` / `DS.cardDecoration` / `DSPrimaryButton` apply .w/.h/.r/.sp.
class DS {
  DS._();

  // ---------------- Font ----------------
  static const String fontFamily = 'Inter';

  // ---------------- Colors ----------------
  static const Color background = Color(0xFFF5F6FA);
  static const Color card = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFEFEFF2);
  static const Color borderMedium = Color(0xFFE5E7EB);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color primaryBlue = Color(0xFF3B5BFF);
  static const Color primaryDark = Color(0xFF2F4EFF);
  static const Color accentRed = Color(0xFFFF2D55);
  static const Color accentLight = Color(0xFFFFE4E8);
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFE6F6ED);
  static const Color starYellow = Color(0xFFFFB800);
  static const Color chipBg = Color(0xFFF0F1F5);

  // ---------------- Radius ----------------
  static const double radiusCard = 20;
  static const double radiusInput = 12;
  static const double radiusButton = 16;
  static const double radiusPill = 999;
  static const double radiusHero = 24;

  // ---------------- Layout ----------------
  static const double maxWidth = 420;
  static const double screenPadding = 16;

  // ---------------- Shadows ----------------
  // 0 4px 20px rgba(0,0,0,0.06)
  static const List<BoxShadow> shadowCard = [
    BoxShadow(color: Color(0x0F000000), offset: Offset(0, 4), blurRadius: 20),
  ];

  // 0 4px 12px rgba(59,91,255,0.3)
  static const List<BoxShadow> shadowButton = [
    BoxShadow(color: Color(0x4D3B5BFF), offset: Offset(0, 4), blurRadius: 12),
  ];

  // ---------------- Helpers ----------------
  static TextStyle ts(double size, FontWeight weight, Color color,
      {double? height, double? letterSpacing}) =>
      TextStyle(
        fontFamily: fontFamily,
        fontSize: size.sp,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
      );

  /// Uppercase label style: 11px / Medium / tertiary / 0.08em tracking.
  static TextStyle label({Color color = textTertiary}) =>
      ts(11, FontWeight.w500, color, letterSpacing: 11.sp * 0.08);

  static BoxDecoration cardDecoration({double radius = radiusCard}) => BoxDecoration(
    color: card,
    borderRadius: BorderRadius.circular(radius.r),
    border: Border.all(color: borderLight),
    boxShadow: shadowCard,
  );
}

/// Primary CTA: blue, 16px radius, blue glow shadow.
class DSPrimaryButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final double height;

  const DSPrimaryButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.height = 48,
  });

  @override
  Widget build(BuildContext context) => Container(
    height: height.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(DS.radiusButton.r),
      boxShadow: DS.shadowButton,
    ),
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: DS.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: Size(0, height.h),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DS.radiusButton.r),
        ),
      ),
      child: child,
    ),
  );
}