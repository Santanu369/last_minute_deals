class CashfreeSessionResponse {
  final String orderId;
  final String paymentSessionId;

  const CashfreeSessionResponse({
    required this.orderId,
    required this.paymentSessionId,
  });

  factory CashfreeSessionResponse.fromJson(Map<String, dynamic> json) {
    return CashfreeSessionResponse(
      orderId: json['order_id'] ?? '',
      paymentSessionId: json['payment_session_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'order_id': orderId, 'payment_session_id': paymentSessionId};
  }
}
