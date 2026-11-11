import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/order/presentation/cubit/order_state.dart';
import 'package:lmd_app/features/order/data/models/create_order_request.dart';
import 'package:lmd_app/features/order/data/services/order_services.dart';

class OrderCubit extends Cubit<OrderState> {
  final OrderService _service;

  OrderCubit(this._service) : super(const OrderState());

  Future<void> createOrder(CreateOrderRequest request) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final order = await _service.createOrder(request);

      emit(state.copyWith(isLoading: false, isSuccess: true, order: order));
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, isSuccess: false, error: e.toString()),
      );
    }
  }
}
