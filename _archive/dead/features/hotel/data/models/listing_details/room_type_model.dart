import 'package:lmd_app/features/hotel/data/models/listing_details/listing_image_model.dart';

class RoomTypeModel {
  final String id;
  final String sku;
  final String name;

  final int capacity;
  final int position;

  final List<ListingImageModel> images;

  const RoomTypeModel({
    required this.id,
    required this.sku,
    required this.name,
    required this.capacity,
    required this.position,
    required this.images,
  });

  factory RoomTypeModel.fromJson(Map<String, dynamic> json) {
    return RoomTypeModel(
      id: json['id'] ?? '',
      sku: json['sku'] ?? '',
      name: json['name'] ?? '',
      capacity: json['capacity'] ?? 0,
      position: json['position'] ?? 0,

      images: (json['images'] as List? ?? [])
          .map((e) => ListingImageModel.fromJson(e))
          .toList(),
    );
  }
}
