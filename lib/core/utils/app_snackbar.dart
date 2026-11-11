import 'package:flutter/material.dart';

class AppSnackbar {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}


// hii krishh kudawala rajput