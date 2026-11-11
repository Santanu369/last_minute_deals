import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HotelHeroStat extends StatelessWidget {
  const HotelHeroStat({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: Colors.white, size: 20.r),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16.sp,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: .8),
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: .5,
            ),
          ),
        ],
      ),
    );
  }
}
