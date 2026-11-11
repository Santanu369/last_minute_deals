import 'package:lmd_app/features/payment/data/models/cashfree_session_response.dart';
import 'package:lmd_app/features/payment/data/models/cashfree_sync_response.dart';

abstract class CashfreeState {}

class CashfreeInitial extends CashfreeState {}

class CashfreeLoading extends CashfreeState {}

class CashfreeSessionReady extends CashfreeState {
  final CashfreeSessionResponse session;
  final String bookingId;

  CashfreeSessionReady({required this.session, required this.bookingId});
}

class CashfreeSuccess extends CashfreeState {
  final CashfreeSyncResponse response;
  final String bookingId;

  CashfreeSuccess({required this.response, required this.bookingId});
}

class CashfreeError extends CashfreeState {
  final String message;

  CashfreeError(this.message);
}
