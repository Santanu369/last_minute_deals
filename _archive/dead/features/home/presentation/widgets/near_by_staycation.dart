// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lmd_app/bloc/details/details_cubit.dart';
// import 'package:lmd_app/bloc/home/home_cubit.dart';
// import 'package:lmd_app/bloc/home/home_state.dart';
// import 'package:lmd_app/models/hotel_details/hotel_page_request.dart';
// import 'package:lmd_app/pages/Details/details_screen.dart';

// class NearByStaycation extends StatefulWidget {
//   const NearByStaycation({super.key});

//   @override
//   State<NearByStaycation> createState() => _NearByStaycationState();
// }

// class _NearByStaycationState extends State<NearByStaycation> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<HomeCubit, HomeState>(
//       buildWhen: (previous, current) =>
//           previous.nearbyListings != current.nearbyListings,
//       builder: (context, state) {
//         final listings = state.nearbyListings;
//         if (state.error != null && listings.isEmpty) {
//           return Center(child: Text(state.error!));
//         }

//         if (listings.isEmpty) {
//           return const SizedBox.shrink();
//         }

//         return Padding(
//           padding: const EdgeInsets.all(8.0.w),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _nearbyStaycationHeader(),

//               const SizedBox(height: 20.h),

//               _nearbyStaycationSlides(listings),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _nearbyStaycationHeader() {
//     return Row(
//       children: [
//         const Expanded(
//           child: Text(
//             "Nearby Staycation",
//             style: TextStyle(
//               fontSize: 24.sp,
//               fontWeight: FontWeight.w700,
//               color: Color(0xff2E3337),
//             ),
//           ),
//         ),

//         GestureDetector(
//           onTap: () {},

//           child: const Text(
//             "View All",
//             style: TextStyle(
//               fontSize: 14.sp,
//               fontWeight: FontWeight.w700,
//               color: Color(0xff4D49D9),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _nearbyStaycationSlides(List listings) {
//     return SizedBox(
//       height: 190.h,

//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,

//         itemCount: listings.length,

//         separatorBuilder: (_, __) {
//           return const SizedBox(width: 16.w);
//         },

//         itemBuilder: (context, index) {
//           final item = listings[index];
//           debugPrint("Cover Image URL: ${item.coverImageUrl}");
//           debugPrint("Title: ${item.title}");

//           return GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => BlocProvider(
//                     create: (_) => DetailsCubit(),
//                     child: DetailsScreen(
//                       request: HotelPageRequest.defaultSearch(hid: item.hid),
//                     ),
//                   ),
//                 ),
//               );
//             },
//             child: _staycationCard(item),
//           );
//         },
//       ),
//     );
//   }

//   Widget _staycationCard(dynamic item) {
//     final double discount = item.discountbps != 0
//         ? item.discountbps / 10000 * 100
//         : 0;
//     return Container(
//       width: 163.w,

//       decoration: BoxDecoration(
//         color: const Color(0xffF2F4F7),

//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(32.r),
//           topRight: Radius.circular(32.r),
//           bottomRight: Radius.circular(8.r),
//           topLeft: Radius.circular(8.r),
//         ),

//         boxShadow: [
//           BoxShadow(
//             offset: const Offset(0, 4),
//             blurRadius: 4,
//             color: Colors.black.withValues(alpha: 0.1),
//           ),
//         ],
//       ),

//       padding: const EdgeInsets.all(4.w),

//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 bottomLeft: Radius.circular(28.r),
//                 topRight: Radius.circular(28.r),
//                 bottomRight: Radius.circular(5.r),
//                 topLeft: Radius.circular(5.r),
//               ),

//               child: Stack(
//                 children: [
//                   CachedNetworkImage(
//                     imageUrl: item.coverImageUrl,
//                     width: double.infinity,
//                     height: double.infinity,
//                     fit: BoxFit.cover,

//                     placeholder: (context, url) {
//                       return Container(
//                         color: Colors.grey.shade200,
//                         child: const Center(
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         ),
//                       );
//                     },

//                     errorWidget: (context, url, error) {
//                       return Container(
//                         color: Colors.grey.shade300,
//                         child: const Icon(Icons.image_not_supported),
//                       );
//                     },
//                   ),

//                   // Bottom Right Text
//                   Positioned(
//                     bottom: 8,
//                     right: 8,

//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 8.w,
//                         vertical: 4.h,
//                       ),

//                       decoration: BoxDecoration(
//                         color: const Color(0xFFAF3300),
//                         borderRadius: BorderRadius.circular(12.r),
//                       ),

//                       child: Text(
//                         "${discount.round()}% OFF",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12.sp,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           const SizedBox(height: 8.h),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 10.w),

//             child: Center(
//               child: Text(
//                 item.title,

//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,

//                 style: const TextStyle(
//                   fontSize: 14.sp,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xff2E3337),
//                 ),
//               ),
//             ),
//           ),

//           const SizedBox(height: 4.h),
//         ],
//       ),
//     );
//   }
// }
