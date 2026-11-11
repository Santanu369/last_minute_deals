import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/app/shell/navbar_cubit.dart';
import 'package:lmd_app/core/widgets/custom_appbar.dart';
import 'package:lmd_app/core/widgets/custom_appbar2.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/features/language/translated_text_wish.dart';
import 'package:lmd_app/features/wishlist/data/models/wishlist_item_model.dart';
import 'package:lmd_app/features/wishlist/data/services/wishlist_service.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final WishlistService _wishlistService = WishlistService();

  List<WishlistItemModel> _items = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    try {
      final items = await _wishlistService.getWishlist();
      if (mounted) {
        setState(() {
          _items = items;
          _isLoading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString().replaceFirst('Exception: ', '');
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _removeItem(WishlistItemModel item) async {
    try {
      await _wishlistService.toggleWishlist(
        id: item.id,
        hotelSource: item.hotelSource,
      );
      setState(() {
        _items.removeWhere(
                (e) => e.id == item.id && e.hotelSource == item.hotelSource);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to remove item',
            style: GoogleFonts.inter(fontSize: 12.sp, color: Colors.white),
          ),
        ),
      );
    }
  }

  Future<void> _confirmClearWishlist() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: DS.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DS.radiusCard.r),
        ),
        title: Text(
          'Clear wishlist?',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: DS.textPrimary,
          ),
        ),
        content: Text(
          'This will remove all saved stays from your wishlist. This action cannot be undone.',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: DS.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'cancel'.tr(),
              style: GoogleFonts.inter(
                color: DS.primaryBlue,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'clear'.tr(),
              style: GoogleFonts.inter(
                color: DS.accentRed,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _clearWishlist();
    }
  }

  Future<void> _clearWishlist() async {
    final itemsToRemove = List<WishlistItemModel>.from(_items);

    // Optimistically clear the UI
    setState(() {
      _items = [];
    });

    // Remove each item from backend via existing toggle API
    bool anyFailed = false;
    for (final item in itemsToRemove) {
      try {
        await _wishlistService.toggleWishlist(
          id: item.id,
          hotelSource: item.hotelSource,
        );
      } catch (e) {
        anyFailed = true;
      }
    }

    if (mounted && anyFailed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Some items could not be removed. Pull to refresh.'),
        ),
      );
    }

    // Re-sync with server to be safe
    if (mounted) {
      await _loadWishlist();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: DS.background,
      appBar: CustomAppbar2(scaffoldKey: _scaffoldKey),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DS.maxWidth),
          child: SafeArea(
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: DS.primaryBlue));
    }

    if (_error != null) {
      return RefreshIndicator(
        color: DS.primaryBlue,
        onRefresh: _loadWishlist,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 200.h),
            Center(
              child: Text(
                _error!,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: DS.textSecondary,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: DS.primaryBlue,
      onRefresh: _loadWishlist,
      child: ListView(
        // Card padding + gap fixed as per spec: 16px card padding, 12px gap
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _header(), SizedBox(height: 16.h),
          if (_items.isEmpty)
            _emptyState()
          else ...[
            for (final item in _items) ...[
              _wishlistCard(item),
              SizedBox(height: 12.h), // gap between cards: 12px
            ],
            SizedBox(height: 8.h),
            _exploreMoreButton(),
          ],
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // H2 - Section Title
              TranslatedText(
                text: 'MY WISHLIST',
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: DS.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              // Secondary body text
              TranslatedText(
                text: 'Your favourite stays, saved for later.',
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: DS.textSecondary,
                ),
              ),
            ],
          ),
        ),
        if (_items.isNotEmpty)
          GestureDetector(
            onTap: _confirmClearWishlist,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE4E8), // Accent Light
                borderRadius: BorderRadius.circular(DS.radiusPill.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete_outline, size: 16.r, color: DS.accentRed),
                  SizedBox(width: 6.w),
                  TranslatedText(
                    text: 'Clear Wishlist',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                      color: DS.accentRed,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: EdgeInsets.only(top: 100.h),
      child: Column(
        children: [
          Icon(Icons.favorite_border, size: 48.r, color: DS.textTertiary),
          SizedBox(height: 12.h),
          Text(
            'Nothing saved yet',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: DS.textPrimary,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Tap the heart on any stay to save it here.',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: DS.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _wishlistCard(WishlistItemModel item) {
    final isRatehawk = item.hotelSource == 'ratehawk';
    final title = isRatehawk ? 'RateHawk hotel'.tr() : item.name;
    final location = item.location.isNotEmpty
        ? item.location
        : (isRatehawk ? 'ID ${item.hid}' : '');
    final hasRating = item.rating != null && item.rating! > 0;

    // Hotel Card: white, 20 radius, 1px #EFEFF2 border, 12 padding, 14 gap,
    // 110x110 image with 14 radius.
    return Container(
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
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: SizedBox(
                  width: 110.w,
                  height: 110.w,
                  child: isRatehawk || item.image.isEmpty
                      ? Container(
                    color: DS.background,
                    child: Icon(
                      isRatehawk ? Icons.apartment : Icons.photo_outlined,
                      size: 24.r,
                      color: DS.textTertiary,
                    ),
                  )
                      : CachedNetworkImage(
                    imageUrl: item.image,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => Container(
                      color: DS.background,
                      child: Icon(
                        Icons.image,
                        size: 24.r,
                        color: DS.textTertiary,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 4,
                bottom: 4,
                child: Icon(
                  Icons.saved_search_rounded,
                  size: 16.r,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dynamic API Hotel Title translated via Method 2
                TranslatedText(
                  text: title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: DS.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                if (location.isNotEmpty)
                // Dynamic API Location translated via Method 2
                  TranslatedText(
                    text: location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: DS.textSecondary,
                    ),
                  ),
                SizedBox(height: 6.h),
                if (hasRating)
                  Row(
                    children: [
                      // Rating pill: green text on light green
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: DS.successLight,
                          borderRadius: BorderRadius.circular(DS.radiusPill.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 14.r, color: DS.starYellow),
                            SizedBox(width: 4.w),
                            Text(
                              item.rating!.toStringAsFixed(1),
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: DS.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (item.reviewCount != null &&
                          item.reviewCount! > 0) ...[
                        const SizedBox(width: 4),
                        Text(
                          '(${item.reviewCount})',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: DS.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                if (hasRating) SizedBox(height: 6.h),
                Row(
                  children: [
                    Text(
                      '₹${item.price.toStringAsFixed(0)}',
                      style: GoogleFonts.inter(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: DS.textPrimary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      ' /night'.tr(),
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: DS.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Heart: 24px circle
          GestureDetector(
            onTap: () => _removeItem(item),
            child: Padding(
              padding: EdgeInsets.only(left: 4.w),
              child: Container(
                width: 24.r,
                height: 24.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: DS.card,
                  border: Border.all(color: DS.accentRed),
                ),
                child: Icon(Icons.favorite, color: DS.accentRed, size: 14.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _exploreMoreButton() {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DS.radiusButton.r),
        boxShadow: DS.shadowButton,
      ),
      child: ElevatedButton(
        onPressed: () {
          context.read<NavbarCubit>().selectTab(0);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: DS.primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DS.radiusButton.r),
          ),
        ),
        child: Text(
          'Explore More Stays',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}