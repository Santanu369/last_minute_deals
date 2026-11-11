import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/booking/presentation/cubit/prebook_state.dart';
import 'package:lmd_app/features/booking/data/models/prebook_request.dart';
import 'package:lmd_app/features/booking/data/services/ratehawk_booking_service.dart';

class PrebookCubit extends Cubit<PrebookState> {
  PrebookCubit() : super(const PrebookState());

  final RatehawkBookingService _ratehawkBookingService =
      RatehawkBookingService();

  Future<void> prebook({required PrebookRequest request}) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));

      final response = await _ratehawkBookingService.prebook(request: request);

      emit(state.copyWith(isLoading: false, response: response));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
