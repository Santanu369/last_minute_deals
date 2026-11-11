class CreateOrderResponse {
  final String orderId;

  final String orderNumber;

  final double totalAmount;

  final bool paymentRequired;

  final String currency;

  CreateOrderResponse({
    required this.orderId,
    required this.orderNumber,
    required this.totalAmount,
    required this.paymentRequired,
    this.currency = 'INR',
  });

  factory CreateOrderResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return CreateOrderResponse(
      orderId: data['order_id'],

      orderNumber: data['order_number'],

      totalAmount: double.parse(
        (data['total_amount']?['\$numberDecimal'] ?? data['total_amount'])
            .toString(),
      ),

      paymentRequired: data['payment_required'] ?? false,

      currency: data['currency'] ?? 'INR',
    );
  }
}
