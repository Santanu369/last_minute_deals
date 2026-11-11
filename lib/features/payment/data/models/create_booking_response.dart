class CreateBookingResponse {
  final String bookingId;
  final String status;
  final String paymentStatus;
  final String expiresAt;
  final double amountTotal;

  const CreateBookingResponse({
    required this.bookingId,
    required this.status,
    required this.paymentStatus,
    required this.expiresAt,
    required this.amountTotal,
  });

  factory CreateBookingResponse.fromJson(Map<String, dynamic> json) {
    return CreateBookingResponse(
      bookingId: json['booking_id'] ?? '',
      status: json['status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      expiresAt: json['expires_at'] ?? '',
      amountTotal: (json['amount_total'] ?? 0).toDouble(),
    );
  }
}
