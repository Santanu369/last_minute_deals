import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lmd_app/core/theme/app_colors.dart';

class AppText {
  AppText._();

  static const String fontFamily = 'Inter';

  /// Global font scale applied to every .sp in the app. 1.0 = spec sizes.
  static const double fontScale = 0.9;

  // =========================
  // Headings
  // =========================

  /// H1 - Hero (30px, Weight 700) - Only for Home Hero "Find your next escape today"[cite: 1]
  static TextStyle get h1 => TextStyle(
    fontFamily: fontFamily,
    fontSize: 30.sp,
    height: 36 / 30,
    fontWeight: FontWeight.w700,
    color: AppColors.black, // Consolidated black primary[cite: 1]
  );

  /// H2 - Section Title (20px, Weight 700)[cite: 1]
  static TextStyle get h2 => TextStyle(
    fontFamily: fontFamily,
    fontSize: 20.sp,
    height: 28 / 20,
    fontWeight: FontWeight.w700,
    color: AppColors.black, // Consolidated black primary[cite: 1]
  );

  /// H3 - Card & List Title (16px, Weight 600)[cite: 1]
  static TextStyle get h3 => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
    color: AppColors.black, // Consolidated black primary[cite: 1]
  );

  // =========================
  // Body Text
  // =========================

  /// Body Regular (14px, Weight 400, Line Height 20px)[cite: 1]
  static TextStyle get body => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black, // Consolidated black primary[cite: 1]
  );

  /// Secondary Body / Description Text (14px, Weight 400)[cite: 1]
  static TextStyle get bodySecondary => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary, // Secondary color 6B7280[cite: 1]
  );

  /// Small Text (12px, Weight 500) - Location, distance, original price[cite: 1]
  static TextStyle get small => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary, // Secondary color 6B7280[cite: 1]
  );

  // =========================
  // Price Styling
  // =========================

  /// Price Highlight (16px, Weight 700)[cite: 1]
  static TextStyle get price => TextStyle(
    fontFamily: fontFamily,
    fontSize: 18.sp,
    height: 22 / 18,
    fontWeight: FontWeight.w700, // Updated weight to 700 per spec[cite: 1]
    color: AppColors.black, // Consolidated black primary[cite: 1]
  );

  /// Original Strikethrough Price (12px, Weight 500)[cite: 1]
  static TextStyle get oldPrice => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    decoration: TextDecoration.lineThrough,
  );

  // =========================
  // Buttons & Controls
  // =========================
  static TextStyle get button => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  /// Secondary Button Text ("Book Now") (14px, Weight 600)[cite: 1]
  static TextStyle get secondaryButton => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    height: 20 / 14,
    fontWeight: FontWeight.w600,
    color: AppColors.black, // Consolidated black primary[cite: 1]
  );

  // =========================
  // Badges & Chips
  // =========================
  static TextStyle get chip => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    color: AppColors.black,
  );

  /// Deal Badge Text (12px, Weight 600)[cite: 1]
  static TextStyle get dealBadge => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primary, // Uses strict E53935 red[cite: 1]
  );

  /// Rating Text (12px, Weight 600)[cite: 1]
  static TextStyle get rating => TextStyle(
    fontFamily: fontFamily,
    fontSize: 12.sp,
    height: 16 / 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primary, // Rating text must be E53935 per audit[cite: 1]
  );

  // =========================
  // Inputs
  // =========================

  static TextStyle get input => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  static TextStyle get inputHint => TextStyle(
    fontFamily: fontFamily,
    fontSize: 14.sp,
    height: 20 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: fontFamily,
    fontSize: 16.sp,
    height: 24 / 16,
    fontWeight: FontWeight.w400,
    color: AppColors.black,
  );

  // =========================
  // Dev-spec tokens (Inter everywhere)
  // =========================

  /// H1 / Section title - 18sp 700
  static TextStyle get section => TextStyle(
    fontFamily: fontFamily, fontSize: 18.sp, height: 22 / 18,
    fontWeight: FontWeight.w700, color: AppColors.textPrimary);

  /// H2 / Card title - 14sp 600
  static TextStyle get cardTitle => TextStyle(
    fontFamily: fontFamily, fontSize: 14.sp, height: 18 / 14,
    fontWeight: FontWeight.w600, color: AppColors.textPrimary);

  /// Body value - 16sp 600 (use 15sp via copyWith where spec says so)
  static TextStyle get value => TextStyle(
    fontFamily: fontFamily, fontSize: 16.sp,
    fontWeight: FontWeight.w600, color: AppColors.textPrimary);

  /// Label / overline - 10sp 600 #9CA3AF, 0.8 spacing
  static TextStyle get label => TextStyle(
    fontFamily: fontFamily, fontSize: 10.sp, letterSpacing: 0.8,
    fontWeight: FontWeight.w600, color: AppColors.textLight);

  /// Caption / location - 12sp 400 #6B7280
  static TextStyle get caption => TextStyle(
    fontFamily: fontFamily, fontSize: 12.sp,
    fontWeight: FontWeight.w400, color: AppColors.textSecondary);

  /// Badge - 11sp 600 white
  static TextStyle get badge => TextStyle(
    fontFamily: fontFamily, fontSize: 11.sp,
    fontWeight: FontWeight.w600, color: AppColors.white);

  /// Search / input hint - 15sp 400 #9CA3AF
  static TextStyle get searchHint => TextStyle(
    fontFamily: fontFamily, fontSize: 15.sp,
    fontWeight: FontWeight.w400, color: AppColors.textLight);

  /// Chip - 14sp (active 600 white / inactive 500 #6B7280)
  static TextStyle chipLabel({required bool active}) => TextStyle(
    fontFamily: fontFamily, fontSize: 14.sp,
    fontWeight: active ? FontWeight.w600 : FontWeight.w500,
    color: active ? AppColors.white : AppColors.textSecondary);

  /// Bottom nav label - 11sp 500
  static TextStyle navLabel({required bool active}) => TextStyle(
    fontFamily: fontFamily, fontSize: 11.sp, fontWeight: FontWeight.w500,
    color: active ? AppColors.textPrimary : AppColors.textLight);
}
