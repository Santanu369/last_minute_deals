import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PerfectPlanSuggestion extends StatefulWidget {
  const PerfectPlanSuggestion({super.key});

  @override
  State<PerfectPlanSuggestion> createState() => _PerfectPlanSuggestionState();
}

class _PerfectPlanSuggestionState extends State<PerfectPlanSuggestion> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0.w),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Text(
                'Perfect For Your Plan',
                style: TextStyle(fontSize: 24.sp, fontWeight: .bold),
              ),
            ],
          ),
          SizedBox(height: 50.h),
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(20),
                child: Image.asset(
                  'assets/home_page/hero1.png',
                  width: double.infinity,
                  height: 300.h,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.r),
                    color: Color(0xffFF7346),
                  ),
                  padding: EdgeInsets.all(8.w),
                  child: Center(
                    child: Text(
                      'FEW ROOMS LEFT',
                      style: TextStyle(fontSize: 10.sp, fontWeight: .bold),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 50,
                right: 20,
                child: Text(
                  '50% OFF TODAY',
                  style: TextStyle(fontSize: 10.sp, fontWeight: .bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Text('Rustic Wooden Hut', style: TextStyle(fontSize: 20.sp)),
              Spacer(),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  color: Color(0xff20201F),
                ),
                child: Row(
                  children: [
                    Icon(Icons.star, color: Color(0xffFF7346), size: 13.r),
                    Text(
                      '4.6',
                      style: TextStyle(fontSize: 14.sp, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(Icons.location_on_sharp),
              Text('Bali, Indonesia • Beachfront'),
            ],
          ),
        ],
      ),
    );
  }
}
