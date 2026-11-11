// import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lmd_app/bloc/details/details_cubit.dart';
// import 'package:lmd_app/bloc/home/home_cubit.dart';
// import 'package:lmd_app/bloc/home/home_state.dart';
// import 'package:lmd_app/models/hotel_details/hotel_page_request.dart';
// import 'package:lmd_app/pages/Details/details_screen.dart';

// class StayAndSave extends StatelessWidget {
//   const StayAndSave({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeCubit, HomeState>(
//       buildWhen: (previous, current) =>
//           previous.stayAndSaveListings != current.stayAndSaveListings,
//       builder: (context, state) {
//         final listings = state.stayAndSaveListings;
//         if (state.error != null && listings.isEmpty) {
//           return Center(child: Text(state.error!));
//         }

//         if (listings.isEmpty) {
//           return const SizedBox.shrink();
//         }
//         return Padding(
//           padding: const EdgeInsets.all(20.0.w),
//           child: Column(
//             children: [
//               const Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Stay & Save",
//                         style: TextStyle(
//                           fontSize: 24.sp,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                       Text("Luxury stays at pocket-friendly prices"),
//                     ],
//                   ),
//                   Text(
//                     "View All",
//                     style: TextStyle(
//                       color: Color(0xff4D49D9),
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 16.h),

//               SizedBox(
//                 height: 370.h,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: listings.length,
//                   separatorBuilder: (_, _) => const SizedBox(width: 24.w),
//                   itemBuilder: (context, index) {
//                     final stay = listings[index];

//                     return StayAndSaveCard(
//                       imageUrl: stay.images[0],
//                       title: stay.name,
//                       location: stay.city,
//                       distance: "2.5 km away",
//                       originalPrice: "₹${stay.price}",
//                       discountedPrice: 0,
//                       // "₹${(stay.priceFrom * (10000 - stay.discountbps)) ~/ 10000}",
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => BlocProvider(
//                               create: (_) => DetailsCubit(),
//                               child: DetailsScreen(
//                                 request: HotelPageRequest.defaultSearch(
//                                   hid: stay.hid,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// class StayAndSaveCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String location;
//   final String distance;
//   final String originalPrice;
//   final int discountedPrice;
//   final VoidCallback? onTap;

//   const StayAndSaveCard({
//     super.key,
//     required this.imageUrl,
//     required this.title,
//     required this.location,
//     required this.distance,
//     required this.originalPrice,
//     required this.discountedPrice,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 280.w,
//       padding: const EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(32.r),
//         gradient: const LinearGradient(
//           colors: [Color(0xffD9D9D9), Color(0xff2A0160)],
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(16.r),
//             child: Image.network(
//               imageUrl,
//               height: 192.h,
//               width: double.infinity,
//               fit: BoxFit.cover,
//               errorBuilder: (_, __, ___) {
//                 return Container(
//                   height: 192.h,
//                   color: Colors.grey.shade300,
//                   child: const Center(child: Icon(Icons.image_not_supported)),
//                 );
//               },
//             ),
//           ),

//           const SizedBox(height: 12.h),

//           Text(
//             title,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w700,
//               color: Colors.white,
//             ),
//           ),

//           const SizedBox(height: 4.h),

//           Text(
//             "$location • $distance",
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w400,
//               color: Color(0xffE6E6E6),
//             ),
//           ),

//           const SizedBox(height: 12.h),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     originalPrice,
//                     style: const TextStyle(
//                       fontSize: 12.sp,
//                       color: Color(0xffE5EBF4),
//                       decoration: TextDecoration.lineThrough,
//                     ),
//                   ),

//                   RichText(
//                     text: TextSpan(
//                       children: [
//                         TextSpan(
//                           text: "0",
//                           style: const TextStyle(
//                             fontSize: 20.sp,
//                             fontWeight: FontWeight.w800,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const TextSpan(
//                           text: "/night",
//                           style: TextStyle(
//                             fontSize: 12.sp,
//                             fontWeight: FontWeight.w500,
//                             color: Color(0xffF5F5F5),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//               InkWell(
//                 onTap: onTap,
//                 borderRadius: BorderRadius.circular(20.r),
//                 child: const CircleAvatar(
//                   radius: 20,
//                   backgroundColor: Color(0xffEDD8FB),
//                   child: Icon(
//                     Icons.arrow_forward_ios_rounded,
//                     size: 13.r,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
