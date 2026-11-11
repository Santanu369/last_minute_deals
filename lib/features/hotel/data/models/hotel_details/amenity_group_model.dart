class AmenityGroupModel {
  final String groupName;

  final List<String> amenities;

  final List<String> nonFreeAmenities;

  const AmenityGroupModel({
    required this.groupName,
    required this.amenities,
    required this.nonFreeAmenities,
  });

  factory AmenityGroupModel.fromJson(Map<String, dynamic> json) {
    return AmenityGroupModel(
      groupName: json['group_name'] ?? '',
      amenities: (json['amenities'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      nonFreeAmenities: (json['non_free_amenities'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}
