import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/payment/presentation/cubit/payment_state.dart';
import 'package:lmd_app/features/payment/data/services/payment_service.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final PaymentService _paymentService;

  PaymentCubit(this._paymentService) : super(PaymentInitial());

  Future<void> checkoutStay({required Map<String, dynamic> body}) async {
    try {
      emit(PaymentLoading());

      final response = await _paymentService.checkoutStay(body: body);

      emit(CheckoutSuccess(response));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}
