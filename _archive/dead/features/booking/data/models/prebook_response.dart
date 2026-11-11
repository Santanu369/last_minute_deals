import 'package:lmd_app/features/booking/data/models/payment_model.dart';
import 'package:lmd_app/features/booking/data/models/cancellation_policy_model.dart';

class PrebookResponse {
  final String bookHash;

  final String matchHash;

  final String meal;

  final String roomName;

  final PaymentModel payment;

  final CancellationPolicyModel cancellation;

  final bool priceChanged;

  const PrebookResponse({
    required this.bookHash,
    required this.matchHash,
    required this.meal,
    required this.roomName,
    required this.payment,
    required this.cancellation,
    required this.priceChanged,
  });

  factory PrebookResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return PrebookResponse(
      bookHash: data['book_hash'] ?? '',
      matchHash: data['match_hash'] ?? '',
      meal: data['meal'] ?? '',
      roomName: data['room_name'] ?? '',
      payment: PaymentModel.fromJson(data['payment'] ?? {}),
      cancellation: CancellationPolicyModel.fromJson(
        data['cancellation'] ?? {},
      ),
      priceChanged: data['price_changed'] ?? false,
    );
  }

  bool get hasBreakfast => meal.toLowerCase() == 'breakfast';
}
