class PricingInfo {
  final double sellingPrice;
  final double originalPrice;
  final int discountPercent;

  const PricingInfo({
    required this.sellingPrice,
    required this.originalPrice,
    required this.discountPercent,
  });
}

class PricingUtils {
  /// Generates stable discount from hotel ID
  /// Range: 10% - 34%
  static int generateDiscount(String id) {
    if (id.isEmpty) return 15;

    final hash = id.codeUnits.fold<int>(
      0,
      (prev, char) => (prev * 31 + char) & 0x7fffffff,
    );

    return 10 + (hash % 25);
  }

  /// Calculate pricing using hotel id
  static PricingInfo calculate({
    required String hotelId,
    required double sellingPrice,
  }) {
    if (sellingPrice <= 0) {
      return const PricingInfo(
        sellingPrice: 0,
        originalPrice: 0,
        discountPercent: 0,
      );
    }

    final discount = generateDiscount(hotelId);

    final originalPrice =
        sellingPrice / (1 - (discount / 100));

    return PricingInfo(
      sellingPrice: sellingPrice,
      originalPrice: originalPrice,
      discountPercent: discount,
    );
  }

  static String formatPrice(dynamic value) {
    final number =
        double.tryParse(value.toString()) ?? 0;

    return number
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
        );
  }
}