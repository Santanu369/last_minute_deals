class CheckoutResponse {
  final String bookingId;
  final String status;
  final String paymentStatus;
  final String expiresAt;
  final double amountTotal;
  final String userId;
  final bool userCreated;

  // New fields for Partner Hotels / Retail Orders
  final Map<String, dynamic>? payment;
  final String? razorpayOrderId;
  final String? keyId;
  final String? orderId;

  CheckoutResponse({
    required this.bookingId,
    required this.status,
    required this.paymentStatus,
    required this.expiresAt,
    required this.amountTotal,
    required this.userId,
    required this.userCreated,
    this.payment,
    this.razorpayOrderId,
    this.keyId,
    this.orderId,
  });

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) {
    // If the response is a retail order response (contains 'data' key with 'order_id')
    if (json.containsKey('data') && json['data'] is Map<String, dynamic>) {
      final data = json['data'] as Map<String, dynamic>;
      final paymentData = data['payment'] as Map<String, dynamic>?;
      return CheckoutResponse(
        bookingId: data['order_id'] ?? '',
        status: json['status'] ?? '',
        paymentStatus: data['payment_status'] ?? 'pending',
        expiresAt: json['expires_at'] ?? '',
        amountTotal: ((data['total_amount'] ?? paymentData?['amount'] ?? 0) as num).toDouble(),
        userId: json['user_id'] ?? '',
        userCreated: json['user_created'] ?? false,
        payment: paymentData,
        razorpayOrderId: paymentData?['razorpay_order_id'] ?? '',
        keyId: paymentData?['key_id'] ?? '',
        orderId: data['order_id'] ?? '',
      );
    }

    return CheckoutResponse(
      bookingId: json['booking_id'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      expiresAt: json['expires_at'] ?? '',
      amountTotal: (json['amount_total'] ?? 0).toDouble(),
      userId: json['user_id'] ?? '',
      userCreated: json['user_created'] ?? false,
    );
  }
}
