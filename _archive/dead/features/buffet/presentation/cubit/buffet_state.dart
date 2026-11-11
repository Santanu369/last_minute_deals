import 'package:lmd_app/features/hotel/data/models/listing_model.dart';

class BuffetState {
  final List<ListingModel> allBuffets;
  final List<ListingModel> visibleBuffets;

  final bool isLoading;
  final bool isLoadingMore;

  final bool hasMore;

  final int page;

  final String selectedCategory;

  final String searchQuery;

  final String? error;

  const BuffetState({
    this.allBuffets = const [],
    this.visibleBuffets = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.page = 1,
    this.selectedCategory = 'all',
    this.searchQuery = '',
    this.error,
  });

  BuffetState copyWith({
    List<ListingModel>? allBuffets,
    List<ListingModel>? visibleBuffets,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
    String? selectedCategory,
    String? searchQuery,
    String? error,
  }) {
    return BuffetState(
      allBuffets: allBuffets ?? this.allBuffets,
      visibleBuffets: visibleBuffets ?? this.visibleBuffets,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      error: error,
    );
  }
}
