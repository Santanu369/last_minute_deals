import 'package:lmd_app/features/payment/data/models/cashfree_order_response.dart';
import 'package:lmd_app/features/payment/data/models/cashfree_session_response.dart';
import 'package:lmd_app/features/payment/data/models/cashfree_sync_response.dart';

abstract class PaymentRepository {
  Future<CashfreeOrderResponse> createOrder({required String bookingId});

  Future<CashfreeSessionResponse> createSession({required String orderId});

  Future<CashfreeSyncResponse> syncPayment({required String bookingId});
}
