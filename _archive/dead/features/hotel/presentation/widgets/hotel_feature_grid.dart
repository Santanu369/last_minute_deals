import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lmd_app/features/hotel/presentation/widgets/hotel_feature_item.dart';

class HotelFeatureGrid extends StatelessWidget {
  const HotelFeatureGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      childAspectRatio: 1.10,
      children: const [
        HotelFeatureItem(
          icon: Icons.verified,
          title: 'Verified Stays',
          subtitle: 'Quality checked',
        ),
        HotelFeatureItem(
          icon: Icons.flash_on,
          title: 'Instant Booking',
          subtitle: 'Book in seconds',
        ),
        HotelFeatureItem(
          icon: Icons.support_agent,
          title: '24/7 Support',
          subtitle: 'Always here',
        ),
        HotelFeatureItem(
          icon: Icons.local_offer,
          title: 'Best Deals',
          subtitle: 'Save up to 70%',
        ),
      ],
    );
  }
}
