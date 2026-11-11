class CashfreeSyncResponse {
  final String bookingId;
  final String providerOrderId;
  final String bookingStatus;
  final String paymentStatus;
  final String paymentRecordStatus;

  const CashfreeSyncResponse({
    required this.bookingId,
    required this.providerOrderId,
    required this.bookingStatus,
    required this.paymentStatus,
    required this.paymentRecordStatus,
  });

  factory CashfreeSyncResponse.fromJson(Map<String, dynamic> json) {
    return CashfreeSyncResponse(
      bookingId: json['booking_id'] ?? '',
      providerOrderId: json['provider_order_id'] ?? '',
      bookingStatus: json['booking_status'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      paymentRecordStatus: json['payment_record_status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'provider_order_id': providerOrderId,
      'booking_status': bookingStatus,
      'payment_status': paymentStatus,
      'payment_record_status': paymentRecordStatus,
    };
  }
}
