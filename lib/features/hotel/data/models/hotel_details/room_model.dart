class RoomModel {
  final String bookHash;
  final String matchHash;

  final String roomName;

  final double price;
  final String currency;

  final String meal;

  final bool refundable;

  final List<String> roomImages;
  final List<String> roomAmenities;
  final String? roomSize;

  const RoomModel({
    required this.bookHash,
    required this.matchHash,
    required this.roomName,
    required this.price,
    required this.currency,
    required this.meal,
    required this.refundable,
    required this.roomImages,
    required this.roomAmenities,
    this.roomSize,
  });

  factory RoomModel.fromJson(Map<String, dynamic> json) {
    return RoomModel(
      bookHash: json['bookHash'] ?? '',
      matchHash: json['matchHash'] ?? '',
      roomName: json['roomName'] ?? '',
      price:
          (json['price'] as num?)?.toDouble() ??
          double.tryParse(json['price'].toString()) ??
          0.0,
      currency: json['currency'] ?? '',
      meal: json['meal'] ?? '',
      refundable: json['refundable'] ?? false,
      roomImages: List<String>.from(json['roomImages'] ?? const []),
      roomAmenities: List<String>.from(json['roomAmenities'] ?? const []),
      roomSize: json['roomSize'],
    );
  }

  bool get isBreakfastIncluded => meal.toLowerCase() == 'breakfast';

  bool get isAllInclusive => meal.toLowerCase() == 'all-inclusive';

  bool get isNoMeal => meal.toLowerCase() == 'nomeal';

  String get mealDisplay {
    switch (meal.toLowerCase()) {
      case 'breakfast':
        return 'Breakfast Included';

      case 'all-inclusive':
        return 'All Inclusive';

      case 'nomeal':
        return 'Room Only';

      default:
        return meal;
    }
  }

  String get firstImage {
    if (roomImages.isEmpty) return '';

    return roomImages.first.replaceAll('{size}', '1024x768');
  }

  List<String> get imageUrls {
    return roomImages.map((e) => e.replaceAll('{size}', '1024x768')).toList();
  }
}
