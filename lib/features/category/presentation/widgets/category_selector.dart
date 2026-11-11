import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lmd_app/core/theme/design_tokens.dart';

class CategorySelector extends StatelessWidget {
  final String selectedCategory;
  final ValueChanged<String> onCategoryChanged;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategoryChanged,
  });

  /// (key passed to onCategoryChanged, translation key). Keys are the API `kind`
  /// values, so filtering does not depend on the UI language.
  static const List<(String, String)> categories = [
    ('all', 'all'),
    ('hotel', 'hotels'),
    ('resort', 'resorts'),
    ('camping', 'camping'),
    ('villa', 'villas'),
    ('luxury-villa', 'luxury_villas'),
  ];

  static String _key(String c) {
    final l = c.trim().toLowerCase();
    return switch (l) {
      'hotels' => 'hotel',
      'resorts' => 'resort',
      'villas' => 'villa',
      'luxury_villas' || 'luxury villas' || 'luxury-villas' => 'luxury-villa',
      _ => l,
    };
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final (key, labelKey) = categories[index];
          final isSelected = _key(selectedCategory) == key;

          return GestureDetector(
            onTap: () => onCategoryChanged(key),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: isSelected ? DS.primaryBlue : DS.card,
                borderRadius: BorderRadius.circular(DS.radiusPill),
                border: Border.all(
                  color: isSelected ? DS.primaryBlue : DS.borderLight,
                  width: 1,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                labelKey.tr(),
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? Colors.white : DS.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}