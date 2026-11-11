import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';

class CashfreeSdkService {
  final CFPaymentGatewayService _gateway = CFPaymentGatewayService();

  void initialize({
    required Function(String orderId) onVerify,
    required Function(CFErrorResponse error, String orderId) onError,
  }) {
    _gateway.setCallback(onVerify, onError);
  }

  Future<void> startPayment({
    required String orderId,
    required String paymentSessionId,
    required bool isProduction,
  }) async {
    try {
      final session = CFSessionBuilder()
          .setOrderId(orderId)
          .setPaymentSessionId(paymentSessionId)
          .setEnvironment(
            isProduction ? CFEnvironment.PRODUCTION : CFEnvironment.SANDBOX,
          )
          .build();

      final payment = CFWebCheckoutPaymentBuilder().setSession(session).build();

      _gateway.doPayment(payment);
    } catch (e) {
      rethrow;
    }
  }
}
