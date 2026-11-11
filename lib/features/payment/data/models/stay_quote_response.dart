class StayQuoteResponse {
  final String listingId;
  final String dealId;
  final String sku;
  final String checkIn;
  final String checkOut;
  final int rooms;
  final String currency;
  final List<NightQuote> nights;
  final double nightsSubtotal;
  final double total;
  final bool tierPricingActive;

  StayQuoteResponse({
    required this.listingId,
    required this.dealId,
    required this.sku,
    required this.checkIn,
    required this.checkOut,
    required this.rooms,
    required this.currency,
    required this.nights,
    required this.nightsSubtotal,
    required this.total,
    required this.tierPricingActive,
  });

  factory StayQuoteResponse.fromJson(Map<String, dynamic> json) {
    return StayQuoteResponse(
      listingId: json['listing_id'] ?? '',
      dealId: json['deal_id'] ?? '',
      sku: json['sku'] ?? '',
      checkIn: json['check_in'] ?? '',
      checkOut: json['check_out'] ?? '',
      rooms: json['rooms'] ?? 0,
      currency: json['currency'] ?? '',
      nights: (json['nights'] as List<dynamic>? ?? [])
          .map((e) => NightQuote.fromJson(e))
          .toList(),
      nightsSubtotal: (json['nights_subtotal'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      tierPricingActive: json['tier_pricing_active'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'listing_id': listingId,
      'deal_id': dealId,
      'sku': sku,
      'check_in': checkIn,
      'check_out': checkOut,
      'rooms': rooms,
      'currency': currency,
      'nights': nights.map((e) => e.toJson()).toList(),
      'nights_subtotal': nightsSubtotal,
      'total': total,
      'tier_pricing_active': tierPricingActive,
    };
  }
}

class NightQuote {
  final String serviceDate;
  final String dayBucket;
  final double unitDealPrice;
  final int rooms;
  final double lineTotal;

  NightQuote({
    required this.serviceDate,
    required this.dayBucket,
    required this.unitDealPrice,
    required this.rooms,
    required this.lineTotal,
  });

  factory NightQuote.fromJson(Map<String, dynamic> json) {
    return NightQuote(
      serviceDate: json['service_date'] ?? '',
      dayBucket: json['day_bucket'] ?? '',
      unitDealPrice: (json['unit_deal_price'] ?? 0).toDouble(),
      rooms: json['rooms'] ?? 0,
      lineTotal: (json['line_total'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'service_date': serviceDate,
      'day_bucket': dayBucket,
      'unit_deal_price': unitDealPrice,
      'rooms': rooms,
      'line_total': lineTotal,
    };
  }
}
