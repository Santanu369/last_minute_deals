import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/payment/presentation/cubit/stay_quote_state.dart';
import 'package:lmd_app/features/payment/data/services/payment_service.dart';

class StayQuoteCubit extends Cubit<StayQuoteState> {
  final PaymentService _paymentService;

  StayQuoteCubit(this._paymentService) : super(StayQuoteInitial());

  Future<void> getStayQuote({
    required String listingId,
    required String dealId,
    required String sku,
    required String checkIn,
    required String checkOut,
    int rooms = 1,
  }) async {
    try {
      emit(StayQuoteLoading());

      final response = await _paymentService.getStayQuote(
        listingId: listingId,
        dealId: dealId,
        sku: sku,
        checkIn: checkIn,
        checkOut: checkOut,
        rooms: rooms,
      );

      emit(StayQuoteLoaded(response));
    } catch (e) {
      if (e.toString().contains('NO_AVAILABILITY')) {
        emit(StayQuoteError('No more rooms available', statusCode: 409));
        return;
      }

      emit(StayQuoteError(e.toString()));
    }
  }
}
