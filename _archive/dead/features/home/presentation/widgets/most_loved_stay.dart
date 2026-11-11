// import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lmd_app/bloc/details/details_cubit.dart';
// import 'package:lmd_app/bloc/home/home_cubit.dart';
// import 'package:lmd_app/bloc/home/home_state.dart';
// import 'package:lmd_app/models/hotel_details/hotel_page_request.dart';
// import 'package:lmd_app/pages/Details/details_screen.dart';

// class MostLovedStay extends StatelessWidget {
//   const MostLovedStay({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0.w),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,

//         children: [
//           const Text(
//             "Most Loved Places",
//             style: TextStyle(fontSize: 24.sp, color: Color(0xff2E3337)),
//           ),

//           const SizedBox(height: 16.h),

//           BlocBuilder<HomeCubit, HomeState>(
//             buildWhen: (previous, current) =>
//                 previous.mostLovedStayListings != current.mostLovedStayListings,
//             builder: (context, state) {
//               final listings = state.mostLovedStayListings;
//               if (state.error != null && listings.isEmpty) {
//                 return Center(child: Text(state.error!));
//               }

//               if (listings.isEmpty) {
//                 return const SizedBox.shrink();
//               }

//               return GridView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: listings.length,
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   mainAxisSpacing: 12,
//                   crossAxisSpacing: 12,
//                   childAspectRatio: 0.8,
//                 ),
//                 itemBuilder: (context, index) {
//                   final stay = listings[index];

//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => BlocProvider(
//                             create: (_) => DetailsCubit(),
//                             child: DetailsScreen(
//                               request: HotelPageRequest.defaultSearch(
//                                 hid: stay.hid,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     child: MostLovedStayCard(
//                       imageUrl: stay.images[0],
//                       title: stay.name,
//                       location: stay.city,
//                       originalPrice: double.parse('${stay.price}'),
//                       discountedPrice: 0,
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }

// class MostLovedStayCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String location;
//   final double? originalPrice;
//   final int? discountedPrice;

//   const MostLovedStayCard({
//     super.key,
//     required this.imageUrl,
//     required this.title,
//     required this.location,
//     this.originalPrice,
//     required this.discountedPrice,
//   });

//   @override
//   Widget build(BuildContext context) {
//     bool hasDiscount = discountedPrice != 0 && originalPrice != null;
//     return Container(
//       padding: const EdgeInsets.only(top: 8.h, bottom: 4.h, left: 4.w, right: 4.w),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(32.r),
//         color: const Color(0xffF2F4F7),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(31.r),
//             child: AspectRatio(
//               aspectRatio: 1.5,
//               child: Image.network(
//                 imageUrl,
//                 // height: 150.h,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) {
//                   return Container(
//                     // height: 96.h,
//                     color: Colors.grey.shade300,
//                     child: const Center(child: Icon(Icons.image_not_supported)),
//                   );
//                 },
//               ),
//             ),
//           ),

//           const SizedBox(height: 12.h),

//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 14.sp,
//                     height: 1.3,
//                     color: Color(0xff2E3337),
//                   ),
//                 ),

//                 const SizedBox(height: 4.h),

//                 Text(
//                   location,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.w400,
//                     fontSize: 10.sp,
//                     height: 1.5,
//                     color: Color(0xff5A6064),
//                   ),
//                 ),

//                 const SizedBox(height: 8.h),

//                 RichText(
//                   text: TextSpan(
//                     children: [
//                       if (hasDiscount)
//                         TextSpan(
//                           text: " ₹$originalPrice",
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontSize: 10.sp,
//                             color: Colors.black54,
//                             decoration: TextDecoration.lineThrough,
//                           ),
//                         ),
//                       TextSpan(
//                         text:
//                             " ₹${hasDiscount ? discountedPrice : originalPrice}",
//                         style: const TextStyle(
//                           fontWeight: FontWeight.w800,
//                           fontSize: 14.sp,
//                           color: Color(0xff3F56BF),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
