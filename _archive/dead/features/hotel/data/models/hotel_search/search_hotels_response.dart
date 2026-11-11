import 'package:lmd_app/features/hotel/data/models/hotel_search/search_result_model.dart';
import 'package:lmd_app/features/hotel/data/models/hotel_search/selected_suggestion_model.dart';

class SearchHotelsResponse {
  final String searchType;

  final SelectedSuggestionModel? selectedSuggestion;

  final List<SearchResultModel> results;

  const SearchHotelsResponse({
    required this.searchType,
    this.selectedSuggestion,
    required this.results,
  });

  factory SearchHotelsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    return SearchHotelsResponse(
      searchType: data['searchType'] ?? 'none',

      selectedSuggestion: data['selectedSuggestion'] != null
          ? SelectedSuggestionModel.fromJson(data['selectedSuggestion'])
          : null,

      results: (data['results'] as List<dynamic>? ?? [])
          .map((e) => SearchResultModel.fromJson(e))
          .toList(),
    );
  }

  bool get hasResults => results.isNotEmpty;

  bool get isRegionSearch => searchType == 'region';

  bool get isHotelSearch => searchType == 'hotel';

  bool get isGeoSearch => searchType == 'geo';

  bool get isEmpty => results.isEmpty;

  int get count => results.length;
}
