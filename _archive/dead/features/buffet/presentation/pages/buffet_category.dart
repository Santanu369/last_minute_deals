// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lmd_app/bloc/buffet/buffet_cubit.dart';
// import 'package:lmd_app/bloc/buffet/buffet_state.dart';
// import 'package:lmd_app/bloc/details/details_cubit.dart';
// // import 'package:flutter_lmd_5/config/assets/app_images.dart';
// // import 'package:flutter_lmd_5/config/assets/basic_text_style.dart';
// // import 'package:flutter_lmd_5/presentation/home/widgets/basic_appbar.dart';
// import 'package:lmd_app/config/assets/app_images.dart';
// import 'package:lmd_app/config/assets/basic_text_style.dart';
// import 'package:lmd_app/models/hotel_details/hotel_page_request.dart';
// import 'package:lmd_app/pages/Details/details_screen.dart';
// // import 'package:flutter_lmd_5/home/widgets/basic_appbar.dart';

// class BuffetCatagory extends StatefulWidget {
//   final String category;
//   const BuffetCatagory({
//     super.key,
//     required this.title,
//     required this.category,
//   });

//   final String title;

//   @override
//   State<BuffetCatagory> createState() => _BuffetCatagoryState();
// }

// class _BuffetCatagoryState extends State<BuffetCatagory>
//     with TickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 5, vsync: this);
//     final cubit = context.read<BuffetCubit>();
//     if (cubit.state.allBuffets.isEmpty) {
//       cubit.loadBuffets();
//     }

//     cubit.changeCategory(widget.category);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   int tab = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xffF8F9FC),
//       appBar: AppBar(
//         backgroundColor: Color(0xffF8F9FC),
//         // centerTitle: true,
//         leading: InkWell(
//           onTap: () {
//             Navigator.pop(context);
//           },
//           child: const Icon(Icons.arrow_back, color: Color(0xff4D49D9)),
//         ),
//         title: BasicTextStyle(
//           title: "Last Minutes Deal".toUpperCase(),
//           weight: FontWeight.w800,
//           size: 20.0.r,
//           spacing: -1,
//           height: 1.4,
//           color: Color(0xff4D49D9),
//         ),
//         actions: [
//           Container(
//             height: 40.h,
//             width: 40.w,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(9999.r),
//             ),
//             child: Image.asset(AppImages.appbarIcon, height: 18.h, width: 18.w),
//           ),
//         ],
//       ),
//       // body: NestedScrollView(
//       //   headerSliverBuilder: (context, innerBoxIsScrolled) {
//       //     return <Widget>[
//       //       SliverOverlapAbsorber(
//       //         handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//       //         sliver: SliverAppBar(
//       //           backgroundColor: Color(0xffF8F9FC),
//       //           elevation: 0,
//       //           pinned: false,
//       //           floating: false,
//       //           expandedHeight: 280,
//       //           collapsedHeight: 280,
//       //           automaticallyImplyLeading: false,
//       //           flexibleSpace: Container(
//       //             margin: EdgeInsets.only(
//       //               right: 24.w,
//       //               left: 24.w,
//       //               bottom: 0,
//       //               top: 30.h,
//       //             ),
//       //             child: _topTitleSection(),
//       //           ),
//       //         ),
//       //       ),
//       //       SliverToBoxAdapter(child: Container(height: 35.h)),
//       //       // SliverPersistentHeader(
//       //       //   pinned: true,
//       //       //   delegate: _TabBarHeaderDelegate(child: _tabbar(context)),
//       //       // ),
//       //        SliverToBoxAdapter(child: Container(height: 0)),
//       //     ];
//       //   },
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             backgroundColor: Color(0xffF8F9FC),
//             elevation: 0,
//             pinned: false,
//             floating: false,
//             expandedHeight: 280,
//             collapsedHeight: 280,
//             automaticallyImplyLeading: false,
//             flexibleSpace: Container(
//               margin: EdgeInsets.only(right: 24.w, left: 24.w, bottom: 0, top: 30.h),
//               child: _topTitleSection(),
//             ),
//           ),
//           SliverToBoxAdapter(child: Container(height: 35.h)),

//           SliverList(
//             delegate: SliverChildListDelegate([
//               Container(
//                 padding: EdgeInsets.only(
//                   right: 24.w,
//                   left: 24.w,
//                   bottom: 0,
//                   top: 0,
//                 ),
//                 constraints: BoxConstraints(maxWidth: 1280),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _weekendBanner(),
//                     SizedBox(height: 35.h),
//                     _articleCards(),
//                   ],
//                 ),
//               ),
//             ]),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _topTitleSection() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         BasicTextStyle(
//           title: "Curated Selection".toUpperCase(),
//           weight: FontWeight.w700,
//           size: 10.r,
//           height: 1.5,
//           spacing: 1,
//           color: Color(0xff7935D6),
//         ),
//         SizedBox(height: 8.h),
//         BasicTextStyle(
//           title: widget.title,
//           weight: FontWeight.w800,
//           size: 36.r,
//           height: 1.25,
//           spacing: -0.9,
//           color: Color(0xff2E3337),
//         ),
//         SizedBox(height: 8.h),
//         Container(
//           padding: EdgeInsets.only(top: 8.h),
//           constraints: BoxConstraints(maxWidth: 576),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               BasicTextStyle(
//                 title:
//                     "Handpicked urban sanctuaries where \ndesign meets comfort. Discover the \nsoulful side of the city.",
//                 weight: FontWeight.w400,
//                 size: 18.r,
//                 height: 1.55,
//                 spacing: 0,
//                 color: Color(0xff5A6064),
//               ),
//               SizedBox(height: 10.h),
//               Container(
//                 constraints: BoxConstraints(maxWidth: 800),
//                 decoration: BoxDecoration(
//                   boxShadow: [
//                     BoxShadow(
//                       blurRadius: 32,
//                       spreadRadius: 0,
//                       offset: Offset(0, 12),
//                       color: Color(0xff2E3337).withValues(alpha: 0.04),
//                     ),
//                   ],
//                 ),

//                 child: SearchBar(
//                   padding: WidgetStatePropertyAll(EdgeInsets.all(12.w)),
//                   hintText: "Where are you heading?",
//                   hintStyle: WidgetStatePropertyAll(
//                     TextStyle(
//                       fontWeight: FontWeight.w500,
//                       fontSize: 16.sp,
//                       color: Color(0xff767B80),
//                       letterSpacing: 0,
//                       height: 1,
//                     ),
//                   ),
//                   backgroundColor: WidgetStatePropertyAll(Color(0xffFFFFFF)),

//                   shape: WidgetStateProperty.all(
//                     RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(
//                         32,
//                       ), // Adjust radius here
//                     ),
//                   ),
//                   shadowColor: WidgetStateProperty.all(
//                     Color(0xff2E3337).withValues(alpha: 0.04),
//                   ),
//                   leading: Padding(
//                     padding: const EdgeInsets.only(left: 8.0.w),
//                     child: Icon(
//                       Icons.search,
//                       color: Color(0xffA40000),
//                       size: 22.r,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   // Widget _tabbar(BuildContext context) {
//   //   return Container(
//   //     color: Color(0xffF8F9FC),
//   //     width: MediaQuery.of(context).size.width,
//   //     height: 75.h,
//   //     // padding: EdgeInsets.symmetric(vertical: 16.h),
//   //     child: Center(
//   //       child: TabBar(
//   //         controller: _tabController,
//   //         physics: BouncingScrollPhysics(),
//   //         isScrollable: true,
//   //         // padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//   //         dividerColor: Colors.transparent,
//   //         dividerHeight: 60,
//   //         splashBorderRadius: BorderRadius.circular(9999.r),
//   //         overlayColor: WidgetStateProperty.all(Colors.transparent),
//   //         labelStyle: TextStyle(
//   //           fontSize: 14.sp,
//   //           fontWeight: FontWeight.w600,
//   //           height: 1.4,
//   //           letterSpacing: 0,
//   //         ),
//   //         indicator: BoxDecoration(borderRadius: BorderRadius.circular(9999.r)),
//   //         indicatorPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
//   //         indicatorSize: TabBarIndicatorSize.tab,
//   //         labelPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
//   //         labelColor: Color(0xffffffff),
//   //         unselectedLabelColor: Color(0xff4D49D9),
//   //         tabAlignment: TabAlignment.center,
//   //         onTap: (value) {
//   //           setState(() {
//   //             tab = value;
//   //             // debugPrint(value);
//   //           });
//   //         },
//   //         tabs: List.generate(5, (index) {
//   //           List<String> tabs = [
//   //             "All",
//   //             "Hotels",
//   //             "Resort",
//   //             "Villas",
//   //             "Apartments",
//   //           ];
//   //           List colors = [
//   //             tab == 0 ? Color(0xff4D49D9) : Color(0xffE8E8F9),
//   //             tab == 1 ? Color(0xffA40000) : Color(0xffE8E8F9),
//   //             tab == 2 ? Color(0xff00AD20) : Color(0xffE8E8F9),
//   //             tab == 3 ? Color(0xffA98129) : Color(0xffE8E8F9),
//   //             tab == 4 ? Color(0xff4D49D9) : Color(0xffE8E8F9),
//   //           ];
//   //           return Container(
//   //             // padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
//   //             width: 80.w,
//   //             height: 40.h,
//   //             decoration: BoxDecoration(
//   //               color: colors[index],
//   //               borderRadius: BorderRadius.circular(9999.r),
//   //             ),
//   //             child: Center(child: Tab(text: tabs[index])),
//   //           );
//   //         }),

//   //         // indicatorColor: Colors.transparent,
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _weekendBanner() {
//     return Container(
//       height: 232.h,
//       width: 342.w,
//       // padding: EdgeInsets.only(top: 8.h),
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
//               width: 270.w,
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

//   Widget _articleCards() {
//     return BlocBuilder<BuffetCubit, BuffetState>(
//       builder: (context, state) {
//         if (state.isLoading) {
//           return Center(child: CircularProgressIndicator());
//         }
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: List.generate(state.visibleBuffets.length, (index) {
//             final buffet = state.visibleBuffets[index];
//             return SizedBox(
//               width: 350.w,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Stack(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(16.r),
//                         child: CachedNetworkImage(
//                           imageUrl: buffet.images[0],
//                           height: 200.h,
//                           width: 350.w,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       Positioned(
//                         right: 16,
//                         top: 16,
//                         child: Column(
//                           children: [
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 12.w,
//                                 vertical: 4.h,
//                               ),
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(9999.r),
//                                 color: Color(0xffFF7346).withValues(alpha: 0.9),
//                               ),
//                               child: BasicTextStyle(
//                                 title: "Few rooms left",
//                                 weight: FontWeight.w700,
//                                 size: 10.r,
//                                 height: 1.5,
//                                 spacing: 1,
//                                 color: Color(0xff420D00),
//                               ),
//                             ),
//                             SizedBox(height: 8.h),
//                             Container(
//                               margin: EdgeInsets.only(left: 7.w),
//                               padding: EdgeInsets.symmetric(
//                                 horizontal: 12.w,
//                                 vertical: 4.h,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Color(0xff95AAFF).withValues(alpha: 0.2),
//                                 borderRadius: BorderRadius.circular(9999.r),
//                                 border: Border.all(
//                                   width: 1,
//                                   color: Color(
//                                     0xff95AAFF,
//                                   ).withValues(alpha: 0.2),
//                                 ),
//                               ),
//                               child: BasicTextStyle(
//                                 title: "50% OFF TODAY",
//                                 weight: FontWeight.w700,
//                                 size: 10.r,
//                                 height: 1.5,
//                                 spacing: 1,
//                                 color: Color(0xff000E48),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 16.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Column(
//                         children: [
//                           BasicTextStyle(
//                             title: "${buffet.name}",
//                             weight: FontWeight.w700,
//                             size: 20.r,
//                             color: Color(0xff1A1A1A),
//                             height: 1.2,
//                             spacing: 0,
//                           ),
//                           SizedBox(height: 2),
//                           BasicTextStyle(
//                             title: "${buffet.city}",
//                             weight: FontWeight.w400,
//                             size: 14.r,
//                             height: 1.3,
//                             color: Color(0xff575757),
//                             spacing: 0,
//                           ),
//                         ],
//                       ),
//                       Container(
//                         height: 28.h,
//                         width: 53.w,
//                         padding: EdgeInsets.only(
//                           top: 4.h,
//                           right: 8.w,
//                           bottom: 4.h,
//                           left: 8.w,
//                         ),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(8.r),
//                           color: Color(0xff20201F),
//                         ),
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.star,
//                               color: Color(0xffFF7346),
//                               size: 12.r,
//                             ),
//                             Container(
//                               padding: EdgeInsets.only(left: 4.w),
//                               child: BasicTextStyle(
//                                 title: "4.9",
//                                 weight: FontWeight.w700,
//                                 size: 14.r,
//                                 spacing: 0,
//                                 color: Color(0xffFFFFFF),
//                                 height: 1.4,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 15.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text.rich(
//                             TextSpan(
//                               text: '₹${buffet.price}',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.w800,
//                                 fontSize: 24.sp,
//                                 height: 1.3,
//                                 letterSpacing: 0,
//                                 color: Color(0xff4D49D9),
//                               ),
//                               children: <TextSpan>[
//                                 TextSpan(
//                                   text: ' /night',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: 14.sp,
//                                     color: Color(0xff575757),
//                                     letterSpacing: 0,
//                                     height: 1.4,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           BasicTextStyle(
//                             title: "Only 2 rooms available",
//                             weight: FontWeight.w700,
//                             size: 10.r,
//                             height: 1.4,
//                             spacing: 0,
//                             color: Color(0xffBB1414),
//                           ),
//                         ],
//                       ),
//                       AnimatedContainer(
//                         duration: Duration(milliseconds: 300),
//                         curve: Curves.easeIn,
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => BlocProvider(
//                                   create: (context) => DetailsCubit(),
//                                   child: DetailsScreen(
//                                     request: HotelPageRequest.defaultSearch(
//                                       hid: buffet.hid,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 24.w,
//                               vertical: 12.h,
//                             ),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(9999.r),
//                               color: Color(0xff4D49D9),
//                             ),
//                             child: Center(
//                               child: BasicTextStyle(
//                                 title: "Book Now",
//                                 weight: FontWeight.w700,
//                                 size: 14.r,
//                                 spacing: 0,
//                                 color: Color(0xffffffff),
//                                 height: 1.4,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 35.h),
//                 ],
//               ),
//             );
//           }),
//         );
//       },
//     );
//   }
// }

// // @immutable
// // class _TabBarHeaderDelegate extends SliverPersistentHeaderDelegate {
// //   const _TabBarHeaderDelegate({required this.child});

// //   final Widget child;

// //   @override
// //   double get minExtent => 75;

// //   @override
// //   double get maxExtent => 75;

// //   @override
// //   Widget build(
// //     BuildContext context,
// //     double shrinkOffset,
// //     bool overlapsContent,
// //   ) {
// //     return Container(color: Color(0xffF8F9FC), child: child);
// //   }

// //   @override
// //   bool shouldRebuild(covariant _TabBarHeaderDelegate oldDelegate) {
// //     return oldDelegate.child != child;
// //   }
// // }
