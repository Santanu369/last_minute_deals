import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HotelFeatureItem extends StatelessWidget {
  const HotelFeatureItem({
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
    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xffEEF2FF),
            child: Icon(icon, color: const Color(0xff4D49D9)),
          ),
          SizedBox(height: 9.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xff767676), fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
