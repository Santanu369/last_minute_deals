import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lmd_app/app/shell/navbar_cubit.dart';
import 'package:lmd_app/app/shell/navbar_widget.dart';
// ---- Colors used across the design ----
const Color _kRed = DS.accentRed;
const Color _kTextDark = DS.textPrimary;
const Color _kTextGrey = DS.textSecondary;
const Color _kGreen = DS.success;

class BookingSuccessScreen extends StatelessWidget {
  final String? bookingId;
  final double? amountPaid;
  final String? paymentId;

  const BookingSuccessScreen({
    super.key,
    this.bookingId,
    this.amountPaid,
    this.paymentId,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat('#,##,##0', 'en_IN');

    return Scaffold(
      backgroundColor: DS.background,
      bottomNavigationBar: const NavbarWidget(), // <-- navbar yahan add kiya
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: DS.maxWidth),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 16.h),

                          // ---- Celebratory checkmark badge ----
                          _celebrationBadge(),

                          SizedBox(height: 22.h),

                          Text(
                            'Payment Successful!',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(fontSize: 20.sp, fontWeight: FontWeight.w700, color: _kTextDark,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Your booking is confirmed.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(fontSize: 14.sp,
                              color: _kTextGrey,
                            ),
                          ),

                          SizedBox(height: 26.h),

                          // ---- Amount paid / Payment ID ----
                          Row(
                            children: [
                              Expanded(
                                child: _infoBlock(
                                  label: 'Amount Paid',
                                  value: amountPaid != null
                                      ? '₹${formatter.format(amountPaid)}'
                                      : '—',
                                  alignEnd: false,
                                ),
                              ),
                              Expanded(
                                child: _infoBlock(
                                  label: 'Payment ID',
                                  value: paymentId ?? bookingId ?? '—',
                                  alignEnd: true,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 26.h),

                          // ---- What's Next ----
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "What's Next?",
                              style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600, color: _kTextDark,
                              ),
                            ),
                          ),
                          SizedBox(height: 14.h),

                          _nextStep(
                            icon: Icons.mail_outline_rounded,
                            text:
                            'We have sent the booking details to your email and SMS.',
                          ),
                          _nextStep(
                            icon: Icons.lock_outline_rounded,
                            text:
                            'You can view your booking details in My Bookings section.',
                          ),
                          _nextStep(
                            icon: Icons.apartment_rounded,
                            text:
                            'Hotel will reach out to you for any special requests.',
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ---- Buttons ----
                  Container(
                    width: double.infinity,
                    height: 56.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(DS.radiusButton.r),
                      boxShadow: DS.shadowButton,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        // 1. Update Navbar state to show Bookings tab (index 1)
                        try {
                          context.read<NavbarCubit>().selectTab(1);
                          // BookingsHistoryPage.refresh();
                        } catch (_) {}

                        // 2. Go back to the root WidgetTree instead of pushing a new page
                        // This preserves the app's core structure
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DS.primaryBlue,
                        shadowColor: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(DS.radiusButton.r),
                        ),
                      ),
                      child: Text(
                        'View Booking',
                        style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text(
                      'Back to Home',
                      style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w600, color: DS.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ), ), ), ), ), ); } Widget _celebrationBadge() {
    return SizedBox(
      width: 140.w,
      height: 140.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // scattered confetti dots
          Positioned(top: 6, left: 18, child: _dot(DS.starYellow, 8)),
          Positioned(top: 2, right: 16, child: _dot(_kRed, 7)),
          Positioned(bottom: 10, left: 8, child: _dot(DS.primaryBlue, 6)),
          Positioned(bottom: 4, right: 10, child: _dot(_kGreen, 7)),
          Positioned(top: 30, right: 0, child: _dot(DS.starYellow, 5)),
          Positioned(bottom: 26, left: -2, child: _dot(_kRed, 5)),

          // outer soft ring
          Container(
            width: 108.w,
            height: 108.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: DS.successLight,
            ),
          ),
          // inner circle with check
          Container(
            width: 82.w,
            height: 82.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: _kGreen,
            ),
            child: Icon(Icons.check_rounded, color: Colors.white, size: 42.r),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _infoBlock({
    required String label,
    required String value,
    required bool alignEnd,
  }) {
    return Column(
      crossAxisAlignment:
      alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12.sp,
            color: _kTextGrey,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w700, color: _kTextDark,
          ),
        ),
      ],
    );
  }

  Widget _nextStep({required IconData icon, required String text}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.h,
            decoration: BoxDecoration(
              color: DS.background, borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 16.r, color: _kTextDark),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Text(
                text,
                style: GoogleFonts.inter(fontSize: 14.sp, fontWeight: FontWeight.w400, color: _kTextGrey, height: 1.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}