import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lmd_app/core/theme/app_colors.dart';
import 'package:lmd_app/core/constants/app_images.dart';
// import '../model/hotel_stat_model.dart';
// import 'hotel_hero_stat.dart';

class HotelHero extends StatelessWidget {
  const HotelHero({
    super.key,
    required this.height,
    required this.leadingText,
    required this.highlightText,
    this.trailingText = '',
    required this.subtitle,
    // this.stats,
  });

  final double height;

  /// White text before highlight
  final String leadingText;

  /// Pink text
  final String highlightText;

  /// White text after highlight (optional)
  final String trailingText;

  /// Subtitle
  final String subtitle;

  // List<HeroStatModel> stats;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 256.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppImages.HotelHeroImage, fit: BoxFit.cover),

          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.1),
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
          ),

          Positioned(
            left: 24,
            right: 24,
            top: 20,
            bottom: 10,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Live Last-Minute Deals in Pune & Lonavala
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.26, // equivalent to 38px line-height
                      ),
                      children: [
                        TextSpan(text: leadingText),
                        TextSpan(
                          text: highlightText,
                          style: const TextStyle(color: AppColors.primary),
                        ),
                        TextSpan(text: trailingText),
                      ],
                    ),
                  ),

                  SizedBox(height: 8.h),

                  /// Hotels • Villas • Camping | Book Today, Stay Today
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      height: 1.43, // equivalent to 20px line-height
                    ),
                  ),

                  SizedBox(height: 12.h),

                  /// Stat Overlay Blur Blocks
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatOverlayBlock('🏢', '77+ PROP'),
                      SizedBox(width: 16.w),
                      _buildStatOverlayBlock('📅', '4,000+ BOOKINGS'),
                      SizedBox(width: 16.w),
                      _buildStatOverlayBlock('🏷️', '70% SAVINGS'),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildStatOverlayBlock(String emoji, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 31.w,
          height: 44.h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.center,
          child: Text(
            emoji,
            style: TextStyle(
              fontSize: 20.sp,
              height: 1.4,
              fontFamily: 'Liberation Sans',
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
            height: 1.5,
            color: Colors.white,
            letterSpacing: 0.25,
          ),
        ),
      ],
    );
  }
}
