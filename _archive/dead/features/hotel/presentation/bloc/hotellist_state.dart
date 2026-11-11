import 'package:equatable/equatable.dart';
import 'package:lmd_app/features/hotel/data/models/listing_model.dart';

class hotelListActivityState extends Equatable {
  final bool loading;
  final List<ListingModel> activities;
  final String error;

  const hotelListActivityState({
    this.loading = false,
    this.activities = const [],
    this.error = '',
  });

  hotelListActivityState copyWith({
    bool? loading,
    List<ListingModel>? activities,
    String? error,
  }) {
    return hotelListActivityState(
      loading: loading ?? this.loading,
      activities: activities ?? this.activities,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [loading, activities, error];
}
