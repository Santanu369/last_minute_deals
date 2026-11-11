import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/core/theme/app_spacing.dart';
import 'package:lmd_app/features/hotel/data/models/hotel_search/search_result_model.dart';
import 'package:lmd_app/features/hotel/data/models/retail_listing_model.dart';
import 'package:lmd_app/features/hotel/presentation/widgets/pricing_utils.dart';
import 'package:lmd_app/features/language/transated_main_card.dart';
import 'package:lmd_app/features/wishlist/data/services/wishlist_service.dart';

class HotelDealCard extends StatefulWidget {
  const HotelDealCard({super.key, required this.listing, required this.onTap})
      : searchListing = null,
        isSearchResults = false;

  const HotelDealCard.searchResult({
    super.key,
    required this.searchListing,
    required this.onTap,
  }) : listing = null,
        isSearchResults = true;

  final RetailListingModel? listing;
  final SearchResultModel? searchListing;

  final VoidCallback onTap;

  final bool isSearchResults;

  @override
  State<HotelDealCard> createState() => _HotelDealCardState();
}

class _HotelDealCardState extends State<HotelDealCard>
    with SingleTickerProviderStateMixin {
  bool isFavorite = false;

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  RetailListingModel? get _safeListing {
    if (widget.listing != null) return widget.listing;
    if (widget.searchListing != null) {
      return RetailListingModel.fromJson({
        '_id': widget.searchListing!.id,
        'id': widget.searchListing!.id,
        'name': widget.searchListing!.roomName,
        'kind': 'hotel',
        'category': {'name': 'hotel'},
        'image': widget.searchListing!.image ?? '',
        'price': {
          'base_price': widget.searchListing!.lowestPrice,
          'sale_price': widget.searchListing!.lowestPrice,
          'discount_percentage': widget.searchListing!.discountPercentage,
        },
        'location': {'city': '', 'state': '', 'country': '', 'address': ''},
        'rating': {'average': 0.0},
        'google_rating': 0.0,
        'google_user_rating_count': 0,
      });
    }
    return null;
  }

  // ============================================================
  // WISHLIST TOGGLE  👈 NEW
  // ============================================================

  Future<void> _handleFavoriteTap() async {
    final listing = _safeListing;
    if (listing == null) return;

    setState(() {
      isFavorite = !isFavorite;
    });

    try {
      final hotelSource = widget.isSearchResults
          ? (widget.searchListing?.hotelSource ?? 'ratehawk')
          : 'partner';

      final id = widget.isSearchResults
          ? (widget.searchListing?.id ?? '')
          : listing.id;

      await WishlistService().toggleWishlist(id: id, hotelSource: hotelSource);
    } catch (e) {
      setState(() {
        isFavorite = !isFavorite;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update wishlist')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Spec: no card chrome, width set by parent (164dp), image full bleed.
    return InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(DS.radiusCard.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildImageSection(), _buildDetailsSection()],
      ),
    );
  }

  Widget _buildImageSection() {
    final image = widget.isSearchResults
        ? widget.searchListing?.image?.replaceAll('{size}', '640x400') ?? ''
        : _safeListing?.thumbnail ?? '';

    return SizedBox(
      width: double.infinity,
      height: AppSizes.homeImageHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DS.radiusCard.r),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (image.isEmpty)
              _imagePlaceholder()
            else
              CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => _imagePlaceholder(),
                // Decode at display size, not full resolution.
                memCacheWidth: (AppSizes.homeCardWidth *
                    MediaQuery.devicePixelRatioOf(context))
                    .round(),
              ),
            Positioned(
              top: 8.h,
              left: 8.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: DS.accentRed,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Live Deal',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 8.h,
              right: 8.w,
              child: Material(
                color: DS.card.withValues(alpha: 0.92),
                shape: const CircleBorder(
                  side: BorderSide(color: DS.textTertiary, width: 1),
                ),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _handleFavoriteTap,
                  child: SizedBox(
                    width: 24.r,
                    height: 24.r,
                    child: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      size: 14.r,
                      color: isFavorite ? DS.accentRed : DS.textTertiary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() => Container(
    color: DS.background,
    child: Icon(Icons.hotel_rounded, size: 32.r, color: DS.textTertiary),
  );

  Widget _buildDetailsSection() {
    final name = widget.isSearchResults
        ? widget.searchListing?.roomName ?? 'Hotel'
        : _safeListing?.name ?? 'Hotel';

    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TranslatedMainCard(
            text: name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: DS.textPrimary,
            ),
          ),
          SizedBox(height: 6.h),
          // Location left, rating pinned to the end; never wraps to a new line.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!widget.isSearchResults)
                Expanded(child: _buildLocation())
              else
                const Spacer(),
              SizedBox(width: AppSpacing.xs),
              _buildRating(),
            ],
          ),
          SizedBox(height: 6.h),
          _buildPrice(),
        ],
      ),
    );
  }

  Widget _buildLocation() {
    final l = _safeListing;
    return Row(
      children: [
        Icon(
          Icons.location_on_outlined,
          size: AppSizes.iconSm,
          color: DS.textTertiary,
        ),
        SizedBox(width: AppSpacing.xs),
        Flexible(
          child: TranslatedMainCard(
            text: '${l?.city ?? ''} ${l?.country ?? ''}'.trim(),
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
    );
  }

  Widget _buildRating() {
    final rating = widget.isSearchResults
        ? 0.0
        : _safeListing?.googleRating.toDouble() ?? 0.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: DS.successLight,
        borderRadius: BorderRadius.circular(DS.radiusPill.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: 12.r, color: DS.starYellow),
          SizedBox(width: AppSpacing.xs),
          Text(
            rating == 0 ? 'N/A' : rating.toStringAsFixed(1),
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: DS.success,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrice() {
    final formatter = NumberFormat('#,##,##0', 'en_IN');
    final price = widget.isSearchResults
        ? widget.searchListing?.lowestPrice ?? 0
        : _safeListing?.salePrice ?? 0;

    final listing = _safeListing;
    final hidden = !widget.isSearchResults && listing != null && listing.priceHidden;
    return Text(
      hidden ? listing.priceLabel : '₹${formatter.format(price.toInt())}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.inter(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: DS.textPrimary,
      ),
    );
  }
}