import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



/// Design tokens taken from the supplied Design System Specification.
///
/// Backend/business data is intentionally NOT defined here. All booking/hotel
/// values must continue to be supplied by the caller from the backend/domain
/// layer.
class _BookingDesign {
  static const primaryRed = Color(0xFFE53935);
  static const lightRed = Color(0xFFFFEDEE);
  static const blackPrimary = Color(0xFF111111);
  static const textSecondary = Color(0xFF6B7280);
  static const border = Color(0xFFE5E7EB);
  static const background = Color(0xFFFAFAFA);
  static const cardBackground = Color(0xFFFFFFFF);
  static const white = Color(0xFFFFFFFF);
  static const sectionCardRadius = 16.0;

  // Semantic status colors are not defined in the supplied specification.
  // They are kept separate from the design-system tokens above.
  static const success = Color(0xFF19B504);
  static const successBackground = Color(0xFFEAF8E8);
  static const pending = Color(0xFFF59E0B);
  static const pendingBackground = Color(0xFFFFF5DC);
  static const failedBackground = lightRed;

  static const fontFamily = 'Inter';

  // H1 Hero — 30px / 700
  // static const h1Size = 30.0;
  // static const h1Weight = FontWeight.w700;

  // H2 Section Title — 20px / 700
  static const h2Size = 20.0;
  static const h2Weight = FontWeight.w700;

  // H3 Card Title — 16px / 600
  static const h3Size = 16.0;
  static const h3Weight = FontWeight.w600;

  // Body Regular — 14px / 400
  static const bodySize = 14.0;
  static const bodyWeight = FontWeight.w400;

  // Small Text — 12px / 500
  // static const smallSize = 12.0;
  // static const smallWeight = FontWeight.w500;

  // Price Text — 16px / 700
  // static const priceSize = 16.0;
  // static const priceWeight = FontWeight.w700;

  // Button Text — 14px / 600
  static const buttonSize = 14.0;
  static const buttonWeight = FontWeight.w600;

  // Primary Button — 48px height, 8px radius, full width.
  static const primaryButtonHeight = 48.0;
  static const primaryButtonRadius = 8.0;

  // Secondary Button — 40px height, 2px border, 8px radius.
  static const secondaryButtonHeight = 40.0;
  // static const secondaryButtonRadius = 8.0;
  static const secondaryButtonBorderWidth = 2.0;

  // Input Field specification (kept here for consistency if this page gains
  // an input later): 52px height, 8px radius, 1px border, 16px padding.
  // static const inputHeight = 52.0;
  // static const inputRadius = 8.0;
  // static const inputBorderWidth = 1.0;
  // static const inputPadding = 16.0;
}

class BookingVerifyPage extends StatelessWidget {
  final String bookingId;
  final String hotelId;
  final String hotelName;
  final String checkIn;
  final String checkOut;
  final String status;
  final String createdAt;
  final String image;
  final String city;
  final String countryCode;
  final String address;
  final String description;

  // Optional callbacks
  final VoidCallback? goToHome;
  final VoidCallback? onPayNow;
  final VoidCallback? onRetryPayment;
  final VoidCallback? onCancel;

  const BookingVerifyPage({
    super.key,
    required this.bookingId,
    required this.hotelId,
    required this.hotelName,
    required this.checkIn,
    required this.checkOut,
    required this.status,
    required this.createdAt,
    required this.image,
    required this.city,
    required this.countryCode,
    required this.address,
    required this.description,
    this.onPayNow,
    this.onRetryPayment,
    this.onCancel,
    this.goToHome,
  });

  // ============================================================
  // NORMALIZED STATUS
  // ============================================================

  String get normalizedStatus {
    return status.trim().toUpperCase();
  }

  // ============================================================
  // STATUS COLOR
  // ============================================================

  Color get statusColor {
    switch (normalizedStatus) {
      case 'COMPLETED':
      case 'CONFIRMED':
        return _BookingDesign.success;

      case 'PENDING':
        return _BookingDesign.pending;

      case 'FAILED':
        return _BookingDesign.primaryRed;

      default:
        return _BookingDesign.textSecondary;
    }
  }

  // ============================================================
  // STATUS BACKGROUND
  // ============================================================

  Color get statusBackground {
    switch (normalizedStatus) {
      case 'COMPLETED':
      case 'CONFIRMED':
        return _BookingDesign.successBackground;

      case 'PENDING':
        return _BookingDesign.pendingBackground;

      case 'FAILED':
        return _BookingDesign.failedBackground;

      default:
        return _BookingDesign.border;
    }
  }

  // ============================================================
  // STATUS ICON
  // ============================================================

  IconData get statusIcon {
    switch (normalizedStatus) {
      case 'COMPLETED':
      case 'CONFIRMED':
        return Icons.check_circle;

      case 'PENDING':
        return Icons.access_time_rounded;

      case 'FAILED':
        return Icons.error_outline;

      default:
        return Icons.help_outline;
    }
  }

  // ============================================================
  // STATUS TITLE
  // ============================================================

  String get statusTitle {
    switch (normalizedStatus) {
      case 'COMPLETED':
      case 'CONFIRMED':
        return 'Booking Completed';

      case 'PENDING':
        return 'Payment Pending';

      case 'FAILED':
        return 'Payment Failed';

      default:
        return 'Booking Status';
    }
  }

  // ============================================================
  // STATUS MESSAGE
  // ============================================================

  String get statusMessage {
    switch (normalizedStatus) {
      case 'COMPLETED':
      case 'CONFIRMED':
        return 'Your hotel booking has been successfully confirmed.';

      case 'PENDING':
        return 'Your booking is pending payment. Complete the payment to confirm your reservation.';

      case 'FAILED':
        return 'The payment for this booking was unsuccessful. Please try the payment again.';

      default:
        return 'Please verify your booking status.';
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _BookingDesign.background,

      appBar: AppBar(
        title: const Text(
          'Booking Details',
          style: TextStyle(
            fontFamily: _BookingDesign.fontFamily,
            fontSize: _BookingDesign.h2Size,
            fontWeight: _BookingDesign.h2Weight,
            color: _BookingDesign.blackPrimary,
          ),
        ),

        centerTitle: false,

        backgroundColor: _BookingDesign.cardBackground,

        foregroundColor: _BookingDesign.blackPrimary,

        elevation: 0,

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),

          child: Container(height: 1, color: _BookingDesign.border),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              _buildStatusHeader(),

              SizedBox(height: 24.h),

              _buildHotelCard(),

              SizedBox(height: 20.h),

              _buildBookingDetails(),

              SizedBox(height: 20.h),

              _buildStayDetails(),

              SizedBox(height: 20.h),

              _buildCreatedDetails(),

              SizedBox(height: 30.h),

              _buildActionButton(),

              SizedBox(height: 15.h),

              if (normalizedStatus == 'PENDING' || normalizedStatus == 'FAILED')
                _buildCancelButton(),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // STATUS HEADER
  // ============================================================

  Widget _buildStatusHeader() {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(20.w),

      decoration: BoxDecoration(
        color: statusBackground,

        borderRadius: BorderRadius.circular(_BookingDesign.sectionCardRadius),

        border: Border.all(color: statusColor.withValues(alpha: 0.25)),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Container(
            width: 52.w,
            height: 52.h,

            decoration: BoxDecoration(
              color: statusColor,

              shape: BoxShape.circle,
            ),

            child: Icon(statusIcon, color: _BookingDesign.white, size: 28.r),
          ),

          SizedBox(width: 16.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  statusTitle,

                  style: TextStyle(
                    fontFamily: _BookingDesign.fontFamily,
                    color: statusColor,
                    fontSize: _BookingDesign.h2Size,
                    fontWeight: _BookingDesign.h2Weight,
                  ),
                ),

                SizedBox(height: 6.h),

                Text(
                  statusMessage,

                  style: TextStyle(
                    color: Color(0xff5F6368),

                    fontSize: 13.sp,

                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // HOTEL CARD
  // ============================================================

  Widget _buildHotelCard() {
    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: _BookingDesign.white,

        borderRadius: BorderRadius.circular(_BookingDesign.sectionCardRadius),

        border: Border.all(color: _BookingDesign.border),

      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          _buildHotelImage(),

          Padding(
            padding: EdgeInsets.all(16.w),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  hotelName,

                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontFamily: _BookingDesign.fontFamily,
                    fontSize: _BookingDesign.h3Size,
                    fontWeight: _BookingDesign.h3Weight,
                    color: _BookingDesign.blackPrimary,
                  ),
                ),

                SizedBox(height: 8.h),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Icon(
                      Icons.location_on_outlined,

                      size: 18.r,

                      color: Color(0xff70757A),
                    ),

                    SizedBox(width: 5.w),

                    Expanded(
                      child: Text(
                        address.isNotEmpty ? address : city,

                        style: TextStyle(
                          color: Color(0xff70757A),

                          fontSize: 13.sp,

                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),

                if (description.isNotEmpty) ...[
                  SizedBox(height: 15.h),

                  Text(
                    description,

                    maxLines: 4,

                    overflow: TextOverflow.ellipsis,

                    style: TextStyle(
                      color: Color(0xff656D78),

                      fontSize: 13.sp,

                      height: 1.5,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHotelImage() {
    if (image.isEmpty) {
      return _imagePlaceholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),

      child: Image.network(
        image,

        width: double.infinity,

        height: 230.h,

        fit: BoxFit.cover,

        errorBuilder: (_, __, ___) {
          return _imagePlaceholder();
        },
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,

      height: 230.h,

      decoration: BoxDecoration(
        color: Colors.grey.shade300,

        borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
      ),

      child: Center(
        child: Icon(Icons.hotel, size: 60.r, color: _BookingDesign.white),
      ),
    );
  }

  // ============================================================
  // BOOKING DETAILS (dynamic 3-column grid)
  // ============================================================

  Widget _buildBookingDetails() {
    return _sectionCard(
      title: 'Booking Details',

      child: Column(
        children: [
          _detailRow('Booking ID', bookingId),

          Divider(height: 22.h),

          _detailRow('Hotel ID', hotelId),

          Divider(height: 22.h),

          _detailRow('Status', normalizedStatus, valueColor: statusColor),

          Divider(height: 22.h),

          _detailRow('City', city),

          Divider(height: 22.h),

          _detailRow('Country', countryCode),
        ],
      ),
    );
  }

  // ============================================================
  // GRID ITEM (label + value used inside Booking Details card)
  // ============================================================

  // ============================================================
  // GRID ITEM (label + value used inside Booking Details card)
  // ============================================================

  // ============================================================
  // STAY DETAILS
  // ============================================================

  // ============================================================
  // STAY DETAILS
  // ============================================================

  Widget _buildStayDetails() {
    return _sectionCard(
      title: 'Stay Details',

      child: Row(
        children: [
          Expanded(
            child: _dateBox(
              icon: Icons.login_rounded,
              title: 'Check-in',
              value: checkIn,
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: _dateBox(
              icon: Icons.logout_rounded,
              title: 'Check-out',
              value: checkOut,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateBox({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),

      decoration: BoxDecoration(
        color: _BookingDesign.background,

        borderRadius: BorderRadius.circular(_BookingDesign.sectionCardRadius),

        border: Border.all(color: _BookingDesign.border),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              Icon(icon, size: 18.r, color: _BookingDesign.primaryRed),

              SizedBox(width: 6.w),

              Text(
                title,

                style: TextStyle(
                  color: Color(0xff6B7280),

                  fontSize: 12.sp,

                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          Text(
            value.isEmpty ? 'TBA' : value,

            style: const TextStyle(
              fontFamily: _BookingDesign.fontFamily,
              fontSize: _BookingDesign.bodySize,
              fontWeight: _BookingDesign.bodyWeight,
              color: _BookingDesign.blackPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // CREATED DETAILS
  // ============================================================

  Widget _buildCreatedDetails() {
    return _sectionCard(
      title: 'Booking Information',

      child: _detailRow('Booked On', _formatDateTime(createdAt)),
    );
  }

  // ============================================================
  // SECTION CARD
  // ============================================================

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.all(16.w),

      decoration: BoxDecoration(
        color: _BookingDesign.white,

        borderRadius: BorderRadius.circular(_BookingDesign.sectionCardRadius),

        border: Border.all(color: _BookingDesign.border),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            title,

            style: const TextStyle(
              fontFamily: _BookingDesign.fontFamily,
              color: _BookingDesign.blackPrimary,
              fontSize: _BookingDesign.h2Size,
              fontWeight: _BookingDesign.h2Weight,
            ),
          ),

          SizedBox(height: 16.h),
          child,
        ],
      ),
    );
  }

  // ============================================================
  // DETAIL ROW
  // ============================================================

  Widget _detailRow(String title, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Expanded(
          child: Text(
            title,

            style: TextStyle(color: Color(0xff70757A), fontSize: 13.sp),
          ),
        ),

        SizedBox(width: 20.w),

        Expanded(
          flex: 2,

          child: Text(
            value.isEmpty ? '-' : value,

            textAlign: TextAlign.right,

            style: TextStyle(
              color: valueColor ?? const Color(0xff202124),

              fontSize: 13.sp,

              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MAIN ACTION BUTTON
  // ============================================================

  Widget _buildActionButton() {
    switch (normalizedStatus) {
    // --------------------------------------------------------
    // COMPLETED
    // --------------------------------------------------------

      case 'COMPLETED':
      case 'CONFIRMED':
        return SizedBox(
          width: double.infinity,

          height: _BookingDesign.primaryButtonHeight,

          child: ElevatedButton.icon(
            onPressed: goToHome,

            icon: const Icon(Icons.check_circle_outline),

            label: const Text(
              'Booking Completed',
              style: TextStyle(
                fontFamily: _BookingDesign.fontFamily,
                fontSize: _BookingDesign.buttonSize,
                fontWeight: _BookingDesign.buttonWeight,
              ),
            ),

            style: FilledButton.styleFrom(
              backgroundColor: _BookingDesign.primaryRed,

              disabledBackgroundColor: _BookingDesign.primaryRed,

              foregroundColor: _BookingDesign.white,

              disabledForegroundColor: _BookingDesign.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_BookingDesign.primaryButtonRadius),
              ),
            ),
          ),
        );

    // --------------------------------------------------------
    // PENDING
    // --------------------------------------------------------

      case 'PENDING':
        return SizedBox(
          width: double.infinity,

          height: _BookingDesign.primaryButtonHeight,

          child: ElevatedButton.icon(
            onPressed: onPayNow,

            icon: const Icon(Icons.payment_rounded),

            label: const Text(
              'Pay Now',
              style: TextStyle(
                fontFamily: _BookingDesign.fontFamily,
                fontSize: _BookingDesign.buttonSize,
                fontWeight: _BookingDesign.buttonWeight,
              ),
            ),

            style: FilledButton.styleFrom(
              backgroundColor: _BookingDesign.primaryRed,

              // foregroundColor: _BookingDesign.white,
              textStyle: const TextStyle(
                fontFamily: _BookingDesign.fontFamily,
                fontSize: _BookingDesign.buttonSize,
                fontWeight: _BookingDesign.buttonWeight,
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_BookingDesign.primaryButtonRadius),
              ),
            ),
          ),
        );

    // --------------------------------------------------------
    // FAILED
    // --------------------------------------------------------

      case 'FAILED':
        return SizedBox(
          width: double.infinity,

          height: _BookingDesign.primaryButtonHeight,

          child: ElevatedButton.icon(
            onPressed: onRetryPayment,

            icon: const Icon(Icons.refresh_rounded),

            label: const Text(
              'Retry Payment',
              style: TextStyle(
                fontFamily: _BookingDesign.fontFamily,
                fontSize: _BookingDesign.buttonSize,
                fontWeight: _BookingDesign.buttonWeight,
              ),
            ),

            style: FilledButton.styleFrom(
              backgroundColor: _BookingDesign.primaryRed,
              // foregroundColor: _BookingDesign.white,

              textStyle: const TextStyle(
                fontFamily: _BookingDesign.fontFamily,
                fontSize: _BookingDesign.buttonSize,
                fontWeight: _BookingDesign.buttonWeight,
              ),

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_BookingDesign.primaryButtonRadius),
              ),
            ),
          ),
        );

      default:
        return SizedBox(
          width: double.infinity,

          height: _BookingDesign.primaryButtonHeight,

          child: ElevatedButton(
            onPressed: null,

            child: const Text(
              'Status Unknown',
              style: TextStyle(
                fontFamily: _BookingDesign.fontFamily,
                fontSize: _BookingDesign.buttonSize,
                fontWeight: _BookingDesign.buttonWeight,
              ),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: _BookingDesign.primaryRed,
              foregroundColor: _BookingDesign.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_BookingDesign.primaryButtonRadius),
              ),
            ),
          ),
        );
    }
  }

  // ============================================================
  // CANCEL BUTTON
  // ============================================================

  Widget _buildCancelButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: OutlinedButton(

        onPressed: onCancel,

        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, _BookingDesign.secondaryButtonHeight),
          maximumSize: const Size(double.infinity, _BookingDesign.secondaryButtonHeight),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          foregroundColor: _BookingDesign.blackPrimary,

          side: const BorderSide(color: _BookingDesign.blackPrimary, width: _BookingDesign.secondaryButtonBorderWidth),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_BookingDesign.primaryButtonRadius),
          ),
        ),

        child: const Text(
          'Cancel Booking',
          style: TextStyle(
            fontFamily: _BookingDesign.fontFamily,
            fontSize: _BookingDesign.buttonSize,
            fontWeight: _BookingDesign.buttonWeight,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _formatDateTime(String value) {
    if (value.isEmpty) {
      return '-';
    }

    final date = DateTime.tryParse(value);

    if (date == null) {
      return value;
    }

    final local = date.toLocal();

    final day = local.day.toString().padLeft(2, '0');

    final month = local.month.toString().padLeft(2, '0');

    final year = local.year.toString();

    final hour = local.hour.toString().padLeft(2, '0');

    final minute = local.minute.toString().padLeft(2, '0');

    return '$day/$month/$year, $hour:$minute';
  }
}