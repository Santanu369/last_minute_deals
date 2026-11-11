// import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lmd_app/bloc/hotel/hotel_cubit.dart';
// import 'package:lmd_app/bloc/hotel/hotel_state.dart';
// import 'package:lmd_app/pages/hotels/hotel_listing_card.dart';

// Widget categoryTab() {
//   return BlocBuilder<HotelCubit, HotelState>(
//     builder: (context, state) {
//       if (state.isLoading) {
//         return const Center(child: CircularProgressIndicator());
//       }

//       if (state.error != null) {
//         return Center(child: Text(state.error!));
//       }

//       if (state.visibleListings.isEmpty) {
//         return const Center(child: Text('No listings found'));
//       }

//       return Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ...List.generate(state.visibleListings.length, (index) {
//             final hotel = state.visibleListings[index];

//             return HotelListingCard(hotel: hotel);
//           }),

//           if (state.isLoadingMore)
//             const Padding(
//               padding: EdgeInsets.symmetric(vertical: 24.h),
//               child: Center(child: CircularProgressIndicator()),
//             ),
//         ],
//       );
//     },
//   );
// }
