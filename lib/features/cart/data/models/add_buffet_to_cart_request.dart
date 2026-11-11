class AddBuffetToCartRequest {
  final String variantId;
  final int quantity;

  const AddBuffetToCartRequest({required this.variantId, this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {'variant_id': variantId, 'quantity': quantity};
  }
}
