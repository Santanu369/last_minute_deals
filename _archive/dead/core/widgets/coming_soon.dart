import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lmd_app/core/theme/basic_text_style.dart';

class ComingSoon extends StatelessWidget {
  const ComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 150,
                  maxWidth: 300
                ),
                child: SvgPicture.asset('assets/comingSoon/line1.svg',width: 150.w,))),
            Positioned(
              top: 0,
              right: 0,
              child: ConstrainedBox(
                 constraints: BoxConstraints(
                  minWidth: 150,
                  maxWidth: 300
                 ),
                child: SvgPicture.asset('assets/comingSoon/line2.svg',width: 150.w,))),
            Positioned(
              top: 0,
              right: 0,
              child: ConstrainedBox(
                 constraints: BoxConstraints(
                  minWidth: 165,
                  maxWidth: 300
                 ),
                child: SvgPicture.asset('assets/comingSoon/line3.svg',width: 165.w,))),
                Positioned(
                  top: 20,
                  left: 18,
                  child: SvgPicture.asset('assets/comingSoon/lmdLogo.svg',height: 37.h,width: 45.w,)),
                  Padding(
                    padding: EdgeInsets.all(8.0.w),
                    child: Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: BasicTextStyle(title: 'Coming Soon'.toUpperCase(), weight: .w700, size: 12.r,height: 1.22,spacing: -(8/100 * 7),color: Color(0xff000000),)),
                    ),
                  )
         ,Center(
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 53.0.w,vertical: 10.h),
                child: SvgPicture.asset('assets/comingSoon/dailyDealsComingSoon.svg',),
              ),
              Positioned(
                bottom: 9,
                right: 0,
                child: SvgPicture.asset('assets/comingSoon/line4.svg',),),
              Positioned(
                bottom: 0,
                right: 0,
                child: SvgPicture.asset('assets/comingSoon/line5.svg',),)
            ],
          )
          ),
          Positioned(
            left: 14,
            bottom: 0,
            child: SvgPicture.asset('assets/comingSoon/GroupAnimates.svg',width: 120.w,height: 180.h,))
          ],
        ),
      ),
    );
  }
}