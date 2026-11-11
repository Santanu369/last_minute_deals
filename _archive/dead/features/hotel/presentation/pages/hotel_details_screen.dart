import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HotelDetailsScreen extends StatelessWidget {
  final int hid;

  const HotelDetailsScreen({
    super.key,
    required this.hid,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Details'),
      ),
//       body: BlocBuilder<HotelDetailsBloc, HotelDetailsState>(
//         builder: (context, state) {
//           if (state.loading) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }

//           if (state.error.isNotEmpty) {
//             return Center(
//               child: Text(state.error),
//             );
//           }

//           final hotel = state.hotel;

//             return SingleChildScrollView(
//       child: Column(
//         children: [
//           // Image.network(
//           //   hotel?.images.isNotEmpty ? hotel.images.first : "",
//           // ),
//           // Text(hotel?.name ?? ""),
//           // Text(hotel?.address ?? ""),
//           // Text("₹${hotel? .price}"),
//         ],
//       ),
//     );
//         },
//       ),
    );
  }
}