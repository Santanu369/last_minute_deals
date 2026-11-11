class SearchResultModel {
  final String id;
  final int hid;
  final String hotelSource;

  final double lowestPrice;
  final String currency;

  final String roomName;

  final String meal;

  final bool hasBreakfast;

  final String? freeCancellation;

  final int availableRooms;

  final int ratesCount;

  final String? image;

  final double discountedPrice;

  const SearchResultModel({
    required this.id,
    required this.hid,
    required this.hotelSource,
    required this.lowestPrice,
    required this.currency,
    required this.roomName,
    required this.meal,
    required this.hasBreakfast,
    this.freeCancellation,
    required this.availableRooms,
    required this.ratesCount,
    this.image,
    this.discountedPrice = 0.0,
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      id: json['id'] ?? '',
      hid: json['hid'] ?? 0,
      hotelSource: json['hotelSource'] ?? 'ratehawk',
      lowestPrice: (json['lowestPrice'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
      roomName: json['roomName'] ?? '',
      meal: json['meal'] ?? '',
      hasBreakfast: json['hasBreakfast'] ?? false,
      freeCancellation: json['freeCancellation'],
      availableRooms: json['availableRooms'] ?? 0,
      ratesCount: json['ratesCount'] ?? 0,
      image: json['image'],
    );
  }

  bool get isRefundable => freeCancellation != null;

  String get mealDisplay {
    switch (meal.toLowerCase()) {
      case 'nomeal':
        return 'No Meals';

      case 'breakfast':
        return 'Breakfast Included';

      case 'halfboard':
        return 'Half Board';

      case 'fullboard':
        return 'Full Board';

      case 'allinclusive':
        return 'All Inclusive';

      default:
        return meal;
    }
  }

  get discountPercentage => null;
}