import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/core/theme/app_spacing.dart';
import 'package:lmd_app/features/hotel/presentation/widgets/hotel_deal_card.dart';

class HotelNearbyDeals extends StatelessWidget {
  const HotelNearbyDeals({
    super.key,
    required this.listings,
    required this.onHotelTap,
    this.loadmore,
    required this.title,
    this.onViewAll,
  });

  final List<dynamic> listings;
  final void Function(dynamic hotel) onHotelTap;
  final int? loadmore;

  final String title;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final int count = 4 * ((loadmore ?? 0) + 1);

    if (listings.take(count).isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              DS.screenPadding.w,
              0,
              DS.screenPadding.w,
              12.h,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title.tr().trim(),
                    maxLines: 2,
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: DS.textPrimary,
                    ),
                  ),
                ),

                if (onViewAll != null)
                  GestureDetector(
                    onTap: onViewAll,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'see_all'.tr(),
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: DS.primaryBlue,
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: AppSizes.iconMd,
                          color: DS.primaryBlue,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(
            height: 225.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: DS.screenPadding.w),
              itemCount: listings.length,
              separatorBuilder: (_, _) => SizedBox(width: 12.w),
              itemBuilder: (context, index) => SizedBox(
                width: AppSizes.homeCardWidth,
                child: HotelDealCard(
                  listing: listings[index],
                  onTap: () => onHotelTap(listings[index]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}