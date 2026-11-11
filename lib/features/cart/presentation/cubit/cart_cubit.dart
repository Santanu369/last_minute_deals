import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lmd_app/features/cart/data/models/add_buffet_to_cart_request.dart';
import 'package:lmd_app/features/cart/data/services/cart_services.dart';

import 'package:lmd_app/features/cart/data/models/add_to_cart_request.dart';
import 'package:lmd_app/features/cart/presentation/cubit/cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartService _cartService;

  CartCubit(this._cartService) : super(const CartState());

  Future<void> addToCart(AddToCartRequest request) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      await _cartService.addToCart(request);

      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          isSuccess: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> addBuffetToCart(AddBuffetToCartRequest request) async {
    try {
      emit(state.copyWith(isLoading: true));

      await _cartService.addBuffetToCart(request);

      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }

  void reset() {
    emit(const CartState());
  }

  void fetchCartItems() {}
}
