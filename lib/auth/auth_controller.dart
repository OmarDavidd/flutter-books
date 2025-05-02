import 'package:flutter/material.dart';
import 'package:flutter_application_1/auth/auth_service.dart';

class LoginController {
  final authService = AuthService();

  Future<void> login(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await authService.singInWithEmailPassword(email, password);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
