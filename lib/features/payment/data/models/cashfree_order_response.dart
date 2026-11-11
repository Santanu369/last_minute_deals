class CashfreeOrderResponse {
  final String bookingId;
  final String orderId;
  final String paymentId;
  final String paymentSessionId; // Added this
  final String status;

  const CashfreeOrderResponse({
    required this.bookingId,
    required this.orderId,
    required this.paymentId,
    required this.paymentSessionId,
    required this.status,
  });

  factory CashfreeOrderResponse.fromJson(Map<String, dynamic> json) {
    // Handling nested data if any, or flat structure
    final data = json['data'] ?? json;
    
    return CashfreeOrderResponse(
      bookingId: (data['booking_id'] ?? '').toString(),
      orderId: (data['cf_order_id'] ?? data['order_id'] ?? '').toString(),
      paymentId: (data['payment_id'] ?? '').toString(),
      paymentSessionId: (data['payment_session_id'] ?? '').toString(),
      status: (data['status'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'order_id': orderId,
      'payment_id': paymentId,
      'payment_session_id': paymentSessionId,
      'status': status,
    };
  }
}
