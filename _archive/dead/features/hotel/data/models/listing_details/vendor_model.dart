class VendorModel {
  final String id;
  final String name;

  const VendorModel({required this.id, required this.name});

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(id: json['id'] ?? '', name: json['name'] ?? '');
  }
}
