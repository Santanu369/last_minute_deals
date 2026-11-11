// import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lmd_app/pages/buffetHome/pages/buffet_home_page.dart';
// import 'package:lmd_app/pages/comingSoonPage/coming_soon.dart';
// import 'package:lmd_app/pages/hotels/hotels_category.dart';
// import 'package:lmd_app/pages/rootPage/widget_tree.dart';

// class SectionOne extends StatefulWidget {
//   const SectionOne({super.key});

//   @override
//   State<SectionOne> createState() => _SectionOneState();
// }

// class _SectionOneState extends State<SectionOne> {
//   List<String> pics = [
//     "assets/home_page/pic1.png",
//     "assets/home_page/pic2.png",
//     "assets/home_page/pic3.png",
//   ];

//   List<String> titles = ["Daily Deals", "Buffet Deals", "Hotel Deals"];

//   @override
//   Widget build(BuildContext context) {
//     // final w = MediaQuery.sizeOf(context).width;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12.w),

//       child: Row(
//         children: List.generate(pics.length, (index) {
//           List pages = [
//             ComingSoon(),
//             WidgetTree(tab1: BuffetHomePage(), tab2: Container(), tab3: Container()),
//             HotelsCategoryPage(),
//           ];
//           return Expanded(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.w),

//               child: InkWell(
//                 onTap: () {
//                  pages[index] != null ? Navigator.push(context, MaterialPageRoute(builder: (context) => pages[index])) : null;
//                 },
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     AspectRatio(
//                       aspectRatio: 0.85,
                
//                       child: Stack(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(20.r),
                
//                             child: Image.asset(
//                               pics[index],
//                               fit: BoxFit.cover,
//                               width: double.infinity,
//                               height: double.infinity,
//                             ),
//                           ),
                
//                           Positioned.fill(
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(20.r),
                
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     begin: Alignment.bottomCenter,
//                                     end: Alignment.topCenter,
                
//                                     colors: [
//                                       Colors.red.withValues(alpha: 0.9),
//                                       Colors.red.withValues(alpha: 0.2),
//                                       Colors.transparent,
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
                
//                           Positioned.fill(
//                             child: Align(
//                               alignment: Alignment.bottomCenter,
                
//                               child: Padding(
//                                 padding: EdgeInsets.only(bottom: 10.h),
                
//                                 child: Text(
//                                   "Up to 70% off",
                
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize:
//                                         (MediaQuery.sizeOf(context).width * 0.035)
//                                             .clamp(10, 22),
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     SizedBox(height: 4.h),
//                     Text(
//                       titles[index],
//                       textAlign: TextAlign.center,
                
//                       style: TextStyle(
//                         fontSize: (MediaQuery.sizeOf(context).width * 0.037)
//                             .clamp(12, 22),
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
