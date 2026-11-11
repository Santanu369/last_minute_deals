import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:lmd_app/core/services/location_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lmd_app/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/details_cubit.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/hotel_cubit.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/hotel_state.dart';
import 'package:lmd_app/core/widgets/custom_appbar.dart';
import 'package:lmd_app/core/theme/app_colors.dart';
import 'package:lmd_app/core/theme/app_spacing.dart';
import 'package:lmd_app/core/theme/app_text.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/features/hotel/data/models/retail_listing_model.dart';
import 'package:lmd_app/features/booking/presentation/pages/booking_page.dart';
import 'package:lmd_app/features/category/presentation/pages/category_listing_screen.dart';
import 'package:lmd_app/features/home/presentation/widgets/home_hero_section.dart';
import 'package:lmd_app/features/hotel/presentation/widgets/hotel_nearby_deals.dart';
import 'package:lmd_app/features/cart/data/services/cart_services.dart';
import 'package:lmd_app/features/hotel/data/services/hotel_service.dart';

class StayHome extends StatefulWidget {
  const StayHome({super.key});

  @override
  State<StayHome> createState() => _StayHomeState();
}

class _StayHomeState extends State<StayHome> {
  int count = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Filter Chips - default active Hotels
  String _selectedCategory = 'hotels';

  @override
  void initState() {
    super.initState();
    context.read<HotelCubit>().loadHotels();
    // Show the location permission prompt up front; result is cached for search.
    LocationService.instance.searchCoordinates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: DS.background,
      // ==========================================================
      // BODY
      // ==========================================================
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: DS.maxWidth),
            child: DefaultTextStyle.merge(
              style: const TextStyle(fontFamily: DS.fontFamily),
              child: RefreshIndicator(
                color: DS.primaryBlue,
                onRefresh: () => context.read<HotelCubit>().loadHotels(force: true),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.zero,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ==========================================================
                        // HERO HEADER (Preserved original app bar & header layout)
                        // ==========================================================
                        // buildHeroHeader(context),

                        CustomAppbar(scaffoldKey: _scaffoldKey),


                        // const SizedBox(height: 12),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.h),
                          child: Container(
                            height: 1,
                            color: DS.borderLight,
                          ),
                        ),
                        // ),
                        // ),

                        HomeHeroSection(), // Search form elements inside
                        const SizedBox(height: 12),

                        // ==========================================================
                        // 3. FILTER CHIPS (2 rows)
                        // ==========================================================
                        _buildFilterChipsSection(),

                        const SizedBox(height: 6),

                        // ==========================================================
                        // HOTEL DEALS (Unchanged functionality, APIs & dynamic data)
                        // ==========================================================
                        _dealsSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ====================================================================
  // HERO HEADER (Original stack layout with CustomAppbar & HomeHeroSection)
  // ====================================================================

  Widget buildHeroHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1. Dark Header Background (Minimal Height)
        Container(
          width: double.infinity,
          // Set a smaller height to keep the dark section minimal
          padding: const EdgeInsets.only(bottom: 150),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            gradient: RadialGradient(
              center: Alignment(1.2, 1.2),
              radius: 1.5,
              colors: [
                Color(0xFF991B1B), // Soft bright red glow
                Color(0xFF450A0A), // Dark red transition
                Color(0xFF121212), // Solid dark charcoal
              ],
              stops: [0.0, 0.45, 1.0],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomAppbar(),
              const SizedBox(height: 16),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.only(top: 32),
          child: HomeHeroSection(),
        ), // Search form elements inside
      ],
    );
  }

  // ====================================================================
  // 3. FILTER CHIPS (2 rows with 8dp horizontal & vertical gap)
  // ====================================================================
  Widget _buildFilterChip(String labelKey) {
    final isActive = _selectedCategory == labelKey;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategory = labelKey;
        });

        String categoryParam;

        switch (labelKey) {
          case 'hotels':
            categoryParam = 'hotel';
            break;

          case 'resorts':
            categoryParam = 'resort';
            break;

          case 'villas':
            categoryParam = 'villa';
            break;

          case 'luxury_villas':
            categoryParam = 'luxury-villa';
            break;

          case 'camping':
            categoryParam = 'camping';
            break;

          default:
            categoryParam = 'all';
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryListingScreen(
              categoryName: categoryParam,
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 38.h,
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        decoration: BoxDecoration(
          color: isActive ? DS.primaryBlue : DS.card,
          borderRadius: BorderRadius.circular(DS.radiusPill.r),
          border: Border.all(
            color: isActive ? DS.primaryBlue : DS.borderLight,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          labelKey.tr(),
          style: TextStyle(
            fontFamily: DS.fontFamily,
            fontSize: 14.sp,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? Colors.white : DS.textPrimary,
          ),
        ),
      ),
    );
  }
  Widget _buildFilterChipsSection() {
    return Padding(
      padding: EdgeInsets.only(top: 16.h, bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: All, Hotels, Resorts, Camping
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: DS.screenPadding.w),
            child: Row(
              children: [
                _buildFilterChip('all'),
                SizedBox(width: 8.w),
                _buildFilterChip('hotels'),
                SizedBox(width: 8.w),
                _buildFilterChip('resorts'),
                SizedBox(width: 8.w),
                _buildFilterChip('camping'),
                SizedBox(width: 8.w),
                _buildFilterChip('villas'),
                SizedBox(width: 8.w),
                _buildFilterChip('luxury_villas'),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md),
          // Row 2: Villas, Luxury Villas
          // SingleChildScrollView(
          //   scrollDirection: Axis.horizontal,
          //   physics: const BouncingScrollPhysics(),
          //   padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenHorizontal),
          //   child: Row(
          //     children: [
          //       _buildFilterChip('Villas'),
          //       SizedBox(width: AppSpacing.md),
          //       _buildFilterChip('Luxury Villas'),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  // ====================================================================
  // HOTEL DEALS SECTION (DYNAMIC DATA / API INTEGRATION)
  // ====================================================================
  Widget _dealsSection() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 1280),
      child: BlocBuilder<HotelCubit, HotelState>(
        builder: (context, state) {
          // ------------------------------------------------------------
          // LOADING
          // ------------------------------------------------------------
          if (state.isLoading) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          // ------------------------------------------------------------
          // ERROR
          // ------------------------------------------------------------
          if (state.error != null) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(state.error!, textAlign: TextAlign.center),
              ),
            );
          }

          // ------------------------------------------------------------
          // DEALS
          // ------------------------------------------------------------
          return Padding(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // ========================================================
                // TODAY'S HOTEL DEALS
                // ========================================================
                HotelNearbyDeals(
                  listings: state.todayDeals,
                  title: 'last_minutes_hotels'.tr(),
                  loadmore: state.todayDeals.length > 30 ? 1 : 0,
                  onViewAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const CategoryListingScreen(categoryName: 'hotel'),
                      ),
                    );
                  },
                  onHotelTap: (hotel) {
                    _openHotelDetails(hotel);
                  },
                ),


                // ========================================================
                // POPULAR RESORTS
                // ========================================================
                HotelNearbyDeals(
                  listings: state.popularResorts,
                  title: 'last_minutes_resorts'.tr(),
                  loadmore: state.popularResorts.length > 30 ? 1 : 0,
                  onViewAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const CategoryListingScreen(categoryName: 'resort'),
                      ),
                    );
                  },
                  onHotelTap: (hotel) {
                    _openHotelDetails(hotel);
                  },
                ),


                // ========================================================
                // TOP VILLAS
                // ========================================================
                HotelNearbyDeals(
                  listings: state.villas,
                  title: 'last_minutes_villas',
                  loadmore: state.villas.length > 30 ? 1 : 0,
                  onViewAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const CategoryListingScreen(categoryName: 'villa'),
                      ),
                    );
                  },
                  onHotelTap: (hotel) {
                    _openHotelDetails(hotel);
                  },
                ),


                // ========================================================
                // CAMPING EXPERIENCES
                // ========================================================
                HotelNearbyDeals(
                  listings: state.camping,
                  title: 'last_minutes_camping'.tr(),
                  loadmore: state.camping.length > 30 ? 1 : 0,
                  onViewAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                        const CategoryListingScreen(categoryName: 'camping'),
                      ),
                    );
                  },
                  onHotelTap: (hotel) {
                    _openHotelDetails(hotel);
                  },
                ),

                SizedBox(height: 80.h + MediaQuery.paddingOf(context).bottom),
              ],
            ),
          );
        },
      ),
    );
  }

  // ====================================================================
  // OPEN HOTEL DETAILS
  // ====================================================================
  void _openHotelDetails(RetailListingModel hotel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => DetailsCubit(HotelService())),
            BlocProvider(create: (_) => CartCubit(CartService())),
          ],
          child: BookingPage(productId: hotel.id, listing: hotel),
        ),
      ),
    );
  }

  // ====================================================================
  // LOAD MORE BUTTON
  // ====================================================================
  Widget buildLoadMoreButton() {
    return BlocBuilder<HotelCubit, HotelState>(
      builder: (context, state) {
        final totalCount = state.visibleListings.length;
        final currentLimit = 12 * (count + 1);
        final showLess = currentLimit >= totalCount && totalCount > 12;

        if (totalCount <= 12) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () {
                setState(() {
                  if (showLess) {
                    count = 0;
                  } else {
                    count++;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    showLess ? 'Show Less Deals'.tr() : 'Load More Deals'.tr(),
                    style: const TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Icon(
                    showLess
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.black,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}