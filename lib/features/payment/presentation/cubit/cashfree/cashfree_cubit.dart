import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/payment/presentation/cubit/cashfree/cashfree_state.dart';
import 'package:lmd_app/features/payment/data/services/payment_service.dart';
import 'package:uuid/uuid.dart';

class CashfreeCubit extends Cubit<CashfreeState> {
  final PaymentService _paymentService;

  CashfreeCubit(this._paymentService) : super(CashfreeInitial());

  Future<void> startPayment({required String bookingId}) async {
    try {
      emit(CashfreeLoading());

      final order = await _paymentService.createCashfreeOrder(
        bookingId: bookingId,
        idempotencyKey: const Uuid().v4(),
      );

      debugPrint('ORDER RESPONSE');
      debugPrint('orderId: ${order.orderId}');
      debugPrint('paymentId: ${order.paymentId}');
      debugPrint('status: ${order.status}');

      final session = await _paymentService.createCashfreeSession(
        orderId: order.orderId,
        returnUrl: '',
      );
      debugPrint('SESSION RESPONSE');

      emit(CashfreeSessionReady(session: session, bookingId: bookingId));
    } catch (e) {
      debugPrint('Cashfree error $e');
      emit(CashfreeError(e.toString()));
    }
  }

  Future<void> syncPayment({required String bookingId}) async {
    try {
      emit(CashfreeLoading());

      final response = await _paymentService.syncPayment(bookingId: bookingId);

      emit(CashfreeSuccess(response: response, bookingId: bookingId));
    } catch (e) {
      emit(CashfreeError(e.toString()));
    }
  }
}
