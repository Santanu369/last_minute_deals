class StayDayPricingModel {
  final int weekdayListPrice;
  final int weekdayDealPrice;

  final int saturdayListPrice;
  final int saturdayDealPrice;

  final int sundayListPrice;
  final int sundayDealPrice;

  const StayDayPricingModel({
    required this.weekdayListPrice,
    required this.weekdayDealPrice,
    required this.saturdayListPrice,
    required this.saturdayDealPrice,
    required this.sundayListPrice,
    required this.sundayDealPrice,
  });

  factory StayDayPricingModel.fromJson(Map<String, dynamic> json) {
    return StayDayPricingModel(
      weekdayListPrice: (json['weekday_list_price'] ?? 0).toInt(),

      weekdayDealPrice: (json['weekday_deal_price'] ?? 0).toInt(),

      saturdayListPrice: (json['saturday_list_price'] ?? 0).toInt(),

      saturdayDealPrice: (json['saturday_deal_price'] ?? 0).toInt(),

      sundayListPrice: (json['sunday_list_price'] ?? 0).toInt(),

      sundayDealPrice: (json['sunday_deal_price'] ?? 0).toInt(),
    );
  }
}
