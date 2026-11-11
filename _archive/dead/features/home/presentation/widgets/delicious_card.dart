import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeliciousCard extends StatelessWidget {
  const DeliciousCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(32.r),

            child: Image.asset(
              'assets/home_page/delicious.jpg',
              width: double.infinity,
              height: 220.h,
              fit: BoxFit.cover,
            ),
          ),

          // gradient overlay
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(32.r),

              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,

                    colors: [
                      Color.fromARGB(255, 161, 67, 0),
                      Color.fromARGB(255, 161, 67, 0).withAlpha(4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            left: 20,
            top: 30,
            child: Text(
              'DELICIOUS SALE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
                fontWeight: .w400,
              ),
            ),
          ),

          Positioned(
            left: 20,
            top: 50,

            child: Text(
              'UP TO 50% OFF',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Positioned(
            left: 20,
            top: 90,
            child: Text(
              'Unlock exclusive discounts on\npremium weekend',
              style: TextStyle(
                color: Color(0xCCC7D2FE),
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          Positioned(
            left: 20,
            bottom: 20,
            child: GestureDetector(
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffFFFFFF),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0.w),
                  child: Text(
                    'Book Now',
                    style: TextStyle(
                      color: Color(0xff544FEB),
                      fontSize: 16.sp,
                      fontWeight: .w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
