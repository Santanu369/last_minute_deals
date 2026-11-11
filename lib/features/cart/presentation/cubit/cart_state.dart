import 'package:equatable/equatable.dart';

class CartState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const CartState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  CartState copyWith({bool? isLoading, bool? isSuccess, String? errorMessage}) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, errorMessage];
}
