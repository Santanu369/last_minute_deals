import 'package:lmd_app/features/payment/data/models/checkout_response.dart';

abstract class PaymentState {}

class PaymentInitial extends PaymentState {}

class PaymentLoading extends PaymentState {}

class CheckoutSuccess extends PaymentState {
  final CheckoutResponse response;

  CheckoutSuccess(this.response);
}

class PaymentError extends PaymentState {
  final String message;

  PaymentError(this.message);
}
