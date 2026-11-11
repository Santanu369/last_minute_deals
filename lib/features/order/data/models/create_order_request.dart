//
class CreateOrderRequest {
  final String name;
  final String email;
  final String phone;
  final String notes;

  const CreateOrderRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'billing_address': {
        'name': name,
        'email': email,
        'address_line1': 'Digital Booking',
        'address_line2': '',
        'city': 'N/A',
        'state': 'N/A',
        'postal_code': '000000',
        'phone': phone,
      },
      'shipping_address': {
        'name': name,
        'email': email,
        'address_line1': 'Digital Booking',
        'address_line2': '',
        'city': 'N/A',
        'state': 'N/A',
        'postal_code': '000000',
        'phone': phone,
      },
      'notes': notes,
      'coupon_code': null,
    };
  }
}
