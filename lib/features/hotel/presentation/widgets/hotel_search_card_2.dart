import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';
import 'package:lmd_app/features/category/presentation/widgets/category_selector.dart';
import 'package:lmd_app/features/language/translated_text_wish.dart';

enum HotelSortOption { recommended, priceLowToHigh, priceHighToLow }

class HotelSearchCard2 extends StatefulWidget {
  const HotelSearchCard2({
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
    this.checkInDateLabel,
    this.checkOutDateLabel,
    this.shortDateRangeLabel,
    this.guestCountLabel = '2 Guests, 1 Room',
    this.guestOnlyLabel = '2 Guests',
    this.onSearchChanged,
    this.onSuggestionTap,
    this.useAltStyle = false,

    // CATEGORY
    this.selectedCategory = 'Hotels',
    this.onCategoryChanged,
    this.resultCount = 0,

    // FILTER BUTTON
    this.filterButtonText = 'Filters',
    this.onFilterTap,

    // SORT
    this.selectedSort = HotelSortOption.recommended,
    this.onSortChanged,
  });

  final LayerLink searchLink;
  final FocusNode searchFocus;
  final TextEditingController searchController;

  final String dateRangeLabel;
  final String? checkInDateLabel;
  final String? checkOutDateLabel;
  final String? shortDateRangeLabel;

  final String guestCountLabel;
  final String guestOnlyLabel;

  final bool isEditGuestVisible;
  final bool isLoading;
  final bool isEdit;
  final bool useAltStyle;

  final VoidCallback onDateTap;
  final VoidCallback onGuestTap;
  final VoidCallback onSearch;

  final Widget guestWidget;

  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSuggestionTap;

  // CATEGORY
  final String selectedCategory;
  final ValueChanged<String>? onCategoryChanged;
  final int resultCount;

  // FILTER BUTTON
  final String filterButtonText;
  final VoidCallback? onFilterTap;

  // SORT
  final HotelSortOption selectedSort;
  final ValueChanged<HotelSortOption>? onSortChanged;

  @override
  State<HotelSearchCard2> createState() => _HotelSearchCard2State();
}

class _HotelSearchCard2State extends State<HotelSearchCard2> {
  String get _checkInText {
    if (widget.checkInDateLabel != null &&
        widget.checkInDateLabel!.isNotEmpty) {
      return widget.checkInDateLabel!;
    }
    // Fallback parser from dateRangeLabel if available
    final parts = widget.dateRangeLabel.split('-');
    if (parts.isNotEmpty) return parts.first.trim();
    return '29 Sep';
  }

  String get _checkOutText {
    if (widget.checkOutDateLabel != null &&
        widget.checkOutDateLabel!.isNotEmpty) {
      return widget.checkOutDateLabel!;
    }
    final parts = widget.dateRangeLabel.split('-');
    if (parts.length > 1) return parts[1].trim();
    return '30 Sep';
  }

  String get _shortDateRange {
    if (widget.shortDateRangeLabel != null &&
        widget.shortDateRangeLabel!.isNotEmpty) {
      return widget.shortDateRangeLabel!;
    }
    return '${_checkInText.replaceAll(' ', '')}-${_checkOutText.replaceAll(' ', '')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ==========================================================
        // 1. TOP DESTINATION SEARCH BAR (52dp height, 26dp pill radius)
        // ==========================================================
        CompositedTransformTarget(
          link: widget.searchLink,
          child: Container(
            height: 56, decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: DS.borderMedium, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: DS.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: widget.searchController,
                    focusNode: widget.searchFocus,
                    textInputAction: TextInputAction.search,
                    onChanged: widget.onSearchChanged,
                    onSubmitted: (_) => widget.onSearch(),
                    style: GoogleFonts.inter(
                      color: DS.textPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      hintText: 'where_are_you_heading'.tr(),
                      hintStyle: GoogleFonts.inter(
                        color: DS.textTertiary,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),

                // Clear Search Button
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: widget.searchController,
                  builder: (context, value, child) {
                    if (value.text.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return GestureDetector(
                      onTap: () {
                        widget.searchController.clear();
                        widget.onSearchChanged?.call('');
                        widget.onSuggestionTap?.call();
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: DS.textTertiary,
                        ),
                      ),
                    );
                  },
                ),

              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ==========================================================
        // 2. CHECK-IN / CHECK-OUT & GUESTS CARD (Radius 20dp, Border #E5E7EB)
        // ==========================================================
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DS.card,
            borderRadius: BorderRadius.circular(DS.radiusCard),
            border: Border.all(color: DS.borderLight, width: 1),
            boxShadow: DS.shadowCard,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Check-in / Check-out row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CHECK-IN
                  Expanded(
                    child: InkWell(
                      onTap: widget.onDateTap,
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'check_in'.tr(),
                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: DS.textTertiary, letterSpacing: 0.88),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                _checkInText,
                                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: DS.textPrimary),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.calendar_today_outlined,
                                size: 16,
                                color: DS.textSecondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Subtle vertical divider
                  Container(
                    width: 1,
                    height: 38,
                    color: DS.borderLight,
                  ),

                  const SizedBox(width: 16),

                  // CHECK-OUT
                  Expanded(
                    child: InkWell(
                      onTap: widget.onDateTap,
                      borderRadius: BorderRadius.circular(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'check_out'.tr(),
                            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: DS.textTertiary, letterSpacing: 0.88),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _checkOutText,
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: DS.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // 1dp Divider
              Container(
                height: 1,
                color: DS.borderLight,
                margin: const EdgeInsets.symmetric(vertical: 14),
              ),

              // GUESTS SECTION
              InkWell(
                onTap: widget.onGuestTap,
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'guests'.tr(),
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: DS.textTertiary, letterSpacing: 0.88),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TranslatedText(
                          text: widget.guestCountLabel,
                          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: DS.textPrimary),
                        ),
                        const Row(
                          children: [
                            Icon(
                              Icons.person_outline_rounded,
                              size: 18,
                              color: DS.textSecondary,
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: DS.textSecondary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // GUEST EDITOR OVERLAY (Inside or below)
              if (widget.isEditGuestVisible) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: DS.borderMedium,
                      width: 1,
                    ),
                  ),
                  child: widget.guestWidget,
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ==========================================================
        // 3. HORIZONTAL CATEGORY CHIPS (40dp height, 20dp pill radius)
        // ==========================================================
        CategorySelector(
          selectedCategory: widget.selectedCategory,
          onCategoryChanged: (category) {
            widget.onCategoryChanged?.call(category);
          },
        ),


        const SizedBox(height: 24), // Gap between sections: 24dp
        // ==========================================================
        // 4. "20 hotels Available" SECTION + "Filters" BUTTON
        // ==========================================================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                '${widget.resultCount} '
                    '${_categoryHeadingText(widget.selectedCategory, widget.resultCount).tr()} '
                    '${'available'.tr()}',
                style: GoogleFonts.inter(
                  fontSize: 18, fontWeight: FontWeight.w600, color: DS.textPrimary,
                ),
              ),
            ),
            GestureDetector(
              onTap: widget.onFilterTap,
              child: Container(
                height: 38, padding: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(DS.radiusPill),
                  border: Border.all(color: DS.borderLight, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.tune_rounded,
                      size: 16,
                      color: DS.textPrimary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _filterText,
                      style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w500, color: DS.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ==========================================================
        // 5. FILTER / SORT CHIPS ROW (Pill radius 20dp, border #E5E7EB)
        // ==========================================================
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            children: [
              // Date Chip
              GestureDetector(
                onTap: widget.onDateTap,
                child: Container(
                  height: 38, padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(DS.radiusPill),
                    border: Border.all(
                      color: DS.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 15,
                        color: DS.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _shortDateRange,
                        style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w500,
                          color: DS.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Guest Chip
              GestureDetector(
                onTap: widget.onGuestTap,
                child: Container(
                  height: 38, padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(DS.radiusPill),
                    border: Border.all(
                      color: DS.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.person_outline_rounded,
                        size: 16,
                        color: DS.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      TranslatedText(
                        text: widget.guestOnlyLabel,
                        style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w500,
                          color: DS.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Sort Chip
              GestureDetector(
                onTap: _showSortBottomSheet,
                child: Container(
                  height: 38, padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(DS.radiusPill),
                    border: Border.all(
                      color: DS.borderLight,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.tune_outlined,
                        size: 15,
                        color: DS.textSecondary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _sortLabel(widget.selectedSort),
                        style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w500,
                          color: DS.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 16,
                        color: DS.textSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // ==========================================================
        // 6. FULL-WIDTH "SEARCH STAYS" BUTTON (52dp, Radius 16dp, #111827)
        // ==========================================================
        Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(DS.radiusButton),
            boxShadow: DS.shadowButton,
          ),
          child: ElevatedButton(
            onPressed: widget.isLoading ? null : widget.onSearch,
            style: ElevatedButton.styleFrom(
              backgroundColor: DS.primaryDark,
              disabledBackgroundColor: DS.primaryDark.withValues(alpha: 0.6),
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DS.radiusButton),
              ),
            ),
            child: widget.isLoading
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.search, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'search_stays'.tr(),
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }

  String _categoryHeadingText(String cat, int count) {
    final lower = cat.trim().toLowerCase();
    if (lower == 'all') {
      return 'hotels'.tr();
    }
    if (lower == 'hotel' || lower == 'hotels') {
      return count == 1 ? 'hotel' : 'hotels';
    }
    if (lower == 'resort' || lower == 'resorts') {
      return count == 1 ? 'resort' : 'resorts';
    }
    if (lower == 'luxury-villa' || lower == 'luxury_villas') {
      return count == 1 ? 'luxury villa' : 'luxury villas';
    }
    if (lower == 'villa' || lower == 'villas') {
      return count == 1 ? 'villa' : 'villas';
    }
    if (lower == 'camping') {
      return 'camping'.tr();
    }
    return lower;
  }

  String get _filterText {
    return widget.filterButtonText.trim().toLowerCase() == 'filters'
        ? 'filters'.tr()
        : widget.filterButtonText;
  }

  // ============================================================
  // SORT LABEL HELPER
  // ============================================================
  String _sortLabel(HotelSortOption option) {
    switch (option) {
      case HotelSortOption.recommended:
        return 'recommended'.tr();
      case HotelSortOption.priceLowToHigh:
        return 'price_low_to_high'.tr();
      case HotelSortOption.priceHighToLow:
        return 'price_high_to_low'.tr();
    }
  }

  Widget _buildSortOption({
    required HotelSortOption option,
    required String title,
  }) {
    final isSelected = widget.selectedSort == option;

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        widget.onSortChanged?.call(option);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.inter(
                  color: DS.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? DS.primaryBlue : DS.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'sort_hotels_by'.tr(),
                  style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.w600, color: DS.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSortOption(
                  option: HotelSortOption.recommended,
                  title: 'recommended'.tr(),
                ),
                _buildSortOption(
                  option: HotelSortOption.priceLowToHigh,
                  title: 'price_low_to_high'.tr(),
                ),
                _buildSortOption(
                  option: HotelSortOption.priceHighToLow,
                  title: 'price_high_to_low'.tr(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}