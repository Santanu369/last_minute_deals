import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/core/theme/app_spacing.dart';
import 'package:lmd_app/features/hotel/data/models/retail_listing_model.dart';
import 'package:lmd_app/features/hotel/presentation/widgets/pricing_utils.dart';
import 'package:lmd_app/features/language/transated_main_card.dart';
import 'package:lmd_app/features/wishlist/data/services/wishlist_service.dart';

class GridViewCard extends StatefulWidget {
  const GridViewCard({
    super.key,
    required this.listings,
    required this.onHotelTap,
    this.loadmore,
  });

  final List<dynamic> listings;
  final void Function(dynamic hotel) onHotelTap;
  final int? loadmore;

  @override
  State<GridViewCard> createState() => _GridViewCardState();
}

class _GridViewCardState extends State<GridViewCard> {
  final WishlistService _wishlistService = WishlistService();
  final Set<String> _savedHotelIds = {};

  @override
  void initState() {
    super.initState();
    _fetchSavedWishlist();
  }

  Future<void> _fetchSavedWishlist() async {
    try {
      final items = await _wishlistService.getWishlist();
      if (!mounted) return;
      setState(() => _savedHotelIds.addAll(items.map((item) => item.id)));
    } catch (_) {
      // A wishlist failure must not prevent hotel deals from rendering.
    }
  }

  String _getHotelId(RetailListingModel hotel) {
    if (hotel.id.isNotEmpty) return hotel.id;
    final source = hotel.hotelSource.isNotEmpty ? hotel.hotelSource : 'default';
    return '${hotel.name}_$source';
  }

  Future<void> _toggleWishlist(RetailListingModel hotel) async {
    final hotelId = _getHotelId(hotel);
    final wasSaved = _savedHotelIds.contains(hotelId);

    setState(() {
      if (wasSaved) {
        _savedHotelIds.remove(hotelId);
      } else {
        _savedHotelIds.add(hotelId);
      }
    });

    try {
      await _wishlistService.toggleWishlist(
        id: hotel.id.isNotEmpty ? hotel.id : hotelId,
        hotelSource: hotel.hotelSource,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        if (wasSaved) {
          _savedHotelIds.add(hotelId);
        } else {
          _savedHotelIds.remove(hotelId);
        }
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update wishlist')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final count = 15 * ((widget.loadmore ?? 0) + 1);
    final deals = widget.listings.take(count).toList();
    if (deals.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: deals.length,
        separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
        itemBuilder: (_, index) {
          final hotel = _normalizeHotel(deals[index]);
          return hotel == null
              ? const SizedBox.shrink()
              : _buildHotelCard(context, hotel);
        },
      ),
    );
  }

  RetailListingModel? _normalizeHotel(dynamic hotel) {
    if (hotel is RetailListingModel) return hotel;
    if (hotel is Map) {
      return RetailListingModel.fromJson(Map<String, dynamic>.from(hotel));
    }
    return null;
  }

  Widget _buildHotelCard(BuildContext context, RetailListingModel hotel) {
    final imageUrl = hotel.images.isNotEmpty ? hotel.images.first : '';
    final rating = hotel.googleRating > 0 ? hotel.googleRating : hotel.rating;
    final reviews = hotel.googleReviewCount;
    final sellingPrice = hotel.salePrice > 0
        ? hotel.salePrice
        : hotel.basePrice;
    final hotelId = _getHotelId(hotel);
    final discount = PricingUtils.calculate(
      hotelId: hotelId,
      sellingPrice: hotel.priceHidden ? 0 : sellingPrice,
    ).discountPercent;
    final isSaved = _savedHotelIds.contains(hotelId);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => widget.onHotelTap(hotel),
        borderRadius: BorderRadius.circular(DS.radiusCard.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: DS.card,
            borderRadius: BorderRadius.circular(DS.radiusCard.r),
            border: Border.all(color: DS.borderLight),
            boxShadow: DS.shadowCard,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHotelImage(imageUrl: imageUrl, discount: discount),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TranslatedMainCard(
                            text: hotel.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: DS.textPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        GestureDetector(
                          onTap: () => _toggleWishlist(hotel),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 24.r,
                            height: 24.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: DS.card,
                              border: Border.all(
                                color: isSaved
                                    ? DS.accentRed
                                    : DS.textTertiary,
                              ),
                            ),
                            child: Icon(
                              isSaved
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 14.r,
                              color: isSaved ? DS.accentRed : DS.textTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 15.r,
                          color: DS.textTertiary,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: TranslatedMainCard(
                            text: _location(hotel),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: DS.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: DS.successLight,
                            borderRadius: BorderRadius.circular(
                              DS.radiusPill.r,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 14.r,
                                color: DS.starYellow,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                rating > 0 ? rating.toStringAsFixed(1) : '4.8',
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: DS.success,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (reviews > 0)
                          Text(
                            ' ($reviews)',
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: DS.textSecondary,
                            ),
                          ),
                        const Spacer(),
                        Text(
                          hotel.priceHidden
                              ? hotel.priceLabel
                              : '₹${_formatPrice(sellingPrice)}',
                          style: GoogleFonts.inter(
                            fontSize: hotel.priceHidden ? 13.sp : 16.sp,
                            fontWeight: FontWeight.w700,
                            color: DS.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHotelImage({required String imageUrl, required int discount}) {
    const imageSize = 110.0;
    return SizedBox(
      width: imageSize,
      height: imageSize,
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14.r),
            child: imageUrl.isEmpty
                ? _imagePlaceholder()
                : CachedNetworkImage(
              imageUrl: imageUrl,
              width: imageSize,
              height: imageSize,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => _imagePlaceholder(),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: DS.accentRed,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                discount > 0 ? '$discount% OFF' : 'Live Deal',
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: DS.background,
      child: const Center(
        child: Icon(Icons.apartment_rounded, color: DS.textTertiary),
      ),
    );
  }

  String _location(RetailListingModel hotel) {
    final city = hotel.city.trim();
    final state = hotel.state.trim();
    if (city.isNotEmpty && state.isNotEmpty) return '$city, $state';
    if (city.isNotEmpty) return city;
    if (state.isNotEmpty) return state;
    return 'Location unavailable';
  }

  String _formatPrice(dynamic value) {
    final number = double.tryParse(value.toString()) ?? 0;
    return number
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => ',');
  }
}