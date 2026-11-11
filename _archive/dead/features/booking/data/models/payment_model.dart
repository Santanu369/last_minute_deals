class PaymentModel {
  final double amount;
  final String currency;
  final String type;

  final bool needCreditCard;

  final bool needCvc;

  const PaymentModel({
    required this.amount,
    required this.currency,
    required this.type,
    required this.needCreditCard,
    required this.needCvc,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      amount: double.tryParse(json['amount'].toString()) ?? 0,
      currency: json['currency'] ?? '',
      type: json['type'] ?? '',
      needCreditCard: json['is_need_credit_card_data'] ?? false,
      needCvc: json['is_need_cvc'] ?? false,
    );
  }
}
