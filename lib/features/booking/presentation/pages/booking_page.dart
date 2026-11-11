import 'dart:convert';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' hide TextDirection;
import 'package:latlong2/latlong.dart';
import 'package:lmd_app/features/language/translated_text_wish.dart';
import 'package:share_plus/share_plus.dart';

import 'package:lmd_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lmd_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/details_state.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/details_cubit.dart';
import 'package:lmd_app/features/order/presentation/cubit/order_cubit.dart';
import 'package:lmd_app/features/payment/presentation/cubit/cashfree/cashfree_cubit.dart';
import 'package:lmd_app/features/payment/presentation/cubit/stay_quote_cubit.dart';
import 'package:lmd_app/features/cart/data/models/add_to_cart_request.dart';
import 'package:lmd_app/features/hotel/data/models/google_review_model.dart';
import 'package:lmd_app/features/hotel/data/models/retail_listing_model.dart';
import 'package:lmd_app/features/hotel/data/models/retail_hotel_details_model.dart';
import 'package:lmd_app/features/booking/presentation/pages/your_selection_page.dart';
import 'package:lmd_app/features/booking/presentation/pages/enquiry_page.dart';
import 'package:lmd_app/features/wishlist/data/services/wishlist_service.dart';
import 'package:lmd_app/features/cart/data/services/cart_services.dart';
import 'package:lmd_app/features/order/data/services/order_services.dart';
import 'package:lmd_app/features/payment/data/services/payment_service_impl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/core/utils/map_launcher.dart';

class BookingPage extends StatefulWidget {
  final String productId;
  final RetailListingModel listing;

  const BookingPage({
    super.key,
    required this.productId,
    required this.listing,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  bool _isEditGuestVisible = false;
  RetailVariant? selectedVariant;

  int rooms = 1;
  int adults = 2;
  int children = 0;
  bool isFavorite = false;
  int selectedAge = 1;
  bool travellingWithPets = false;
  late DateTime checkInDate;
  late DateTime checkOutDate;
  bool _datesSelected = false;
  bool _showDateValidationError = false;

  bool readmore = false;
  int _currentIndex = 1;
  bool _isAmenitiesExpanded = false;
  bool _isReviewsExpanded = false;

  // Design Tokens matching HTML Visual Reference
  static const Color _kBg = DS.background;
  static const Color _kBorder = DS.borderLight;
  static const Color _kDark = DS.textPrimary;
  static const Color _kGray = DS.textSecondary;
  static const Color _kMuted = DS.textSecondary;
  static const Color _kPlaceholder = DS.textTertiary;
  static const Color _kRed = DS.accentRed;
  static const Color _kGreen = DS.success;
  static const Color _kGreenText = DS.success;
  static const Color _kGreenBg = DS.successLight;
  static const Color _kGreenBorder = DS.successLight;
  static const Color _kPillBg = Color(0xFFF0F1F5);

  @override
  void initState() {
    checkInDate = DateTime.now();
    checkOutDate = DateTime.now().add(const Duration(days: 1));
    _datesSelected = false;
    _showDateValidationError = false;
    super.initState();
    context.read<DetailsCubit>().loadHotelDetails(
      productId: widget.productId,
      source: widget.listing?.hotelSource,
      fallbackPrice: widget.listing?.salePrice ?? 0,
    );
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    try {
      final id = widget.listing.id.isNotEmpty ? widget.listing.id : widget.productId;
      // Same partner/ratehawk rule the toggle uses.
      final source = RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(id) ? 'partner' : 'ratehawk';
      final alreadyFavorite =
      await WishlistService().isInWishlist(id: id, hotelSource: source);
      if (mounted) {
        setState(() {
          isFavorite = alreadyFavorite;
        });
      }
    } catch (_) {
      // Ignore silently
    }
  }

  Future<void> _handleFavoriteTap() async {
    final id = widget.listing.id.isNotEmpty ? widget.listing.id : widget.productId;
    final hotelSource = RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(id) ? 'partner' : 'ratehawk';

    setState(() {
      isFavorite = !isFavorite;
    });

    try {
      await WishlistService().toggleWishlist(
        id: id,
        hotelSource: hotelSource,
      );
    } catch (_) {
      // Catch silently to guarantee immediate, error-free local heart UI updates
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWidescreen = screenWidth > 450;

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
        ),
      ),
      child: Scaffold(
        backgroundColor: _kBg,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: isWidescreen ? 24.0 : 0.0,
                horizontal: isWidescreen ? 16.0 : 0.0,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(isWidescreen ? 32 : 0),
                    border: isWidescreen ? Border.all(color: _kBorder, width: 1) : null,
                    boxShadow: isWidescreen
                        ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ]
                        : null,
                  ),
                  clipBehavior: isWidescreen ? Clip.antiAlias : Clip.none,
                  child: BlocBuilder<DetailsCubit, DetailsState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: _kDark, strokeWidth: 2.5),
                        );
                      }

                      if (state.error != null) {
                        return Center(
                          child: Text(
                            state.error!,
                            style: GoogleFonts.inter(color: _kRed, fontSize: 14.sp),
                          ),
                        );
                      }

                      final hotel = state.hotel;
                      if (hotel == null) {
                        return Center(
                          child: TranslatedText (
                            text: 'Hotel not found',
                            style: GoogleFonts.inter(color: _kGray, fontSize: 14.sp),
                          ),
                        );
                      }

                      if (selectedVariant == null) {
                        selectedVariant = hotel.variants.firstWhere(
                              (v) => v.id == widget.productId || v.id == widget.listing.variantId,
                          orElse: () => hotel.defaultVariant,
                        );
                      }

                      return Column(
                        children: [
                          // 56px Pro Header with Back, Title, Wishlist & Share
                          _buildHeader(hotel),

                          // Scrollable Details Body
                          Expanded(
                            child: RefreshIndicator(
                              color: DS.textPrimary,
                              onRefresh: () => context.read<DetailsCubit>().loadHotelDetails(
                                productId: widget.productId,
                                source: widget.listing?.hotelSource,
                                fallbackPrice: widget.listing?.salePrice ?? 0,
                              ),
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildImageCarousel(hotel),
                                    _buildHotelHeader(hotel),
                                    _buildAmenitiesRow(hotel),
                                    _buildAboutPropertySection(hotel),
                                    _buildSelectYourStaySection(hotel),
                                    _buildAvailableRoomTypesSection(hotel),
                                    _buildExploreLocalScene(hotel),
                                    _buildGoogleReviewsSection(),
                                    SizedBox(height: 24.h),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Sticky Pro Bottom Bar
                          _buildBottomBar(hotel),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // 1. HEADER (56px Sticky Top Bar with Back, Title, Heart & Share)
  // ===========================================================================
  Widget _buildHeader(RetailHotelDetailsModel hotel) {
    return Container(
      height: 56.h,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: _kBorder, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: _kBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.arrow_back, size: 18.r, color: _kDark),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 180),
                    child: TranslatedText(
                      text: hotel.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                        color: _kDark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  TranslatedText(
                    text: hotel.city.isNotEmpty ? hotel.city : hotel.state,
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: _kPlaceholder,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: _handleFavoriteTap,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: isFavorite ? DS.accentRed : _kBg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isFavorite ? DS.accentRed : Colors.black.withValues(alpha: 0.06),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 16.r,
                    color: isFavorite ? Colors.white : _kDark,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () {
                  final hotel = context.read<DetailsCubit>().state.hotel;
                  if (hotel == null) return;
                  SharePlus.instance.share(
                    ShareParams(
                      text: '''
🏨 ${hotel.name}
📍 ${hotel.address}, ${hotel.city}, ${hotel.state}
⭐ ${hotel.starRating} Star Hotel
Book now on Last Minutes Deal: https://play.google.com/store/apps/details?id=com.twwios.lmd
''',
                    ),
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: _kBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                  ),
                  alignment: Alignment.center,
                  child: Icon(Icons.share_outlined, size: 16.r, color: _kDark),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 2. HERO IMAGE CAROUSEL (Aspect 1.28/1, Badges, Counter & Dots)
  // ===========================================================================
  Widget _buildImageCarousel(RetailHotelDetailsModel hotel) {
    final images = hotel.images.isNotEmpty ? hotel.images : [''];

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0), child: ClipRRect( borderRadius: BorderRadius.circular(DS.radiusHero.r), child: Container( decoration: BoxDecoration( color: DS.background, borderRadius: BorderRadius.circular(DS.radiusHero.r),
    ),
      child: AspectRatio(
        aspectRatio: 1.8 / 1,
        child: Stack(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 1.8 / 1,
                viewportFraction: 1.0,
                enableInfiniteScroll: images.length > 1,
                autoPlay: images.length > 1,
                autoPlayInterval: const Duration(seconds: 4),
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index + 1;
                  });
                },
              ),
              items: images.map((imageUrl) {
                return SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      color: DS.background,
                      child: Icon(Icons.hotel_rounded, size: 48.r, color: _kPlaceholder),
                    ),
                  )
                      : Container(
                    color: DS.background,
                    child: Icon(Icons.hotel_rounded, size: 48.r, color: _kPlaceholder),
                  ),
                );
              }).toList(),
            ),

            // Top-Left Editor's Pick / Deal Badge
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_awesome, size: 12.r, color: _kDark),
                    SizedBox(width: 5.w),
                    TranslatedText(
                      text:"EDITOR'S PICK",
                      style: GoogleFonts.inter(
                        fontSize: 10.sp, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: _kDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom-Right Counter Pill
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: TranslatedText(
                  text: '$_currentIndex/${images.length}',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Bottom-Center Dots Pill
            if (images.length > 1)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(images.length > 7 ? 7 : images.length, (index) {
                        final isActive = (_currentIndex - 1) % (images.length > 7 ? 7 : images.length) == index;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.symmetric(horizontal: 2.5.w),
                          width: isActive ? 22 : 6,
                          height: 6.h,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
    ),
    );
  }

  // ===========================================================================
  // 3. HOTEL HEADER (Title, Location Pill, Rating Badge)
  // ===========================================================================
  Widget _buildHotelHeader(RetailHotelDetailsModel hotel) {
    final rating = widget.listing.googleRating > 0
        ? widget.listing.googleRating.toStringAsFixed(1)
        : (hotel.starRating > 0 ? hotel.starRating.toStringAsFixed(1) : '4.0');
    final reviewCount = widget.listing.googleReviewCount > 0
        ? widget.listing.googleReviewCount
        : 23;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            text: hotel.name,
            style: GoogleFonts.inter(
              fontSize: 20.sp, fontWeight: FontWeight.w700, height: 1.2, color: _kDark,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Location Pill
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: const BoxDecoration(
                      color: _kPillBg,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.location_on_rounded, size: 14.r, color: _kDark),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    '${hotel.city}, ${hotel.state}',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: _kGray,
                    ),
                  ),
                ],
              ),

              // Rating Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _kGreenBg, borderRadius: BorderRadius.circular(DS.radiusPill.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 16.w,
                      height: 16.h,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.star_rounded, size: 14.r, color: DS.starYellow),
                    ),
                    SizedBox(width: 5.w),
                    TranslatedText(
                      text: rating,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: _kGreenText,
                      ),
                    ),
                    const SizedBox(width: 3),
                    TranslatedText(
                      text: '($reviewCount reviews)',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                        color: _kGreenText.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 4. AMENITIES PRESENTATION (Circular icons + "+X more" dashed style)
  // ===========================================================================
  IconData _getAmenityIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('wifi') || lower.contains('wi-fi') || lower.contains('internet')) {
      return Icons.wifi_rounded;
    }
    if (lower.contains('park') || lower.contains('garage') || lower.contains('valet')) {
      return Icons.directions_car_rounded;
    }
    if (lower.contains('restaurant') ||
        lower.contains('dining') ||
        lower.contains('food') ||
        lower.contains('breakfast') ||
        lower.contains('dinner') ||
        lower.contains('lunch') ||
        lower.contains('cafe') ||
        lower.contains('kitchen')) {
      return Icons.restaurant_rounded;
    }
    if (lower.contains('ac') ||
        lower.contains('air condition') ||
        lower.contains('air-condition') ||
        lower.contains('cooling')) {
      return Icons.ac_unit_rounded;
    }
    if (lower.contains('tv') || lower.contains('television')) {
      return Icons.tv_rounded;
    }
    if (lower.contains('pool') || lower.contains('swimming')) {
      return Icons.pool_rounded;
    }
    if (lower.contains('spa') ||
        lower.contains('massage') ||
        lower.contains('sauna') ||
        lower.contains('wellness')) {
      return Icons.spa_rounded;
    }
    if (lower.contains('gym') ||
        lower.contains('fitness') ||
        lower.contains('workout')) {
      return Icons.fitness_center_rounded;
    }
    if (lower.contains('bar') ||
        lower.contains('lounge') ||
        lower.contains('pub') ||
        lower.contains('drink')) {
      return Icons.local_bar_rounded;
    }
    if (lower.contains('music') || lower.contains('dj')) {
      return Icons.music_note_rounded;
    }
    if (lower.contains('cricket') ||
        lower.contains('sports') ||
        lower.contains('game') ||
        lower.contains('screening')) {
      return Icons.sports_cricket_rounded;
    }
    if (lower.contains('power') ||
        lower.contains('backup') ||
        lower.contains('generator')) {
      return Icons.bolt_rounded;
    }
    if (lower.contains('pet') || lower.contains('dog') || lower.contains('cat')) {
      return Icons.pets_rounded;
    }
    if (lower.contains('room service') ||
        lower.contains('service') ||
        lower.contains('housekeeping')) {
      return Icons.room_service_rounded;
    }
    if (lower.contains('laundry') || lower.contains('washing')) {
      return Icons.local_laundry_service_rounded;
    }
    if (lower.contains('cctv') || lower.contains('security') || lower.contains('guard')) {
      return Icons.security_rounded;
    }
    if (lower.contains('elevator') || lower.contains('lift')) {
      return Icons.elevator_rounded;
    }
    if (lower.contains('balcony') || lower.contains('terrace') || lower.contains('view')) {
      return Icons.balcony_rounded;
    }
    if (lower.contains('bath') || lower.contains('shower') || lower.contains('geyser')) {
      return Icons.bathtub_rounded;
    }
    if (lower.contains('beach') || lower.contains('sea')) {
      return Icons.beach_access_rounded;
    }
    return Icons.check_circle_outline_rounded;
  }

  double _calculateTextWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.inter(
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.1,
        ),
      ),
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout();
    return textPainter.width;
  }

  Widget _buildAmenityCircleItem({
    required IconData icon,
    required String label,
    int? maxLines = 1,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 46.w,
          height: 46.h,
          decoration: BoxDecoration(
            color: _kBg,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
          ),
          alignment: Alignment.center,
          child: Icon(icon, size: 18.r, color: _kDark),
        ),
        SizedBox(height: 6.h),
        TranslatedText(
          text: label,
          textAlign: TextAlign.center,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.1,
            color: _kGray,
          ),
        ),
      ],
    );
  }

  Widget _buildMoreCircleButton(int count) {
    return GestureDetector(
      onTap: () => setState(() => _isAmenitiesExpanded = true),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46.w,
            height: 46.h,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: TranslatedText(
              text:'+$count',
              style: GoogleFonts.inter(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: _kDark,
              ),
            ),
          ),
          SizedBox(height: 6.h),
          TranslatedText(
            text: '+$count more',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.1,
              color: _kGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollapseCircleButton() {
    return GestureDetector(
      onTap: () => setState(() => _isAmenitiesExpanded = false),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 46.w,
            height: 46.h,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.keyboard_arrow_up_rounded,
              size: 20.r,
              color: _kDark,
            ),
          ),
          SizedBox(height: 6.h),
          TranslatedText(
            text: 'Show less',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.1,
              color: _kGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesRow(RetailHotelDetailsModel hotel) {
    final List<String> rawAmenities = hotel.amenities
        .map((a) => a.trim())
        .where((a) => a.isNotEmpty)
        .toList();

    if (rawAmenities.isEmpty) {
      return const SizedBox.shrink();
    }

    // Deduplicate case-insensitively while preserving original order and exact naming
    final Set<String> seen = {};
    final List<String> amenities = [];
    for (final a in rawAmenities) {
      if (seen.add(a.toLowerCase())) {
        amenities.add(a);
      }
    }

    final bool hasMore = amenities.length > 4;
    final int remainingCount = amenities.length - 4;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 0),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: _isAmenitiesExpanded
            ? _buildExpandedAmenities(amenities)
            : _buildCollapsedAmenities(amenities, hasMore, remainingCount),
      ),
    );
  }

  Widget _buildCollapsedAmenities(
      List<String> amenities,
      bool hasMore,
      int remainingCount,
      ) {
    final initialAmenities = amenities.take(4).toList();

    final List<Widget> visibleWidgets = [];
    final List<String> labels = [];

    for (final amenity in initialAmenities) {
      visibleWidgets.add(
        _buildAmenityCircleItem(
          icon: _getAmenityIcon(amenity),
          label: amenity,
        ),
      );
      labels.add(amenity);
    }

    if (hasMore) {
      visibleWidgets.add(_buildMoreCircleButton(remainingCount));
      labels.add('+$remainingCount more');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        final int count = visibleWidgets.length;

        if (count == 0) return const SizedBox.shrink();

        final double slotWidth = availableWidth / count;

        // Check if all visible items are short enough to fit naturally inside equal columns
        bool canFitInSlots = true;
        for (final label in labels) {
          final double textWidth = _calculateTextWidth(label);
          final double itemWidth = math.max(46.0, textWidth);
          // If any item's width exceeds slotWidth (with a 2px buffer),
          // it is a longer amenity name that should preserve the natural working layout
          if (itemWidth > slotWidth - 2) {
            canFitInSlots = false;
            break;
          }
        }

        if (canFitInSlots) {
          // Short amenity names: spread evenly across the complete available width
          return Row(
            children: visibleWidgets
                .map((w) => Expanded(child: Center(child: w)))
                .toList(),
          );
        } else {
          // Longer amenity names: preserve the current working layout naturally without overflow
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                for (int i = 0; i < visibleWidgets.length; i++)
                  Padding(
                    padding: EdgeInsets.only(
                      right: i == visibleWidgets.length - 1 ? 0 : 12,
                    ),
                    child: visibleWidgets[i],
                  ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildExpandedAmenities(List<String> amenities) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double availableWidth = constraints.maxWidth;
        final int crossAxisCount = availableWidth > 480 ? 5 : 4;
        const double horizontalSpacing = 12.0;
        final double itemWidth =
            (availableWidth - (crossAxisCount - 1) * horizontalSpacing) /
                crossAxisCount;

        return Wrap(
          spacing: horizontalSpacing,
          runSpacing: 16,
          children: [
            for (final amenity in amenities)
              SizedBox(
                width: itemWidth,
                child: _buildAmenityCircleItem(
                  icon: _getAmenityIcon(amenity),
                  label: amenity,
                  maxLines: 2,
                ),
              ),
            SizedBox(
              width: itemWidth,
              child: _buildCollapseCircleButton(),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // 5. ABOUT PROPERTY SECTION (Card with badges and Clean Typography)
  // ===========================================================================
  Widget _buildAboutPropertySection(RetailHotelDetailsModel hotel) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          color: _kBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TranslatedText(
              text: 'ABOUT PROPERTY',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: _kDark,
              ),
            ),
            SizedBox(height: 10.h),
            TranslatedText(
              text: hotel.description.isNotEmpty
                  ? hotel.description
                  : 'A serene getaway offering comfortable accommodations, warm hospitality, and convenient access to local attractions and scenic viewpoints.',
              maxLines: readmore ? null : 3,
              overflow: readmore ? TextOverflow.visible : TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 13.5.sp,
                height: 1.6,
                letterSpacing: -0.1,
                color: _kMuted,
              ),
            ),
            if (hotel.description.length > 120) ...[
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () => setState(() => readmore = !readmore),
                behavior: HitTestBehavior.opaque,
                child: Text(
                  readmore ? 'Show Less' : 'Read More',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: _kDark,
                  ),
                ),
              ),
            ],
            SizedBox(height: 12.h),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                  ),
                  child: TranslatedText(
                    text:  'Free cancellation',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: _kDark,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
                  ),
                  child: Text(
                    'Pay at hotel',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: _kDark,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // 6. SELECT YOUR STAY (2-Col Grid for Dates & Guests Picker)
  // ===========================================================================
  Widget _buildSelectYourStaySection(RetailHotelDetailsModel hotel) {
    int nightCount = checkOutDate.difference(checkInDate).inDays;
    if (nightCount <= 0) nightCount = 1;

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TranslatedText(
            text: 'Select Your Stay',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
              color: _kDark,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              // Dates Picker Card
              Expanded(
                child: GestureDetector(
                  onTap: () async {
                    final picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                      initialDateRange: DateTimeRange(
                        start: checkInDate,
                        end: checkOutDate,
                      ),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: ColorScheme.light(
                              primary: DS.primaryBlue,
                              onPrimary: Colors.white,
                              primaryContainer: const Color(0xFFE8ECFF),
                              onPrimaryContainer: DS.primaryBlue,
                              secondary: DS.primaryBlue,
                              onSecondary: Colors.white,
                              secondaryContainer: const Color(0xFFE8ECFF),
                              onSecondaryContainer: DS.primaryBlue,
                              surface: Colors.white,
                              onSurface: _kDark,
                            ),
                            datePickerTheme: DatePickerThemeData(
                              rangeSelectionBackgroundColor: const Color(0xFFE8ECFF),
                              rangeSelectionOverlayColor: WidgetStateProperty.all(
                                DS.primaryBlue.withValues(alpha: 0.12),
                              ),
                              rangePickerBackgroundColor: Colors.white,
                              rangePickerHeaderBackgroundColor: Colors.white,
                              rangePickerHeaderForegroundColor: _kDark,
                              headerBackgroundColor: Colors.white,
                              headerForegroundColor: _kDark,
                              todayForegroundColor: WidgetStateProperty.all(DS.primaryBlue),
                              todayBorder: const BorderSide(color: DS.primaryBlue),
                              dayForegroundColor: WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return Colors.white;
                                }
                                return null;
                              }),
                              dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
                                if (states.contains(WidgetState.selected)) {
                                  return DS.primaryBlue;
                                }
                                return null;
                              }),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setState(() {
                        checkInDate = picked.start;
                        checkOutDate = picked.end;
                        _datesSelected = true;
                        _showDateValidationError = false;
                      });
                    }
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: _showDateValidationError
                            ? _kRed
                            : Colors.black.withValues(alpha: 0.08),
                        width: _showDateValidationError ? 1.5 : 1.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: _kPillBg,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.calendar_today_rounded, size: 16.r, color: _kDark),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TranslatedText(
                                text: _datesSelected
                                    ? "${DateFormat('MMM d').format(checkInDate)} – ${DateFormat('MMM d').format(checkOutDate)}"
                                    : 'Select Dates',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: _kDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              TranslatedText(
                                text: _datesSelected
                                    ? "$nightCount night${nightCount > 1 ? 's' : ''} • $adults guests"
                                    : 'Choose arrival...',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: _kPlaceholder,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              // Guests Picker Card
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditGuestVisible = !_isEditGuestVisible;
                    });
                  },
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.h,
                          decoration: BoxDecoration(
                            color: _kPillBg,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          alignment: Alignment.center,
                          child: Icon(Icons.people_alt_outlined, size: 16.r, color: _kDark),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TranslatedText(
                                text: '$rooms Room · $adults Guests',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 12.5.sp,
                                  fontWeight: FontWeight.w600,
                                  color: _kDark,
                                ),
                              ),
                              const SizedBox(height: 2),
                              TranslatedText(
                                text: "$adults adults${children > 0 ? ', $children ch.' : ''}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w500,
                                  color: _kPlaceholder,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Collapsible Guest Editor
          if (_isEditGuestVisible) ...[
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: _kBorder),
              ),
              child: _editGuests(),
            ),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // 7. AVAILABLE ROOM TYPES (Cards matching HTML Reference)
  // ===========================================================================
  Widget _buildAvailableRoomTypesSection(RetailHotelDetailsModel hotel) {
    final formatter = NumberFormat('#,##,##0', 'en_IN');

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 28.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TranslatedText(
                text: 'Available Room Types',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                  color: _kDark,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE4E8),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFFFE4E8)),
                ),
                child: TranslatedText(
                  text: "${hotel.variants.length} Option${hotel.variants.length > 1 ? 's' : ''} Found",
                  style: GoogleFonts.inter(
                    color: _kRed,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: hotel.variants.length,
            separatorBuilder: (context, index) => SizedBox(height: 16.h),
            itemBuilder: (context, index) {
              final variant = hotel.variants[index];
              final isSelected = selectedVariant?.id == variant.id;
              final roomImage = variant.images.isNotEmpty
                  ? variant.images.first
                  : (hotel.images.isNotEmpty ? hotel.images.first : '');

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedVariant = variant;
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected ? _kGreenBorder : Colors.black.withValues(alpha: 0.08),
                      width: isSelected ? 1.5 : 1.0,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: _kGreen.withValues(alpha: 0.12),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        )
                      else
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Room Image Header (158px)
                      Stack(
                        children: [
                          SizedBox(
                            height: 180.h,
                            width: double.infinity,
                            child: roomImage.isNotEmpty
                                ? CachedNetworkImage(
                              imageUrl: roomImage,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Container(
                                color: _kPillBg,
                                child: Icon(Icons.hotel_rounded, size: 40.r, color: _kPlaceholder),
                              ),
                            )
                                : Container(
                              color: _kPillBg,
                              child: Icon(Icons.hotel_rounded, size: 40.r, color: _kPlaceholder),
                            ),
                          ),

                          // Top-Left Image Label
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.92),
                                borderRadius: BorderRadius.circular(20.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: TranslatedText(
                                text: variant.bedType.isNotEmpty
                                    ? '${variant.bedType} Room'
                                    : 'Standard Room',
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp, fontWeight: FontWeight.w500,
                                  color: _kDark,
                                ),
                              ),
                            ),
                          ),

                          // Top-Right Availability Badge
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: isSelected ? _kGreenBg : Colors.white,
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(
                                  color: isSelected ? _kGreenBorder : Colors.black.withValues(alpha: 0.1),
                                ),
                              ),
                              child: TranslatedText(
                                text: isSelected ? 'Selected' : 'Available',
                                style: GoogleFonts.inter(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected ? _kGreenText : _kDark,
                                ),
                              ),
                            ),
                          ),

                          // Bottom Row over image (ROOM IMAGE badge & expand icon)
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.7), borderRadius: BorderRadius.circular(DS.radiusPill.r), ), child: TranslatedText( text: 'ROOM IMAGE',
                                  style: GoogleFonts.inter(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                ),
                                Container(
                                  width: 28.w,
                                  height: 28.h,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Icon(Icons.fullscreen_rounded, size: 16.r, color: _kDark),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      // Room Content Padding 16
                      Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title & Checkmark Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: TranslatedText(
                                    text: variant.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.inter(
                                      fontSize: 14.5.sp,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.2,
                                      color: _kDark,
                                    ),
                                  ),
                                ),
                                if (isSelected) ...[
                                  SizedBox(width: 8.w),
                                  Container(
                                    width: 24.w,
                                    height: 24.h,
                                    decoration: const BoxDecoration(
                                      color: _kGreen,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Icon(Icons.check, size: 14.r, color: Colors.white),
                                  ),
                                ],
                              ],
                            ),

                            SizedBox(height: 10.h),

                            // Feature Pills Row
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: _kPillBg,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.crop_square_rounded, size: 12.r, color: DS.textSecondary),
                                      SizedBox(width: 4.w),
                                      TranslatedText(
                                        text: '${variant.areaSqFt > 0 ? variant.areaSqFt : 350} sq.ft',
                                        style: GoogleFonts.inter(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: DS.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: _kPillBg,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.hotel_rounded, size: 12.r, color: DS.textSecondary),
                                      SizedBox(width: 4.w),
                                      TranslatedText(
                                        text: variant.bedType.isNotEmpty ? variant.bedType : 'Double',
                                        style: GoogleFonts.inter(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: DS.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: _kPillBg,
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.apartment_rounded, size: 12.r, color: DS.textSecondary),
                                      SizedBox(width: 4.w),
                                      TranslatedText(
                                        text: variant.roomType.isNotEmpty
                                            ? variant.roomType
                                            : (variant.name.toLowerCase().contains('breakfast')
                                            ? 'Breakfast Incl.'
                                            : 'Standard'),
                                        style: GoogleFonts.inter(
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w500,
                                          color: DS.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 14.h),

                            // Price & Select Button Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!variant.enquiryOnly && variant.basePrice > variant.salePrice)
                                      Row(
                                        children: [
                                          TranslatedText(
                                            text: '₹${formatter.format(variant.basePrice)}',
                                            style: GoogleFonts.inter(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                              color: _kPlaceholder,
                                              decoration: TextDecoration.lineThrough,
                                            ),
                                          ),
                                          SizedBox(width: 6.w),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                            decoration: BoxDecoration(
                                              color: _kGreenBg,
                                              borderRadius: BorderRadius.circular(20.r),
                                            ),
                                            child: TranslatedText(
                                              text: '${variant.discountPercentage}% OFF',
                                              style: GoogleFonts.inter(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w700,
                                                color: _kGreenText,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (variant.enquiryOnly)
                                      TranslatedText(
                                        text: variant.enquiryLabel,
                                        style: GoogleFonts.inter(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w700,
                                          color: _kDark,
                                        ),
                                      )
                                    else
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          TranslatedText(
                                            text: '₹${formatter.format(variant.salePrice)}',
                                            style: GoogleFonts.inter(
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: -0.5,
                                              color: _kDark,
                                            ),
                                          ),
                                          TranslatedText(
                                            text: ' /night',
                                            style: GoogleFonts.inter(
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w500,
                                              color: _kGray,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),

                                // Select CTA Button
                                Container(
                                  height: 40.h,
                                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                                  decoration: BoxDecoration(
                                    color: isSelected ? DS.textPrimary : DS.card, borderRadius: BorderRadius.circular(DS.radiusInput.r),
                                    border: isSelected
                                        ? null
                                        : Border.all(color: DS.borderMedium),
                                    boxShadow: isSelected
                                        ? [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.18),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ]
                                        : null,
                                  ),
                                  alignment: Alignment.center,
                                  child: isSelected
                                      ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TranslatedText(
                                        text: 'Selected',
                                        style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Icon(Icons.check, size: 14.r, color: Colors.white),
                                    ],
                                  )
                                      : TranslatedText(
                                    text: 'Select',
                                    style: GoogleFonts.inter(
                                      color: _kDark,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Green selection bar at card bottom
                      if (isSelected)
                        Container(
                          height: 4.h,
                          width: double.infinity,
                          color: _kGreen,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Dashed Notice Box
          Container(
            margin: EdgeInsets.only(top: 20.h),
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: _kBg,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.black.withValues(alpha: 0.1), style: BorderStyle.solid),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, size: 16.r, color: _kGray),
                SizedBox(width: 10.w),
                Expanded(
                  child: TranslatedText(
                    text:  'Prices include taxes & fees. Free cancellation before 12 PM on check-in day.',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      height: 1.4,
                      fontWeight: FontWeight.w500,
                      color: _kGray,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 8. EXPLORE LOCAL SCENE (Map Card)
  // ===========================================================================
  Widget _buildExploreLocalScene(RetailHotelDetailsModel hotel) {
    final query = '${hotel.name}, ${hotel.location}';
    final googlePlaceId = widget.listing.googlePlaceId;

    void launchMap() {
      if (googlePlaceId.isNotEmpty) {
        MapLauncher.openGooglePlace(googlePlaceId, query);
      } else {
        MapLauncher.openMapSearch(query);
      }
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TranslatedText(
                text: 'EXPLORE LOCAL SCENE',
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: _kDark,
                ),
              ),
              GestureDetector(
                onTap: launchMap,
                behavior: HitTestBehavior.opaque,
                child: TranslatedText(
                  text: 'Open Maps',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: _kRed,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: launchMap,
            child: Container(
              height: 180.h,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: _kBorder),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                children: [
                  MapPreviewWidget(
                    query: query,
                    fallbackCity: hotel.city,
                  ),
                  Center(
                    child: Container(
                      height: 44.h,
                      width: 44.w,
                      decoration: BoxDecoration(
                        color: _kRed,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _kRed.withValues(alpha: 0.35),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                        size: 20.r,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 9. GOOGLE REVIEWS SECTION
  // ===========================================================================
  Color _getAvatarColor(String name) {
    const colors = [
      Color(0xFF7C3AED), // purple (Ansh Tiwari in screenshot)
      Color(0xFFEF4444), // red (Kishan Rao in screenshot)
      Color(0xFFDC2626), // crimson (Megha Rao in screenshot)
      Color(0xFFF97316), // orange
      Color(0xFF3B82F6), // blue
      Color(0xFF10B981), // emerald
      Color(0xFF8B5CF6), // violet
    ];
    if (name.isEmpty) return colors[0];
    final hash = name.codeUnits.fold<int>(0, (prev, elem) => prev + elem);
    return colors[hash % colors.length];
  }

  String _getInitials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'G';
    final parts = trimmed.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    if (trimmed.length >= 2) {
      return trimmed.substring(0, 2).toUpperCase();
    }
    return trimmed[0].toUpperCase();
  }

  Widget _buildStarRating(double rating, {double size = 16}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1;
        IconData icon;
        if (rating >= starValue) {
          icon = Icons.star_rounded;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }
        return Icon(icon, size: size, color: DS.starYellow);
      }),
    );
  }

  Widget _buildGoogleReviewsSection() {
    final double ratingVal = widget.listing.googleRating > 0
        ? widget.listing.googleRating
        : (widget.listing.rating > 0 ? widget.listing.rating : 0.0);
    final String ratingStr =
    ratingVal > 0 ? ratingVal.toStringAsFixed(1) : '0.0';
    final int totalReviewCount = widget.listing.googleReviewCount;
    final List<GoogleReviewModel> availableReviews =
        widget.listing.googleReviews;

    // If completely no rating and no reviews at all
    if (ratingVal == 0 && totalReviewCount == 0 && availableReviews.isEmpty) {
      return Padding(
        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: _kBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.black.withValues(alpha: 0.04)),
          ),
          alignment: Alignment.center,
          child: TranslatedText(
            text: 'No Google reviews available for this property.',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: _kGray,
            ),
          ),
        ),
      );
    }

    const int maxInitial = 2;
    final bool hasMoreReviews = availableReviews.length > maxInitial;
    final List<GoogleReviewModel> displayedReviews = _isReviewsExpanded
        ? availableReviews
        : (hasMoreReviews
        ? availableReviews.take(maxInitial).toList()
        : availableReviews);

    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Overall Google Rating Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top header inside card
                Row(
                  children: [
                    Image.asset(
                      'assets/icons/google.png',
                      width: 18.w,
                      height: 18.h,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.g_mobiledata_rounded,
                        size: 20.r,
                        color: _kRed,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    TranslatedText(
                      text: 'Google Reviews',
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: _kDark,
                      ),
                    ),
                    if (totalReviewCount > 0) ...[
                      SizedBox(width: 5.w),
                      TranslatedText(
                        text: '($totalReviewCount)',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: _kGray,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 16.h),

                // Center rating info
                TranslatedText(
                  text: 'Overall Google Rating',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: _kDark,
                  ),
                ),
                SizedBox(height: 8.h),
                TranslatedText(
                  text: ratingStr,
                  style: GoogleFonts.inter(
                    fontSize: 38.sp,
                    fontWeight: FontWeight.w800,
                    height: 1.0,
                    letterSpacing: -1,
                    color: _kDark,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStarRating(ratingVal, size: 20.r),
                    if (totalReviewCount > 0) ...[
                      SizedBox(width: 6.w),
                      TranslatedText(
                        text: '($totalReviewCount)',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: _kGray,
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 16.h),

                // Action button (Collapse Reviews / View Reviews)
                if (availableReviews.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isReviewsExpanded = !_isReviewsExpanded;
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: DS.primaryBlue,
                        borderRadius: BorderRadius.circular(24.r),
                        boxShadow: [
                          BoxShadow(
                            color: DS.primaryBlue.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            size: 16.r,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8.w),
                          TranslatedText(
                            text: _isReviewsExpanded
                                ? 'Collapse Reviews'
                                : 'View Reviews',
                            style: GoogleFonts.inter(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            _isReviewsExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 18.r,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 2. Individual Reviews List (if available)
          if (availableReviews.isNotEmpty) ...[
            Padding(
              padding: EdgeInsets.only(top: 20.h, bottom: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/icons/google.png',
                        width: 16.w,
                        height: 16.h,
                        errorBuilder: (_, __, ___) => Icon(
                          Icons.g_mobiledata_rounded,
                          size: 18.r,
                          color: _kRed,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      TranslatedText(
                        text: 'Google Reviews (${availableReviews.length})',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: _kDark,
                        ),
                      ),
                    ],
                  ),
                  TranslatedText(
                    text: 'Fixed Card View',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                      color: _kGray,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  for (final review in displayedReviews)
                    _buildReviewCard(review),
                ],
              ),
            ),

            // Secondary expand/collapse control if multiple reviews exist
            if (hasMoreReviews)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isReviewsExpanded = !_isReviewsExpanded;
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TranslatedText(
                        text: _isReviewsExpanded
                            ? 'Collapse reviews'
                            : 'View all ${availableReviews.length} reviews',
                        style: GoogleFonts.inter(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: _kRed,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        _isReviewsExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 18.r,
                        color: _kRed,
                      ),
                    ],
                  ),
                ),
              ),
          ] else if (totalReviewCount > 0 || ratingVal > 0) ...[
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: _kBg,
                  borderRadius: BorderRadius.circular(16.r),
                  border:
                  Border.all(color: Colors.black.withValues(alpha: 0.04)),
                ),
                alignment: Alignment.center,
                child: TranslatedText(
                  text: 'No detailed written reviews available for this property.',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    color: _kGray,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReviewCard(GoogleReviewModel review) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Avatar, Author, Date, and Google Review Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with Initials
              Container(
                width: 38.w,
                height: 38.h,
                decoration: BoxDecoration(
                  color: _getAvatarColor(review.author),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: TranslatedText(
                  text: _getInitials(review.author),
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 10.w),

              // Author & Date
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TranslatedText(
                      text: review.author.isNotEmpty ? review.author : 'Google User',
                      style: GoogleFonts.inter(
                        fontSize: 13.5.sp,
                        fontWeight: FontWeight.w700,
                        color: _kDark,
                      ),
                    ),
                    if (review.relativePublishTime.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      TranslatedText(
                        text: review.relativePublishTime,
                        style: GoogleFonts.inter(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w400,
                          color: _kGray,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Google Review pill badge
              Container(
                padding:
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color: Colors.black.withValues(alpha: 0.12),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/google.png',
                      width: 14.w,
                      height: 14.h,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.g_mobiledata_rounded,
                        size: 16.r,
                        color: _kRed,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    TranslatedText(
                      text: 'Review',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: DS.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),

          // Rating Row
          Row(
            children: [
              _buildStarRating(review.rating, size: 15.r),
              SizedBox(width: 6.w),
              TranslatedText(
                text: '${review.rating.toStringAsFixed(review.rating % 1 == 0 ? 0 : 1)} / 5',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: _kDark,
                ),
              ),
            ],
          ),

          // Review Text
          if (review.text.isNotEmpty) ...[
            SizedBox(height: 8.h),
            TranslatedText(
              text: review.text,
              style: GoogleFonts.inter(
                fontSize: 12.5.sp,
                height: 1.5,
                letterSpacing: -0.1,
                color: _kMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ===========================================================================
  // 9. STICKY BOTTOM BAR (Price & Red Book Now CTA)
  // ===========================================================================
  Widget _buildBottomBar(RetailHotelDetailsModel hotel) {
    final variant = selectedVariant ?? hotel.defaultVariant;
    final formatter = NumberFormat('#,##,##0', 'en_IN');

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: _kBorder, width: 1),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!variant.enquiryOnly && variant.basePrice > variant.salePrice && variant.discountPercentage > 0)
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFE4E8),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(color: const Color(0xFFFFE4E8)),
                          ),
                          child: TranslatedText(
                            text: '${variant.discountPercentage}% OFF',
                            style: GoogleFonts.inter(
                              color: _kRed,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        TranslatedText(
                          text: '₹${formatter.format(variant.basePrice)}',
                          style: GoogleFonts.inter(
                            color: _kPlaceholder,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 2),
                  if (variant.enquiryOnly)
                    TranslatedText(
                      text: variant.enquiryLabel,
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: _kDark,
                      ),
                    )
                  else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        TranslatedText(
                          text: '₹${formatter.format(variant.salePrice)}',
                          style: GoogleFonts.inter(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: _kDark,
                          ),
                        ),
                        TranslatedText(
                          text:  '/night',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: _kGray,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            SizedBox(
              height: 48.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: DS.primaryBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DS.radiusButton.r),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                ),
                onPressed: () async {
                  if (variant.enquiryOnly) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<AuthCubit>(),
                          child: EnquiryPage(
                            variantId: variant.id,
                            villaName: hotel.name,
                            checkIn: _datesSelected ? checkInDate : null,
                            checkOut: _datesSelected ? checkOutDate : null,
                            adults: adults,
                            children: children,
                          ),
                        ),
                      ),
                    );
                    return;
                  }
                  if (!_datesSelected) {
                    setState(() {
                      _showDateValidationError = true;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: TranslatedText(text: 'Please select check-in and check-out dates from the calendar first.'),
                        backgroundColor: _kDark,
                      ),
                    );
                    return;
                  }

                  final request = AddToCartRequest(
                    variantId: variant.id,
                    hotelId: hotel.id,
                    hotelName: hotel.name,
                    hotelLocation: '${hotel.address}, ${hotel.city}, ${hotel.state}, ${hotel.country}',
                    maxGuests: '${variant.maxOccupancy} Adults',
                    roomType: variant.name,
                    checkInTime: hotel.checkInTime,
                    checkOutTime: hotel.checkOutTime,
                    bedType: variant.bedType,
                    checkIn: checkInDate,
                    checkOut: checkOutDate,
                    totalPrice: variant.salePrice,
                  );

                  await context.read<CartCubit>().addToCart(request);

                  if (!mounted) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(value: context.read<DetailsCubit>()),
                          BlocProvider.value(value: context.read<AuthCubit>()),
                          BlocProvider(create: (_) => OrderCubit(OrderService())),
                          BlocProvider(create: (_) => CartCubit(CartService())),
                          BlocProvider(create: (_) => CashfreeCubit(PaymentServiceImpl())),
                          BlocProvider(create: (_) => StayQuoteCubit(PaymentServiceImpl())),
                        ],
                        child: YourSelectionPage(
                          stayName: hotel.name,
                          listingId: hotel.id,
                          dealId: widget.listing.id,
                          sku: widget.listing.sku,
                          variantId: variant.id,
                          provider: widget.listing.kind,
                          paymentMethod: '',
                          dateRange: "${DateFormat('MMM d').format(checkInDate)} — ${DateFormat('MMM d').format(checkOutDate)}",
                          price: variant.salePrice,
                          basePrice: variant.basePrice,
                          imagePath: hotel.images.isNotEmpty ? hotel.images.first : '',
                          checkInDate: checkInDate,
                          checkOutDate: checkOutDate,
                          rooms: rooms,
                          adults: adults,
                          children: children,
                        ),
                      ),
                    ),
                  );
                },
                child: TranslatedText(
                  text: variant.enquiryOnly ? 'Enquire' : 'Book Now',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // GUEST COUNTERS
  // ===========================================================================
  Widget buildCounter({
    required String title,
    String? subtitle,
    required int value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TranslatedText(
                  text: title,
                  style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w700, color: _kDark),
                ),
                if (subtitle != null)
                  TranslatedText(
                    text: subtitle,
                    style: GoogleFonts.inter(fontSize: 11.sp, color: _kGray),
                  ),
              ],
            ),
          ),
          Container(
            height: 34.h,
            decoration: BoxDecoration(
              color: _kPillBg,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: _kBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: onMinus,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    child: Icon(Icons.remove, size: 16.r, color: _kDark),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: TranslatedText(
                    text: value.toString(),
                    style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w700, color: _kDark),
                  ),
                ),
                GestureDetector(
                  onTap: onPlus,
                  behavior: HitTestBehavior.opaque,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    child: Icon(Icons.add, size: 16.r, color: _kDark),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _editGuests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildCounter(
          title: 'Rooms',
          value: rooms,
          onMinus: () {
            if (rooms > 1) setState(() => rooms--);
          },
          onPlus: () {
            if (rooms < 20) setState(() => rooms++);
          },
        ),
        buildCounter(
          title: 'Adults',
          value: adults,
          onMinus: () {
            if (adults > 1) setState(() => adults--);
          },
          onPlus: () {
            if (adults < 40) setState(() => adults++);
          },
        ),
        buildCounter(
          title: 'Children',
          subtitle: '0-17 Years Old',
          value: children,
          onMinus: () {
            if (children > 0) setState(() => children--);
          },
          onPlus: () {
            if (children < 40) setState(() => children++);
          },
        ),
        SizedBox(height: 8.h),
        TranslatedText(
          text: 'Please provide correct guest counts for the best rates.',
          style: GoogleFonts.inter(fontSize: 10.sp, color: _kPlaceholder),
        ),
        if (children > 0) ...[
          SizedBox(height: 12.h),
          const Divider(color: _kBorder, height: 1),
          SizedBox(height: 12.h),
          TranslatedText(
            text: 'Age Of Children',
            style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600, color: _kDark),
          ),
          SizedBox(height: 8.h),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: children,
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TranslatedText(
                    text: 'Child ${index + 1}',
                    style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w600, color: _kDark),
                  ),
                  Container(
                    height: 32.h,
                    padding: EdgeInsets.symmetric(horizontal: 10.w),
                    decoration: BoxDecoration(
                      color: _kPillBg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: _kBorder),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: selectedAge,
                        icon: Icon(Icons.keyboard_arrow_down_rounded, size: 16.r, color: _kDark),
                        items: List.generate(17, (i) => i + 1).map((age) {
                          return DropdownMenuItem(
                            value: age,
                            child: TranslatedText(text: '$age Yr', style: GoogleFonts.inter(fontSize: 12.sp, fontWeight: FontWeight.w600, color: _kDark)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedAge = val);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
        SizedBox(height: 16.h),
        Center(
          child: SizedBox(
            height: 40.h,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _isEditGuestVisible = false),
              style: ElevatedButton.styleFrom(
                backgroundColor: _kDark,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              ),
              child: TranslatedText(text: 'Done', style: GoogleFonts.inter(fontSize: 13.sp, fontWeight: FontWeight.w700)),
            ),
          ),
        ),
      ],
    );
  }
}

class MapPreviewWidget extends StatefulWidget {
  final String query;
  final String fallbackCity;

  const MapPreviewWidget({
    super.key,
    required this.query,
    required this.fallbackCity,
  });

  @override
  State<MapPreviewWidget> createState() => _MapPreviewWidgetState();
}

class _MapPreviewWidgetState extends State<MapPreviewWidget> {
  LatLng _center = const LatLng(18.5913, 73.7389);
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCoordinates();
  }

  Future<void> _loadCoordinates() async {
    LatLng? coords = await _fetchCoords(widget.query);
    if (coords == null && widget.fallbackCity.isNotEmpty) {
      coords = await _fetchCoords(widget.fallbackCity);
    }
    if (coords != null) {
      if (mounted) {
        setState(() {
          _center = coords!;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Geocoding results shared across opens: Nominatim asks for few, cached requests.
  static final Map<String, LatLng?> _coordsCache = {};

  Future<LatLng?> _fetchCoords(String query) async {
    if (_coordsCache.containsKey(query)) return _coordsCache[query];
    try {
      final response = await http.get(
        Uri.parse('https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=1'),
        headers: {'User-Agent': 'LastMinutesDealApp/1.0'},
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final lat = double.tryParse(data[0]['lat']?.toString() ?? '');
          final lon = double.tryParse(data[0]['lon']?.toString() ?? '');
          if (lat != null && lon != null) {
            return _coordsCache[query] = LatLng(lat, lon);
          }
        }
      }
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(
        child: SizedBox(
          height: 32.h,
          width: 32.w,
          child: CircularProgressIndicator(color: Color(0xFF111827), strokeWidth: 2.5),
        ),
      );
    }

    return FlutterMap(
      options: MapOptions(
        initialCenter: _center,
        initialZoom: 14.0,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.none,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://a.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}@2x.png',
          userAgentPackageName: 'com.lastminutessdeal.app',
        ),
      ],
    );
  }
}