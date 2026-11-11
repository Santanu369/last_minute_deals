import 'package:equatable/equatable.dart';
import 'package:lmd_app/features/hotel/data/models/retail_listing_model.dart';

class HotelSearchState extends Equatable {
  final bool isLoading;
  final bool isLoadingMore;
  final bool isSuccess;
  final String? errorMessage;

  final List<RetailListingModel> results;

  /// Server pagination (POST /hotels/ratehawk/search).
  final int page;
  final int total;
  final bool hasMore;

  const HotelSearchState({
    this.isLoading = false,
    this.isLoadingMore = false,
    this.isSuccess = false,
    this.errorMessage,
    this.results = const [],
    this.page = 1,
    this.total = 0,
    this.hasMore = false,
  });

  HotelSearchState copyWith({
    bool? isLoading,
    bool? isLoadingMore,
    bool? isSuccess,
    String? errorMessage,
    List<RetailListingModel>? results,
    int? page,
    int? total,
    bool? hasMore,
  }) {
    return HotelSearchState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
      results: results ?? this.results,
      page: page ?? this.page,
      total: total ?? this.total,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        isLoadingMore,
        isSuccess,
        errorMessage,
        results,
        page,
        total,
        hasMore,
      ];
}
