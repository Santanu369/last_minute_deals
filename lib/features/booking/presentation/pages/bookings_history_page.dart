import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:lmd_app/features/booking/presentation/cubit/booking_history_cubit.dart';
import 'package:lmd_app/features/booking/presentation/cubit/booking_history_state.dart';
import 'package:lmd_app/features/payment/data/models/booking_history_response.dart';
import 'package:lmd_app/features/payment/presentation/pages/payment_checkout_page.dart';
import 'package:lmd_app/features/booking/data/services/booking_service.dart';
import 'package:lmd_app/features/language/presentation/language_picker_page.dart';
import 'package:lmd_app/features/language/translated_text_wish.dart';

class BookingsHistoryPage extends StatefulWidget {
  const BookingsHistoryPage({super.key});

  @override
  State<BookingsHistoryPage> createState() => _BookingsHistoryPageState();
}

class _BookingsHistoryPageState extends State<BookingsHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String? _expandedBookingId;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<BookingHistoryCubit>().loadBookingHistory();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingHistoryCubit>(
      create: (_) =>
      BookingHistoryCubit(bookingService: BookingService())
        ..loadBookingHistory(),
      child: Scaffold(
        backgroundColor: DS.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: DS.card,
          foregroundColor: DS.textPrimary,
          centerTitle: false,
          title: Text(
            'my_bookings'.tr(),
            style: GoogleFonts.inter(fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          actions: [
            IconButton(
              tooltip: 'language'.tr(),
              icon: Icon(Icons.language, size: 23.sp),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const LanguagePicker(),
                );
              },
            ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: DS.maxWidth),
            child: BlocBuilder<BookingHistoryCubit, BookingHistoryState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: DS.primaryBlue),
                  );
                }

                if (state.errorMessage != null) {
                  return _buildErrorState(state.errorMessage!);
                }

                return Column(
                  children: [
                    _buildTabs(
                      state.completedBookings.length,
                      state.pendingBookings.length,
                      state.failedBookings.length,
                    ),

                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildBookingList(state.completedBookings, 'CONFIRMED'),
                          _buildBookingList(state.pendingBookings, 'PENDING'),
                          _buildBookingList(state.failedBookings, 'FAILED'),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 55.r, color: DS.accentRed),
            SizedBox(height: 14.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 14.sp, color: DS.textSecondary,
              ),
            ),
            SizedBox(height: 18.h),
            ElevatedButton(
              onPressed: () {
                context.read<BookingHistoryCubit>().loadBookingHistory();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DS.primaryBlue,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(DS.radiusButton.r),
                ),
              ),
              child: Text('try_again'.tr()),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TABS
  // ============================================================

  Widget _buildTabs(int completedCount, int pendingCount, int failedCount) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: DS.borderLight, width: 1)),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        // Fix: isScrollable tabs default to TabAlignment.start, which pushes
        // "Pending" and "Failed" toward the left when the total tab width is
        // less than the screen width. Centering them fixes that.
        tabAlignment: TabAlignment.start,
        indicatorColor: DS.primaryBlue,
        indicatorWeight: 2,
        labelColor: DS.primaryBlue,
        unselectedLabelColor: DS.textSecondary,
        labelStyle: GoogleFonts.inter(fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        tabs: [
          Tab(child: _tabTitle('confirmed'.tr(), completedCount, 0)),
          Tab(child: _tabTitle('pending'.tr(), pendingCount, 1)),
          Tab(child: _tabTitle('failed'.tr(), failedCount, 2)),
        ],
      ),
    );
  }

  Widget _tabTitle(String title, int count, int index) {
    final isSelected = _tabController.index == index;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title),
        if (count > 0) ...[
          SizedBox(width: 6.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? DS.primaryBlue.withValues(alpha: 0.10)
                  : DS.background,
              borderRadius: BorderRadius.circular(DS.radiusPill.r),
            ),
            child: Text(
              '$count',
              style: GoogleFonts.inter(fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: isSelected ? DS.primaryBlue : DS.textTertiary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  // ============================================================
  // BOOKING LIST
  // ============================================================

  // NOTE: `bookings` here always comes from the Cubit/State, which
  // itself is populated by calling BookingHistoryResponse.fromJson(...)
  // on the raw API response — nothing in this page is static/mocked.
  Widget _buildBookingList(List<BookingHistoryItem> bookings, String status) {
    if (bookings.isEmpty) {
      return _buildEmptyState(status);
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<BookingHistoryCubit>().loadBookingHistory();
      },
      child: ListView.builder(
        padding: EdgeInsets.fromLTRB(16.w, 18.h, 12.w, 30.h),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          return _buildBookingCard(context, bookings[index], status);
        },
      ),
    );
  }

  // ============================================================
  // EMPTY
  // ============================================================

  Widget _buildEmptyState(String status) {
    String title;
    String subtitle = '';

    switch (status) {
      case 'PENDING':
        title = 'No_pending_bookings'.tr();
        subtitle = 'You_have no_pending_bookings_at_the_moment'.tr();
        break;
    // case 'COMPLETED':
      case 'CONFIRMED':
        title = 'No_completed_bookings'.tr();
        subtitle = 'You_have no_completed_bookings_at_the_moment'.tr();
        break;

      case 'FAILED':
        title = 'No_failed_bookings'.tr();
        subtitle = 'You_have no_failed_bookings_at_the_moment'.tr();
        break;

      default:
        title = 'no_data'.tr();
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.hotel_outlined,
            size: 60.r, color: DS.textTertiary,
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600, color: DS.textPrimary,
            ),
          ),

          Text(
            subtitle,
            style: GoogleFonts.inter(fontSize: 14.sp, color: DS.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // BOOKING CARD
  // ============================================================

  Widget _buildBookingCard(
      BuildContext context,
      BookingHistoryItem booking,
      String status,
      ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: DS.card,
        borderRadius: BorderRadius.circular(DS.radiusCard.r),
        border: Border.all(color: DS.borderLight),
        boxShadow: DS.shadowCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHotelImage(booking, status),

          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HOTEL NAME
                Row(
                  children: [
                    // Expanded(
                    //   child: Text(
                    //     booking.hotelName,
                    //     maxLines: 1,
                    //     overflow: TextOverflow.ellipsis,
                    //     style: const TextStyle(
                    //       fontFamily: 'Inter',
                    //       fontSize: 15.sp,
                    //       fontWeight: FontWeight.w700,
                    //     ),
                    //   ),
                    // ),

                    Expanded(
                      child: TranslatedText(
                        text: booking.hotelName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600, color: DS.textPrimary,
                        ),
                      ),
                    ),
                    Spacer(),

                    GestureDetector(
                      onTap: () {
                        _viewDetails(booking);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _expandedBookingId == booking.bookingId
                                ? 'hide_details'.tr()
                                : 'view_details'.tr(),
                            style: GoogleFonts.inter(color: DS.primaryBlue,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            _expandedBookingId == booking.bookingId
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            size: 18.r,
                            color: DS.primaryBlue,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 6.h),

                // LOCATION
                _buildAddress(booking),

                SizedBox(height: 8.h),

                // RATING
                if (booking.rating > 0)
                  Row(
                    children: [
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
                              booking.rating.toStringAsFixed(1),
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w700,
                                color: DS.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 12.h),

                if (_expandedBookingId == booking.bookingId) ...[
                  SizedBox(height: 14.h),
                  _buildBookingDetails(booking),
                ],

                SizedBox(height: 12.h),

                // AMENITIES
                _buildAmenities(booking),

                // const SizedBox(height: 14.h),

                // DESCRIPTION  <-- NEW: this was missing before, so it never rendered
                // _buildDescription(booking),
                // const SizedBox(height: 14.h),

                // ADDRESS
                // _buildAddress(booking),
                SizedBox(height: 14.h),

                // DATES
                _buildDates(booking),

                SizedBox(height: 14.h),

                // NIGHTS
                if (booking.nights > 0)
                  Row(
                    children: [
                      Icon(
                        Icons.nights_stay_outlined,
                        size: 17.r,
                        color: DS.textTertiary,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${booking.nights} ${booking.nights == 1 ? 'night'.tr() : 'nights'.tr()}',
                        style: GoogleFonts.inter(fontSize: 13.sp,
                          color: DS.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                SizedBox(height: 16.h),

                const Divider(height: 1, color: DS.borderLight),

                SizedBox(height: 16.h),

                // ACTION BUTTONS
                _buildActionButtons(context, booking, status),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HOTEL IMAGE
  // ============================================================

  Widget _buildHotelImage(BookingHistoryItem booking, String status) {
    final imageUrl = booking.image;

    return Padding(
      padding: EdgeInsets.all(8.0.w),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
            child: SizedBox(
              height: 175.h,
              width: double.infinity,
              child: imageUrl.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    _imagePlaceholder(loading: true),
                errorWidget: (context, url, error) {
                  return _imagePlaceholder();
                },
              )
                  : _imagePlaceholder(),
            ),
          ),

          Positioned(top: 12, left: 12, child: _buildStatusBadge(status)),
        ],
      ),
    );
  }

  Widget _imagePlaceholder({bool loading = false}) {
    return Container(
      color: DS.background,
      child: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Icon(Icons.hotel, size: 50.r, color: DS.textTertiary),
      ),
    );
  }

  // ============================================================
  // STATUS
  // ============================================================

  Widget _buildStatusBadge(String status) {
    Color background;
    Color foreground;
    IconData icon;
    String text;

    switch (status.toUpperCase()) {
      case 'CONFIRMED':
        background = DS.successLight;
        foreground = DS.success;
        icon = Icons.check_circle_outline;
        text = 'completed'.tr();
        break;

      case 'PENDING':
        background = const Color(0xfffff1d9);
        foreground = const Color(0xffc77b00);
        icon = Icons.access_time;
        text = 'pending'.tr();
        break;

      case 'FAILED':
        background = const Color(0xFFFFE4E8);
        foreground = DS.accentRed;
        icon = Icons.error_outline;
        text = 'failed'.tr();
        break;

      default:
        background = DS.background;
        foreground = DS.textSecondary;
        icon = Icons.info_outline;
        text = status;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(DS.radiusPill.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15.r, color: foreground),
          SizedBox(width: 4.w),
          Text(
            text,
            style: GoogleFonts.inter(fontSize: 11.sp, fontWeight: FontWeight.w700, color: foreground,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // AMENITIES
  // ============================================================

  Widget _buildAmenities(BookingHistoryItem booking) {
    if (booking.highlights.isEmpty) {
      return const SizedBox.shrink();
    }

    final highlights = booking.highlights.take(4).toList();

    return Wrap(
      spacing: 7,
      runSpacing: 7,
      children: highlights.map((highlight) {
        return _amenityChip(highlight);
      }).toList(),
    );
  }

  Widget _amenityChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F1F5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TranslatedText(
        text: text,
        style: GoogleFonts.inter(fontSize: 11.sp, fontWeight: FontWeight.w500, color: DS.textSecondary,
        ),
      ),
    );
  }

  // ============================================================
  // DESCRIPTION  (NEW)
  // ============================================================

  Widget _buildDescription(BookingHistoryItem booking) {
    if (booking.description.isEmpty) {
      return const SizedBox.shrink();
    }

    return TranslatedText(
      text: booking.description,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.inter(fontSize: 13.sp,
        height: 1.4,
        color: DS.textSecondary,
      ),
    );
  }

  // ============================================================
  // ADDRESS
  // ============================================================

  Widget _buildAddress(BookingHistoryItem booking) {
    if (booking.address.isEmpty) {
      return const SizedBox.shrink();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.place_outlined, size: 17.r, color: DS.textTertiary),
        SizedBox(width: 6.w),
        Expanded(
          child: TranslatedText(
            text: booking.address,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(fontSize: 13.sp,
              height: 1.4,
              color: DS.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // DATES
  // ============================================================

  Widget _buildDates(BookingHistoryItem booking) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 75.w,
              child: Text(
                'check_in'.tr(),
                style: GoogleFonts.inter(fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Text(
                _formatDate(booking.checkIn),
                style: GoogleFonts.inter(fontSize: 12.sp,
                  color: DS.textSecondary,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 10.h),

        Row(
          children: [
            SizedBox(
              width: 75.w,
              child: Text(
                'check_out'.tr(),
                style: GoogleFonts.inter(fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Text(
                _formatDate(booking.checkOut),
                style: GoogleFonts.inter(fontSize: 13.sp,
                  color: DS.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  String _formatDate(String value) {
    if (value.isEmpty) return 'tba'.tr();

    final date = DateTime.tryParse(value);
    if (date == null) return value;

    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }

  // ============================================================
  // ACTION BUTTONS
  // ============================================================

  Widget _buildActionButtons(
      BuildContext context,
      BookingHistoryItem booking,
      String status,
      ) {
    if (status == 'CONFIRMED') {
      return Column(
        children: [
          _primaryButton(
            text: 'booking_confirmed'.tr(),
            icon: Icons.check_circle_outline,
            backgroundColor: DS.success,
            onTap: () {
              _viewDetails(booking);
            },
          ),

          SizedBox(height: 10.h),

          _outlineButton(
            text: 'cancel'.tr(),
            onTap: () {
              _cancelBooking(context, booking);
            },
          ),
        ],
      );
    }

    if (status == 'PENDING') {
      return Column(
        children: [
          _buildPaymentSummary(booking),
          SizedBox(height: 10.h),
          _primaryButton(
            text: 'pay_now'.tr(),
            icon: Icons.payment,
            backgroundColor: DS.primaryBlue,
            onTap: () => _payNow(booking),
          ),
        ],
      );
    }

    if (status == 'FAILED') {
      return Column(
        children: [
          _buildPaymentSummary(booking),
          SizedBox(height: 10.h),
          _primaryButton(
            text: 'retry_payment'.tr(),
            icon: Icons.refresh,
            backgroundColor: DS.primaryBlue,
            onTap: () => _payNow(booking),
          ),
        ],
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildPaymentSummary(BookingHistoryItem booking) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'total_amount'.tr(),
          style: GoogleFonts.inter(fontSize: 13.sp,
            color: DS.textSecondary,
          ),
        ),
        Text(
          booking.totalAmount > 0
              ? '₹${booking.totalAmount.toStringAsFixed(0)}'
              : 'tba'.tr(),
          style: GoogleFonts.inter(fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BUTTONS
  // ============================================================

  Widget _primaryButton({
    required String text,
    required IconData icon,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DS.radiusButton.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18.r),
            SizedBox(width: 7.w),
            Text(
              text,
              style: GoogleFonts.inter(fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _outlineButton({required String text, required VoidCallback onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: DS.textPrimary,
          side: const BorderSide(color: DS.borderMedium, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DS.radiusButton.r),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(fontSize: 13.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // ACTIONS
  // ============================================================

  Widget _buildBookingDetails(BookingHistoryItem booking) {
    final paymentMethod = _displayPaymentMethod(booking.paymentMethod);
    final status = _displayStatus(booking.status);
    final profileUser = context.read<AuthCubit>().state.user;
    final email = profileUser?.email.isNotEmpty == true
        ? profileUser!.email
        : booking.guestEmail;
    final mobile = profileUser?.phone?.isNotEmpty == true
        ? profileUser!.phone!
        : profileUser?.userName.isNotEmpty == true
        ? profileUser!.userName
        : booking.guestPhone;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: DS.background,
        borderRadius: BorderRadius.circular(DS.radiusInput.r),
        border: Border.all(color: DS.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'booking_details'.tr(),
            style: GoogleFonts.inter(fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 14.h),
          _detailRow('booking_id'.tr(), booking.bookingId),
          _detailRow(
            'status'.tr(),
            '$status${paymentMethod == 'tba'.tr() ? '' : ' ($paymentMethod)'}',
          ),
          _detailRow(
            'room_type'.tr(),
            booking.roomType.isEmpty ? booking.hotelName : booking.roomType,
          ),
          _detailRow(
            'lead_guest'.tr(),
            booking.guestName.isEmpty ? 'tba'.tr() : booking.guestName,
          ),
          _detailRow('email'.tr(), email),
          _detailRow('mobile'.tr(), mobile),
          _detailRow('payment_method'.tr(), paymentMethod),
          _detailRow(
            'total_amount'.tr(),
            booking.totalAmount > 0
                ? '₹${booking.totalAmount.toStringAsFixed(0)}'
                : 'tba'.tr(),
          ),
          _detailRow('booked_on'.tr(), _formatBookedOn(booking.createdAt)),
        ],
      ),
    );
  }

  String _displayStatus(String value) {
    if (value.isEmpty) return 'tba'.tr();

    final normalized = value.toUpperCase();
    return normalized[0] + normalized.substring(1).toLowerCase();
  }

  String _displayPaymentMethod(String value) {
    if (value.isEmpty) return 'tba'.tr();

    switch (value.toLowerCase()) {
      case 'cod':
      case 'cash':
      case 'cash_on_delivery':
      case 'pay_at_counter':
        return 'pay_at_counter'.tr();
      default:
        return value;
    }
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108.w,
            child: Text(
              label,
              style: GoogleFonts.inter(fontSize: 12.sp,
                color: DS.textTertiary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'tba'.tr() : value,
              style: GoogleFonts.inter(fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatBookedOn(String value) {
    if (value.isEmpty) return 'tba'.tr();

    final date = DateTime.tryParse(value)?.toLocal();
    if (date == null) return value;

    final hour = date.hour == 0
        ? 12
        : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final second = date.second.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'pm' : 'am';
    return '${date.day}/${date.month}/${date.year}, '
        '$hour:$minute:$second $period';
  }

  void _viewDetails(BookingHistoryItem booking) {
    setState(() {
      _expandedBookingId = _expandedBookingId == booking.bookingId
          ? null
          : booking.bookingId;
    });
  }

  void _payNow(BookingHistoryItem booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentCheckoutPage(
          totalAmount: booking.totalAmount,
          stayName: '',
          guestEmail: '',
          guestPhone: '',
        ),
      ),
    );
  }

  void _cancelBooking(BuildContext context, BookingHistoryItem booking) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('cancel_booking_question'.tr()),
          content: Text('cancel_booking_confirmation'.tr()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('no'.tr()),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                context.read<BookingHistoryCubit>().cancelBooking(
                  booking.bookingId,
                );
              },
              child: Text('yes_cancel'.tr()),
            ),
          ],
        );
      },
    );
  }
//  SizedBox(height: 40.h + MediaQuery.paddingOf(context).bottom),
}