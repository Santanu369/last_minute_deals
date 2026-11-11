import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lmd_app/core/theme/app_colors.dart';
import 'package:lmd_app/core/theme/app_text.dart';

class HotelSearchCard extends StatefulWidget {
  const HotelSearchCard({
    super.key,
    required this.searchLink,
    required this.searchFocus,
    required this.searchController,
    required this.dateRangeLabel,
    required this.isEditGuestVisible,
    required this.isLoading,
    required this.onDateTap,
    required this.onGuestTap,
    required this.guestWidget,
    required this.onSearch,
    required this.isEdit,
    this.guestCountLabel = '2 Guests, 1 Room',
    this.onSearchChanged,
    this.onSuggestionTap,
    this.useAltStyle = false,
  });

  final LayerLink searchLink;
  final FocusNode searchFocus;
  final TextEditingController searchController;
  final String dateRangeLabel;
  final bool isEditGuestVisible;
  final bool isLoading;
  final bool isEdit;
  final bool useAltStyle;
  final VoidCallback onDateTap;
  final VoidCallback onGuestTap;
  final Widget guestWidget;
  final String guestCountLabel;
  final VoidCallback onSearch;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSuggestionTap;

  @override
  State<HotelSearchCard> createState() => _HotelSearchCardState();
}

class _HotelSearchCardState extends State<HotelSearchCard> {
  // ============================================================
  // DATE HELPERS
  // ============================================================

  String get _checkInDate {
    if (widget.dateRangeLabel == 'Select check-in and check-out') {
      return DateFormat('MMM d').format(DateTime.now());
    }

    final parts = widget.dateRangeLabel.split(' - ');
    if (parts.isEmpty) return 'Today';
    return parts.first;
  }

  String get _checkOutDate {
    if (widget.dateRangeLabel == 'Select check-in and check-out') {
      return DateFormat(
        'MMM d',
      ).format(DateTime.now().add(const Duration(days: 1)));
    }

    final parts = widget.dateRangeLabel.split(' - ');
    if (parts.length < 2) return 'Today';
    return parts.last;
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (widget.useAltStyle) {
      return _buildAltCard();
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.background, // Solid white card background[cite: 1]
        borderRadius: BorderRadius.circular(
          16,
        ), // Standard 16px radius for cards[cite: 1]
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ), // 1px E5E7EB border[cite: 1]
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(
              0,
              0,
              0,
              0.08,
            ), // Subtle 0 1px 3px rgba(0,0,0,0.08) shadow[cite: 1]
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDestination(),
          const Divider(height: 1, thickness: 1, color: AppColors.border),
          _buildDates(),
          const Divider(height: 1, thickness: 1, color: AppColors.border),
          _buildGuests(),
          if (widget.isEditGuestVisible) _buildGuestEditor(),
          _buildSearchButton(),
        ],
      ),
    );
  }

  Widget _buildAltCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 0),
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.12),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildAltDestination(),
          Divider(height: 18.h, color: AppColors.border),
          _buildAltRow(
            icon: Icons.calendar_today_outlined,
            label: 'CHECK-IN — CHECK-OUT',
            value: '${_checkInDate} — ${_checkOutDate} • 2 nights',
            onTap: widget.onDateTap,
          ),
          Divider(height: 18.h, color: AppColors.border),
          _buildAltRow(
            icon: Icons.person_outline,
            label: 'GUESTS',
            value: widget.guestCountLabel.replaceFirst(',', ' •'),
            onTap: widget.onGuestTap,
          ),
          if (widget.isEditGuestVisible) widget.guestWidget,
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            height: 46.h,
            child: ElevatedButton.icon(
              onPressed: widget.isLoading ? null : widget.onSearch,
              icon: Icon(Icons.search, size: 20.r),
              label: const Text('Search Stays'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11.r),
                ),
                textStyle: AppText.button,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAltDestination() {
    return CompositedTransformTarget(
      link: widget.searchLink,
      child: Row(
        children: [
          _buildAltIcon(Icons.location_on_outlined),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('DESTINATION', style: _altLabelStyle),
                TextField(
                  controller: widget.searchController,
                  focusNode: widget.searchFocus,
                  onChanged: widget.onSearchChanged,
                  onSubmitted: (_) => widget.onSearch(),
                  style: AppText.body.copyWith(fontWeight: FontWeight.w700),
                  decoration: const InputDecoration(
                    hintText: 'Where are you heading?',
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
        ],
      ),
    );
  }

  Widget _buildAltRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          _buildAltIcon(icon),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: _altLabelStyle),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.body.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAltIcon(IconData icon) {
    return Container(
      width: 34.w,
      height: 34.h,
      decoration: const BoxDecoration(
        color: AppColors.softRose,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 18.r, color: AppColors.primary),
    );
  }

  TextStyle get _altLabelStyle => AppText.small.copyWith(
    fontSize: 11.sp,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
  );

  // ============================================================
  // DESTINATION INPUT (52px height spec)
  // ============================================================

  Widget _buildDestination() {
    return CompositedTransformTarget(
      link: widget.searchLink,
      child: Container(
        height: 52.h, // Specified input height[cite: 1]
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ), // 16px inner padding[cite: 1]
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 20.r, // Standardized 20px icon[cite: 1]
              color: AppColors
                  .textSecondary, // Secondary 6B7280 icon color[cite: 1]
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 2),
                  Text(
                    'DESTINATION',
                    style: AppText.small.copyWith(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: widget.searchController,
                            focusNode: widget.searchFocus,
                            textInputAction: TextInputAction.search,
                            onChanged: widget.onSearchChanged,
                            onSubmitted: (_) => widget.onSearch(),
                            style: AppText.input.copyWith(
                              color: AppColors.black,
                              fontWeight: FontWeight
                                  .w600, // Black text for input[cite: 1]
                            ),
                            decoration: InputDecoration(
                              hintText: 'Where are you heading?',
                              hintStyle: AppText.inputHint,
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        ValueListenableBuilder<TextEditingValue>(
                          valueListenable: widget.searchController,
                          builder: (context, value, child) {
                            if (value.text.isEmpty)
                              return const SizedBox.shrink();
                            return GestureDetector(
                              onTap: () {
                                widget.searchController.clear();
                                widget.onSearchChanged?.call('');
                                widget.onSuggestionTap?.call();
                              },
                              child: Padding(
                                padding: EdgeInsets.only(left: 8.w),
                                child: Icon(
                                  Icons.close,
                                  size: 18.r,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CHECK-IN / CHECK-OUT
  // ============================================================

  Widget _buildDates() {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: _DateField(
              title: 'CHECK-IN',
              value: _checkInDate,
              onTap: widget.onDateTap,
            ),
          ),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            color: AppColors.border,
          ),
          Expanded(
            child: _DateField(
              title: 'CHECK-OUT',
              value: _checkOutDate,
              onTap: widget.onDateTap,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // GUESTS
  // ============================================================

  Widget _buildGuests() {
    return InkWell(
      onTap: widget.onGuestTap,
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(8.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Icon(
              Icons.person_outline,
              size: 20.r, // Standard 20px icon[cite: 1]
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GUESTS & ROOMS',
                    style: AppText.small.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.guestCountLabel,
                    style: AppText.body.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20.r,
              color: AppColors.primary, // Primary Red accent arrow[cite: 1]
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // GUEST EDITOR
  // ============================================================

  Widget _buildGuestEditor() {
    return Column(
      children: [
        const Divider(height: 1, thickness: 1, color: AppColors.border),
        Padding(padding: EdgeInsets.all(16.w), child: widget.guestWidget),
      ],
    );
  }

  // ============================================================
  // PRIMARY SEARCH BUTTON (48px height, 8px radius spec)
  // ============================================================

  Widget _buildSearchButton() {
    return Padding(
      padding: EdgeInsets.all(16.w), // Outer 16px spacing[cite: 1]
      child: SizedBox(
        width: double.infinity,
        height: 48.h, // Rigid 48px height spec[cite: 1]
        child: ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onSearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary, // Fixed E53935 Red[cite: 1]
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
            disabledForegroundColor: Colors.white,
            elevation: 0,
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                8,
              ), // Fixed 8px Radius[cite: 1]
            ),
          ),
          child: widget.isLoading
              ? SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search, size: 20.r, color: Colors.white),
                    SizedBox(width: 8.w),
                    Text(
                      'Search Stays',
                      style: AppText.button.copyWith(
                        color: Colors.white,
                      ), // 14px 600 Inter[cite: 1]
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ==================================================================
// DATE FIELD COMPONENT
// ==================================================================

class _DateField extends StatelessWidget {
  const _DateField({
    required this.title,
    required this.value,
    required this.onTap,
  });

  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 20.r, // Standard 20px icon[cite: 1]
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.small.copyWith(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.body.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
