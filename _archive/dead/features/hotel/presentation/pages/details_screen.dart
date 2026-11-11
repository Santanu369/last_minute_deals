// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:intl/intl.dart';
// import 'package:lmd_app/bloc/details/detail_state.dart';
// import 'package:lmd_app/bloc/details/details_cubit.dart';
// import 'package:lmd_app/bloc/prebook/prebook_cubit.dart';
// import 'package:lmd_app/models/hotel_booking/prebook_request.dart';
// import 'package:lmd_app/models/hotel_details/hotel_page_request.dart';
// import 'package:lmd_app/models/hotel_details/room_model.dart';
// import 'package:lmd_app/pages/bookingPages/date_time.dart';
// import 'package:lmd_app/utils/app_snackbar.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:lmd_app/pages/bookingPages/booking_page.dart';

// // import 'package:lmd_app/pages/bookingPages/booking_success_screen.dart';

// class DetailsScreen extends StatefulWidget {
//   final HotelPageRequest request;
//   const DetailsScreen({super.key, required this.request});

//   @override
//   State<DetailsScreen> createState() => _DetailsScreenState();
// }

// class _DetailsScreenState extends State<DetailsScreen> {
//   final MapController _mapController = MapController();
//   double _currentZoom = 12.0;
//   RoomModel? selectedRoom;
//   final String day = AppDateTime.day;

//   @override
//   void initState() {
//     super.initState();
//     context.read<DetailsCubit>().loadHotelDetails(request: widget.request);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final formatter = NumberFormat('#,##,##0', 'en_IN');
//     const primaryColor = Color(0xFF4D49D9);
//     const orangeColor = Color(0xFFFF7A28);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: primaryColor),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           'LAST MINUTES DEAL',
//           style: TextStyle(
//             color: primaryColor,
//             fontSize: 16.sp,
//             fontWeight: FontWeight.w900,
//             letterSpacing: 0.5,
//           ),
//         ),
//         centerTitle: false,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.share_outlined, color: primaryColor),
//             onPressed: () {
//               final hotel = context.read<DetailsCubit>().state.hotel;

//               if (hotel == null) return;

//               SharePlus.instance.share(
//                 ShareParams(
//                   text:
//                       '''
// 🏨 ${hotel.hotel.name}

// 📍 ${hotel.hotel.address}

// Book now on Last Minutes Deal

// https://play.google.com/store/apps/details?id=com.twwios.lmd
// ''',
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: BlocBuilder<DetailsCubit, DetailsState>(
//         builder: (context, state) {
//           debugPrint("state.hotel: ${state.hotel}");
//           if (state.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           if (state.error != null) {
//             return Center(child: Text('Error: ${state.error}'));
//           }
//           if (state.hotel == null) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           // final oldPrice = day == "Sun"
//           //     ? state.listing!.stayDayPricing!.sundayListPrice
//           //     : day == 'Sat'
//           //     ? state.listing!.stayDayPricing!.saturdayListPrice
//           //     : state.listing!.stayDayPricing!.weekdayListPrice;
//           // final newPrice = day == "Sun"
//           //     ? state.listing!.stayDayPricing!.sundayDealPrice
//           //     : day == 'Sat'
//           //     ? state.listing!.stayDayPricing!.saturdayDealPrice
//           //     : state.listing!.stayDayPricing!.weekdayDealPrice;
//           final currentRoom = selectedRoom ?? state.hotel!.rooms.first;
//           debugPrint("lenght of stays: ${state.hotel!.rooms.length}");
//           return Stack(
//             children: [
//               SingleChildScrollView(
//                 padding: const EdgeInsets.only(bottom: 64.h),
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Main Image Header
//                       Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(16.r),
//                             child: CachedNetworkImage(
//                               imageUrl: state.hotel?.hotel.coverImage ?? '',
//                               width: double.infinity,
//                               height: 380.h,
//                               fit: BoxFit.cover,
//                               errorWidget: (context, error, stackTrace) {
//                                 return Container(
//                                   width: double.infinity,
//                                   height: 380.h,
//                                   color: Colors.grey[200],
//                                   child: const Icon(
//                                     Icons.image,
//                                     size: 50.r,
//                                     color: Colors.grey,
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           Positioned(
//                             top: 16,
//                             left: 16,
//                             child: Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12.w,
//                                 vertical: 6.h,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: orangeColor,
//                                 borderRadius: BorderRadius.circular(20.r),
//                               ),
//                               child: const Text(
//                                 'SPONTANEOUS ESCAPE',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 11.sp,
//                                   fontWeight: FontWeight.bold,
//                                   letterSpacing: 0.5,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20.h),

//                       // Title and Rating
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               maxLines: 1,
//                               overflow: .ellipsis,
//                               '${state.hotel?.hotel.name}',
//                               style: TextStyle(
//                                 fontSize: 32.sp,
//                                 fontWeight: FontWeight.w800,
//                                 height: 1.1,
//                                 color: Color(0xFF1A1A1A),
//                               ),
//                             ),
//                           ),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 10.w,
//                               vertical: 6.h,
//                             ),
//                             decoration: BoxDecoration(
//                               color: const Color(0xFFF3F4F6),
//                               borderRadius: BorderRadius.circular(16.r),
//                             ),
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Icons.star,
//                                   color: Color(0xFFFFB020),
//                                   size: 16.r,
//                                 ),
//                                 const SizedBox(width: 4.w),
//                                 Text(
//                                   '${state.hotel?.hotel.starRating ?? 0}',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 13.sp,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 2),
//                                 Text(
//                                   '(${state.hotel?.hotel.starRating ?? 0})',
//                                   style: TextStyle(
//                                     color: Colors.black87,
//                                     fontSize: 13.sp,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8.h),

//                       // Location
//                       Row(
//                         children: [
//                           const Icon(
//                             Icons.location_on_outlined,
//                             color: primaryColor,
//                             size: 18.r,
//                           ),
//                           const SizedBox(width: 4.w),
//                           Text(
//                             '${state.hotel?.hotel.address ?? ''}',
//                             style: TextStyle(
//                               color: Colors.black87,
//                               fontSize: 15.sp,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 24.h),

//                       // Amenities Icons (Centered as requested)
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           _buildAmenityIcon(
//                             Icons.spa_outlined,
//                             const Color(0xFF34C759),
//                           ),
//                           const SizedBox(width: 24.w),
//                           _buildAmenityIcon(
//                             Icons.room_service_outlined,
//                             const Color(0xFFFF9500),
//                           ),
//                           const SizedBox(width: 24.w),
//                           _buildAmenityIcon(
//                             Icons.pool_outlined,
//                             const Color(0xFF32ADE6),
//                           ),
//                           const SizedBox(width: 24.w),
//                           _buildAmenityIcon(
//                             Icons.restaurant_outlined,
//                             const Color(0xFF8E8E93),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 32.h),

//                       // Explore Local Scene
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Text(
//                             'EXPLORE LOCAL SCENE',
//                             style: TextStyle(
//                               fontSize: 13.sp,
//                               fontWeight: FontWeight.w800,
//                               letterSpacing: 1.2,
//                               color: Color(0xFF4A4A4A),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed: () async {
//                               final Uri url = Uri.parse(
//                                 'https://maps.apple.com/?q=15.2993,74.1240',
//                               );
//                               // Using a basic launchUrl without checking canLaunchUrl first,
//                               // which often fails on iOS simulators due to missing schemes in Info.plist.
//                               try {
//                                 await launchUrl(url);
//                               } catch (e) {
//                                 debugPrint("Could not launch map: $e");
//                               }
//                             },
//                             style: TextButton.styleFrom(
//                               padding: EdgeInsets.zero,
//                               minimumSize: Size.zero,
//                               tapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                             ),
//                             child: const Text(
//                               'Open Maps',
//                               style: TextStyle(
//                                 color: primaryColor,
//                                 fontSize: 13.sp,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16.h),

//                       // Live Map using flutter_map
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(16.r),
//                         child: SizedBox(
//                           width: double.infinity,
//                           height: 180.h,
//                           child: Stack(
//                             children: [
//                               // FlutterMap(
//                               //   mapController: _mapController,
//                               //   options: MapOptions(
//                               //     initialCenter: LatLng(
//                               //       state.listing!.lat,
//                               //       state.listing!.lng,
//                               //     ), // Goa, India
//                               //     initialZoom: 10.0,
//                               //     interactionOptions: const InteractionOptions(
//                               //       flags: InteractiveFlag.all,
//                               //     ),
//                               //   ),
//                               //   children: [
//                               //     TileLayer(
//                               //       // @2x added to the end of the URL for High Quality Retina Tiles
//                               //       urlTemplate:
//                               //           'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png',
//                               //       userAgentPackageName:
//                               //           'com.hotelapp.bookingdeal',
//                               //     ),
//                               //     MarkerLayer(
//                               //       markers: [
//                               //         Marker(
//                               //           point: LatLng(
//                               //             state.listing!.lat,
//                               //             state.listing!.lng,
//                               //           ), // Marker in India
//                               //           width: 40.w,
//                               //           height: 40.h,
//                               //           child: Container(
//                               //             decoration: BoxDecoration(
//                               //               color: primaryColor,
//                               //               shape: BoxShape.circle,
//                               //               border: Border.all(
//                               //                 color: Colors.white,
//                               //                 width: 2,
//                               //               ),
//                               //               boxShadow: [
//                               //                 BoxShadow(
//                               //                   color: Colors.black.withValues(
//                               //                     alpha: 0.2,
//                               //                   ),
//                               //                   blurRadius: 4,
//                               //                   offset: const Offset(0, 2),
//                               //                 ),
//                               //               ],
//                               //             ),
//                               //             child: const Icon(
//                               //               Icons.location_on,
//                               //               color: Colors.white,
//                               //               size: 20.r,
//                               //             ),
//                               //           ),
//                               //         ),
//                               //       ],
//                               //     ),
//                               //   ],
//                               // ),
//                               // Zoom Controls
//                               Positioned(
//                                 right: 12,
//                                 bottom: 12,
//                                 child: Column(
//                                   children: [
//                                     _buildZoomButton(Icons.add, () {
//                                       setState(() {
//                                         _currentZoom =
//                                             (_mapController.camera.zoom + 1)
//                                                 .clamp(1.0, 18.0);
//                                         _mapController.move(
//                                           _mapController.camera.center,
//                                           _currentZoom,
//                                         );
//                                       });
//                                     }),
//                                     const SizedBox(height: 8.h),
//                                     _buildZoomButton(Icons.remove, () {
//                                       setState(() {
//                                         _currentZoom =
//                                             (_mapController.camera.zoom - 1)
//                                                 .clamp(1.0, 18.0);
//                                         _mapController.move(
//                                           _mapController.camera.center,
//                                           _currentZoom,
//                                         );
//                                       });
//                                     }),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 32.h),

//                       // Choose Your Room
//                       if (state.hotel != null && state.hotel!.rooms.isNotEmpty)
//                         const Text(
//                           'Choose Your Room',
//                           style: TextStyle(
//                             fontSize: 20.sp,
//                             fontWeight: FontWeight.w800,
//                             color: Color(0xFF1A1A1A),
//                           ),
//                         ),
//                       const SizedBox(height: 20.h),

//                       // ListView.builder(itemBuilder: (context, index)=>{
//                       // },),
//                       SizedBox(
//                         // height: 550.h,
//                         child: ListView.separated(
//                           separatorBuilder: (_, _) => SizedBox(height: 24.h),
//                           shrinkWrap: true,
//                           physics: NeverScrollableScrollPhysics(),
//                           itemCount: state.hotel!.rooms.length,
//                           itemBuilder: (context, index) {
//                             final roomitem = state.hotel!.rooms[index];
//                             for (
//                               int i = 0;
//                               i < roomitem.roomImages.length;
//                               i++
//                             ) {
//                               debugPrint("room images: ${roomitem.roomImages[i]}");
//                             }
//                             return SizedBox(
//                               width: 320.w,
//                               child: _buildRoomItem(
//                                 context,
//                                 room: roomitem,
//                                 onBookNow: () async {
//                                   // roomitem.bookHash & roomitem.matchHash
//                                   final request = PrebookRequest(
//                                     bookHash: roomitem.bookHash,
//                                   );
//                                   await context.read<PrebookCubit>().prebook(
//                                     request: request,
//                                   );
//                                   final state = context
//                                       .read<PrebookCubit>()
//                                       .state;
//                                   if (state.response != null) {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (_) => BookingPage(productId: productId, listing: listing)
//                                         // BookingPage(
//                                         //   // prebook: state.response!,
//                                         //   request: widget.request,
//                                         //   imageUrl:
//                                         //       roomitem.roomImages.isNotEmpty
//                                         //       ? roomitem.roomImages.first
//                                         //       : '',
//                                         // ),
//                                       ),
//                                     );
//                                   }
//                                   // Navigator.push(
//                                   //   context,
//                                   //   MaterialPageRoute(
//                                   //     builder: (_) => BookingPage(
//                                   //       room: roomitem,
//                                   //       hotel: state.hotel!.hotel,
//                                   //     ),
//                                   //   ),
//                                   // );
//                                 },
//                               ),
//                               // child: _buildRoomItem(
//                               //   context,
//                               //   title: '${roomitem.roomName}',
//                               //   imagePath: state.hotel?.hotel.coverImage ?? '',
//                               //   size: '1000 sq.ft',
//                               //   bed: 'King Bed',
//                               //   features: [
//                               //     _Feature(
//                               //       icon: Icons.restaurant,
//                               //       text:
//                               //           'All Meals Included (Breakfast, Lunch & Dinner)',
//                               //       iconColor: primaryColor,
//                               //       textColor: primaryColor,
//                               //     ),
//                               //     _Feature(
//                               //       icon: Icons.local_laundry_service_outlined,
//                               //       text:
//                               //           'Complimentary Laundry (2 pieces/day)',
//                               //       iconColor: const Color(0xFF34C759),
//                               //     ),
//                               //     _Feature(
//                               //       icon: Icons.check_circle_outline,
//                               //       text: 'Free Cancellation',
//                               //       iconColor: const Color(0xFF34C759),
//                               //     ),
//                               //   ],
//                               //   // oldPrice: oldPrice,
//                               //   // newPrice: newPrice,
//                               //   // hasMostPopular: true,
//                               //   // muchMore: true,
//                               //   onBookNow: () {
//                               //     if (state.deals.isEmpty) {
//                               //       AppSnackbar.showError(
//                               //         context,
//                               //         "No deals available right now",
//                               //       );
//                               //       return;
//                               //     }
//                               //     // Navigator.push(
//                               //     //   context,
//                               //     //   MaterialPageRoute(
//                               //     //     builder: (_) => BookingPage(
//                               //     //       stayName: state.hotel!.hotel.name,
//                               //     //       listingId: '${state.hotel!.hotel.hid}',
//                               //     //       dealId: state.deals.first.id,
//                               //     //       sku: roomitem.sku,
//                               //     //       imagePath:
//                               //     //           state.hotel?.hotel.coverImage ?? '',
//                               //     //       roomName: roomitem.name,
//                               //     //       price: newPrice,
//                               //     //       oldPrice: oldPrice,
//                               //     //     ),
//                               //     //   ),
//                               //     // );
//                               //   },
//                               // ),
//                             );
//                           },
//                         ),
//                       ),

//                       const SizedBox(height: 20.h),
//                     ],
//                   ),
//                 ),
//               ),

//               // Bottom Sticky Bar
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withValues(alpha: 0.05),
//                         offset: const Offset(0, -4),
//                         blurRadius: 10,
//                       ),
//                     ],
//                   ),
//                   child: SafeArea(
//                     top: false,
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                         left: 20.w,
//                         right: 20.w,
//                         top: 12.h,
//                         bottom: 6.h,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               const Text(
//                                 'TOTAL FOR 2 NIGHTS',
//                                 style: TextStyle(
//                                   fontSize: 11.sp,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.black54,
//                                   letterSpacing: 0.5,
//                                 ),
//                               ),
//                               const SizedBox(height: 2),
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.baseline,
//                                 textBaseline: TextBaseline.alphabetic,
//                                 children: [
//                                   Text(
//                                     '${formatter.format(currentRoom.price)}',
//                                     style: TextStyle(
//                                       fontSize: 22.sp,
//                                       fontWeight: FontWeight.w800,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 4.w),
//                                   Text(
//                                     '+ taxes',
//                                     style: TextStyle(
//                                       fontSize: 12.sp,
//                                       color: Colors.black87,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 48.h,
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 // final roomitem = state.listing!.stayRoomTypes[index];
//                                 if (state.hotel == null ||
//                                     state.hotel!.rooms.isEmpty) {
//                                   AppSnackbar.showError(
//                                     context,
//                                     "No deals available right now",
//                                   );
//                                   return;
//                                 }
//                                 // Navigator.push(
//                                 //   context,
//                                 //   MaterialPageRoute(
//                                 //     builder: (context) => BookingPage(
//                                 //       stayName: state.hotel!.hotel.name,
//                                 //       listingId: '${state.hotel!.hotel.hid}',
//                                 //       dealId: state.deals.first.id,
//                                 //       sku: state
//                                 //           .listing!
//                                 //           .stayRoomTypes
//                                 //           .first
//                                 //           .sku,
//                                 //       imagePath:
//                                 //           state.hotel?.hotel.coverImage ?? '',
//                                 //       price: selectedRoom!.price,

//                                 //       oldPrice: state.listing!.minDealPrice,
//                                 //       roomName: state.hotel!.hotel.name,
//                                 //     ),
//                                 //   ),
//                                 // );
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: primaryColor,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(24.r),
//                                 ),
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 32.w,
//                                 ),
//                                 elevation: 0,
//                               ),
//                               child: const Text(
//                                 'Book Now',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 14.sp,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildZoomButton(IconData icon, VoidCallback onPressed) {
//     return Container(
//       width: 36.w,
//       height: 36.h,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withValues(alpha: 0.1),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: IconButton(
//         icon: Icon(icon, size: 20.r, color: Colors.black87),
//         padding: EdgeInsets.zero,
//         onPressed: onPressed,
//       ),
//     );
//   }

//   Widget _buildAmenityIcon(IconData icon, Color color) {
//     return Container(
//       width: 48.w,
//       height: 48.h,
//       decoration: BoxDecoration(
//         color: color.withValues(alpha: 0.1),
//         shape: BoxShape.circle,
//       ),
//       child: Center(child: Icon(icon, color: color, size: 24.r)),
//     );
//   }

//   Widget _buildRoomItem(
//     BuildContext context, {
//     required RoomModel room,
//     required VoidCallback onBookNow,
//   }) {
//     final formatter = NumberFormat('#,##,##0', 'en_IN');
//     return Container(
//       margin: const EdgeInsets.only(bottom: 32.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Room Image
//           Stack(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(16.r),
//                 child: Image.network(
//                   room.firstImage,

//                   width: double.infinity,
//                   height: 200.h,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       width: double.infinity,
//                       height: 200.h,
//                       color: Colors.grey[200],
//                       child: const Icon(
//                         Icons.image,
//                         size: 50.r,
//                         color: Colors.grey,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               // if (hasMostPopular)
//               //   Positioned(
//               //     top: 12,
//               //     right: 12,
//               //     child: Container(
//               //       padding: const EdgeInsets.symmetric(
//               //         horizontal: 12.w,
//               //         vertical: 6.h,
//               //       ),
//               //       decoration: BoxDecoration(
//               //         color: Colors.white,
//               //         borderRadius: BorderRadius.circular(16.r),
//               //       ),
//               //       child: const Text(
//               //         'MOST POPULAR',
//               //         style: TextStyle(
//               //           color: Color(0xFFFF7A28),
//               //           fontSize: 11.sp,
//               //           fontWeight: FontWeight.w800,
//               //           letterSpacing: 0.5,
//               //         ),
//               //       ),
//               //     ),
//               //   ),
//             ],
//           ),
//           const SizedBox(height: 16.h),

//           Text(
//             room.roomName,
//             style: const TextStyle(
//               fontSize: 18.sp,
//               fontWeight: FontWeight.w800,
//               color: Color(0xFF1A1A1A),
//             ),
//           ),
//           const SizedBox(height: 6.h),
//           Row(
//             children: [
//               Icon(Icons.square_foot_outlined, size: 16.r, color: Colors.black87),
//               const SizedBox(width: 4.w),
//               if (room.roomSize != null)
//                 Padding(
//                   padding: const EdgeInsets.only(top: 8.h),
//                   child: Text(
//                     room.roomSize!,
//                     style: const TextStyle(fontWeight: FontWeight.w600),
//                   ),
//                 ),
//               const SizedBox(width: 16.w),
//               Icon(Icons.bed_outlined, size: 16.r, color: Colors.black87),
//               const SizedBox(width: 4.w),
//               // Text(
//               //   room.bed,
//               //   style: const TextStyle(
//               //     fontSize: 13.sp,
//               //     color: Colors.black87,
//               //     fontWeight: FontWeight.w600,
//               //   ),
//               // ),
//             ],
//           ),
//           const SizedBox(height: 16.h),

//           // Features
//           // ...features.map(
//           //   (f) => Padding(
//           //     padding: const EdgeInsets.only(bottom: 8.0.h),
//           //     child: Row(
//           //       crossAxisAlignment: CrossAxisAlignment.start,
//           //       children: [
//           //         Icon(f.icon, size: 18.r, color: f.iconColor),
//           //         const SizedBox(width: 8.w),
//           //         Expanded(
//           //           child: Text(
//           //             f.text,
//           //             style: TextStyle(
//           //               fontSize: 13.sp,
//           //               color: f.textColor ?? Colors.black87,
//           //               fontWeight: FontWeight.w600,
//           //             ),
//           //           ),
//           //         ),
//           //       ],
//           //     ),
//           //   ),
//           // ),
//           Column(
//             children: [
//               if (room.meal.isNotEmpty)
//                 _buildFeature(
//                   Icons.restaurant,
//                   room.mealDisplay,
//                   const Color(0xFF4D49D9),
//                 ),

//               _buildFeature(
//                 room.refundable
//                     ? Icons.check_circle_outline
//                     : Icons.cancel_outlined,
//                 room.refundable ? "Free Cancellation" : "Non-refundable",
//                 room.refundable ? Colors.green : Colors.red,
//               ),
//             ],
//           ),

//           // if (muchMore)
//           //   Padding(
//           //     padding: const EdgeInsets.only(top: 2.0.h, bottom: 8.0.h),
//           //     child: const Text(
//           //       'Much More...',
//           //       style: TextStyle(
//           //         fontSize: 13.sp,
//           //         color: Colors.black54,
//           //         fontWeight: FontWeight.w600,
//           //       ),
//           //     ),
//           //   ),
//           const SizedBox(height: 16.h),

//           // Price and Book Now
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.baseline,
//                     textBaseline: TextBaseline.alphabetic,
//                     children: [
//                       Text(
//                         "${room.currency} ${formatter.format(room.price)}",
//                         style: const TextStyle(
//                           fontSize: 24.sp,
//                           fontWeight: FontWeight.w800,
//                           color: Color(0xFF4D49D9),
//                         ),
//                       ),
//                       const Text(
//                         ' /night',
//                         style: TextStyle(
//                           fontSize: 13.sp,
//                           color: Colors.black87,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4.h),
//                   const Text(
//                     'ONLY 2 ROOMS\nAVAILABLE',
//                     style: TextStyle(
//                       fontSize: 10.sp,
//                       fontWeight: FontWeight.w800,
//                       color: Color(0xFFE53935), // Red
//                       height: 1.2,
//                       letterSpacing: 0.2,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 40.h,
//                 child: ElevatedButton(
//                   onPressed: onBookNow,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF4D49D9),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20.r),
//                     ),
//                     elevation: 0,
//                     padding: const EdgeInsets.symmetric(horizontal: 24.w),
//                   ),
//                   child: const Text(
//                     'Book Now',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 13.sp,
//                       fontWeight: FontWeight.bold,
//                     ),
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

// class _Feature {
//   final IconData icon;
//   final String text;
//   final Color iconColor;
//   final Color? textColor;

//   _Feature({
//     required this.icon,
//     required this.text,
//     required this.iconColor,
//   }) : textColor = null;
// }

// Widget _buildFeature(IconData icon, String text, Color color) {
//   return Padding(
//     padding: const EdgeInsets.only(bottom: 8.h),
//     child: Row(
//       children: [
//         Icon(icon, size: 18.r, color: color),
//         const SizedBox(width: 8.w),
//         Expanded(
//           child: Text(
//             text,
//             style: const TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
//           ),
//         ),
//       ],
//     ),
//   );
// }
