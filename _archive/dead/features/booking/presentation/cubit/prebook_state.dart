import 'package:lmd_app/features/booking/data/models/prebook_response.dart';

class PrebookState {
  final bool isLoading;
  final PrebookResponse? response;
  final String? error;

  const PrebookState({this.isLoading = false, this.response, this.error});

  PrebookState copyWith({
    bool? isLoading,
    PrebookResponse? response,
    String? error,
  }) {
    return PrebookState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
      error: error,
    );
  }
}
