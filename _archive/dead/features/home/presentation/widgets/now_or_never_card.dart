// import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// class NoworneverCard extends StatefulWidget {
//   const NoworneverCard({super.key});

//   @override
//   State<NoworneverCard> createState() => _NoworneverCardState();
// }

// class _NoworneverCardState extends State<NoworneverCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.only(top: 40.h, right: 24.w, bottom: 24.h, left: 24.w),
//       decoration: BoxDecoration(
//         color: Color(0xff2E3337),
//         borderRadius: BorderRadius.circular(32.r),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Now or Never",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 18.sp,
//                   letterSpacing: 0,
//                   height: 1.5,
//                   color: Color(0xffFFFFFF),
//                 ),
//               ),
//               Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16.r),
//                       color: Color(0xffFFFFFF).withValues(alpha: 0.1),
//                     ),
//                     child: BasicTextStyle(
//                       title: "02",
//                       weight: FontWeight.w400,
//                       size: 14.r,
//                       color: Color(0xffFFFFFF),
//                       spacing: 0,
//                       height: 1.3,
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   BasicTextStyle(
//                     title: ":",
//                     weight: FontWeight.w400,
//                     size: 16.r,
//                     spacing: 0,
//                     color: Color(0xffffffff).withValues(alpha: 0.5),
//                     height: 1.5,
//                   ),
//                   SizedBox(width: 8.w),
//                   Container(
//                     padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16.r),
//                       color: Color(0xffFFFFFF).withValues(alpha: 0.1),
//                     ),
//                     child: BasicTextStyle(
//                       title: "45",
//                       weight: FontWeight.w400,
//                       size: 14.r,
//                       color: Color(0xffFFFFFF),
//                       spacing: 0,
//                       height: 1.3,
//                     ),
//                   ),
//                   SizedBox(width: 8.w),
//                   BasicTextStyle(
//                     title: ":",
//                     weight: FontWeight.w400,
//                     size: 16.r,
//                     spacing: 0,
//                     color: Color(0xffffffff).withValues(alpha: 0.5),
//                     height: 1.5,
//                   ),
//                   SizedBox(width: 8.w),
//                   Container(
//                     padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(16.r),
//                       color: Color(0xffFFFFFF).withValues(alpha: 0.1),
//                     ),
//                     child: BasicTextStyle(
//                       title: "18",
//                       weight: FontWeight.w400,
//                       size: 14.r,
//                       color: Color(0xffFFFFFF),
//                       spacing: 0,
//                       height: 1.3,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           SizedBox(height: 24.h),
//           Container(
//             padding: EdgeInsets.all(16.w),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16.r),
//               border: Border.all(
//                 width: 1,
//                 color: Color(0xffFFFFFF).withValues(alpha: 0.1),
//               ),
//               color: Color(0xffFFFFFF).withValues(alpha: 0.05),
//             ),
//             child: Row(
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(48.r),
//                   child: Image.asset(AppImages.nowOrNever),
//                 ),
//                 SizedBox(width: 16.w),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     BasicTextStyle(
//                       title: "Tonight only",
//                       weight: FontWeight.w700,
//                       size: 10.r,
//                       spacing: 1,
//                       color: Color(0xffCBA9FF),
//                       height: 1.5,
//                     ),
//                     Text(
//                       "Triangle Pine \nTent",
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 16.sp,
//                         letterSpacing: 0,
//                         height: 1.2,
//                         color: Color(0xffFFFFFF),
//                       ),
//                     ),
//                     BasicTextStyle(
//                       title: "Swiss, Alps",
//                       weight: FontWeight.w400,
//                       size: 12.r,
//                       spacing: 0,
//                       color: Color(0xffffffff).withValues(alpha: 0.6),
//                       height: 1.2,
//                     ),
//                     Container(
//                       padding: EdgeInsets.only(top: 8.h, right: 0),
//                       child: BasicTextStyle(
//                         title: "₹7,000",
//                         weight: FontWeight.w800,
//                         size: 18.r,
//                         spacing: 0,
//                         color: Color(0xffffffff),
//                         height: 1.5,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
