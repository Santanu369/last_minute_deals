import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HotelSectionTitle extends StatelessWidget {
  const HotelSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.onViewAll,
    this.padding,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onViewAll;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff1D1D1D),
                    height: 1.4,
                  ),
                ),
              ),

              if (onViewAll != null)
                InkWell(
                  onTap: onViewAll,
                  child: Text(
                    'VIEW ALL',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.6,
                      color: Color(0xffFF3B7F),
                    ),
                  ),
                ),
            ],
          ),

          if (subtitle != null) ...[
            SizedBox(height: 4.h),
            Text(
              subtitle!,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Color(0xff535353),
                height: 1.33,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
