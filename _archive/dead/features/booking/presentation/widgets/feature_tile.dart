import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 34.w,
          height: 34.h,
          decoration: BoxDecoration(
            color: const Color(0xFFF1EEFF),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 18.r,
            color: const Color(0xFF4E46F8),
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13.sp
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10.sp,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}