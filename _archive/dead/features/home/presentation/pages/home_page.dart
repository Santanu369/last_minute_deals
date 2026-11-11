// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lmd_app/bloc/auth/auth_cubit.dart';
// import 'package:lmd_app/bloc/details/details_cubit.dart';
// import 'package:lmd_app/bloc/home/home_cubit.dart';
// import 'package:lmd_app/bloc/home/home_state.dart';
// import 'package:lmd_app/common/widgets/home_appbar.dart';
// import 'package:lmd_app/models/hotel_details/hotel_search_request.dart';
// import 'package:lmd_app/pages/Details/details_screen.dart';
// import 'package:lmd_app/pages/auth/login_page.dart';
// import 'package:lmd_app/pages/home/widgets/near_by_staycation.dart';
// import 'package:lmd_app/pages/home/widgets/most_loved_stay.dart';
// import 'package:lmd_app/pages/home/widgets/perfect_plan_suggestion.dart';
// import 'package:lmd_app/pages/home/widgets/section_one.dart';
// import 'package:lmd_app/pages/home/widgets/stay_and_save.dart';
// import 'package:lmd_app/pages/home/widgets/weekend_card.dart';
// // import 'package:geocoding/geocoding.dart';
// // import 'package:lmd_app/services/location_service.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final TextEditingController searchController = TextEditingController();
//   final FocusNode searchListFocus = FocusNode();
//   final FocusNode searchFocus = FocusNode();
//   String searchQuery = '';
//   // String currentLocation = '';
//   late final HomeCubit _homeCubit;
//   final LayerLink _searchLink = LayerLink();

//   // Future<void> loadNearbyListings1() async {
//   //   final permission = await Geolocator.requestPermission();
//   //   // Future<void> loadNearbyListings1() async {
//   //   final permission = await Geolocator.requestPermission();

//   //   if (permission == LocationPermission.denied) {
//   //     return;
//   //   }
//   //   if (permission == LocationPermission.denied) {
//   //     return;
//   //   }

//   //   final position = await Geolocator.getCurrentPosition();
//   //   final position = await Geolocator.getCurrentPosition();

//   //   final placemarks = await placemarkFromCoordinates(
//   //     position.latitude,
//   //     position.longitude,
//   //   );
//   //   final placemarks = await placemarkFromCoordinates(
//   //     position.latitude,
//   //     position.longitude,
//   //   );

//   //   if (!mounted) return;
//   //   if (!mounted) return;

//   //   final place = placemarks.first;
//   //   final place = placemarks.first;

//   //   setState(() {
//   //     currentLocation = "${place.locality}, ${place.country}";
//   //   });
//   //   setState(() {
//   //     currentLocation = "${place.locality}, ${place.country}";
//   //   });

//   //   if (!mounted) return;
//   //   if (!mounted) return;

//   //   _homeCubit.loadSearchedListings(
//   //     lat: 18.5204,
//   //     lng: 73.8567,
//   //   ); //Temp location values of pune.

//   //   // context.read<HomeCubit>().loadSearchedListings(
//   //   //   lat: position.latitude,
//   //   //   lng: position.longitude,
//   //   // );
//   // }
//   //   // context.read<HomeCubit>().loadSearchedListings(
//   //   //   lat: position.latitude,
//   //   //   lng: position.longitude,
//   //   // );
//   // }

//   // Future<void> loadNearbyListings() async {
//   //   final permission = await Geolocator.requestPermission();

//   //   if (permission == LocationPermission.denied) {
//   //     return;
//   //   }

//   //   final position = await Geolocator.getCurrentPosition();
//   //   // test giving pune location rather than passing the position values
//   //   _homeCubit.loadSearchedListings(lat: 18.5204, lng: 73.8567);
//   // }

//   @override
//   void initState() {
//     super.initState();
//     // loadNearbyListings();
//     // loadNearbyListings1();
//     _homeCubit = context.read<HomeCubit>();
//     // _homeCubit.loadWeekendDeals();
//     _homeCubit.loadListings();
//     _homeCubit.loadSearchedListings(lat: 18.5204, lng: 73.8567);
//     // _homeCubit.loadNearbyStaycations();
//     _homeCubit.loadMostLovedListings();
//     _homeCubit.loadStayAndSaveListings();
//   }

//   @override
//   void dispose() {
//     searchController.dispose();
//     searchListFocus.dispose();
//     searchFocus.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final authState = context.watch<AuthCubit>().state;
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         key: _scaffoldKey,

//         endDrawer: Drawer(
//           child: ListView(
//             children: [
//               DrawerHeader(child: Text("Menu")),

//               ListTile(title: Text("Profile")),

//               ListTile(title: Text("Settings")),

//               ListTile(
//                 onTap: () async {
//                   await context.read<AuthCubit>().logout();

//                   if (context.mounted) {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(builder: (_) => LoginPage()),
//                     );
//                   }
//                 },
//                 title: Center(
//                   child: Text(
//                     "logout",
//                     style: TextStyle(decoration: TextDecoration.underline),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),

//         appBar: PreferredSize(
//           preferredSize: Size.fromHeight(kToolbarHeight),
//           child: HomeAppbar(),
//         ),
//         body: Stack(
//           children: [
//             RefreshIndicator(
//               onRefresh: () async {
//                 await Future.wait([
//                   // _homeCubit.loadWeekendDeals(),
//                   _homeCubit.loadListings(),
//                   // _homeCubit.loadNearbyStaycations(),
//                   _homeCubit.loadMostLovedListings(),
//                   _homeCubit.loadStayAndSaveListings(),
//                 ]);
//               },
//               child: SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     SizedBox(height: 6),
//                     Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(14),

//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 10,
//                               offset: Offset(0, 4),
//                             ),
//                           ],
//                         ),

//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: CompositedTransformTarget(
//                             link: _searchLink,
//                             child: TextField(
//                               focusNode: searchFocus,
//                               controller: searchController,

//                               onChanged: (value) {
//                                 setState(() {
//                                   searchQuery = value.toLowerCase().trim();
//                                 });
//                               },
//                               decoration: InputDecoration(
//                                 hintText: "Search hotels, events, stores...",
//                                 hintStyle: TextStyle(color: Color(0xffADB2B8)),
//                                 prefixIcon: Icon(Icons.search),
//                                 prefixStyle: TextStyle(
//                                   color: Color(0xffADB2B8),
//                                 ),
//                                 filled: true,
//                                 fillColor: Colors.white,

//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(14),
//                                   borderSide: BorderSide.none,
//                                 ),

//                                 enabledBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(14),
//                                   borderSide: BorderSide.none,
//                                 ),

//                                 focusedBorder: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(14),
//                                   borderSide: BorderSide.none,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     // BlocBuilder<HomeCubit, List<ListingModel>>(
//                     //   builder: (context, listings) {
//                     //     final filteredListings = listings.where((listing) {
//                     //       return listing.title.toLowerCase().contains(searchQuery) ||
//                     //           listing.type.toLowerCase().contains(searchQuery);
//                     //     }).toList();
//                     //     debugPrint(filteredListings);

//                     //     return ListView.builder(
//                     //       shrinkWrap: true,
//                     //       physics: NeverScrollableScrollPhysics(),
//                     //       itemCount: filteredListings.length,
//                     //       itemBuilder: (context, index) {
//                     //         final listing = filteredListings[index];

//                     //         return ListTile(
//                     //           title: Text(listing.title),
//                     //           subtitle: Text(listing.type),
//                     //         );
//                     //       },
//                     //     );
//                     //   },
//                     // ),
//                     SizedBox(height: 20),
//                     SectionOne(),
//                     SizedBox(height: 40),
//                     WeekendCard(),
//                     // SizedBox(height: 10),
//                     // RecentbooksSection(),
//                     // SizedBox(height: 20),
//                     // DeliciousCard(),
//                     SizedBox(height: 20),
//                     PerfectPlanSuggestion(),
//                     SizedBox(height: 10),
//                     MostLovedStay(),
//                     StayAndSave(),
//                     SizedBox(height: 20),
//                     NearByStaycation(),
//                     SizedBox(height: 80),
//                   ],
//                 ),
//               ),
//             ),
//             if (searchQuery.isNotEmpty)
//               CompositedTransformFollower(
//                 link: _searchLink,
//                 showWhenUnlinked: false,
//                 targetAnchor: Alignment.bottomLeft,
//                 followerAnchor: Alignment.topLeft,
//                 offset: const Offset(0, 8),
//                 child: Material(
//                   elevation: 5,
//                   borderRadius: BorderRadius.circular(14),
//                   child: Container(
//                     width: MediaQuery.of(context).size.width - 40,
//                     constraints: BoxConstraints(maxHeight: 300),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(14),
//                     ),
//                     child: BlocBuilder<HomeCubit, HomeState>(
//                       builder: (context, state) {
//                         if (state.isLoading) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }

//                         if (state.error != null) {
//                           return Center(child: Text(state.error!));
//                         }

//                         final filteredListings = state.searchListings.where((
//                           listing,
//                         ) {
//                           return listing.name.toLowerCase().contains(
//                             searchQuery.toLowerCase(),
//                           );
//                           //  ||
//                           // // listing.type.toLowerCase().contains(
//                           // //   searchQuery.toLowerCase(),
//                           // // );
//                         }).toList();

//                         if (filteredListings.isEmpty) {
//                           return SizedBox(
//                             height: 60,
//                             child: const Center(
//                               child: Text('No listings found'),
//                             ),
//                           );
//                         }

//                         return ListView.builder(
//                           shrinkWrap: true,
//                           itemCount: filteredListings.length,
//                           itemBuilder: (context, index) {
//                             final listing = filteredListings[index];

//                             return Material(
//                               color: Colors.transparent,
//                               child: ListTile(
//                                 title: Text(listing.name),
//                                 // subtitle: Text(listing.type),
//                                 onTap: () {
//                                   searchController.text = listing.name;

//                                   setState(() {
//                                     searchQuery = '';
//                                   });

//                                   searchListFocus.unfocus();

//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => BlocProvider(
//                                         create: (_) => DetailsCubit(),
//                                         child: DetailsScreen(
//                                           request:
//                                               HotelSearchRequest.defaultSearch(
//                                                 hid: listing.hid,
//                                               ),
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             );
//                           },
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
