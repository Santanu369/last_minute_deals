import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchTile extends StatelessWidget {
  const SearchTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.trailingIcon,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final IconData trailingIcon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.h,
              decoration: BoxDecoration(
                color: const Color(0xffF3F1FF),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Icon(icon, color: const Color(0xff4D49D9), size: 24.r),
            ),

            SizedBox(width: 16.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff7A7F87),
                      letterSpacing: 1,
                    ),
                  ),

                  SizedBox(height: 5.h),

                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff222222),
                    ),
                  ),
                ],
              ),
            ),

            Icon(trailingIcon, color: const Color(0xffB6BBC2)),
          ],
        ),
      ),
    );
  }
}
