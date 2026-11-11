class HotelFilterOption {
  final String value;
  final String label;
  final int? count;

  const HotelFilterOption({required this.value, required this.label, this.count});

  factory HotelFilterOption.fromJson(Map<String, dynamic> j) => HotelFilterOption(
        value: '${j['value']}',
        label: (j['label'] ?? j['value'] ?? '').toString(),
        count: (j['count'] as num?)?.toInt(),
      );
}

class HotelFilterDef {
  final String key;
  final String label;
  final String group;
  final String type; // multi | single | text | range
  final List<HotelFilterOption> options;

  const HotelFilterDef({
    required this.key,
    required this.label,
    required this.group,
    required this.type,
    required this.options,
  });

  factory HotelFilterDef.fromJson(Map<String, dynamic> j) => HotelFilterDef(
        key: (j['key'] ?? '').toString(),
        label: (j['label'] ?? '').toString(),
        group: (j['group'] ?? '').toString(),
        type: (j['type'] ?? 'multi').toString(),
        options: [
          for (final o in (j['options'] as List? ?? const []))
            HotelFilterOption.fromJson(Map<String, dynamic>.from(o as Map)),
        ],
      );
}

class HotelFilterConfig {
  final List<HotelFilterDef> filters;
  final List<HotelFilterOption> sorts;

  const HotelFilterConfig({required this.filters, required this.sorts});

  factory HotelFilterConfig.fromJson(Map<String, dynamic> j) => HotelFilterConfig(
        filters: [
          for (final f in (j['filters'] as List? ?? const []))
            HotelFilterDef.fromJson(Map<String, dynamic>.from(f as Map)),
        ],
        sorts: [
          for (final o in (j['sorts'] as List? ?? const []))
            HotelFilterOption.fromJson(Map<String, dynamic>.from(o as Map)),
        ],
      );
}
