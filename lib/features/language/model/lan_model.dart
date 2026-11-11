class LanguageModel {
  final String code;
  final String name;
  final String nativeName;

  const LanguageModel({
    required this.code,
    required this.name,
    required this.nativeName,
  });

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      code: json['code']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      nativeName: json['native']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'name': name,
      'native': nativeName,
    };
  }
}