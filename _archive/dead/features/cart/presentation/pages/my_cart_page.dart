import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lmd_app/features/booking/presentation/pages/your_selection_page.dart';

class MyCartPage extends StatelessWidget {
  final String stayName;
  final String listingId;
  final String dealId;
  final String sku;
  final String paymentMethod;
  final String dateRange;
  final double price;
  final double basePrice;
  final String imagePath;
  final String guestName;
  final String guestPhone;
  final String guestEmail;
  final String arrivalPreference;
  final String variantId;
  final String provider;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final int rooms;
  final int adults;
  final int children;

  const MyCartPage({
    super.key,
    required this.paymentMethod,
    required this.sku,
    required this.listingId,
    required this.dealId,
    required this.dateRange,
    required this.stayName,
    required this.price,
    required this.basePrice,
    required this.imagePath,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
    required this.arrivalPreference,
    required this.variantId,
    required this.provider,
    required this.checkInDate,
    required this.checkOutDate,
    required this.rooms,
    required this.adults,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return YourSelectionPage(
      stayName: stayName,
      listingId: listingId,
      dealId: dealId,
      sku: sku,
      variantId: variantId,
      provider: provider,
      paymentMethod: paymentMethod,
      dateRange: dateRange,
      price: price,
      basePrice: basePrice,
      imagePath: imagePath,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      rooms: rooms,
      adults: adults,
      children: children,
      initialTabIndex: 1,
      initialGuestName: guestName,
      initialGuestEmail: guestEmail,
      initialGuestPhone: guestPhone,
      initialArrivalPreference: arrivalPreference,
    );
  }
}