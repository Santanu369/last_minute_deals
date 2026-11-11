// import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lmd_app/bloc/details/details_cubit.dart';
// import 'package:lmd_app/bloc/hotel/hotel_cubit.dart';
// import 'package:lmd_app/bloc/hotel/hotel_state.dart';
// import 'package:lmd_app/bloc/prebook/prebook_cubit.dart';
// import 'package:lmd_app/common/widgets/basic_appbar.dart';
// import 'package:lmd_app/config/assets/basic_text_style.dart';
// import 'package:lmd_app/models/hotel_details/hotel_page_request.dart';
// import 'package:lmd_app/models/listing_model.dart';
// import 'package:lmd_app/pages/Details/details_screen.dart';
// import 'package:lmd_app/pages/hotels/hotels_category.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';


// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {

//    final TextEditingController searchController = TextEditingController();
//   // final FocusNode _destinatonFocus = FocusNode();
//   final FocusNode _searchFocus = FocusNode();
//   // final FocusNode _editGuestFocus = FocusNode();
//   final LayerLink _searchLink = LayerLink();

//   String searchQuery = '';
//   bool _isDestinatonDialog = false;
//   bool _isEditGuestVisible = false;
//   bool _searchButton = true;
//   DateTime? _selectedStartDate;
//   DateTime? _selectedEndDate;

//   double editGuestHeight = 822;

//   int rooms = 1;
//   int adults = 2;
//   int children = 0;

//   int selectedAge = 1;
//   bool travellingWithPets = false;

//   String get _dateRangeLabel {
//     if (_selectedStartDate == null || _selectedEndDate == null) {
//       return 'Select check-in and check-out';
//     }

//     final startLabel = _formatDate(_selectedStartDate!);
//     final endLabel = _formatDate(_selectedEndDate!);
//     return '$startLabel - $endLabel';
//   }

//   String _formatDate(DateTime date) {
//     final month = <int, String>{
//       1: 'Jan',
//       2: 'Feb',
//       3: 'Mar',
//       4: 'Apr',
//       5: 'May',
//       6: 'Jun',
//       7: 'Jul',
//       8: 'Aug',
//       9: 'Sep',
//       10: 'Oct',
//       11: 'Nov',
//       12: 'Dec',
//     }[date.month];

//     return '$month ${date.day}';
//   }

//    Future<void> _showPicker() async {
//     DateTime? tempStartDate = _selectedStartDate;
//     DateTime? tempEndDate = _selectedEndDate;

//     await showDialog<void>(
//       context: context,
//       barrierDismissible: false,
//       builder: (dialogContext) {
//         return Dialog(
//           insetPadding: const EdgeInsets.all(16.w),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.r),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.w),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text(
//                       'Select dates',
//                       style: TextStyle(
//                         fontSize: 18.sp,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                     IconButton(
//                       onPressed: () => Navigator.of(dialogContext).pop(),
//                       icon: const Icon(Icons.close),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8.h),
//                 SizedBox(
//                   height: 420.h,
//                   child: SfDateRangePicker(
//                     view: DateRangePickerView.month,
//                     selectionMode: DateRangePickerSelectionMode.range,
//                     minDate: DateTime.now(),
//                     showActionButtons: true,
//                     confirmText: 'Apply',
//                     cancelText: 'Cancel',
//                     startRangeSelectionColor: Color(0xff4D49D9),
//                     endRangeSelectionColor: Color(0xff4D49D9),
//                     todayHighlightColor: Color(0xff4D49D9),
//                     rangeSelectionColor: Color(
//                       0xff4D49D9,
//                     ).withValues(alpha: 0.5),
//                     // maxDate: DateTime.now().add(Duration(days: 2)),
//                     initialSelectedRange:
//                         tempStartDate == null && tempEndDate == null
//                         ? PickerDateRange(
//                             DateTime.now().add(Duration(days: 1)),
//                             DateTime.now().add(Duration(days: 2)),
//                           )
//                         : PickerDateRange(tempStartDate, tempEndDate),
//                     onSelectionChanged:
//                         (DateRangePickerSelectionChangedArgs args) {
//                           if (args.value is PickerDateRange) {
//                             final range = args.value as PickerDateRange;
//                             setState(() {
//                               tempStartDate = range.startDate;
//                               tempEndDate = range.endDate;
//                             });
//                           }
//                         },
//                     onSubmit: (Object? value) {
//                       if (value is PickerDateRange) {
//                         setState(() {
//                           _selectedStartDate = value.startDate;
//                           _selectedEndDate = value.endDate;
//                         });
//                       }
//                       Navigator.of(dialogContext).pop();
//                     },
//                     onCancel: () => Navigator.of(dialogContext).pop(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//    @override
//   void dispose() {
//     searchController.dispose();
//     // _destinatonFocus.dispose();
//     // _editGuestFocus.dispose();
//     super.dispose();
//   }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: BasicAppbar(isActions: false,),
//       body : Stack(
//         children: [
//           SingleChildScrollView(
//             child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
//               child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
              
//                 children: [
//                   _topTitleSection([]),
//                    SizedBox(height: 25.h),
//               _articleCards(),
//                 ],
//               ),
//             ),
//           ),
       
//        Visibility(
//               visible: _isDestinatonDialog,
//               child: CompositedTransformFollower(
//                 link: _searchLink,
//                 targetAnchor: Alignment.bottomLeft,
//                 followerAnchor: Alignment.topLeft,
//                 offset: const Offset(0, 0),
//                 child: Material(
//                   elevation: 8,
//                   borderRadius: BorderRadius.circular(16.r),
//                   child: Container(
//                     width: MediaQuery.of(context).size.width - 48,
//                     constraints: const BoxConstraints(maxHeight: 300),
//                     child: BlocBuilder<HotelCubit, HotelState>(
//                       builder: (context, state) {
//                         List<ListingModel> listings = state.allListings;

//                         // switch (tab) {
//                         //   case 1:
//                         //     listings = listings
//                         //         .where(
//                         //           (e) => e.category.toLowerCase().contains(
//                         //             'hotel',
//                         //           ),
//                         //         )
//                         //         .toList();
//                         //     break;

//                         //   case 2:
//                         //     listings = listings
//                         //         .where(
//                         //           (e) => e.category.toLowerCase().contains(
//                         //             'resort',
//                         //           ),
//                         //         )
//                         //         .toList();
//                         //     break;

//                         //   case 3:
//                         //     listings = listings
//                         //         .where(
//                         //           (e) => e.category.toLowerCase().contains(
//                         //             'villa',
//                         //           ),
//                         //         )
//                         //         .toList();
//                         //     break;
//                         // }
//                         // final filteredListings = listings.where((listing) {
//                         //   return listing.name.toLowerCase().contains(
//                         //         searchQuery,
//                         //       ) ||
//                         //       listing.city.toLowerCase().contains(
//                         //         searchQuery,
//                         //       ) ||
//                         //       listing.category.toLowerCase().contains(
//                         //         searchQuery,
//                         //       );
//                         // }).toList();

//                         return Column(
//                           children: [
//                             SearchBar(
//                               controller: searchController,
//                               focusNode: _searchFocus,
//                               onChanged: (value) {
//                                 setState(() {
//                                   searchQuery = value.trim().toLowerCase();
//                                 });
//                               },
//                               // padding: WidgetStatePropertyAll(EdgeInsets.all(12.w)),
//                               hintText: "Where are you heading?",
//                               hintStyle: WidgetStatePropertyAll(
//                                 TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 16.sp,
//                                   color: Color(0xff767B80),
//                                   letterSpacing: 0,
//                                   height: 1,
//                                 ),
//                               ),
//                               backgroundColor: WidgetStatePropertyAll(
//                                 Color(0xffFFFFFF),
//                               ),
//                               shape: WidgetStateProperty.all(
//                                 RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(
//                                     12,
//                                   ), // Adjust radius here
//                                 ),
//                               ),
//                               shadowColor: WidgetStateProperty.all(
//                                 Color(0xff2E3337).withValues(alpha: 0.04),
//                               ),
//                               leading: Padding(
//                                 padding: const EdgeInsets.only(left: 8.0.w),
//                                 child: Icon(
//                                   Icons.search,
//                                   color: Colors.black,
//                                   size: 22.r,
//                                 ),
//                               ),
//                             ),
//                             listings.isEmpty
//                                 ? Container(
//                                     // margin: const EdgeInsets.only(top: 8.h),
//                                     padding: const EdgeInsets.all(16.w),
//                                     decoration: BoxDecoration(
//                                       // color: Colors.white,
//                                       borderRadius: BorderRadius.circular(16.r),
//                                     ),
//                                     child: const Text('No hotels found'),
//                                   )
//                                 : Container(
//                                     // margin: const EdgeInsets.only(top: 8.h),
//                                     constraints: const BoxConstraints(
//                                       maxHeight: 300,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(16.r),
//                                     ),
//                                     child: ListView.builder(
//                                       shrinkWrap: true,
//                                       itemCount: listings.length,
//                                       itemBuilder: (context, index) {
//                                         final hotel = listings[index];

//                                         return Material(
//                                           color: Colors.transparent,
//                                           child: ListTile(
//                                             title: Text(hotel.name),
//                                             subtitle: Text(hotel.city),
//                                             onTap: () {
//                                               searchController.text =
//                                                   hotel.name;

//                                               setState(() {
//                                                 searchQuery = '';
//                                               });

//                                               Navigator.push(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder: (_) => MultiBlocProvider(
//                                                     providers: [
//                                                       BlocProvider(
//                                                         create: (_) =>
//                                                             DetailsCubit(),
//                                                       ),
//                                                       BlocProvider(
//                                                         create: (_) =>
//                                                             PrebookCubit(),
//                                                       ),
//                                                     ],
//                                                     child: DetailsScreen(
//                                                       request:
//                                                           HotelPageRequest.defaultSearch(
//                                                             hid: hotel.hid,
//                                                           ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                               );
//                                             },
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                           ],
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
       
//         ],
//       )
//     );
//   }

//     Widget _articleCards() {
//     return BlocBuilder<HotelCubit, HotelState>(
//       builder: (context, state) {
//         if (state.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: state.visibleListings.map((hotel) {
//             return ConstrainedBox(
//               constraints: BoxConstraints(
//                 maxWidth: 600,
//                 minWidth: 350,
//                 minHeight: 390,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Stack(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(16.r),
//                         child: buildListingImage(
//                           imageUrl: hotel.thumbnail,
//                           height: 200.h,
//                           width: double.infinity,
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
//                                 title: "0",
//                                 // "${(hotel.discountbps / 100).toStringAsFixed(0)}% OFF",
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
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             BasicTextStyle(
//                               title: "${hotel.name}",
//                               weight: FontWeight.w700,
//                               size: 20.r,
//                               color: Color(0xff1A1A1A),
//                               height: 1.2,
//                               spacing: 0,
//                             ),
//                             SizedBox(height: 2),
//                             BasicTextStyle(
//                               title: "${hotel.city}",
//                               weight: FontWeight.w400,
//                               size: 14.r,
//                               height: 1.3,
//                               color: Color(0xff575757),
//                               spacing: 0,
//                             ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         height: 28.h,
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
//                           mainAxisSize: MainAxisSize.min,
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
//                               text: '₹${hotel.price}',
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
//                             title: "Book before it's gone",
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
//                             // Navigator.push(
//                             //   context,
//                             //   MaterialPageRoute(
//                             //     builder: (_) => BlocProvider(
//                             //       create: (_) => DetailsCubit(),
//                             //       child: DetailsScreen(
//                             //         request: HotelPageRequest.defaultSearch(
//                             //           hid: hotel.hid,
//                             //         ),
//                             //       ),
//                             //     ),
//                             //   ),
//                             // );
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (_) => MultiBlocProvider(
//                                   providers: [
//                                     BlocProvider(create: (_) => DetailsCubit()),
//                                     BlocProvider(create: (_) => PrebookCubit()),
//                                   ],
//                                   child: DetailsScreen(
//                                     request: HotelPageRequest.defaultSearch(
//                                       hid: hotel.hid,
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
//           }).toList(),
//         );
//       },
//     );
//   }

//    Widget _topTitleSection(List<dynamic> colors) {
//     return
//         Container(
//           // padding: tab == 0 ? EdgeInsets.only(top: 0) : EdgeInsets.only(top: 8.h),
//           constraints: BoxConstraints(maxWidth: 576),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               SizedBox(height: 10.h),

//               Container(
//                 constraints: BoxConstraints(maxWidth: 800),
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16.w,
//                   vertical: 24.h,
//                 ),

//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(14.r),
//                   boxShadow: [
//                     BoxShadow(
//                       blurRadius: 32,
//                       spreadRadius: 0,
//                       offset: Offset(4, 4),
//                       color: Color(0xff2E3337).withValues(alpha: 0.05),
//                     ),
//                   ],
//                 ),

//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CompositedTransformTarget(
//                       link: _searchLink,
//                       child: InkWell(
//                         onTap: () {
//                           _searchFocus.requestFocus();
//                           setState(() {
//                             _isDestinatonDialog = !_isDestinatonDialog;
//                           });
//                         },
//                         child: _buildTile(
//                           icon: Icons.location_on_outlined,
//                           title: "DESTINATION",
//                           value: "Where are you heading?",
//                           tralingIcon: Icons.chevron_right,
//                         ),
//                       ),
//                     ),

//                     const Divider(
//                       height: 20.h,
//                       color: Color(0xffC4C4C4),
//                       thickness: 0.2,
//                     ),

//                     InkWell(
//                       onTap: () => _showPicker(),
//                       child: _buildTile(
//                         icon: Icons.calendar_month_outlined,
//                         title: "CHECK-IN - CHECK-OUT",
//                         value: _dateRangeLabel,
//                         tralingIcon: Icons.chevron_right,
//                       ),
//                     ),

//                     const Divider(
//                       height: 20.h,
//                       color: Color(0xffC4C4C4),
//                       thickness: 0.2,
//                     ),

//                     Column(
//                       children: [
//                         InkWell(
//                           onTap: () {
//                             setState(() {
//                               _isEditGuestVisible = !_isEditGuestVisible;
//                               _searchButton = !_searchButton;
//                             });
//                           },
//                           child: _buildTile(
//                             icon: Icons.people_alt_outlined,
//                             title: "GUEST & ROOMS",
//                             value: "2 Adults, 1 Room",
//                             tralingIcon: _isEditGuestVisible == false
//                                 ? Icons.chevron_right
//                                 : Icons.keyboard_arrow_down,
//                           ),
//                         ),
//                         Visibility(
//                           visible: _isEditGuestVisible,
//                           child: _editGuests(),
//                         ),
//                       ],
//                     ),

//                     Visibility(
//                       visible: _searchButton,
//                       child: Container(
//                         margin: EdgeInsets.only(left: 40.w, right: 40.w, top: 24.h),
//                         width: double.infinity,
//                         height: 50.h,
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => const SearchPage(),
//                               ),
//                             );
//                           },
//                           icon: const Icon(Icons.search, color: Colors.white),
//                           label: const Text(
//                             "Search Stays",
//                             style: TextStyle(color: Colors.white, fontSize: 16.sp),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF4D49D9),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(10.r),
//                             ),
//                             elevation: 0,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
      
    
//   }

//     static Widget _buildTile({
//     required IconData icon,
//     required String title,
//     required String value,
//     required IconData tralingIcon,
//   }) {
//     return Row(
//       children: [
//         Container(
//           width: 42.w,
//           height: 42.h,
//           decoration: BoxDecoration(
//             color: const Color(0xFFE8E8F9),
//             borderRadius: BorderRadius.circular(10.r),
//           ),
//           child: Center(child: Icon(icon, color: const Color(0xFF4D49D9))),
//         ),

//         const SizedBox(width: 12.w),

//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 10.sp,
//                   color: Color(0xff474747),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               const SizedBox(height: 4.h),
//               Text(
//                 value,
//                 style: const TextStyle(fontSize: 16.sp, color: Colors.black87),
//               ),
//             ],
//           ),
//         ),

//         Icon(
//           tralingIcon,
//           color: Color(0xffBABABA),
//           // size: 20.r,
//         ),
//       ],
//     );
//   }

//    Widget _editGuests() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 8.w, right: 8.w, top: 18.h),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           buildCounter(
//             title: "Room",
//             value: rooms,
//             onMinus: () {
//               if (rooms > 1) {
//                 setState(() => rooms--);
//               }
//             },
//             onPlus: () {
//               if (rooms < 20) {
//                 setState(() => rooms++);
//               }
//             },
//           ),

//           buildCounter(
//             title: "Adults",
//             value: adults,
//             onMinus: () {
//               if (adults > 1) {
//                 setState(() => adults--);
//               }
//             },
//             onPlus: () {
//               if (adults < 40) {
//                 setState(() => adults++);
//               }
//             },
//           ),

//           buildCounter(
//             title: "Children",
//             subtitle: "0-17 Years Old",
//             value: children,
//             onMinus: () {
//               if (children > 0) {
//                 setState(() => children--);
//               }
//             },
//             onPlus: () {
//               if (children < 40) {
//                 setState(() => children++);
//               }
//             },
//           ),

//           const SizedBox(height: 10.h),

//           Text(
//             "Please provide right number of children along with their right age for best options and prices.",
//             style: TextStyle(color: Color(0xff767676), fontSize: 9.sp),
//           ),

//           const SizedBox(height: 12.h),

//           Divider(color: Color(0xffd6d6d6)),

//           Visibility(
//             visible: children > 0,
//             child: Column(
//               crossAxisAlignment: .start,
//               children: [
//                 const SizedBox(height: 12.h),

//                 const Text(
//                   "Age Of Children",
//                   style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
//                 ),

//                 const SizedBox(height: 12.h),

//                 SizedBox(
//                   height: children >= 5 ? 239 : null,
//                   child: ListView.separated(
//                     itemCount: children,
//                     physics: children > 5
//                         ? BouncingScrollPhysics()
//                         : NeverScrollableScrollPhysics(),
//                     separatorBuilder: (context, index) => SizedBox(height: 12.h),
//                     shrinkWrap: true,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Row(
//                         children: [
//                           Expanded(
//                             child: Text(
//                               "Child ${index + 1}",
//                               style: TextStyle(
//                                 fontSize: 18.sp,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xff1a1a1a),
//                               ),
//                             ),
//                           ),

//                           Container(
//                             width: 99.w,
//                             height: 38.h,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12.w,
//                               vertical: 5.h,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(32.r),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(.08),
//                                   blurRadius: 8,
//                                   offset: const Offset(0, 3),
//                                 ),
//                               ],
//                             ),
//                             child: DropdownButtonHideUnderline(
//                               child: DropdownButton<int>(
//                                 value: selectedAge,
//                                 menuMaxHeight: 300,
//                                 icon: const Icon(Icons.keyboard_arrow_down),
//                                 items: <DropdownMenuItem<int>>[
//                                   ...List.generate(17, (index) {
//                                     return DropdownMenuItem(
//                                       value: index + 1,
//                                       child: Text("${index + 1} Yr"),
//                                     );
//                                   }),
//                                 ],
//                                 onChanged: (value) {
//                                   setState(() {
//                                     selectedAge = value!;
//                                   });
//                                 },
//                               ),
//                             ),
//                           ),
//                         ],
//                       );
//                     },
//                   ),
//                 ),

//                 const SizedBox(height: 12.h),

//                 Divider(color: Color(0xffd6d6d6)),
//               ],
//             ),
//           ),

//           const SizedBox(height: 12.h),
//           Container(
//             padding: const EdgeInsets.only(top: 8.h, bottom: 8.h, right: 8.w),
//             decoration: BoxDecoration(
//               color: Colors.transparent,
//               borderRadius: BorderRadius.circular(12.r),
//               border: Border.all(color: Colors.grey.shade300),
//             ),
//             child: Row(
//               children: [
//                 Checkbox(
//                   value: travellingWithPets,
//                   onChanged: (value) {
//                     setState(() {
//                       travellingWithPets = value!;
//                     });
//                   },
//                 ),
//                 const SizedBox(width: 5.w),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Are You Travelling With Pets?",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 12.sp,
//                         ),
//                       ),
//                       Text(
//                         overflow: .ellipsis,
//                         maxLines: 2,
//                         "Selecting this option will show only pet-friendly properties. Please review the pet policies & applicable fees, if any.",
//                         style: TextStyle(
//                           fontSize: 9.sp,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 5.w),
//                 const Icon(Icons.pets, color: Colors.grey),
//               ],
//             ),
//           ),
//           const SizedBox(height: 18.h),

//           Center(
//             child: SizedBox(
//               width: 160.w,
//               height: 52.h,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xff4B3DF0),
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(28.r),
//                   ),
//                 ),
//                 child: const Text(
//                   "Apply",
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                     color: Colors.white,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget buildCounter({
//     required String title,
//     String? subtitle,
//     required int value,
//     required VoidCallback onMinus,
//     required VoidCallback onPlus,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.h),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 if (subtitle != null)
//                   Text(
//                     subtitle,
//                     style: TextStyle(color: Colors.grey.shade500, fontSize: 11.sp),
//                   ),
//               ],
//             ),
//           ),

//           Container(
//             width: 99.w,
//             height: 38.h,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(24.r),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(.08),
//                   blurRadius: 8,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 GestureDetector(
//                   onTap: onMinus,
//                   child: const Icon(Icons.remove, size: 20.r),
//                 ),
//                 Text(
//                   value.toString(),
//                   style: const TextStyle(
//                     fontSize: 16.sp,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: onPlus,
//                   child: const Icon(Icons.add, color: Colors.indigo, size: 20.r),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }


// }