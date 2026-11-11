class SelectedSuggestionModel {
  final int id;
  final String name;
  final String type;

  const SelectedSuggestionModel({
    required this.id,
    required this.name,
    required this.type,
  });

  factory SelectedSuggestionModel.fromJson(Map<String, dynamic> json) {
    return SelectedSuggestionModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
