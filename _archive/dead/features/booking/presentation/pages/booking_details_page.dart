import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:lmd_app/core/theme/app_colors.dart';
import 'package:lmd_app/features/payment/data/models/booking_history_response.dart';

class BookingDetailsPage extends StatelessWidget {
  final BookingHistoryItem booking;

  const BookingDetailsPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: const Text(
          'Booking Details',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 28.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroImage(),
            SizedBox(height: 18.h),
            Text(
              booking.hotelName,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 7.h),
            _iconText(Icons.location_on_outlined, booking.location),
            if (booking.rating > 0) ...[
              SizedBox(height: 9.h),
              Row(
                children: [
                  Icon(Icons.star, color: Color(0xffffb400), size: 18.r),
                  SizedBox(width: 5.w),
                  Text(
                    '${booking.rating.toStringAsFixed(1)} rating',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: 22.h),
            _section(
              title: 'Your stay',
              child: Row(
                children: [
                  Expanded(
                    child: _dateTile(
                      icon: Icons.login_rounded,
                      label: 'Check-in',
                      value: _formatDate(booking.checkIn),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _dateTile(
                      icon: Icons.logout_rounded,
                      label: 'Check-out',
                      value: _formatDate(booking.checkOut),
                    ),
                  ),
                ],
              ),
            ),
            if (booking.highlights.isNotEmpty) ...[
              SizedBox(height: 14.h),
              _section(
                title: 'What this stay offers',
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: booking.highlights.map(_amenity).toList(),
                ),
              ),
            ],
            if (booking.description.isNotEmpty ||
                booking.address.isNotEmpty) ...[
              SizedBox(height: 14.h),
              _section(
                title: 'About this stay',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (booking.description.isNotEmpty)
                      Text(
                        booking.description,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                    if (booking.address.isNotEmpty) ...[
                      if (booking.description.isNotEmpty)
                        SizedBox(height: 14.h),
                      _iconText(Icons.place_outlined, booking.address),
                    ],
                  ],
                ),
              ),
            ],
            SizedBox(height: 14.h),
            _section(
              title: 'Booking information',
              child: Column(
                children: [
                  _infoRow('Status', _displayStatus(booking.status)),
                  Divider(height: 22.h),
                  _infoRow('Booking ID', booking.bookingId),
                  if (booking.nights > 0) ...[
                    Divider(height: 22.h),
                    _infoRow(
                      'Duration',
                      '${booking.nights} ${booking.nights == 1 ? 'night' : 'nights'}',
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18.r),
      child: AspectRatio(
        aspectRatio: 1.55,
        child: booking.image.isEmpty
            ? _imagePlaceholder()
            : CachedNetworkImage(
                imageUrl: booking.image,
                fit: BoxFit.cover,
                placeholder: (_, __) => _imagePlaceholder(loading: true),
                errorWidget: (_, __, ___) => _imagePlaceholder(),
              ),
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 14.h),
          child,
        ],
      ),
    );
  }

  Widget _dateTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.softRose,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 18.r),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.sp,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value.isEmpty ? 'TBA' : value,
            textAlign: TextAlign.end,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _iconText(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 17.r, color: AppColors.textSecondary),
        SizedBox(width: 5.w),
        Expanded(
          child: Text(
            value.isEmpty ? 'Location unavailable' : value,
            style: const TextStyle(
              fontFamily: 'Inter',
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _amenity(String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: AppColors.lightRed,
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: Text(
        value,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 12.sp,
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _imagePlaceholder({bool loading = false}) {
    return Container(
      color: const Color(0xffececec),
      child: Center(
        child: loading
            ? const CircularProgressIndicator()
            : Icon(Icons.hotel, size: 54.r, color: Colors.grey),
      ),
    );
  }

  String _displayStatus(String status) =>
      status.toUpperCase() == 'CONFIRMED' ? 'Confirmed' : status;

  String _formatDate(String value) {
    if (value.isEmpty) return 'TBA';
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    const months = [
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
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
