import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lmd_app/features/profile/presentation/pages/profile_screen.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import 'package:lmd_app/features/hotel/presentation/cubit/hotel_search_cubit.dart';
import 'package:lmd_app/features/hotel/presentation/cubit/hotel_search_state.dart';
import 'package:lmd_app/core/theme/app_colors.dart';
import 'package:lmd_app/core/theme/app_spacing.dart';
import 'package:lmd_app/core/theme/app_text.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/features/hotel/data/models/hotel_search/search_hotels_request.dart';
import 'package:lmd_app/features/category/presentation/pages/category_listing_screen.dart';
import 'package:lmd_app/features/notifications/presentation/pages/notifications_page.dart';

class HomeHeroSection extends StatefulWidget {
  const HomeHeroSection({super.key});

  @override
  State<HomeHeroSection> createState() => _HomeHeroSectionState();
}

class _HomeHeroSectionState extends State<HomeHeroSection> {
  // ============================================================
  // CONTROLLERS
  // ============================================================
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  // ============================================================
  // SEARCH STATE
  // ============================================================
  bool _isEditGuestVisible = false;

  // ============================================================
  // DATE STATE
  // ============================================================
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  // ============================================================
  // GUEST STATE
  // ============================================================
  int rooms = 1;
  int adults = 2;
  int children = 0;
  bool travellingWithPets = false;

  @override
  void initState() {
    super.initState();
    _selectedStartDate = DateTime.now().add(const Duration(days: 1));
    _selectedEndDate = DateTime.now().add(const Duration(days: 2));
  }

  @override
  void dispose() {
    searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  // ============================================================
  // DATE LABELS
  // ============================================================
  String get _checkInDateLabel {
    final date =
        _selectedStartDate ?? DateTime.now().add(const Duration(days: 1));
    // return DateFormat('EEE, d MMM').format(date);
    return DateFormat('d MMM').format(date);
  }

  String get _checkOutDateLabel {
    final date =
        _selectedEndDate ?? DateTime.now().add(const Duration(days: 2));
    return DateFormat('d MMM').format(date);
  }

  // ============================================================
  // GUEST LABEL
  // ============================================================
  String get _guestCountLabel {
    final totalGuests = adults + children;
    final guestStr = totalGuests == 1 ? 'Guest'.tr() : 'Guests'.tr();
    final roomStr = rooms == 1 ? 'Room'.tr() : 'Rooms'.tr();
    return '$totalGuests $guestStr, $rooms $roomStr';
  }

  // ============================================================
  // SEARCH HANDLER
  // ============================================================
  Future<void> _handleSearch() async {
    // Nothing typed: the results page asks for location and searches near the
    // user (else Pune) once it is open, so no permission prompt on this click.
    final destination = searchController.text.trim();
    final checkIn =
        _selectedStartDate ?? DateTime.now().add(const Duration(days: 1));
    final checkOut =
        _selectedEndDate ?? DateTime.now().add(const Duration(days: 2));

    final request = SearchHotelsRequest(
      checkIn: checkIn,
      checkOut: checkOut,
      rooms: rooms,
      adults: adults,
      children: List.filled(children, 5),
      query: destination,
    );

    // Open the results page right away; the supplier search can take many
    // seconds and the page shows its own spinner / error while it runs.
    final cubit = context.read<HotelSearchCubit>();
    await cubit.searchHotels(request);

    if (!mounted) return;

    if (cubit.state.isSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryListingScreen(
            categoryName: 'All'.tr(),
            initialQuery: destination,
            initialStartDate: checkIn,
            initialEndDate: checkOut,
            initialRooms: rooms,
            initialAdults: adults,
            initialChildren: children,
            initialTravellingWithPets: travellingWithPets,
            searchCubit: cubit,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(cubit.state.errorMessage ?? 'Search failed'.tr()),
        ),
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryListingScreen(
          locateOnOpen: destination.isEmpty,
          categoryName: 'All'.tr(),
          initialQuery: destination,
          initialStartDate: checkIn,
          initialEndDate: checkOut,
          initialRooms: rooms,
          initialAdults: adults,
          initialChildren: children,
          initialTravellingWithPets: travellingWithPets,
          searchCubit: cubit,
        ),
      ),
    );
  }

  // ============================================================
  // DATE PICKER DIALOG
  // ============================================================
  Future<void> _showPicker() async {
    DateTime? tempStartDate = _selectedStartDate;
    DateTime? tempEndDate = _selectedEndDate;

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: DS.card,
          insetPadding: EdgeInsets.all(16.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select dates'.tr(),
                        style: TextStyle(
                          fontFamily: DS.fontFamily,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: DS.textPrimary,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        icon: const Icon(Icons.close, color: Color(0xFF111827)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    height: 360.h,
                    child: SfDateRangePicker(
                      view: DateRangePickerView.month,
                      selectionMode: DateRangePickerSelectionMode.range,
                      minDate: DateTime.now(),
                      showActionButtons: true,
                      confirmText: 'Apply'.tr(),
                      cancelText: 'Cancel'.tr(),
                      startRangeSelectionColor: DS.primaryBlue,
                      endRangeSelectionColor: DS.primaryBlue,
                      todayHighlightColor: DS.primaryBlue,
                      rangeSelectionColor: DS.primaryBlue.withValues(
                        alpha: 0.12,
                      ),
                      initialSelectedRange: PickerDateRange(
                        tempStartDate ??
                            DateTime.now().add(const Duration(days: 1)),
                        tempEndDate ??
                            DateTime.now().add(const Duration(days: 2)),
                      ),
                      onSelectionChanged:
                          (DateRangePickerSelectionChangedArgs args) {
                        if (args.value is PickerDateRange) {
                          final range = args.value as PickerDateRange;
                          tempStartDate = range.startDate;
                          tempEndDate = range.endDate;
                        }
                      },
                      onSubmit: (Object? value) {
                        if (value is PickerDateRange) {
                          setState(() {
                            _selectedStartDate = value.startDate;
                            _selectedEndDate =
                                value.endDate ??
                                    value.startDate?.add(const Duration(days: 1));
                          });
                        }
                        Navigator.of(dialogContext).pop();
                      },
                      onCancel: () {
                        Navigator.of(dialogContext).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // HERO HEADING (Unchanged exact original)
  // ============================================================
  Widget _buildHeroHeading(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "India's home for ",
                style: AppText.h1.copyWith(
                  fontFamily: AppText.fontFamily,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: 'last\nminute stays.',
                style: AppText.h1.copyWith(
                  fontFamily: AppText.fontFamily,
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.sm),
      ],
    );
  }

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.h),
            // Existing Heading
            // _buildHeroHeading(context),

            // 1. TOP SEARCH BAR
            _buildTopSearchBar(),

            // 2. CHECK-IN / CHECKOUT / GUESTS CARD
            BlocBuilder<HotelSearchCubit, HotelSearchState>(
              builder: (context, searchState) {
                return _buildCheckInGuestsCard(searchState);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // 1. TOP SEARCH BAR
  // ============================================================
  Widget _buildTopSearchBar() {
    return Container(
      height: 56.h,
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: DS.card,
        borderRadius: BorderRadius.circular(DS.radiusInput.r),
        border: Border.all(color: DS.borderMedium, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.place_outlined, size: 20.r, color: DS.textSecondary),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: searchController,
              focusNode: _searchFocus,
              style: TextStyle(
                fontFamily: DS.fontFamily,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: DS.textPrimary,
              ),
              decoration: InputDecoration(
                // hintText: 'Search destinations, hotels...'.tr(),
                hintText: 'where_are_you_going'.tr(),
                hintStyle: TextStyle(
                  fontFamily: DS.fontFamily,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: DS.textTertiary,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              onSubmitted: (_) => _handleSearch(),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: Icon(
              Icons.notifications_none_rounded,
              size: 20.r,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // 2. CHECK-IN / CHECKOUT / GUESTS CARD
  // ============================================================
  Widget _buildCheckInGuestsCard(HotelSearchState searchState) {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: DS.card,
        borderRadius: BorderRadius.circular(DS.radiusCard.r),
        border: Border.all(color: DS.borderLight, width: 1),
        boxShadow: DS.shadowCard,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Check-in / Checkout Row
          Row(
            children: [
              // Check-in Column
              Expanded(
                child: InkWell(
                  onTap: _showPicker,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Row(
                    children: [
                      // Container(
                      //   width: 40.w,
                      //   height: 40.h,
                      //   decoration: const BoxDecoration(
                      //     color: Color(0xFFF3F4F6),
                      //     shape: BoxShape.circle,
                      //   ),
                      //   alignment: Alignment.center,
                      //   child: Icon(
                      //     Icons.calendar_today_outlined,
                      //     size: 20.r,
                      //     color: const Color(0xFF111827),
                      //   ),
                      // ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CHECK-IN'.tr(),
                              style: TextStyle(
                                fontFamily: DS.fontFamily,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: DS.textTertiary,
                                letterSpacing: 0.88,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Text(
                                  _checkInDateLabel,
                                  style: TextStyle(
                                    fontFamily: DS.fontFamily,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: DS.textPrimary,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 20.r,
                                  color: DS.textSecondary,
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

              // Vertical Divider
              Container(
                height: 32.h,
                width: 1.w,
                margin: EdgeInsets.symmetric(horizontal: 12.w),
                color: DS.borderLight,
              ),

              // Checkout Column
              Expanded(
                child: InkWell(
                  onTap: _showPicker,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Row(
                    children: [
                      // Container(
                      //   width: 40.w,
                      //   height: 40.h,
                      //   decoration: const BoxDecoration(
                      //     color: Color(0xFFF3F4F6),
                      //     shape: BoxShape.circle,
                      //   ),
                      //   alignment: Alignment.center,
                      //   child: Icon(
                      //     Icons.calendar_month_outlined,
                      //     size: 20.r,
                      //     color: const Color(0xFF111827),
                      //   ),
                      // ),
                      // SizedBox(width: 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CHECK-OUT'.tr(),
                              style: TextStyle(
                                fontFamily: DS.fontFamily,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w500,
                                color: DS.textTertiary,
                                letterSpacing: 0.88,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              _checkOutDateLabel,
                              style: TextStyle(
                                fontFamily: DS.fontFamily,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: DS.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Horizontal Divider: 1dp #F3F4F6, 16dp vertical spacing
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Container(height: 1, color: DS.borderLight),
          ),

          // Guests Row
          InkWell(
            onTap: () {
              setState(() {
                _isEditGuestVisible = !_isEditGuestVisible;
              });
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Row(
              children: [
                // Container(
                //   width: 40.w,
                //   height: 40.h,
                //   decoration: const BoxDecoration(
                //     color: Color(0xFFF3F4F6),
                //     shape: BoxShape.circle,
                //   ),
                //   alignment: Alignment.center,
                //   child: Icon(
                //     Icons.people_outline,
                //     size: 20.r,
                //     color: const Color(0xFF111827),
                //   ),
                // ),
                // SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GUESTS'.tr(),
                        style: TextStyle(
                          fontFamily: DS.fontFamily,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                          color: DS.textTertiary,
                          letterSpacing: 0.88,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _guestCountLabel,
                        style: TextStyle(
                          fontFamily: DS.fontFamily,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: DS.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 20.r,
                      color: DS.textSecondary,
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      _isEditGuestVisible
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      size: 20.r,
                      color: DS.textSecondary,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Expandable Guest Editor
          if (_isEditGuestVisible) ...[
            SizedBox(height: 16.h),
            Container(height: 1, color: DS.borderLight),
            SizedBox(height: 12.h),
            _buildGuestEditor(),
          ],

          // Search button
          Padding(
            padding: EdgeInsets.only(top: 16.h),
            child: Container(
              width: double.infinity,
              height: 56.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DS.radiusButton.r),
                boxShadow: DS.shadowButton,
              ),
              child: ElevatedButton(
                onPressed: searchState.isLoading ? null : _handleSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: DS.primaryDark,
                  disabledBackgroundColor: DS.primaryDark,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(DS.radiusButton.r),
                  ),
                ),
                child: searchState.isLoading
                    ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 18.r, color: Colors.white),
                    SizedBox(width: 8.w),
                    Text(
                      'Search'.tr(),
                      style: TextStyle(
                        fontFamily: DS.fontFamily,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GUEST COUNTERS
  // ============================================================
  Widget _buildGuestEditor() {
    return Column(
      children: [
        _buildCounterRow(
          title: 'Rooms'.tr(),
          value: rooms,
          onMinus: () {
            if (rooms > 1) setState(() => rooms--);
          },
          onPlus: () {
            if (rooms < 20) setState(() => rooms++);
          },
        ),
        _buildCounterRow(
          title: 'Adults'.tr(),
          subtitle: 'Ages 13 or above'.tr(),
          value: adults,
          onMinus: () {
            if (adults > 1) setState(() => adults--);
          },
          onPlus: () {
            if (adults < 40) setState(() => adults++);
          },
        ),
        _buildCounterRow(
          title: 'Children.'.tr(),
          subtitle: 'Ages 0–12'.tr(),
          value: children,
          onMinus: () {
            if (children > 0) setState(() => children--);
          },
          onPlus: () {
            if (children < 20) setState(() => children++);
          },
        ),
      ],
    );
  }

  Widget _buildCounterRow({
    required String title,
    String? subtitle,
    required int value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: DS.fontFamily,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: DS.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: DS.fontFamily,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: DS.textSecondary,
                  ),
                ),
              ],
            ],
          ),
          // Quantity pill:  –  value  +
          Container(
            height: 32.h,
            decoration: BoxDecoration(
              color: DS.card,
              borderRadius: BorderRadius.circular(DS.radiusPill.r),
              border: Border.all(color: DS.borderMedium),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: onMinus,
                  borderRadius: BorderRadius.circular(DS.radiusPill.r),
                  child: SizedBox(
                    width: 32.w,
                    height: 32.h,
                    child: Icon(
                      Icons.remove,
                      size: 16.r,
                      color: DS.textPrimary,
                    ),
                  ),
                ),
                SizedBox(
                  width: 28.w,
                  child: Center(
                    child: Text(
                      '$value',
                      style: TextStyle(
                        fontFamily: DS.fontFamily,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: DS.textPrimary,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: onPlus,
                  borderRadius: BorderRadius.circular(DS.radiusPill.r),
                  child: SizedBox(
                    width: 32.w,
                    height: 32.h,
                    child: Icon(Icons.add, size: 16.r, color: DS.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}