import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentbooksSection extends StatefulWidget {
  const RecentbooksSection({super.key});

  @override
  State<RecentbooksSection> createState() => _RecentbooksSectionState();
}

class _RecentbooksSectionState extends State<RecentbooksSection> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0.w),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          // Title row
          Row(
            children: [
              Text(
                'Recent Bookings',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontFamily: '42dot Sans',
                  fontWeight: FontWeight.w500,
                ),
              ),

              Spacer(),

              Text(
                'View all',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Color(0xff4D49D9),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20.r)),

              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(3, 3),
                ),
              ],
            ),

            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    bottomLeft: Radius.circular(20.r),
                  ),

                  child: Image.asset(
                    'assets/home_page/hero.png',
                    width: 150.w,
                    height: 140.h,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(width: 10.w),

                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: .start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Palacio Villa',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 2),

                      Text(
                        'Santorini, Greece • 4.2 km away',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Color(0xff767676),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Align(
                        alignment: AlignmentGeometry.bottomLeft,
                        child: Text(
                          'Check-in: May 16, 2026',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Color(0xff767676),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.verified, color: Color(0xff19B504)),
                          SizedBox(width: 5.w),
                          Text(
                            'COMPLETED',
                            style: TextStyle(
                              color: Color(0xff19B504),
                              fontSize: 12.sp,
                              fontWeight: .w700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
