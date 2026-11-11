// import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lmd_app/bloc/buffet/buffet_cubit.dart';
// import 'package:lmd_app/bloc/buffet/buffet_state.dart';
// // import 'package:flutter_lmd_5/config/assets/app_images.dart';
// // import 'package:flutter_lmd_5/config/assets/basic_text_style.dart';
// // import 'package:flutter_lmd_5/home/widgets/basic_appbar.dart';
// // import 'package:flutter_lmd_5/presentation/home/widgets/basic_appbar.dart';
// // import 'package:lmd_app/common/widgets/basic_appbar.dart';
// import 'package:lmd_app/config/assets/app_images.dart';
// import 'package:lmd_app/config/assets/basic_text_style.dart';
// import 'package:lmd_app/common/widgets/home_appbar.dart';
// import 'package:lmd_app/pages/buffetPages/buffet_catagory.dart';

// class BuffetHomePage extends StatefulWidget {
//   const BuffetHomePage({super.key});

//   @override
//   State<BuffetHomePage> createState() => _BuffetHomePageState();
// }

// class _BuffetHomePageState extends State<BuffetHomePage> {
//   final searchController = TextEditingController();
//   String searchQuery = "";
//   @override
//   initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(kToolbarHeight),
//         child: HomeAppbar(),
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             child: Padding(
//               padding: EdgeInsetsGeometry.only(
//                 bottom: 80,
//                 right: 24,
//                 left: 24,
//                 top: 20,
//               ),
//               child: Column(
//                 children: [
//                   _searchBar(),
//                   SizedBox(height: 32.h),
//                   _categories(context),
//                   SizedBox(height: 32.h),
//                   _recentBooking(),
//                   SizedBox(height: 32.h),
//                   _grandPlace(),
//                   SizedBox(height: 32.h),
//                   _weekendBanner(),
//                   SizedBox(height: 32.h),
//                     _recommendedForYouTitle(),
//               SizedBox(height: 32.h),
//               _recommendedForYouCards(),
//               // SizedBox(height: 32.h),
//                _nowOrNever(),
//               SizedBox(height: 32.h),
//                _nearbyStaycation(),
//               SizedBox(height: 32.h),
//               _nearbyStaycationSlides(),
//               SizedBox(height: 32.h),
//               _specialOfferBanner(),
//               SizedBox(height: 32.h),
//               _bookTableTitle(),
//               SizedBox(height: 32.h),
//               _bookTableCards(),
//               SizedBox(height: 32.h),
//               // _staySave(),
//               // SizedBox(height: 32.h),
//               // _staySaveCards(),
//               // SizedBox(height: 32.h),
//               // _addedSoon(),
//               // SizedBox(height: 32.h),
//               // _addedSoonSlides(),
//               // SizedBox(height: 32.h),
//               // _nowOrNever(),
//               // SizedBox(height: 32.h),
           
             
//               _limitedOfferTitle(),
//               SizedBox(height: 32.h,),
//               _limitedOfferCards(),
//               SizedBox(height: 32.h,),
//               // _perfectForPlanTitle(),
//               // SizedBox(height: 32.h,),
//               // _perfectForPlanCards()
//                 ],
//               ),
//             ),
//           ),
//           if (searchQuery.isNotEmpty) _searchResults(),
//         ],
//       ),
//     );
//   }

//   Widget _searchResults() {
//     return Positioned(
//       top: 90,
//       left: 24,
//       right: 24,
//       child: Material(
//         elevation: 5,
//         borderRadius: BorderRadius.circular(14.r),
//         child: Container(
//           constraints: const BoxConstraints(maxHeight: 300),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(14.r),
//           ),
//           child: BlocBuilder<BuffetCubit, BuffetState>(
//             builder: (context, state) {
//               if (state.isLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (state.visibleBuffets.isEmpty) {
//                 return const SizedBox(
//                   height: 60.h,
//                   child: Center(child: Text('No buffets found')),
//                 );
//               }

//               return ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: state.visibleBuffets.length,
//                 itemBuilder: (context, index) {
//                   final buffet = state.visibleBuffets[index];

//                   return ListTile(
//                     leading: ClipRRect(
//                       borderRadius: BorderRadius.circular(8.r),
//                       child: Image.network(
//                         buffet.images[0],
//                         width: 40.w,
//                         height: 40.h,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     title: Text(buffet.name),
//                     subtitle: Text(buffet.city),
//                     onTap: () {
//                       searchController.text = buffet.name;

//                       setState(() {
//                         searchQuery = '';
//                       });

//                       FocusScope.of(context).unfocus();

//                       // Navigate to details
//                     },
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _searchBar() {
//     return SizedBox(
//       width: double.infinity,
//       child: SearchBar(
//         controller: searchController,
//         onChanged: (value) {
//           setState(() {
//             searchQuery = value;
//           });

//           context.read<BuffetCubit>().search(value);
//         },
//         hintText: "Search hotels, events, stores...",
//         hintStyle: WidgetStatePropertyAll(
//           TextStyle(
//             fontWeight: FontWeight.w400,
//             fontSize: 16.sp,
//             color: Color(0xffADB2B8),
//           ),
//         ),
//         backgroundColor: WidgetStatePropertyAll(Color(0xffFFFFFF)),

//         shape: WidgetStateProperty.all(
//           RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16.r), // Adjust radius here
//           ),
//         ),
//         shadowColor: WidgetStateProperty.all(Color(0xffFFFFFF)),
//         leading: Padding(
//           padding: const EdgeInsets.only(left: 8.0.w),
//           child: Icon(Icons.search, color: Color(0xff767B80), size: 22.r),
//         ),
//       ),
//     );
//   }

//   Widget _categories(BuildContext context) {
//     return Container(
//       height: 88.h,
//       width: MediaQuery.sizeOf(context).width,
//       padding: EdgeInsets.symmetric(horizontal: 0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       BuffetCatagory(title: "All Buffets", category: "all"),
//                 ),
//               );
//             },
//             child: SizedBox(
//               height: 88.h,
//               child: Column(
//                 children: [
//                   Container(
//                     height: 64.h,
//                     width: 64.w,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.r),
//                       color: Color(0xffE8E8F9),
//                       boxShadow: [
//                         BoxShadow(
//                           offset: Offset(0, 2),
//                           blurRadius: 10,
//                           color: Color(0xff000000).withValues(alpha: 0.15),
//                         ),
//                       ],
//                     ),
//                     child: Image.asset(
//                       "assets/home_page/buffetCatIcon1.png",
//                       height: 25.h,
//                       width: 25.w,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   SizedBox(
//                     // width: 80.w,
//                     child: BasicTextStyle(
//                       title: "All Buffets",
//                       weight: FontWeight.w700,
//                       size: 15.r,
//                       spacing: -0.3,
//                       color: Color(0xff2E3337),
//                       height: 1,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       BuffetCatagory(title: "Lunch", category: "lunch"),
//                 ),
//               );
//             },
//             child: SizedBox(
//               height: 88.h,
//               child: Column(
//                 children: [
//                   Container(
//                     height: 64.h,
//                     width: 64.w,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.r),
//                       color: Color(0xffE8E8F9),
//                       boxShadow: [
//                         BoxShadow(
//                           offset: Offset(0, 2),
//                           blurRadius: 10,
//                           color: Color(0xff000000).withValues(alpha: 0.15),
//                         ),
//                       ],
//                     ),
//                     child: Image.asset(
//                       "assets/home_page/buffetCatIcon2.png",
//                       height: 25.h,
//                       width: 25.w,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   SizedBox(
//                     // width: 80.w,
//                     child: BasicTextStyle(
//                       title: "Lunch",
//                       weight: FontWeight.w700,
//                       size: 15.r,
//                       spacing: -0.3,
//                       color: Color(0xff2E3337),
//                       height: 1,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) =>
//                       BuffetCatagory(title: "Dinner", category: "dinner"),
//                 ),
//               );
//             },
//             child: SizedBox(
//               height: 88.h,
//               child: Column(
//                 children: [
//                   Container(
//                     height: 64.h,
//                     width: 64.w,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.r),
//                       color: Color(0xffE8E8F9),
//                       boxShadow: [
//                         BoxShadow(
//                           offset: Offset(0, 2),
//                           blurRadius: 10,
//                           color: Color(0xff000000).withValues(alpha: 0.15),
//                         ),
//                       ],
//                     ),
//                     child: Image.asset(
//                       "assets/home_page/buffetCatIcon3.png",
//                       height: 25.h,
//                       width: 25.w,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   SizedBox(
//                     // width: 80.w,
//                     child: BasicTextStyle(
//                       title: "Dinner",
//                       weight: FontWeight.w700,
//                       size: 15.r,
//                       spacing: -0.3,
//                       color: Color(0xff2E3337),
//                       height: 1,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => BuffetCatagory(
//                     title: "Group Friendly",
//                     category: "group friendly",
//                   ),
//                 ),
//               );
//             },
//             child: SizedBox(
//               height: 88.h,
//               child: Column(
//                 children: [
//                   Container(
//                     height: 64.h,
//                     width: 64.w,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.r),
//                       color: Color(0xffE8E8F9),
//                       boxShadow: [
//                         BoxShadow(
//                           offset: Offset(0, 2),
//                           blurRadius: 10,
//                           color: Color(0xff000000).withValues(alpha: 0.15),
//                         ),
//                       ],
//                     ),
//                     child: Image.asset(
//                       "assets/home_page/buffetCatIcon4.png",
//                       height: 25.h,
//                       width: 25.w,
//                     ),
//                   ),
//                   SizedBox(height: 8.h),
//                   SizedBox(
//                     // width: 80.w,
//                     child: BasicTextStyle(
//                       title: "Group Friendly",
//                       weight: FontWeight.w700,
//                       size: 15.r,
//                       spacing: -0.3,
//                       color: Color(0xff2E3337),
//                       height: 1,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _weekendBanner() {
//     return Container(
//       height: 232.h,
//       width: 342.w,
//       padding: EdgeInsets.only(top: 8.h),
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(32.r)),
//       child: Stack(
//         children: [
//           Align(
//             alignment: Alignment.center,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(47.r),
//               child: Image(
//                 image: AssetImage(AppImages.weekendBanner),
//                 fit: BoxFit.cover,
//                 height: 224.h,
//                 width: 342.w,
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: Container(
//               height: 224.h,
//               width: 342.w,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(47.r),
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xff4D49D9).withValues(alpha: 0.8),
//                     Color(0xff4D49D9).withValues(alpha: 0),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: SizedBox(
//               height: 175.h,
//               width: 306.w,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(9999.r),
//                       color: Color(0xffCBA9FF),
//                     ),
//                     child: BasicTextStyle(
//                       title: "Weekend Special",
//                       weight: FontWeight.w900,
//                       size: 10.r,
//                       spacing: 1,
//                       height: 1.2,
//                       color: Color(0xff4B0098),
//                     ),
//                   ),
//                   SizedBox(height: 6.h),
//                   BasicTextStyle(
//                     title: "Weekend Gateway",
//                     weight: FontWeight.w700,
//                     size: 30.r,
//                     spacing: -1.5,
//                     color: Color(0xffffffff),
//                   ),
//                   SizedBox(height: 6.h),
//                   Row(
//                     children: [
//                       BasicTextStyle(
//                         title: "40%",
//                         weight: FontWeight.w800,
//                         size: 48.r,
//                         spacing: 0,
//                         color: Color(0xffffffff),
//                         height: 1,
//                       ),
//                       SizedBox(width: 10.w),
//                       SizedBox(
//                         width: 80.w,
//                         height: 35.h,
//                         child: BasicTextStyle(
//                           title: "OFF ON ALL BOOKINGS",
//                           weight: FontWeight.w800,
//                           size: 14.r,
//                           spacing: 0,
//                           color: Color(0xffffffff),
//                           height: 1.25,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 8.h),
//                   AnimatedContainer(
//                     curve: Curves.easeIn,
//                     duration: Duration(milliseconds: 300),
//                     child: Container(
//                       height: 40.h,
//                       width: 100.w,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(9999.r),
//                         color: Color(0xffFFFFFF),
//                       ),
//                       child: Center(
//                         child: BasicTextStyle(
//                           title: "Book Now",
//                           weight: FontWeight.w700,
//                           size: 16.r,
//                           spacing: 0,
//                           color: Color(0xff4D49D9),
//                           height: 1.5,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _recentBooking() {
//     return SizedBox(
//       height: 32.h,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           BasicTextStyle(
//             title: "Recent Booking",
//             weight: FontWeight.w700,
//             size: 24.r,
//             height: 1.3,
//             spacing: -0.6,
//             color: Color(0xff2E3337),
//           ),
//           BasicTextStyle(
//             title: "View All",
//             weight: FontWeight.w700,
//             size: 14.r,
//             height: 1.4,
//             spacing: 0,
//             color: Color(0xff4D49D9),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _grandPlace() {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(32.r),
//       child: Container(
//         width: 342.w,
//         height: 135.h,
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(32.r),
//           color: Color(0xffffffff),
//         ),
//         child: Row(
//           children: [
//             Image.asset(
//               AppImages.palacioVilla,
//               width: 114.w,
//               fit: BoxFit.fitHeight,
//             ),
//             Container(
//               padding: EdgeInsets.all(16.w),
//               width: 228.w,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       BasicTextStyle(
//                         title: "Palacio Villa",
//                         weight: FontWeight.w700,
//                         size: 18.r,
//                         spacing: 0,
//                         height: 1.2,
//                         color: Color(0xff1F2024),
//                       ),
//                       BasicTextStyle(
//                         title: "Santorini, Greece • 4.2 km away",
//                         weight: FontWeight.w400,
//                         size: 10.r,
//                         spacing: 0,
//                         height: 2,
//                         color: Color(0xff767676),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       BasicTextStyle(
//                         title: "Check-in: May 16, 2026",
//                         weight: FontWeight.w400,
//                         size: 12.r,
//                         spacing: 0,
//                         height: 1.3,
//                         color: Color(0xff767B80),
//                       ),
//                       Image.asset(
//                         "assets/images/Frame 876.png",
//                         height: 18.h,
//                         width: 80.w,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _staySave() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             BasicTextStyle(
//               title: "Stay & Save",
//               weight: FontWeight.w700,
//               size: 24.r,
//               spacing: -0.6,
//               height: 1.4,
//               color: Color(0xff2E3337),
//             ),
//             BasicTextStyle(
//               title: "Luxury stays at pocket-friendly prices",
//               weight: FontWeight.w400,
//               size: 14.r,
//               spacing: 0,
//               height: 1.2,
//               color: Color(0xff5A6064),
//             ),
//           ],
//         ),
//         BasicTextStyle(
//           title: "View All",
//           weight: FontWeight.w700,
//           size: 14.r,
//           height: 1.2,
//           color: Color(0xff4D49D9),
//         ),
//       ],
//     );
//   }

//   Widget _staySaveCards() {
//     return Container(
//       width: 342.w,
//       height: 368.h,
//       padding: EdgeInsets.symmetric(vertical: 15.h),
//       child: ListView.separated(
//         shrinkWrap: true, // Sizes the list to its children
//         physics: const NeverScrollableScrollPhysics(),
//         scrollDirection: Axis.horizontal,
//         itemCount: 3,
//         separatorBuilder: (BuildContext context, int index) {
//           return SizedBox(width: 24.w);
//         },
//         itemBuilder: (BuildContext context, int index) {
//           return Container(
//             height: 338.h,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xffD9D9D9), Color(0xff2A0160)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.circular(32.r),
//             ),
//             padding: EdgeInsets.all(16.w),
//             constraints: BoxConstraints(minWidth: 280),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(16.r),
//                   child: Image.asset(
//                     AppImages.bgStay,
//                     height: 192.h,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 Container(
//                   padding: EdgeInsets.only(top: 12.5.h),
//                   child: BasicTextStyle(
//                     title: "Palacio Villa",
//                     weight: FontWeight.w700,
//                     size: 18.r,
//                     color: Color(0xffffffff),
//                     height: 1.25,
//                     spacing: 0,
//                   ),
//                 ),
//                 BasicTextStyle(
//                   title: "Santorini, Greece • 4.2 km away",
//                   weight: FontWeight.w400,
//                   size: 14.r,
//                   height: 1.2,
//                   color: Color(0xffE6E6E6),
//                   spacing: 0,
//                 ),
//                 Container(
//                   padding: EdgeInsets.only(top: 8.5.h),
//                   width: 248.w,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           BasicTextStyle(
//                             title: "₹19000",
//                             weight: FontWeight.w400,
//                             size: 12.r,
//                             height: 1.3,
//                             spacing: 0,
//                             color: Color(0xffE5EBF4),
//                             decoration: TextDecoration.lineThrough,
//                           ),
//                           Text.rich(
//                             TextSpan(
//                               text: '₹13,500',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w800,
//                                 fontSize: 20.sp,
//                                 height: 1.3,
//                                 letterSpacing: 0,
//                                 color: Color(0xffffffff),
//                               ),
//                               children: <TextSpan>[
//                                 TextSpan(
//                                   text: '/night',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 12.sp,
//                                     color: Color(0xffF5F5F5),
//                                     letterSpacing: 0,
//                                     height: 1.3,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       AnimatedContainer(
//                         duration: Duration(milliseconds: 300),
//                         curve: Curves.easeIn,
//                         child: CircleAvatar(
//                           radius: 20,
//                           backgroundColor: Color(0xffEDD8FB),
//                           child: Icon(
//                             Icons.arrow_forward_ios_rounded,
//                             size: 13.r,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _addedSoon() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         SizedBox(
//           width: 277.w,
//           child: BasicTextStyle(
//             title: "Added Soon",
//             weight: FontWeight.w700,
//             size: 24.r,
//             color: Color(0xff2E3337),
//             spacing: -0.6,
//             height: 1.3,
//           ),
//         ),
//         SizedBox(width: 1),
//         AnimatedContainer(
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeIn,
//           child: BasicTextStyle(
//             title: "View All",
//             weight: FontWeight.w700,
//             size: 14.r,
//             color: Color(0xff4D49D9),
//             spacing: 0,
//             height: 1.4,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _addedSoonSlides() {
//     List<String> sliders = [AppImages.slider1, AppImages.slider2];

//     return SizedBox(
//       height: 189.h,
//       width: 345.w,
//       child: ListView.separated(
//         shrinkWrap: true, // Sizes the list to its children
//         physics: const NeverScrollableScrollPhysics(),
//         scrollDirection: Axis.horizontal,
//         itemCount: 2,
//         separatorBuilder: (BuildContext context, int index) {
//           return SizedBox(width: 20.w);
//         },
//         itemBuilder: (BuildContext context, int index) {
//           return Container(
//             height: 189.h,
//             width: 163.w,
//             decoration: BoxDecoration(
//               color: Color(0xffF2F4F7),
//               borderRadius: BorderRadius.circular(32.r),
//             ),
//             padding: EdgeInsets.only(top: 7.h, bottom: 4.h, right: 4.w, left: 4.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(28.r),
//                   child: Image.asset(
//                     sliders[index],
//                     height: 128.h,
//                     width: 149.w,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 SizedBox(height: 6.h),
//                 Container(
//                   height: 42.h,
//                   padding: EdgeInsets.only(right: 12.w, left: 12.w, bottom: 8.h),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       BasicTextStyle(
//                         title: "Palacio Villa",
//                         weight: FontWeight.w700,
//                         size: 14.r,
//                         color: Color(0xff2E3337),
//                         height: 1.2,
//                         spacing: 0,
//                       ),
//                       BasicTextStyle(
//                         title: "₹13,500 ",
//                         weight: FontWeight.w800,
//                         size: 14.r,
//                         height: 1.2,
//                         color: Color(0xff3F56BF),
//                         spacing: 0,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _nowOrNever() {
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
//               BasicTextStyle(
//                 title: "Now or Never",
//                 weight: FontWeight.w700,
//                 size: 18.r,
//                 spacing: 0,
//                 height: 1.5,
//                 color: Color(0xffFFFFFF),
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
//                     BasicTextStyle(
//                       title: "Triangle Pine \nTent",
//                       weight: FontWeight.w700,
//                       size: 16.r,
//                       spacing: 0,
//                       color: Color(0xffFFFFFF),
//                       height: 1.2,
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

//   Widget _nearbyStaycation() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         SizedBox(
//           width: 277.w,
//           child: BasicTextStyle(
//             title: "Nearby you",
//             weight: FontWeight.w700,
//             size: 24.r,
//             color: Color(0xff2E3337),
//             spacing: -0.6,
//             height: 1.3,
//           ),
//         ),
//         SizedBox(width: 1),
//         AnimatedContainer(
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeIn,
//           child: BasicTextStyle(
//             title: "View All",
//             weight: FontWeight.w700,
//             size: 14.r,
//             color: Color(0xff4D49D9),
//             spacing: 0,
//             height: 1.4,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _nearbyStaycationSlides() {
//     List<String> sliders = [AppImages.stayCation1, AppImages.stayCation2];
//     List<String> title = ["Vani Villa", "Hotel Devine"];

//     return SizedBox(
//       height: 179.h,
//       width: 345.w,
//       child: ListView.separated(
//         shrinkWrap: true, // Sizes the list to its children
//         physics: const NeverScrollableScrollPhysics(),
//         scrollDirection: Axis.horizontal,
//         itemCount: 2,
//         separatorBuilder: (BuildContext context, int index) {
//           return SizedBox(width: 19.w);
//         },
//         itemBuilder: (BuildContext context, int index) {
//           return Container(
//             height: 167.h,
//             width: 163.w,
//             decoration: BoxDecoration(
//               color: Color(0xffF2F4F7),
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(32.r),
//                 topRight: Radius.circular(32.r),
//                 bottomRight: Radius.circular(8.r),
//                 topLeft: Radius.circular(8.r),
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   offset: Offset(0, 4),
//                   blurRadius: 4,
//                   spreadRadius: 0,
//                   color: Color(0xff000000).withValues(alpha: 0.1),
//                 ),
//               ],
//             ),
//             padding: EdgeInsets.only(top: 7.h, bottom: 4.h, right: 4.w, left: 4.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: 130.h,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(28.r),
//                       topRight: Radius.circular(28.r),
//                       bottomRight: Radius.circular(5.r),
//                       topLeft: Radius.circular(5.r),
//                     ),
//                     child: Image.asset(
//                       sliders[index],
//                       height: 128.h,
//                       width: 149.w,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 6.h),
//                 Container(
//                   height: 25.h,
//                   padding: EdgeInsets.only(right: 12.w, left: 12.w, bottom: 12.h),
//                   child: BasicTextStyle(
//                     title: title[index],
//                     weight: FontWeight.w700,
//                     size: 14.r,
//                     color: Color(0xff2E3337),
//                     height: 1.2,
//                     spacing: 0,
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _specialOfferBanner() {
//     return Container(
//       width: 342.w,
//       decoration: BoxDecoration(borderRadius: BorderRadius.circular(32.r)),
//       child: Stack(
//         children: [
//           Align(
//             alignment: Alignment.center,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(32.r),
//               child: Image(
//                 image: AssetImage(AppImages.specialOffer),
//                 fit: BoxFit.cover,
//                 height: 208.55,
//                 width: 342.w,
//               ),
//             ),
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: Container(
//               height: 210.h,
//               width: 342.w,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(32.r),
//                 gradient: LinearGradient(
//                   colors: [
//                     Color(0xff803500).withValues(alpha: 0.63),
//                     Color(0xffD9D9D9).withValues(alpha: 0),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsetsGeometry.all(24),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     BasicTextStyle(
//                       title: "Delicious Sale",
//                       weight: FontWeight.w800,
//                       size: 10.r,
//                       spacing: 2,
//                       height: 1.5,
//                       color: Color(0xffffffff),
//                     ),
//                     SizedBox(height: 3.3),
//                     BasicTextStyle(
//                       title: "UP TO 50% OFF",
//                       weight: FontWeight.w800,
//                       size: 30.r,
//                       spacing: 0,
//                       height: 1.25,
//                       color: Color(0xffffffff),
//                     ),
//                     SizedBox(height: 3.3),
//                     SizedBox(
//                       height: 48.h,
//                       width: 168.w,
//                       child: Align(
//                         alignment: Alignment.centerLeft,
//                         child: BasicTextStyle(
//                           title:
//                               "Unlock exclusive discounts on \npremium weekend ",
//                           weight: FontWeight.w400,
//                           size: 12.r,
//                           spacing: 0,
//                           height: 1.3,
//                           color: Color(0xffC7D2FE).withValues(alpha: 0.8),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16.h),
//                 AnimatedContainer(
//                   duration: Duration(milliseconds: 300),
//                   curve: Curves.easeIn,
//                   child: Container(
//                     height: 36.h,
//                     width: 142.w,
//                     padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 6.h),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(9999.r),
//                       color: Color(0xffffffff),
//                     ),
//                     child: Center(
//                       child: BasicTextStyle(
//                         title: "Book Now",
//                         weight: FontWeight.w700,
//                         size: 16.r,
//                         spacing: 0,
//                         color: Color(0xff544FEB),
//                         height: 1.5,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _bookTableTitle() {
//     return SizedBox(
//       width: 342.w,
//       child: BasicTextStyle(
//         title: "Book Your Table",
//         weight: FontWeight.w700,
//         size: 24.r,
//         color: Color(0xff2E3337),
//         spacing: -0.6,
//         height: 1.3,
//       ),
//     );
//   }

//   Widget _bookTableCards() {
//     return SizedBox(
//       width: 345.w,
//       height: 251.h,
//       child: ListView.separated(
//         shrinkWrap: true, // Sizes the list to its children
//         physics: const NeverScrollableScrollPhysics(),
//         scrollDirection: Axis.horizontal,
//         itemCount: 5,
//         separatorBuilder: (BuildContext context, int index) {
//           return SizedBox(width: 16.w);
//         },
//         itemBuilder: (BuildContext context, int index) {
//           return Container(
//             height: 251.h,
//             width: 207.w,
//             decoration: BoxDecoration(
//               color: Color(0xffF2F4F7),
//               borderRadius: BorderRadius.circular(23.r),
//             ),
//             padding: EdgeInsets.only(top: 7.h, bottom: 4.h, left: 9.w, right: 9.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(21.r),
//                   child: Image.asset(
//                     AppImages.bookTable,
//                     height: 128.h,
//                     width: 189.w,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 SizedBox(height: 6.h),
//                 SizedBox(
//                   width: 189.w,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Align(
//                         alignment: Alignment.centerLeft,
//                         child: Container(
//                           height: 20.h,
//                           padding: EdgeInsets.only(right: 12.w, left: 12.w),
//                           child: BasicTextStyle(
//                             title: "Hotel Greentop",
//                             weight: FontWeight.w700,
//                             size: 14.r,
//                             color: Color(0xff2E3337),
//                             height: 1.42,
//                             spacing: 0,
//                           ),
//                         ),
//                       ),
//                       SizedBox(width: 6.w),
//                       Container(
//                         height: 15.h,
//                         width: 36.w,
//                         padding: EdgeInsets.only(
//                           top: 2.h,
//                           right: 2.w,
//                           bottom: 2.h,
//                           left: 6.w,
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5.r),
//                           color: Color(0xff20201F),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.star,
//                               color: Color(0xffFF7346),
//                               size: 10.r,
//                             ),
//                             Container(
//                               padding: EdgeInsets.only(left: 4.w),
//                               child: BasicTextStyle(
//                                 title: "4.9",
//                                 weight: FontWeight.w700,
//                                 size: 8.r,
//                                 spacing: 0,
//                                 color: Color(0xffFFFFFF),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 6.h),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 7.0.w),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.location_on_outlined,
//                         color: Color(0xff767676),
//                         size: 14.r,
//                       ),
//                       SizedBox(height: 4.h),
//                       BasicTextStyle(
//                         title: "Malad",
//                         weight: FontWeight.w400,
//                         size: 14.r,
//                         height: 1.4,
//                         color: Color(0xff767676),
//                         spacing: 0,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(height: 6.h),
//                 Container(
//                   width: 171.w,
//                   padding: EdgeInsets.symmetric(horizontal: 9.w),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       BasicTextStyle(
//                         title: "₹3,000",
//                         weight: FontWeight.w400,
//                         size: 12.r,
//                         height: 1.3,
//                         spacing: 0,
//                         color: Color(0xff767676),
//                         decoration: TextDecoration.lineThrough,
//                       ),
//                       BasicTextStyle(
//                         title: "₹1,640",
//                         weight: FontWeight.w800,
//                         size: 20.r,
//                         height: 1.4,
//                         spacing: 0,
//                         color: Color(0xffA20197),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _recommendedForYouTitle() {
//     return SizedBox(
//       width: 342.w,
//       child: BasicTextStyle(
//         title: "Recommended for You",
//         weight: FontWeight.w700,
//         size: 24.r,
//         color: Color(0xff2E3337),
//         spacing: -0.6,
//         height: 1.3,
//       ),
//     );
//   }

//   Widget _recommendedForYouCards() {
//     List banner = [
//       AppImages.mostLovedStay1,
//       AppImages.mostLovedStay2,
//       AppImages.mostLovedStay3,
//       AppImages.mostLovedStay4,
//     ];
//     return SizedBox(
//       width: 347.w,
//       child: GridView.count(
//         physics: NeverScrollableScrollPhysics(),
//         shrinkWrap: true,
//         childAspectRatio: 163 / 195,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         crossAxisCount: 2,
//         children: List.generate(4, (index) {
//           return Container(
//             height: 195.h,
//             width: 163.w,
//             padding: EdgeInsets.only(top: 8.h, bottom: 4.h, left: 4.w, right: 4.w),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(32.r),
//               color: Color(0xffF2F4F7),
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(31.r),
//                   child: Image.asset(
//                     banner[index],
//                     height: 96.h,
//                     width: 146.w,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 SizedBox(height: 12.h),
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     right: 12.w,
//                     bottom: 12.h,
//                     left: 12.w,
//                   ),
//                   child: Column(
//                     children: [
//                       BasicTextStyle(
//                         title: "Palacio Villa",
//                         weight: FontWeight.w700,
//                         size: 14.r,
//                         spacing: 0,
//                         height: 1.3,
//                         color: Color(0xff2E3337),
//                       ),
//                       Container(
//                         padding: EdgeInsets.only(bottom: 8.h),
//                         child: BasicTextStyle(
//                           title: "Santorini, Greece",
//                           weight: FontWeight.w400,
//                           size: 10.r,
//                           spacing: 0,
//                           height: 1.5,
//                           color: Color(0xff5A6064),
//                         ),
//                       ),
//                       Text.rich(
//                         TextSpan(
//                           text: "₹25,000",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w400,
//                             fontSize: 10.sp,
//                             letterSpacing: 0,
//                             height: 2,
//                             decoration: TextDecoration.lineThrough,
//                           ),
//                           children: <TextSpan>[
//                             TextSpan(
//                               text: " ₹13,500",
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w800,
//                                 fontSize: 14.sp,
//                                 letterSpacing: 0,
//                                 height: 1.3,
//                                 color: Color(0xff3F56BF),
//                                 decoration: TextDecoration.none,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   Widget _limitedOfferTitle() {
//     return SizedBox(
//       width: 342.w,
//       child: BasicTextStyle(
//         title: "Limited Special Offers",
//         weight: FontWeight.w700,
//         size: 24.r,
//         color: Color(0xff2E3337),
//         spacing: -0.6,
//         height: 1.3,
//       ),
//     );
//   }

//   Widget _limitedOfferCards() {
//     return SizedBox(
//       height: 189.h,
//       width: 345.w,
//       child: ListView.separated(
//         shrinkWrap: true, // Sizes the list to its children
//         physics: const NeverScrollableScrollPhysics(),
//         scrollDirection: Axis.horizontal,
//         itemCount: 2,
//         separatorBuilder: (BuildContext context, int index) {
//           return SizedBox(width: 20.w);
//         },
//         itemBuilder: (BuildContext context, int index) {
//           return Container(
//             height: 189.h,
//             width: 163.w,
//             decoration: BoxDecoration(
//               color: Color(0xffF2F4F7),
//               borderRadius: BorderRadius.circular(32.r),
//             ),
//             padding: EdgeInsets.only(top: 7.h, bottom: 4.h, right: 4.w, left: 4.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(28.r),
//                   child: Image.asset(
//                     AppImages.limitedOffer,
//                     height: 128.h,
//                     width: 149.w,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 SizedBox(height: 6.h),
//                 Container(
//                   height: 42.h,
//                   padding: EdgeInsets.only(right: 12.w, left: 12.w, bottom: 8.h),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       BasicTextStyle(
//                         title: "Palacio Villa",
//                         weight: FontWeight.w700,
//                         size: 14.r,
//                         color: Color(0xff2E3337),
//                         height: 1.2,
//                         spacing: 0,
//                       ),
//                       BasicTextStyle(
//                         title: "₹13,500 ",
//                         weight: FontWeight.w800,
//                         size: 14.r,
//                         height: 1.2,
//                         color: Color(0xff3F56BF),
//                         spacing: 0,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _perfectForPlanTitle() {
//     return Container(
//       padding: EdgeInsets.only(top: 16.h),
//       width: 342.w,
//       child: BasicTextStyle(
//         title: "Perfect For Your Plan",
//         weight: FontWeight.w700,
//         size: 24.r,
//         color: Color(0xff2E3337),
//         spacing: -0.6,
//         height: 1.3,
//       ),
//     );
//   }

//   Widget _perfectForPlanCards() {
//     return Container(
//       width: 345.w,
//       height: 415.h,
//       padding: EdgeInsets.symmetric(vertical: 15.h),
//       child: ListView.separated(
//         shrinkWrap: true, // Sizes the list to its children
//         physics: const NeverScrollableScrollPhysics(),
//         scrollDirection: Axis.horizontal,
//         itemCount: 6,
//         separatorBuilder: (BuildContext context, int index) {
//           return SizedBox(width: 30.w);
//         },
//         itemBuilder: (BuildContext context, int index) {
//           return Container(
//             height: 396.h,
//             width: 342.w,
//             margin: EdgeInsets.only(top: 8.h),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Stack(
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(16.r),
//                       child: Image.asset(
//                         AppImages.perfectForPlan,
//                         height: 256.h,
//                         width: 342.w,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     Positioned(
//                       right: 16,
//                       top: 16,
//                       child: Column(
//                         children: [
//                           Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 12.w,
//                               vertical: 4.h,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(9999.r),
//                               color: Color(0xffFF7346).withValues(alpha: 0.9),
//                             ),
//                             child: BasicTextStyle(
//                               title: "Few rooms left",
//                               weight: FontWeight.w700,
//                               size: 10.r,
//                               height: 1.5,
//                               spacing: 1,
//                               color: Color(0xff420D00),
//                             ),
//                           ),
//                           SizedBox(height: 8.h),
//                           Container(
//                             margin: EdgeInsets.only(left: 7.w),
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 12.w,
//                               vertical: 4.h,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Color(0xff95AAFF).withValues(alpha: 0.2),
//                               borderRadius: BorderRadius.circular(9999.r),
//                               border: Border.all(
//                                 width: 1,
//                                 color: Color(0xff95AAFF).withValues(alpha: 0.2),
//                               ),
//                             ),
//                             child: BasicTextStyle(
//                               title: "50% OFF TODAY",
//                               weight: FontWeight.w700,
//                               size: 10.r,
//                               height: 1.5,
//                               spacing: 1,
//                               color: Color(0xff000E48),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 16.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Column(
//                       children: [
//                         BasicTextStyle(
//                           title: "Rustic Wooden Hut",
//                           weight: FontWeight.w700,
//                           size: 20.r,
//                           color: Color(0xff1A1A1A),
//                           height: 1.2,
//                           spacing: 0,
//                         ),
//                         SizedBox(height: 2),
//                         BasicTextStyle(
//                           title: "Bali, Indonesia • Beachfront",
//                           weight: FontWeight.w400,
//                           size: 14.r,
//                           height: 1.3,
//                           color: Color(0xff575757),
//                           spacing: 0,
//                         ),
//                       ],
//                     ),
//                     Container(
//                       height: 28.h,
//                       width: 53.w,
//                       padding: EdgeInsets.only(
//                         top: 4.h,
//                         right: 8.w,
//                         bottom: 4.h,
//                         left: 8.w,
//                       ),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(8.r),
//                         color: Color(0xff20201F),
//                       ),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Icon(Icons.star, color: Color(0xffFF7346), size: 12.r),
//                           Container(
//                             padding: EdgeInsets.only(left: 4.w),
//                             child: BasicTextStyle(
//                               title: "4.9",
//                               weight: FontWeight.w700,
//                               size: 14.r,
//                               spacing: 0,
//                               color: Color(0xffFFFFFF),
//                               height: 1.4,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 15.h),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text.rich(
//                           TextSpan(
//                             text: '₹20,500',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w800,
//                               fontSize: 24.sp,
//                               height: 1.3,
//                               letterSpacing: 0,
//                               color: Color(0xff4D49D9),
//                             ),
//                             children: <TextSpan>[
//                               TextSpan(
//                                 text: ' /night',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 14.sp,
//                                   color: Color(0xff575757),
//                                   letterSpacing: 0,
//                                   height: 1.4,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         BasicTextStyle(
//                           title: "Only 2 rooms available",
//                           weight: FontWeight.w700,
//                           size: 10.r,
//                           height: 1.4,
//                           spacing: 0,
//                           color: Color(0xffBB1414),
//                         ),
//                       ],
//                     ),
//                     AnimatedContainer(
//                       duration: Duration(milliseconds: 300),
//                       curve: Curves.easeIn,
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 24.w,
//                           vertical: 12.h,
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(9999.r),
//                           color: Color(0xff4D49D9),
//                         ),
//                         child: Center(
//                           child: BasicTextStyle(
//                             title: "Book Now",
//                             weight: FontWeight.w700,
//                             size: 14.r,
//                             spacing: 0,
//                             color: Color(0xffffffff),
//                             height: 1.4,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
