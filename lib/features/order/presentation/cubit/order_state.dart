import 'package:lmd_app/features/order/data/models/create_order_response.dart';

class OrderState {
  final bool isLoading;

  final bool isSuccess;

  final String? error;

  final CreateOrderResponse? order;

  const OrderState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.order,
  });

  OrderState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
    CreateOrderResponse? order,
  }) {
    return OrderState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
      order: order ?? this.order,
    );
  }
}
