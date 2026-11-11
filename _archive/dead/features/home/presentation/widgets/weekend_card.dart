// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lmd_app/bloc/details/details_cubit.dart';
// import 'package:lmd_app/bloc/home/home_cubit.dart';
// import 'package:lmd_app/bloc/home/home_state.dart';
// import 'package:lmd_app/models/hotel_details/hotel_page_request.dart';
// import 'package:lmd_app/pages/Details/details_screen.dart';

// class WeekendCard extends StatelessWidget {
//   const WeekendCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 10.w),
//       child: AspectRatio(
//         aspectRatio: 342 / 224,
//         child: BlocBuilder<HomeCubit, HomeState>(
//           buildWhen: (previous, current) =>
//               previous.weekendDeals != current.weekendDeals,
//           builder: (context, state) {
//             final weekendDeals = state.weekendDeals;
//             if (state.error != null && weekendDeals.isEmpty) {
//               return Center(child: Text(state.error!));
//             }

//             if (weekendDeals.isEmpty) {
//               return const SizedBox.shrink();
//             }

//             // if (weekendDeals.isEmpty) {
//             //   return const Center(child: CircularProgressIndicator());
//             // }
//             if (weekendDeals.isEmpty) {
//               return const SizedBox.shrink();
//             }
//             return LayoutBuilder(
//               builder: (context, constraints) {
//                 final width = constraints.maxWidth;
//                 final height = constraints.maxHeight;

//                 return Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(40.r),
//                       child: CachedNetworkImage(
//                         imageUrl:
//                             "${weekendDeals.first.images}?tr=w-$width,h-$height",
//                         width: double.infinity,
//                         height: double.infinity,
//                         fit: BoxFit.cover,
//                       ),
//                     ),

//                     Positioned.fill(
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(40.r),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                               begin: Alignment.centerLeft,
//                               end: Alignment.centerRight,
//                               colors: [
//                                 const Color(0xff6C4DFF).withValues(alpha: 0.60),
//                                 const Color(0xff6C4DFF).withValues(alpha: 0.2),
//                                 Colors.transparent,
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     Positioned(
//                       left: width * 0.05,
//                       top: height * 0.08,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10.w,
//                           vertical: 6.h,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color(0xffCBA9FF),
//                           borderRadius: BorderRadius.circular(20.r),
//                         ),
//                         child: const Text(
//                           "WEEKEND SPECIAL",
//                           style: TextStyle(
//                             color: Colors.purple,
//                             fontSize: 10.sp,
//                             fontWeight: FontWeight.w900,
//                           ),
//                         ),
//                       ),
//                     ),

//                     Positioned(
//                       left: width * 0.05,
//                       top: height * 0.25,
//                       child: const Text(
//                         "Weekend Gateway",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 24.sp,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),

//                     Positioned(
//                       left: width * 0.05,
//                       top: height * 0.42,
//                       child: const Text(
//                         "40%",
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 42.sp,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),

//                     Positioned(
//                       left: width * 0.30,
//                       top: height * 0.45,
//                       child: const Text(
//                         "OFF ON ALL\nBOOKINGS",
//                         style: TextStyle(color: Colors.white, fontSize: 13.sp),
//                       ),
//                     ),

//                     Positioned(
//                       left: width * 0.05,
//                       bottom: height * 0.08,
//                       child: GestureDetector(
//                         onTap: () {
//                           // Handle "Book Now" tap
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => BlocProvider(
//                                 create: (_) => DetailsCubit(),
//                                 child: DetailsScreen(
//                                   request: HotelPageRequest.defaultSearch(
//                                     hid: weekendDeals.first.hid,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 18.w,
//                             vertical: 12.h,
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(25.r),
//                           ),
//                           child: const Text(
//                             "Book Now",
//                             style: TextStyle(
//                               color: Color(0xff4D49D9),
//                               fontSize: 16.sp,
//                               fontWeight: FontWeight.w900,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
